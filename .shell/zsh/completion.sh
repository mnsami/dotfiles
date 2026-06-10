# zsh completion — prepend brew's zsh completion dirs to fpath, then init completion.
# zsh's native _ssh/_defaults/_killall completers supersede bash's manual
# `complete -W` lists, so those are not hand-ported here.

if command -v brew &>/dev/null; then
	fpath=(
		"$(brew --prefix)/share/zsh-completions"
		"$(brew --prefix)/share/zsh/site-functions"
		$fpath
	)
fi

# -i silently ignores insecure (e.g. group-writable) dirs instead of prompting
# to "ignore or abort". Homebrew's share dir is group-writable, so bare compinit
# aborts here and compdef below would fail. -i loads the secure dirs and skips
# the insecure ones without a fatal prompt.
autoload -Uz compinit && compinit -i

# Guard like the original bash `type _git &> /dev/null` check: only register the
# `g` -> git completion if compinit actually defined compdef.
(( $+functions[compdef] )) && compdef g=git
