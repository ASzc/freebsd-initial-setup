# Make it so that vim and pagers don't leave a mess on the screen
# Also enables scrollwheel in vim
TERM=${TERM:-xterm-clear}
[ "$TERM" = xterm ] && TERM=xterm-clear
export TERM

# Exec bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
