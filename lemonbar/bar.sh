#!/usr/bin/bash

# note: requires package lemonbar-xft-git
#font1="Source Code Pro:size=12"
font1="Gohu GohuFont"
font2="FontAwesome"
bar=$(which lemonbar)
config="$HOME/.config/lemonbar/config.sh"

killall -q $bar

while pgrep -u $UID -x $bar >/dev/null; do sleep 1; done

# get our current resolution
res=$(xdpyinfo | awk '/dimensions/{print $2}')
resArray=(${res//x/ })

# set size of bar
# hardcoded values for 1920x1080 display
x=1400
y=35
xOffset=260
yOffset=20

. $config | $bar -p -f "$font1" -f "$font2" -g ${x}x${y}+${xOffset}+${yOffset}
