# zsh shell options — setopt equivalents of the bash shopt options, plus history wiring.

# shopt -s nocaseglob
setopt no_case_glob

# shopt -s histappend (append + write each command as it is entered)
setopt append_history inc_append_history

# shopt -s cdspell (closest zsh equivalent; correct also offers command spelling correction)
setopt correct

# shopt -s autocd
setopt auto_cd

# HISTCONTROL=ignoreboth (dedupe + ignore leading-space commands)
setopt hist_ignore_all_dups hist_ignore_space

# globstar is intentionally dropped — zsh's ** recursive glob is native.

# History file wiring (bash uses a default history file; zsh needs it set explicitly).
HISTFILE="$HOME/.zsh_history"
SAVEHIST="${HISTSIZE:-32768}"
