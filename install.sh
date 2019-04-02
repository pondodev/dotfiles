#!/usr/bin/env bash
# install all config files into their respective places.
# this script works for me, might not work for you. this script isn't
# intended for anyone else except me so i won't fix this if it doesn't work
# for you, sorry!

echo "installing config files"
cp .*rc ~/
cp -r .*/ ~/
rm -rf ~/.git # just clean out the git repo folder from home dir
cp -r */ ~/.config
