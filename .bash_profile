# colors
export CLICOLOR=1

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# aliases
alias ls='ls -G'
alias dir='dir -G'
alias vdir='vdir -G'

alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

alias ll='ls -alhF -G'
alias la='ls -A -G'
alias l='ls -CF -G'


[[ -f /usr/local/etc/bash_completion.d/git-completion.bash ]] && source /usr/local/etc/bash_completion.d/git-completion.bash
[[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]] && source /usr/local/etc/bash_completion.d/git-prompt.sh

source_bash_completion() {
  local f
  [[ $BASH_COMPLETION ]] && return 0
  echo -e "sourcing all files"
  for f in /{etc,usr/share/bash-completion}/bash_completion; do
    if [[ -r $f ]]; then
      . "$f"
      return 0;
    fi
  done
}

source_bash_completion
unset -f source_bash_completion

[[ -f /usr/share/git/completion/git-prompt.sh ]] && source /usr/share/git/completion/git-prompt.sh

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
if ! agent_is_running; then
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
