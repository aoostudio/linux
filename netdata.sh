#!/bin/bash
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
