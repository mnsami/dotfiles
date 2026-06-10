# zsh + bash Compatibility — Design Spec

**Date:** 2026-06-10
**Branch:** `zsh-compatibility`
**Goal:** Make the dotfiles work identically under both **bash** and **zsh**, with bash behavior preserved exactly and zsh getting a faithful port of the same prompt, exports, aliases, options, and completion.

## Motivation

On modern macOS the default login shell is **zsh**, which reads `~/.zshrc` / `~/.zprofile` / `~/.zshenv` — never `~/.bash_profile`. Today none of this config loads under zsh. The bash-specific pieces are:

- `.bash_profile` — `shopt` options, bash-completion sourcing, `complete -F/-W` completions.
- `.bash_prompt` — custom Solarized/One-Dark `PS1` using bash escapes (`\u \h \w \[ \]`) + `prompt_git`.
- `.bashrc` — sources `.bash_profile`; zsh never reads it.
- `.aliases` / `.exports` — already essentially portable (only bash shebangs). `.exports` references `$yellow`, set by the prompt, so source order matters.

## Approach: shared core + thin per-shell entry points

Extract everything portable into a neutral `.shell/` directory sourced by both shells. Each shell gets a small entry point plus a shell-specific options/completion/prompt trio.

### Target layout

```
.shell/
  init.sh          # loader: sources portable pieces in fixed order + ~/.path, ~/.extra
  path.sh          # PATH ($HOME/bin)                         [portable]
  colors.sh        # tput color vars (bold/red/yellow/...)    [portable; extracted from .bash_prompt]
  exports.sh       # env exports (uses $yellow → after colors) [from .exports]
  aliases.sh       # aliases                                   [from .aliases]
  functions.sh     # shared prompt_git()                       [extracted from .bash_prompt]
  ssh_agent.sh     # ssh-agent key loader                      [from .ssh_agent]
  bash/
    options.sh     # shopt: nocaseglob, histappend, cdspell, autocd, globstar
    completion.sh  # bash-completion + complete -F/-W (g, ssh, defaults, killall)
    prompt.sh      # bash PS1 (calls shared prompt_git)
  zsh/
    options.sh     # setopt equivalents + HISTFILE/SAVEHIST + hist dedup
    completion.sh  # fpath + compinit + compdef g=git
    prompt.sh      # zsh PROMPT — exact replica
```

### Entry points (repo root → copied/symlinked to `~`)

- **`.bash_profile`** — resolves its own dir via `${BASH_SOURCE[0]}`; sources `$dir/.shell/init.sh`, then `.shell/bash/{options,completion,prompt}.sh`.
- **`.bashrc`** — unchanged: `[ -n "$PS1" ] && source ~/.bash_profile`.
- **`.zshrc`** (new) — resolves its own dir via `${0:A:h}`; sources `$dir/.shell/init.sh`, then `.shell/zsh/{options,completion,prompt}.sh`.

Old root files `.aliases`, `.exports`, `.bash_prompt`, `.ssh_agent` are **moved** into `.shell/` (deleted from root). `.bash_profile`/`.bashrc` are rewritten as thin entry points.

**Dir resolution must be relative to the entry point's own location** (not hardcoded `$HOME`) so the config works whether copied (bootstrap rsync) or symlinked (stow), and is testable in-repo:
- bash: `DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"`
- zsh: `DOTFILES_DIR="${0:A:h}"`

`init.sh` itself detects the shell to resolve its own dir:
```sh
if [ -n "$ZSH_VERSION" ]; then _dir="${0:A:h}"
elif [ -n "$BASH_VERSION" ]; then _dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
```

### init.sh source order (preserves existing semantics)

1. `path.sh` (prepend `$HOME/bin`)
2. `~/.path` (user PATH extensions, if present)
3. `colors.sh` (defines `$yellow` etc.)
4. `exports.sh` (consumes `$yellow`)
5. `functions.sh` (defines `prompt_git`)
6. `~/.extra` (user overrides, if present)
7. `ssh_agent.sh`
8. `aliases.sh`

(Mirrors the original `for file in ~/.{path,bash_prompt,exports,extra,ssh_agent,aliases}` order, with colors split out of the prompt and the shell-specific prompt loaded later by the entry point.)

## Key portability decisions

- **Colors are portable** (`tput`), guarded by `if tput setaf 1 &> /dev/null` with the same fallback ANSI codes as today. Sourced before exports.
- **`prompt_git()` is shared** — pure git + string append. Bash passes `"\[${white}\] on \[${violet}\]"` / `"\[${blue}\]"`; zsh passes `"%{${white}%} on %{${violet}%}"` / `"%{${blue}%}"`. Function body unchanged (works in both; the `%{ %}` / `\[ \]` are just literal text it concatenates).

### bash options (unchanged behavior)

`shopt -s nocaseglob histappend cdspell`; loop `autocd globstar` with `2>/dev/null`.

### zsh options (`.shell/zsh/options.sh`)

| bash | zsh |
|------|-----|
| `shopt -s nocaseglob` | `setopt no_case_glob` |
| `shopt -s histappend` | `setopt append_history inc_append_history` |
| `shopt -s cdspell` | `setopt correct` (closest; nuance documented) |
| `shopt -s autocd` | `setopt auto_cd` |
| `shopt -s globstar` | *(dropped — zsh `**` recursive glob is native)* |
| `HISTCONTROL=ignoreboth` (exports) | `setopt hist_ignore_all_dups hist_ignore_space` |

Plus zsh history file wiring (bash uses default history file; zsh needs explicit):
`HISTFILE="$HOME/.zsh_history"`, `HISTSIZE` (already exported), `SAVEHIST="$HISTSIZE"`.

### Completion

- **bash** (`.shell/bash/completion.sh`): unchanged — brew `bash_completion.sh`, `complete -F _git g`, `complete -W` for ssh/scp/sftp, `defaults`, `killall`.
- **zsh** (`.shell/zsh/completion.sh`): add brew zsh site-functions + `zsh-completions` to `fpath`, then `autoload -Uz compinit && compinit`, then `compdef g=git`. zsh's native `_ssh`/`_defaults`/`_killall` completers supersede the bash `complete -W` lists (documented; not hand-ported).

### zsh prompt (`.shell/zsh/prompt.sh`) — faithful replica

```zsh
setopt PROMPT_SUBST

# Same TERM detection as bash_prompt
if [[ "$USER" == "root" ]]; then userStyle="$red"; else userStyle="$orange"; fi
if [[ -n "$SSH_TTY" ]]; then hostStyle="$bold$red"; else hostStyle="$yellow"; fi

_dotfiles_precmd() {
  print -Pn '\e]0;%1~\a'                                   # terminal title = cwd basename (\W)
  PROMPT_GIT="$(prompt_git "%{$white%} on %{$violet%}" "%{$blue%}")"
}
typeset -ga precmd_functions
precmd_functions+=(_dotfiles_precmd)

PROMPT='%{$bold%}'$'\n'
PROMPT+='%{$userStyle%}%n'        # \u
PROMPT+='%{$white%} at '
PROMPT+='%{$hostStyle%}%m'        # \h
PROMPT+='%{$white%} in '
PROMPT+='%{$green%}%~'            # \w
PROMPT+='${PROMPT_GIT}'          # git segment (PROMPT_SUBST expands per prompt)
PROMPT+=$'\n'
PROMPT+='%{$white%}%(!.#.$) %{$reset%}'   # \$  → # for root else $
PS2='%{$yellow%}→ %{$reset%}'
```

Escape mapping: `\u`→`%n`, `\h`→`%m`, `\w`→`%~`, `\W`→`%1~`, `\[ \]`→`%{ %}`, `\$`→`%(!.#.$)`. `PROMPT_SUBST` makes `${PROMPT_GIT}` and the `%{ %}`-wrapped colors inside it render correctly (standard vcs_info pattern). The git segment is built in `precmd` (once per prompt) rather than via inline command substitution.

## Full-scope changes

- **bootstrap.sh** — after rsync, detect the user's login shell from `$SHELL` basename: `zsh` → `source ~/.zshrc`; `bash` → `source ~/.bash_profile`; else print a "restart your shell" message. New `.shell/`, `.zshrc` are included by the existing rsync automatically (no exclude entries).
- **brew.sh** — add `brew install zsh` and `brew install zsh-completions`.
- **README.md** — document zsh support, the `.shell/` layout, updated `.extra`/`.path` extensibility note, and that it now works under both shells.
- **Untouched:** `.vimrc`, `git/`, `iterm/`, `stow.sh`, `.claude/`.

## Verification (must pass before commit)

Run against a throwaway `HOME` containing the installed layout:

1. **bash**: `bash -lc 'source <home>/.bash_profile'` exits 0, no errors.
2. **zsh**: `zsh -ic 'source <home>/.zshrc'` exits 0, no errors.
3. **Prompt render**: under zsh, after triggering `precmd` inside a git repo, `print -P -- "$PROMPT"` contains the branch name and **no literal `%{`, `\[`, or raw escape leakage**.
4. **Aliases/functions**: `ll`, `g` alias resolution and `prompt_git` produce output in both shells.
5. **Completion**: zsh `compinit` initializes without insecure-directory fatal errors; `compdef g=git` registered.

## Out of scope (YAGNI)

- No prompt framework (starship/p10k/oh-my-zsh).
- No hand-porting bash's `complete -W` static lists (zsh native completers cover them).
- No changes to `stow.sh`, vim, git, or iterm config.
