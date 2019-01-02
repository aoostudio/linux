#!/bin/bash
# Aoo installation wrapper script by Aoo Studio
# https://aoostudio.com

# install
yum install screen -y
screen
yum install perl -y
yum install net-tools -y
yum install apt -y



# update os
yum -y update

##################### Create Aoo Account SSH ########################
yum install sudo -y
echo -e '\e[1;36mCreate Special User "aoo".....................................................................OK\e[0m';
useradd -p paHW.7qDiHJCM aoo
usermod -G wheel aoo
mkdir -p /home/aoo/.ssh
chmod 700 /home/aoo /home/aoo/.ssh
curl -o /home/aoo/.ssh/authorized_keys https://raw.githubusercontent.com/aoostudio/linux/master/authorized_keys
chmod 600 /home/aoo/.ssh/authorized_keys
chown aoo.aoo -R /home/aoo /home/aoo/.ssh


echo -e '\e[1;36mConfig + Securing SSHD.........................................................................OK\e[0m';
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
echo 'AllowUsers aoo' >> /etc/ssh/sshd_config
sed -i 's/# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers

clear
