#!/usr/bin/bash

# import colours from pywal
. "$HOME/.cache/wal/colors.sh"

# constants
update=0.2
hostname="$(hostname)"

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

set_colours() {
  echo -n "%{F$foreground}%{B$background}"
}

set_inverse_colours() {
  echo -n "%{F$background}%{B$foreground}"
}

hostname() {
    echo -n "$USER@$hostname"
}

battery() {
        percent=$(acpi --battery | cut -d, -f2)
        level=${percent::-1}
        status=$(acpi --battery | cut -d, -f1 | cut -d: -f2)

        # display charging/danger icon
        if [ $status == "Charging" ]; then
            echo -ne "$charging "
        elif (( level <= 10 )); then
            echo -ne "$danger "
        fi

        # display battery level
        if (( level > 80 )); then
            echo -ne "$batt4"
        elif (( level > 60 )); then
            echo -ne "$batt3"
        elif (( level > 40 )); then
            echo -ne "$batt2"
        elif (( level > 20 )); then
            echo -ne "$batt1"
        else
            echo -ne "$batt0"
        fi

        # finally display the actual number
        echo -n "$percent"
}

network() {
    ssid=$(iwgetid -r)
    if [ ${#ssid} = 0 ]; then
        echo -ne "$sadface no network connected"
    else
        echo -ne "$wifi $ssid"
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
            echo -n $(set_inverse_colours) " ${element:1} " $(set_colours)
        elif [[ $element = o* ]]; then
            # show inactive workspaces
            echo -n "  ${element:1}  "
        fi
    done
}

clock() {
    datetime=$(date "+%A %B %d, %H:%M")
    echo -n "$datetime"
}

volume() {
    info=$(amixer get Master \
        | grep % \
        | head -n 1)

    vol=$(echo $info \
        | awk '{print $5}' \
        | sed 's/[^0-9%]//g')

    status=$(echo $info \
        | awk '{print $6}')

    # display if volume is muted or not
    if [ $status = "[on]" ]; then
        echo -ne "$volon "
    else
        echo -ne "$voloff "
    fi

    # display volume percent
    echo -n "$vol"
}

while true; do
    # kill process once x is no longer running
    if ! pgrep -x "Xorg" > /dev/null 
    then
        break
    fi

    echo -n "$(set_colours)"

    # left side
    echo -n "$(bspwm)"
    # center
    echo -n "%{c} $(hostname) // $(clock)"
    # right side
    echo "%{r}$(network) // $(volume) // $(battery) "
    sleep $update;
done
