#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
	    --exclude "git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "docs/" \
		--exclude "iterm" \
		-avh --no-perms . ~;

    cp  -r git/. ~/.;
	case "$(basename "${SHELL:-}")" in
		zsh)
			echo "Installed. Restart your shell or run: exec zsh";
			;;
		bash)
			source ~/.bash_profile;
			;;
		*)
			echo "Installed. Restart your shell to apply changes.";
			;;
	esac;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
