# zsh prompt — faithful port of .bash_prompt.
# Color vars ($bold $red $yellow $violet $white $green $blue $orange $reset) come
# from .shell/colors.sh and prompt_git from .shell/functions.sh (both sourced by init).
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
