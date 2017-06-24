# modeline obtainined from working VMware "fit guest to fullscreen" using `xvidtune -show`
xrandr --newmode "force2560x1440"   258.53   2560 2610 2660 2710   1440 1490 1540 1590 -hsync +vsync
xrandr --addmode Virtual1 force2560x1440
xrandr --output Virtual1 --mode force2560x1440
xrandr --dpi 144
# unmute PCM audio source and set to max volume; master volume is controlled by keyboard
amixer sset PCM 100 unmute
# load Xresources
xrdb -merge ~/.config/X11/Xresources
# remap some keys
xmodmap $HOME/.config/Xmodmap
# path to my fonts
xset +fp $HOME/.fonts
# for clipboard sync
vmware-user-suid-wrapper &
#vmware-user &
# start window manager
notion
