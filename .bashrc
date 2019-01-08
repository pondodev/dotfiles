#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias neofetch='neofetch --ascii ~/.ascii/ecorp'

PS1='[\u@\h \W]\$ '

# Pretty colours on all new terminals
(cat ~/.cache/wal/sequences &)
