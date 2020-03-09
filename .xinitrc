if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Load Xresources stuffs
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xrdb ~/.cache/wal/colors.Xresources

# reverse touchpad scroll
xinput set-button-map 11 1 2 3 5 4 6 7

# remap escape to caps lock
setxkbmap us
#setxkbmap -option caps:escape
setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'

exec bspwm
