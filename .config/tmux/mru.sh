#!/bin/bash
# Alt-Tab style most-recently-used window cycling for tmux.
#   mru.sh push SESSION_ID                       (session-window-changed hook)
#   mru.sh next DIR SESSION_ID WINDOW_ID [hold]  (DIR = 1 or -1)
#   mru.sh release SESSION_ID
# With "hold" (urxvt's ctrltab extension), a cycle lasts until "release" is
# sent when Ctrl comes up.  Otherwise presses less than TIMEOUT ms apart
# continue the same cycle.  When a cycle ends, the window it landed on
# becomes most recent.
TIMEOUT=1000
HOLD_TIMEOUT=30000  # in case a release gets lost

exec 9>"${XDG_RUNTIME_DIR:-/tmp}/tmux-mru.lock"
flock 9

mode=$1
case $mode in
next) dir=$2; sid=$3; cur=$4; hold=$5 ;;
*)    sid=$2 ;;
esac
now=$(($(date +%s%N) / 1000000))

get() { tmux show-options -qv -t "$sid" "$1"; }
list=($(get @mru))
idx=$(get @mru_i); idx=${idx:-0}
last=$(get @mru_t); last=${last:-0}
held=$(get @mru_held); held=${held:-0}

if [ "$held" = 1 ]; then limit=$HOLD_TIMEOUT; else limit=$TIMEOUT; fi
cycling=$(( now - last < limit ))

# Bring WID to the front of the list
front() {
    local w new=("$1")
    for w in "${list[@]}"; do [ "$w" != "$1" ] && new+=("$w"); done
    list=("${new[@]}")
}

# Finish a previous cycle: the window it landed on becomes most recent
commit() {
    if [ "$idx" != 0 ] && [ -n "${list[idx]}" ]; then front "${list[idx]}"; fi
    idx=0
}

# Drop closed windows, append new ones at the end
sync() {
    local live w new=()
    live=" $(tmux list-windows -t "$sid" -F '#{window_id}' | tr '\n' ' ') "
    for w in "${list[@]}"; do [[ $live == *" $w "* ]] && new+=("$w"); done
    for w in $live; do [[ " ${new[*]} " != *" $w "* ]] && new+=("$w"); done
    list=("${new[@]}")
}

save() {
    tmux set-option -q -t "$sid" @mru "${list[*]}" \; \
         set-option -q -t "$sid" @mru_i "$idx" \; \
         set-option -q -t "$sid" @mru_t "$1" \; \
         set-option -q -t "$sid" @mru_held "$2"
}

case $mode in
push)
    [ "$cycling" = 1 ] && exit 0
    commit
    front "$(tmux display-message -p -t "$sid" '#{window_id}')"
    sync
    save 0 0
    ;;
next)
    if [ "$cycling" = 0 ]; then
        commit
        front "$cur"
        sync
    fi
    n=${#list[@]}
    [ "$n" -lt 2 ] && exit 0
    idx=$(( ((idx + dir) % n + n) % n ))
    save "$now" "$([ "$hold" = hold ] && echo 1 || echo 0)"
    tmux select-window -t "${list[idx]}"
    ;;
release)
    [ "$held" = 1 ] || exit 0
    commit
    save 0 0
    ;;
esac
