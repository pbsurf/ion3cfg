# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# inputrc
export INPUTRC=$HOME/.inputrc

# fuck unicode
export LANG="C"  # was "en_US" - not avail on debian
export LC_ALL="C"

# disable use of C-s/C-1 for scroll lock
tty > /dev/null && stty -ixon -ixoff

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# save more than default of 500
export HISTSIZE=5000
export HISTFILESIZE=5000

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
# Note that aliases can't take args - have to define an intermediate fn
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

#if [ "$TERM" != "dumb" ]; then
if [ -e "$HOME/.dircolors" ]; then
  eval "`dircolors -b $HOME/.dircolors`"
else
  eval "`dircolors -b`"
fi
alias ls='ls --color=auto'
alias dir='ls --format=long --group-directories-first -p -G'
#alias vdir='ls --format=vertical'
#fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
alias l='dir -A'
alias dira='dir -A'

# find syntax is a bit too verbose
alias ff='find . -iname'

# create alias for aptitude
alias apt='aptitude'
# try this: always open vim in new window (if running under xterm)
#  disown suppresses exit notification
if type x-terminal-emulator &> /dev/null; then
disownvim() { x-terminal-emulator -e vim $* & disown; }
alias vim='disownvim'
fi
# separate command for starting vim in insert mode
alias vimi='vim -c startinsert'
# similarly for scite
disownscite() { scite $* & disown; }
alias scite='disownscite'

# Replace default man viewer with vim
# the script checks to make sure the man page exists before starting vim
# Note the "` `" around the calls to apropos - more bash insanity
vman() {
   if [ $# -eq 0 ]; then
     /usr/bin/man
   elif [ -n "`apropos -e $*`" ] || [ -n "`apropos $*`" ]; then
     /usr/bin/man $* | col -b | /usr/bin/vim -R -c "set ft=man nomod nolist noim noma title titlestring=man\ $*" -
   else
     /usr/bin/man $*
   fi
}
alias man='vman'

# Syntax highlighting for cat and less
#alias scat='pygmentize-2.7 -f terminal --'
# provided by source-highlight package
alias scat='/usr/share/source-highlight/src-hilite-lesspipe.sh'
alias vless='/usr/share/vim/vimcurrent/macros/less.sh'
alias ack='/usr/bin/ack-grep'

# simple HTTP server
fileserver() {
  ip addr | sed -nE 's/^\s*inet ([^/]+).*eth0$/Server IP: \1/p' && sudo python -m SimpleHTTPServer 80
}
alias server='fileserver'

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# prompt appearance
source $HOME/.bashprompt
