#!/bin/bash
# author:biandou
#lnp-74 环境安装脚本

#下载最新签名
cd /etc/pki/rpm-gpg
wget http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-7
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#安装 nginx必须环境
yum -y install gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel wget

#进入安装文件夹
cd /usr/local/

#下载nginx-1.20.2
wget http://nginx.org/download/nginx-1.20.2.tar.gz

#解压nginx-1.20.2
tar -zxvf nginx-1.20.2.tar.gz && rm -f ./nginx-1.20.2.tar.gz && cd nginx-1.20.2

#执行nginx 安装
./configure --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module  --with-http_stub_status_module && make && make install

#添加 www:www 用户组
groupadd -f www && useradd -g www www

#替换nginx的配置文件
cp /usr/local/etc/nginx.conf /usr/local/nginx/conf/

#创建nginx命令软连接
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

#创建nginx日志目录
mkdir /var/log/nginx

#安装crontab
yum -y install vixie-cron

yum -y install crontabs

#安装remi镜像源
yum -y install epel-release && rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#安装php74
yum --enablerepo=remi -y install php74-php php74-php-fpm

#安装php74扩展
yum --enablerepo=remi -y install php74-php-xml php74-php-sockets php74-php-session php74-php-mysql php74-php-cli php74-php-bcmath php74-php-xml php74-php-pecl-redis php74-php-devel php74-php-common php74-php-json php74-php-mbstring php74-php-pdo php74-php-pear php74-php-process php74-php-intl php74-php-opcache

#设置php软连接
mv /usr/bin/php74-cgi /usr/bin/php-cgi
mv /usr/bin/php74-pear /usr/bin/php-pear
mv /usr/bin/php74-phar /usr/bin/php-phar
mv /usr/bin/php74 /usr/bin/php
ln -s /opt/remi/php74/root/usr/sbin/php-fpm /usr/bin/php-fpm

#替换php-fpm的www.conf配置文件
cp /usr/local/etc/www.conf /etc/opt/remi/php74/php-fpm.d/

#设置php禁用函数
sed -i 's/disable_functions =/disable_functions = passthru,exec,system,popen,chroot,scandir,chgrp,chown,escapesh
ellcmd,escapeshellarg,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,pfsockopen,putenv/g' /etc/opt/remi/php74/php.ini

#安装zip uzip
yum -y install zip unzip

#安装compsoer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod -R 777 /usr/local/bin/composer

#安装git 一些composer库安装需要git
yum -y install git

#清理yum缓存
yum clean all