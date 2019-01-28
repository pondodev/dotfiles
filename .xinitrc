if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Load Xresources stuffs
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xrdb ~/.cache/wal/colors.Xresources

# Rebind caps lock to escape
setxkbmap us
setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'

exec i3
