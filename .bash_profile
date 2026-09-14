#!/usr/bin/env bash

# Resolve this entry point's own directory so the config works whether copied
# (bootstrap rsync) or symlinked (stow), and is testable in-repo.
_dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load the shared, portable core (path, colors, exports, functions, ssh-agent,
# aliases) in a fixed order.
. "$_dotfiles_dir/.shell/init.sh"

# Load the bash-specific options, completion, and prompt.
. "$_dotfiles_dir/.shell/bash/options.sh"
. "$_dotfiles_dir/.shell/bash/completion.sh"
. "$_dotfiles_dir/.shell/bash/prompt.sh"

unset _dotfiles_dir
