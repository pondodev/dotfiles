#!/usr/bin/bash

# note: requires package lemonbar-xft-git
font1="Source Code Pro:size=12"
font2="FontAwesome"
font3="Source Han Sans"
bar=$(which lemonbar)
config="$HOME/.config/lemonbar/config.sh"

killall -q $bar

while pgrep -u $UID -x $bar >/dev/null; do sleep 1; done

# get our current resolution
res=$(xdpyinfo | awk '/dimensions/{print $2}')
resArray=(${res//x/ })

# apply scaling based on resolution
# TODO: made this work cause fucking decimals
#x=$((${resArray[0]} / ))
#y=$((${resArray[1]} / ))
x=1920
y=35

. $config | $bar -p -f "$font1" -f "$font2" -f "$font3" -g ${x}x${y}
