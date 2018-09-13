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
HISTCONTROL=ignoreboth
# save more than default of 500
HISTSIZE=20000
HISTFILESIZE=20000
# don't use default history file name so it is less likely to get wiped out
#HISTFILE=$HOME/.bash_hist
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
    TITLE_PROMPT='echo -ne "\033]0;${USER/$DEFAULT_USER/}@${HOSTNAME/$DEFAULT_HOST/}: ${PWD/$HOME/\~}\007"'
    ;;
*)
    ;;
esac

# these can be overridden in .localrc as needed
DEFAULT_USER=mwhite
DEFAULT_HOST=deb77

# function to allow title to be set manually
title() {
  TITLE=$*;
  TITLE_PROMPT='echo -ne "\033]0;$TITLE\007"'
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
elif [ -e "$HOME/.config/dircolors" ]; then
  eval "`dircolors -b $HOME/.config/dircolors`"
else
  eval "`dircolors -b`"
fi

if [ -n "$IS_OSX" ]; then
  alias ls='ls -G'
  alias dir='ls -l -p -G'
else
  alias ls='LC_COLLATE=C ls --color=auto'
  alias dir='LC_COLLATE=C ls --format=long --group-directories-first -p -G'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
alias l='dir -A'
alias dira='dir -A'

# find syntax is a bit too verbose - iname matches name w/o path; ipath whole path
alias ff='find . -iname'
alias fp='find . -ipath'

# create alias for aptitude; debian now has an executable called apt too, but aptitude search is better
alias apt='aptitude'
# sort apt search results by popularity - wget -O - http://popcon.debian.org/by_inst.gz | gunzip -c > popcon
popcon() { aptitude search -F %p $* | grep -Fwf - /var/opt/popcon | less -EFXr; }

# run command in a new shell tab
newtab() {
  if [ -n "$TMUX" ]; then
    tmux new-window $*
  elif [ -n "$IS_OSX" ]; then
    osascript 2>/dev/null <<-END
      tell application "iTerm"
        tell the current terminal
          launch session "Default Session"
          tell the current session
            write text " cd $PWD; exec $*"
          end tell
       end tell
     end tell
END
  elif [ -n "$IS_XTERM" ]; then
    x-terminal-emulator -e $* & disown;
  else
    $*
  fi
}

# try this: always open vim in new window (if running under xterm)
#  disown suppresses exit notification
disownvim() { newtab "vim" $*; }
alias vim='disownvim'
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
    /usr/bin/man $* | col -b | "vim" -R -c "set ft=man nomod nolist noim noma title titlestring=man\ $*" -
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
# Use ag by default to supply file list for fuzzy file finder
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS="--multi"
# fzf -> vim, iff any files choosen
fzv() { hits=`fzf`; [ -n "$hits" ] && vim $hits; }
# fzf with preview pane, showing first $1 lines of current file (default is 100 lines)
fzp() { fzf --preview "head -${1:-100} {}"; }

# python
export PYTHONSTARTUP=~/.config/pystartup

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
  #PS1="${PS1:-\u@\h:\w> }"
  PS1="\n\[\033[0;37;0;45m\]${PS1::-1}\[\033[m\] "
elif [[ $EUID -eq 0 ]]; then
  # root: full prompt, red
  PS1='\n\[\033[0;37;0;41m\]\u@\h:\w>\[\033[m\] '
else
  # local user - path only, blue
  PS1='\n\[\033[0;37;0;44m\]:\w>\[\033[m\] '
fi

if [ -f ~/.localrc ]; then
  source $HOME/.localrc
fi
