# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# inputrc
export INPUTRC=$HOME/.inputrc

# disable use of C-s/C-1 for scroll lock
tty > /dev/null && stty -ixon -ixoff

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

#if [ "$TERM" != "dumb" ]; then
eval "`dircolors -b`"
alias ls='ls --color=auto'
#alias vdir='ls --color=auto --format=vertical'
alias dir='ls --color=auto --format=long'
#fi

# some more ls aliases
#alias ll='ls -l'
alias la='ls -A'
#alias l='ls -CF'
alias dira='dir -A'

# create alias for aptitude
alias apt='aptitude'
# separate command for starting vim in insert mode
alias vimi='vim -c startinsert'

# Replace default man viewer with vim
# the script checks to make sure the man page exists before starting vim
vman() {
   if [ $# -eq 0 ]; then
     /usr/bin/man                                                                            
   elif man -k $* ; then
     /usr/bin/man $* | col -b | vim -R -c 'set ft=man nomod nolist noim noma' -
   else
     /usr/bin/man $*   
   fi
}
alias man='vman'

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# prompt appearance
source $HOME/.bashprompt

