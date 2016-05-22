# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# inputrc
export INPUTRC=$HOME/.inputrc

# fuck unicode
#export LANG="C"  # was "en_US" - not avail on debian
#export LC_ALL="C"

# disable use of C-s/C-1 for scroll lock
tty > /dev/null && stty -ixon -ixoff

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth
# save more than default of 500
export HISTSIZE=5000
export HISTFILESIZE=5000
# save history after every command
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# check for xterm
`type x-terminal-emulator &> /dev/null` && [ -n "$DISPLAY" ] && IS_XTERM=true
# check for Mac OS X
[[ "$OSTYPE" == "darwin"* ]] && IS_OSX=true

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# If this is an xterm set the title to user@host:dir
# Note that PROMPT_COMMAND is a command to be executed just before displaying each prompt,
#  whereas PS1 determines the appearance of the prompt itself
case "$TERM" in
xterm*|rxvt*)
    export TITLE_PROMPT='echo -ne "\033]0;${USER/matthew_white/}@${HOSTNAME/matthew-white.local/}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# function to allow title to be set manually
title() {
  TITLE=$*;
  export TITLE_PROMPT='echo -ne "\033]0;$TITLE\007"'
}

# eval allows us to defer evaluation of $TITLE_PROMPT
PROMPT_COMMAND="eval \$TITLE_PROMPT;$PROMPT_COMMAND"

# this is to prevent mc from hanging for 10 seconds at startup
if [ -n "$MC_TMPDIR" ]; then
  PROMPT_COMMAND=
fi

# Alias definitions.
if [ -n "$IS_OSX" ]; then
  # changes from OSX default: change dir from blue(e) to cyan(g)
  export LSCOLORS="gxfxcxdxbxegedabagacad"
elif [ -e "$HOME/.dircolors" ]; then
  eval "`dircolors -b $HOME/.dircolors`"
else
  eval "`dircolors -b`"
fi

if [ -n "$IS_OSX" ]; then
  alias ls='ls -G'
  alias dir='ls -l -p -G'
else
  alias ls='ls --color=auto'
  alias dir='ls --format=long --group-directories-first -p -G'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
alias l='dir -A'
alias dira='dir -A'

# find syntax is a bit too verbose - iname matches name w/o path; ipath whole path
alias ff='find . -iname'
alias fp='find . -ipath'

# create alias for aptitude
alias apt='aptitude'
# try this: always open vim in new window (if running under xterm)
#  disown suppresses exit notification
if [ -n "$IS_XTERM" ]; then
  disownvim() { x-terminal-emulator -e vim $* & disown; }
  alias vim='disownvim'
fi
# similarly for scite
disownscite() { scite $* &> /dev/null & disown; }
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
alias vless='/usr/share/vim/vimcurrent/macros/less.sh'
alias au='ag --color --pager "less -EFXr"'
alias aq='au -Q'

# in place sed - different syntax for GNU vs. BSD (Mac)
if [ -n "$IS_OSX" ]; then
  alias sedi="sed -i '' -e"
else
  alias sedi="sed -i -e"
fi

# simple HTTP server
fileserver() {
  ip addr | sed -nE 's/^\s*inet ([^/]+).*eth0$/Server IP: \1/p' && sudo python -m SimpleHTTPServer 80
}
alias server='fileserver'

# if bash completion script has already run, BASH_COMPLETION will be set readonly
if (unset BASH_COMPLETION 2> /dev/null) then
  if [ -n "$IS_OSX" ]; then
    BASH_COMPLETION=$(brew --prefix)/etc/bash_completion
  else
    BASH_COMPLETION=/etc/bash_completion
  fi
  # enable bash completion in interactive shells
  if [ -f $BASH_COMPLETION ]; then
    source $BASH_COMPLETION
  fi
fi
# override and disable tilde expansion function in bash_completion
_expand() {
  return 0;
}

# upload dotfiles before sshing - only needs to be used on first connect
sshrc() {
  host=$1 ; shift
  scp ~/.inputrc ~/.bash_profile ~/.bashrc $host:
  ssh $host "$@"
}

# prompt appearance - override in .localrc if desired
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  # ssh session: add purple background and leading newline to existing prompt
  export PS1="\n\[\033[0;37;0;45m\]${PS1::-1}\[\033[m\] "
elif [[ $EUID -eq 0 ]]; then
  # root: full prompt, red
  export PS1='\n\[\033[0;37;0;41m\]\u@\h:\w>\[\033[m\] '
else
  # local user - path only, blue
  export PS1='\n\[\033[0;37;0;44m\]:\w>\[\033[m\] '
fi

if [ -f ~/.localrc ]; then
  source $HOME/.localrc
fi
