if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Load Xresources stuffs
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xrdb ~/.cache/wal/colors.Xresources

exec i3
