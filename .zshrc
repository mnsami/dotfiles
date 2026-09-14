# zsh entry point — sources the shared core, then zsh-specific options/completion/prompt.
# Dir is resolved relative to this file so it works whether copied or symlinked.
# Use the %x prompt expansion (the file currently being sourced), NOT $0: when zsh
# auto-reads .zshrc at startup, $0 is the shell name (-zsh), so ${0:A:h} would resolve
# against $PWD and break from any directory other than ~ or the repo.
_dotfiles_dir="${${(%):-%x}:A:h}"

. "$_dotfiles_dir/.shell/init.sh"

. "$_dotfiles_dir/.shell/zsh/options.sh"
. "$_dotfiles_dir/.shell/zsh/completion.sh"
. "$_dotfiles_dir/.shell/zsh/prompt.sh"

unset _dotfiles_dir
