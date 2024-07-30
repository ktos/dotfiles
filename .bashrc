# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# load common aliases
alias grep='grep --color=auto'
alias ddu='du -h --max-depth=1 .'

# load aliases and options specific for Windows and Linux
if [ "$(uname -s)" = "Linux" ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias ll='ls -alF'
    alias ddu='du -h --max-depth=1 .'
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    export EDITOR=vim    
    export TERM=xterm-256color

    export LC_NUMERIC="pl_PL.UTF-8"
    export LC_TIME="pl_PL.UTF-8"
    export LC_MONETARY="pl_PL.UTF-8"

    # turn off Ctrl + s XOFF (XON is Ctrl + q)
    stty ixany
    stty ixoff -ixon
    stty stop undef
    stty start undef

    # initialize oh-my-posh
    eval "$(oh-my-posh init bash --config ~/.omp-bash.json)"

    # initialize ble.sh if exists
    if [ -f ~/.local/share/blesh/ble.sh ]; then
      source ~/.local/share/blesh/ble.sh
    fi

    # initialize WSL bridges to Windows SSH and GPG
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
      rm -f "$SSH_AUTH_SOCK"
      wsl2_ssh_bridge_bin="$HOME/.ssh/wsl2-ssh-bridge.exe"
      if test -x "$wsl2_ssh_bridge_bin"; then
        (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_bridge_bin" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: $wsl2_ssh_bridge_bin is not executable."
      fi
      unset wsl2_ssh_bridge_bin
    fi

    export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
    if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
      rm -rf "$GPG_AGENT_SOCK"
      wsl2_ssh_bridge_bin="$HOME/.ssh/wsl2-ssh-bridge.exe"
      if test -x "$wsl2_ssh_bridge_bin"; then
        (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_bridge_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: $wsl2_ssh_bridge_bin is not executable."
      fi
      unset wsl2_ssh_bridge_bin
    fi
else
    alias ls='lsd'
    alias ll='lsd -lh'
    
    eval "$(oh-my-posh init bash --config ~/.omp-winbash.json)"
fi