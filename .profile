# ~/.profile: login shell setup (bash reads this when there is no ~/.bash_profile; also sh/dash and display managers)
# Must stay POSIX sh. Environment set here is inherited by the whole session; per-shell setup goes in ~/.bashrc

# prepend to PATH if dir exists and isn't already present (tmux panes etc. are login shells that inherit PATH)
for d in "$HOME/bin" "$HOME/.local/bin"; do
  case ":$PATH:" in
    *":$d:"*) ;;
    *) [ -d "$d" ] && PATH="$d:$PATH" ;;
  esac
done
unset d
export PATH

# ssh-agent runs as a systemd user service (~/.config/systemd/user/ssh-agent.service) so keys survive X restarts;
#  setting this here (vs. .bashrc) puts it in the desktop session env, and also stops Xsession from starting its own agent
#  (only for local sessions and if the agent exists, so forwarded agents over ssh - incl. via sshrc - are left alone)
if [ -z "$SSH_CONNECTION" ] && [ -S "$XDG_RUNTIME_DIR/openssh_agent" ]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/openssh_agent"
fi

# interactive bash setup
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
