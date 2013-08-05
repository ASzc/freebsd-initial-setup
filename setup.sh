#/bin/sh

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

    # Copy to skeleton (affect future users)
    cp "skel/$skel_file" /etc/skel/
    # TODO chown

    # Apply to root
    cp "/etc/skel/$skel_file" /root/
    # TODO chown

    # Apply to current users
    for user in $(ls /home)
    do
        cp "/etc/skel/$skel_file" /root/
        # TODO chown
    done
}

h2 "vim"
apply_skel .vimrc

h2 "bash"
apply_skel .bashrc

h2 "htop"
# htop:
#***********************************************************
#htop(1) requires linprocfs(5) to be mounted. If you don't
#have it mounted already, please add this line to /etc/fstab
#and run `mkdir -p /usr/compat/linux/proc; ln -s /usr/compat /compat; mount linproc`:
#linproc /compat/linux/proc linprocfs rw 0 0
#***********************************************************



h1 "Optional configuration"

exit 0
# TODO
h2 "Set default shell to bash for certain users"
read -p "Enter a username: " -r username
bash_path="$(which bash)"
usermod -s "$bash_path" "$username"
