# zsh entry point — sources the shared core, then zsh-specific options/completion/prompt.
# Dir is resolved relative to this file so it works whether copied or symlinked.
_dotfiles_dir="${0:A:h}"

. "$_dotfiles_dir/.shell/init.sh"

. "$_dotfiles_dir/.shell/zsh/options.sh"
. "$_dotfiles_dir/.shell/zsh/completion.sh"
. "$_dotfiles_dir/.shell/zsh/prompt.sh"

unset _dotfiles_dir
