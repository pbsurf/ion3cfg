xrandr --output default --mode 1280x1024
# remap caps lock as shift
xmodmap -e "remove lock = Caps_Lock"
xmodmap -e "add shift = Caps_Lock"
# start window manager
ion3

