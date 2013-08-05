#!/bin/sh

# Copyright (C) 2013 Alex Szczuczko
#
# This file may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

# Exit on non-zero exit code from a complete statement
set -e

if [ "$(id -u)" != 0 ]
then
    echo "Must be run as root"
    exit 2
fi

echo "FreeBSD Initial Setup"
echo "This script will perform various installation and configuration actions."

# Prompt for confirmation
read -r -p "Proceed? [y/N]: " REPLY
if [ "$REPLY" = y ] || [ "$REPLY" = Y ]
then
    echo "Proceeding. Script will stop on any errors."
    echo ""
else
    echo "Aborting."
    exit 3
fi

# Messaging functions
h1() {
    echo "==> $*"
}

h2() {
    echo "    >> $*"
}

h1 "Installing packages"

inst_pkg() {
    h2 "$1"
    pkg_add -r "$1"
}

inst_pkg vim-lite # no X11 (why does the default vim include gvim anyway?)
inst_pkg curl
inst_pkg bash
inst_pkg htop

h1 "Configuring"

apply_skel() {
    skel_file="$1"
    skel_dot_file="$(echo "$skel_file" | sed -e 's/^\./dot./')"

    # Copy to skeleton (affect future users)
    cp "skel/$skel_file" "/etc/skel/$skel_dot_file"

    # Apply to root
    cp "/usr/share/skel/$skel_dot_file" /root/

    # Apply to current users
    ls /home | while read -r user
    do
        cp "/usr/share/skel/$skel_dot_file" "/home/$user/"
        chown "$user:" "/home/$user/$skel_file"
    done
}

h2 "vim"
apply_skel .vimrc

h2 "bash"
apply_skel .bashrc
apply_skel .bash_profile

h2 "htop"
echo "linproc /compat/linux/proc linprocfs rw 0 0" >> /etc/fstab
mkdir -p /usr/compat/linux/proc
ln -s /usr/compat /compat
mount linproc



h1 "Optional configuration"

prompt_skip() {
    while true
    do
        read -r -p "Perform this step? [y/n]: " REPLY
        if [ "$REPLY" = n ] || [ "$REPLY" = N ]
        then
            echo "Declined." >&2
            return 1
        elif [ "$REPLY" = y ] || [ "$REPLY" = Y ]
        then
            echo "Accepted." >&2
            return 0
        else
            echo "Enter n or N to decline. Enter y or Y to accept." >&2
        fi
    done
}

h2 "Reduce TTY quantity"
echo "For embedded systems, the default 8 ttys may be unnecessary. To save"
echo "the limited memory these systems usually have, we can set the amount"
echo "to a lower value."
if prompt_skip
then
    while true
    do
        read -r -p "Enter the desired number of ttys: [2-7] " tty_count
        if [ "$tty_count" -lt 2 ] || [ "$tty_count" -gt 7 ]
        then
            echo "Bad number, out of range" >&2
        else
            break
        fi
    done
    sed -i -r -e 's/^\(ttyv['"$tty_count"'-7]\)/#\1/' /etc/ttys
fi


h1 "Finished."

exit 0
# TODO
h2 "Set default shell to bash for certain users"
read -p "Enter a username: " -r username
bash_path="$(which bash)"
chsh -s "$bash_path" "$username"
