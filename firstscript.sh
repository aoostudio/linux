#!/bin/bash
# Aoo installation wrapper script is written by Aoo Studio
# https://aoostudio.com

# This script is written aoo
# update os
yum -y update

# install
yum install screen -y
yum install perl -y
yum install net-tools -y
yum install wget -y
yum install whois -y
