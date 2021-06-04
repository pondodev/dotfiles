#!/usr/bin/bash

# import colours from pywal
. "$HOME/.cache/wal/colors.sh"

# constants
update=0.2
hostname="$(cat /proc/sys/kernel/hostname)"

batt4="\uf240"
batt3="\uf241"
batt2="\uf242"
batt1="\uf243"
batt0="\uf244"
charging="\uf0e7"
danger="\uf071"

volon="\uf028"
voloff="\uf026"

wifi="\uf1eb"
sadface="\uf119"

# and then our output :)
output=""

set_colours() {
  output="$output%{F$foreground}%{B$background}"
}

set_inverse_colours() {
  output="$output%{F$background}%{B$foreground}"
}

hostname() {
    output="$output$USER@$hostname"
}

battery() {
        level=$(cat /sys/class/power_supply/BAT0/capacity)
	status="$(cat /sys/class/power_supply/BAT0/status)"

        # display charging/danger icon
        if [ $status == "Charging" ]; then
            output="$output$charging "
        elif [ "$level" -le 10 ]; then
            output="$output$danger "
        fi

        # display battery level
        if [ "$level" -gt 80 ]; then
            output="$output$batt4 "
        elif [ "$level" -gt 60 ]; then
            output="$output$batt3 "
        elif [ "$level" -gt 40 ]; then
            output="$output$batt2 "
        elif [ "$level" -gt 20 ]; then
            output="$output$batt1 "
        else
            output="$output$batt0 "
        fi

        # finally display the actual number
        output="$output$level%"
}

network() {
    ssid=$(iwgetid -r)
    if [ ${#ssid} = 0 ]; then
        output="$output$sadface no network connected"
    else
        output="$output$wifi $ssid"
    fi
}

bspwm() {
    # get status of workspaces, cut out unnecessary parts at beginning and
    # end. could be improved by slicing an array.
    status=$(bspc wm -g | cut -d: -f2-11)
    
    IFS=':' read -r -a arr <<< $status 

    for element in "${arr[@]}"
    do
        if [[ $element = F* || $element = O* ]]; then
            # show active workspace
            set_inverse_colours
            output="$output  ${element:1}  "
            set_colours
        elif [[ $element = o* ]]; then
            # show inactive workspaces
            output="$output  ${element:1}  "
        fi
    done
}

clock() {
    datetime=$(date "+%A %B %d, %H:%M")
    output="$output$datetime"
}

volume() {
    info=$(amixer get Master \
        | grep % \
        | head -n 1)

    vol=$(echo $info \
        | awk '{print $4}' \
        | sed 's/[^0-9%]//g')

    status=$(echo $info \
        | awk '{print $6}')

    # display if volume is muted or not
    if [ $status = "[on]" ]; then
        output="$output$volon "
    else
        output="$output$voloff "
    fi

    # display volume percent
    output="$output$vol"
}

while true; do
    # kill process once x is no longer running
    if ! pgrep -x "Xorg" > /dev/null 
    then
        break
    fi

    set_colours

    # left side
    bspwm
    # center
    output="$output%{c} "
    hostname
    output="$output // "
    clock
    # right side
    output="$output%{r}"
    network
    output="$output // "
    volume
    output="$output // "
    battery

    echo -ne "$output "
    output=""
    sleep $update;
done
