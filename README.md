# FreeBSD Initial Setup

## Overview

### Description

This repo contains scripts and information for setting up a base FreeBSD install with tools that you would find commonly in a Linux distribution.

### Features

The following points are installed/configured:

*   vim
*   curl
*   bash
*   htop
*   tty quantity
*   TERM=xterm-clear

See setup.sh for more detail.

## How to use

Install FreeBSD normally.

After installing and rebooting, enter a root shell and run these commands:

    fetch https://api.github.com/repos/ASzc/freebsd-initial-setup/tarball/master
    tar -xvf master
    cd ASzc-freebsd*

    ./setup.sh
