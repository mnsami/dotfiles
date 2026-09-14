# Add `~/bin` and `~/.local/bin` to the `$PATH`.
# `~/.local/bin` holds user-installed CLIs (e.g. the `claude` native install);
# it is not on macOS's default PATH, so it must be added here.

export PATH="$HOME/bin:$HOME/.local/bin:$PATH";
