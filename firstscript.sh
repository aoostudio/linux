#!/bin/bash
# Aoo Basic installation wrapper # Version 1.0.0.9
# Script Developed by Apivat Pattana-Anurak
# SysAdmin & Programmer # Thailand # Bangkok
# https://www.aoostudio.com
# Download : curl -O https://raw.githubusercontent.com/aoostudio/linux/master/aoo.sh
# Install : sh aoo.sh

################## Step1 basic install & update ####################
# install
yum install screen -y
yum install open-vm-tools -y
yum -y install epel-release
yum install net-tools -y
yum install wget -y
yum install whois -y
yum install ntp -y
yum install perl -y

# update os
yum -y update

################## Step2 Create Aoo Account SSH ####################
# install sudo
yum install sudo -y
# Start Create Aoo Account
echo -e '\e[1;36mCreate Special User "aoo".....................................................................OK\e[0m';
useradd -p paHW.7qDiHJCM aoo
usermod -G wheel aoo
mkdir -p /home/aoo/.ssh
chmod 700 /home/aoo /home/aoo/.ssh
curl -o /home/aoo/.ssh/authorized_keys https://raw.githubusercontent.com/aoostudio/linux/master/authorized_keys
chmod 600 /home/aoo/.ssh/authorized_keys
chown aoo.aoo -R /home/aoo /home/aoo/.ssh
