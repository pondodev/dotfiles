#!/bin/bash
file=ls ~/Pictures/Wallpapers/ | shuf -n 1
wal -i ~/Pictures/Wallpapers/$file
