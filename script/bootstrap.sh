#!/usr/bin/env bash


#!/bin/bash

set -e
export DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------
# Configure APT
# ------------------------------------------------------------------------------
echo "Installing default APT sources"
sudo sh -c "cat > /etc/apt/sources.list" <<-EOF
deb http://httpredir.debian.org/debian jessie main
deb http://security.debian.org/ jessie/updates main
deb http://httpredir.debian.org/debian jessie-updates main
EOF

sudo sh -c "cat > /etc/apt/apt.conf.d/99no-recommends" <<-EOF
APT::Install-Recommends "false";
EOF

sudo sh -c "cat > /etc/apt/apt.conf.d/99no-install-suggests" <<-EOF
APT::Install-Suggests "false";
EOF

sudo apt-get -y update

# ------------------------------------------------------------------------------
# Apply default system configuration
# ------------------------------------------------------------------------------
echo "Setting timezone to Europe/Berlin"
sudo sh -c "cat > /etc/timezone" <<-EOF
Europe/Berlin
EOF
sudo dpkg-reconfigure -f noninteractive tzdata

echo "Setting default locales"
sudo sh -c "cat > /etc/locale.gen" <<-EOF
# This file lists locales that you wish to have built. You can find a list
# of valid supported locales at /usr/share/i18n/SUPPORTED, and you can add
# user defined locales to /usr/local/share/i18n/SUPPORTED. If you change
# this file, you need to rerun locale-gen.

en_US.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
EOF

sudo sh -c "cat > /etc/default/locale" <<-EOF
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
EOF
sudo dpkg-reconfigure -f noninteractive locales

echo "Setting keyboard defaults"
sudo sh -c "cat > /etc/default/keyboard" <<-EOF
# Check /usr/share/doc/keyboard-configuration/README.Debian for
# documentation on what to do after having modified this file.

# The following variables describe your keyboard and can have the same
# values as the XkbModel, XkbLayout, XkbVariant and XkbOptions options
# in /etc/X11/xorg.conf.

XKBMODEL="pc105"
XKBLAYOUT="de"
XKBVARIANT="nodeadkeys"
XKBOPTIONS=""

# If you don't want to use the XKB layout on the console, you can
# specify an alternative keymap.  Make sure it will be accessible
# before /usr is mounted.
# KMAP=/etc/console-setup/defkeymap.kmap.gz
EOF
sudo dpkg-reconfigure -f noninteractive keyboard-configuration

echo "Disabling speaker device"
sudo sh -c "cat > /etc/modprobe.d/blacklist-pcspkr.conf" <<-EOF
blacklist pcspkr
EOF

# ------------------------------------------------------------------------------
# Install basic packages
# ------------------------------------------------------------------------------
echo "Installing default packages"
sudo -E apt-get -y install ntpdate fail2ban ufw puppet

# ------------------------------------------------------------------------------
# Configure NTP
# ------------------------------------------------------------------------------
echo "Configuring NTP services"
sudo ntpdate pool.ntp.org
sudo -E apt-get -y install ntp
sudo sh -c "cat > /etc/ntp.conf" <<-EOF
server 0.de.pool.ntp.org
server 1.de.pool.ntp.org
server 2.de.pool.ntp.org
server 3.de.pool.ntp.org
EOF

# ------------------------------------------------------------------------------
# Configure Puppet Agent
# ------------------------------------------------------------------------------
sudo sh -c "cat > /etc/puppet/puppet.conf" <<-EOF
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=$vardir/lib/facter
prerun_command=/etc/puppet/etckeeper-commit-pre
postrun_command=/etc/puppet/etckeeper-commit-post
server=sensei.kogitoapp.vm

[master]
# These are needed when the puppetmaster is run by passenger
# and can safely be removed if webrick is used.
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY
EOF

# ------------------------------------------------------------------------------
# Configure ufw
# ------------------------------------------------------------------------------
# echo "Configuring and enabling UFW"
# sudo ufw default deny incoming
# sudo ufw default allow outgoing
# sudo ufw allow ssh
# sudo ufw --force enable

# ------------------------------------------------------------------------------
# Install default tools
# ------------------------------------------------------------------------------
sudo -E apt-get -y install curl rsync sudo vim

# ------------------------------------------------------------------------------
# Put Puppet Agent into manual mode
# ------------------------------------------------------------------------------
sudo puppet agent --enable
sudo service puppet stop

# ------------------------------------------------------------------------------
# What's left: signal we are ready to go
# ------------------------------------------------------------------------------
echo "All done. All services are ready for use."
