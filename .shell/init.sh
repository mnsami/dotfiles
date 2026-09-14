# Portable loader for the shared shell core.
# Resolves its own directory per-shell, then sources the portable pieces in a
# fixed order (mirroring the original .bash_profile source loop), plus the
# optional user files ~/.path and ~/.extra.

# Resolve this file's own directory (.shell) in a shell-appropriate way.
if [ -n "$ZSH_VERSION" ]; then
	# %x = the file being sourced; robust even if FUNCTION_ARGZERO is disabled.
	_shell_dir="${${(%):-%x}:A:h}"
elif [ -n "$BASH_VERSION" ]; then
	_shell_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# 1. PATH (prepend $HOME/bin)
. "$_shell_dir/path.sh"
# 2. ~/.path (user PATH extensions, if present)
[ -r "$HOME/.path" ] && [ -f "$HOME/.path" ] && . "$HOME/.path"
# 3. colors.sh (defines $yellow etc.)
. "$_shell_dir/colors.sh"
# 4. exports.sh (consumes $yellow)
. "$_shell_dir/exports.sh"
# 5. functions.sh (defines prompt_git)
. "$_shell_dir/functions.sh"
# 6. ~/.extra (user overrides, if present)
[ -r "$HOME/.extra" ] && [ -f "$HOME/.extra" ] && . "$HOME/.extra"
# 7. ssh_agent.sh
. "$_shell_dir/ssh_agent.sh"
# 8. aliases.sh
. "$_shell_dir/aliases.sh"

unset _shell_dir
