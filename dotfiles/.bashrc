# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
  else
  color_prompt=
  fi

fi

. ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1;
if [ "$color_prompt" = yes ]; then
  if [ $(uname) = Darwin ]; then
    PS1='\[\033[0;90m\]\w\[\033[0;33m\] $(__git_ps1 " (%s)")\[\033[00m\]\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[0;90m\]\w\[\033[0;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
  fi
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

if [ $(uname) = Darwin ]; then
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# enable color support of ls and also add handy aliases
# Ubuntu
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

  # human readable file sizes
  alias ls='ls -h --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
else
  # human readable file sizes
  alias ls='ls -h'
fi

export CLICOLOR=1
export LSCOLORS=Axfxcxdxbxegedabagacad

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -ClF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Customize the PATH (especially for Homebrew)
if [ -d /usr/local/bin ]; then
  PATH=/usr/local/bin:$PATH
fi

## Uncomment these if they are installed

# Macs need to have git autocomplete enabled.
# Autocomplete for git
# if [ -f ~/.git-completion.bash ]; then
#   . ~/.git-completion.bash
# fi

# Homebrew on a Mac
# Setting the PATH for Homebrew, and programs installed by Homebrew
# export PATH="/opt/homebrew/bin:$PATH"

# My local scripts.
# Initialize my local ksys library for autocompletions
# eval "$(/Users/kris/Projects/local/bin/ksys init -)"

