xrandr --output Virtual1 --mode 1280x1024
# remap some keys
xmodmap $HOME/.Xmodmap
# path to my fonts
xset +fp $HOME/.fonts
# for clipboard sync
vmware-user-suid-wrapper &
# start window manager
notion

