# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# vim as the default editor
export EDITOR=vim

# Colourized PS1, green for users, red for root
if [[ "$(id -u)" == 0 ]]
then
    PS1='\[\e[0;31m\][\u@\h \W]\$\[\e[0m\] '
else
    PS1='\[\e[0;32m\][\u@\h \W]\$\[\e[0m\] '
fi
