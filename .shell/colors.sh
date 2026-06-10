# Terminal color setup (portable; extracted from .bash_prompt).
# Defines: bold reset black blue cyan green orange purple red violet white yellow
# This is the only place TERM detection and colors live.

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	black=$(tput setaf 0);
	blue=$(tput setaf 75);
	cyan=$(tput setaf 73);
	green=$(tput setaf 107);
	orange=$(tput setaf 173);
	purple=$(tput setaf 176);
	red=$(tput setaf 167);
	violet=$(tput setaf 105);
	white=$(tput setaf 15);
	yellow=$(tput setaf 142);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;
