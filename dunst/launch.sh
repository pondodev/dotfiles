#!/usr/bin/env bash

. "${HOME}/.cache/wal/colors.sh"

pkill dunst
while [ ! -z "`pgrep dunst`" ]; do sleep 0.1; done

dunst \
	-lb "${color14:-#FFFFFF}" \
	-nb "${color14:-#FFFFFF}" \
	-cb "${color14:-#FFFFFF}" \
	-lf "${color0:-#000000}" \
	-cf "${color0:-#000000}" \
	-nf "${color0:-#000000}" \
	-fn "Source Code Pro 12" \
	-geometry "600x40-20+55" \
        -max_icon_size 40
>> /dev/null 2>&1 &
