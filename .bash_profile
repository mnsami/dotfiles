# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,ssh,aliases}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


# show git info
GIT_PS1_SHOWDIRTYSTATE=true

export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1)\$ "


# ssh agent start
SSH_AGENT_ENV=~/.ssh/agent.env

agent_is_running() {
  if [ "$SSH_AUTH_SOCK" ]; then
    # ssh-add returns:
    #   0 = agent running, has keys
    #   1 = agent running, no keys
    #   2 = agent not running
    ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
  else
    false
  fi
}

agent_has_keys() {
  ssh-add -l >/dev/null 2>&1
}

agent_load_env() {
  . "$SSH_AGENT_ENV" >/dev/null
}

agent_start() {
  (umask 077; ssh-agent >"$SSH_AGENT_ENV")
  . "$SSH_AGENT_ENV" >/dev/null
}

add_all_keys() {
  ls ~/.ssh | grep .*_rsa$ --color=never | sed "s:^:`echo ~`/.ssh/:" | xargs -n 1 ssh-add
}

if ! agent_is_running; then
  agent_load_env
fi

# if your keys are not stored in ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.pub, you'll need
# to paste the proper path after ssh-add
AGENT_IS_RUNNING=agent_is_running
if [[ $AGENT_IS_RUNNING -eq 0 || $AGENT_IS_RUNNING -eq false ]]
then
  agent_start
  add_all_keys
elif ! agent_has_keys; then
  add_all_keys
fi

echo `ssh-add -l | wc -l` SSH keys registered.

unset SSH_AGENT_ENV


# set environmental variable language
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
export EDITOR=vim

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
