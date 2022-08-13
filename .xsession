# modeline obtainined from working VMware "fit guest to fullscreen" using `xvidtune -show`
xrandr --newmode "force3840x2400"   794.25  3840 4160 4584 5328  2400 2403 2409 2486 -hsync +vsync
xrandr --addmode Virtual1 force3840x2400
xrandr --output Virtual1 --mode force3840x2400
xrandr --dpi 320
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
