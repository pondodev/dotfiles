#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias neofetch='neofetch --ascii ~/.ascii/moebius'
alias cleanup="~/.scripts/cleanup.sh"
alias runelite="java -jar /usr/share/runelite/RuneLite.jar --mode=OFF"
alias randomwallpaper="~/.scripts/randomwallpaper.sh"

PS1='[\u@\h \W]\$ '

# Pretty colours on all new terminals
(cat ~/.cache/wal/sequences &)
[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" > /dev/null
