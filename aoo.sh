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

### AllowUsers aoo to Sudo ssh ###
echo -e '\e[1;36mConfig + Securing SSHD.........................................................................OK\e[0m';
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
echo 'AllowUsers root' >> /etc/ssh/sshd_config
echo 'AllowUsers aoo' >> /etc/ssh/sshd_config
sed -i 's/# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers

# Create Perl encripted Password by Aoostudio :  
# https://github.com/aoostudio/linux/blob/master/Create%20Password%20(perl%20encrypted%20linux)

################## Step3 Install Monitor Process ####################
yum install htop -y
yum install atop -y
yum install iftop -y
 yum install nmon -y
### mysql procress monitor ##
yum install mytop -y
curl -o /root/.mytop https://raw.githubusercontent.com/aoostudio/linux/master/.mytop

rm -rf mod_evasive* csf* aoo.sh xcache* . # Delete Script aoo.sh
history -c

######################### End Script  #######################

echo "************************************************************"
echo "*                 PLEASE REBOOT SERVER NOW                 *"
echo "*      Current date : $(date)         *"
echo "*                 Hostname   @ $(hostname)                 *"
echo "*                  Network configuration                   *"
ip -o -f inet addr show | awk '/scope global/ {print $1, $2, $3, $4, $5, $6}'
echo "************************************************************"
