#!/bin/bash
# Stech Asia Basic installation wrapper For Linux Centos 6,7 # Version 1.0.0.1
# Script Developed by Apivat Pattana-Anurak
# SysAdmin & Programmer Form #Bangkok #Thailand 
# curl -O https://raw.githubusercontent.com/aoopa/linux-centos/master/aoo.sh
# sh stech.sh


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

################## Step2 Create stech Account SSH ####################
# install sudo
yum install sudo -y
echo -e '\e[1;36mCreate Special User "stech".....................................................................OK\e[0m';
useradd -p paGDXTCNSS.DE stech
usermod -G wheel stech
mkdir -p /home/stech/.ssh
chmod 700 /home/stech /home/stech/.ssh
curl -o /home/stech/.ssh/authorized_keys https://raw.githubusercontent.com/aoopa/linux-centos/master/authorized_keys
chmod 600 /home/stech/.ssh/authorized_keys
chown stech.stech -R /home/stech /home/stech/.ssh

