# modeline obtainined from working VMware 1920x1080 using `xvidtune -show`; another approach is `cvt 1920 1080 60`
xrandr --newmode "force1920x1080"  152.77   1920 1970 2020 2070   1080 1130 1180 1230 -hsync +vsync
xrandr --addmode Virtual1 force1920x1080
xrandr --output Virtual1 --mode force1920x1080
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
