#!/bin/bash
# author:biandou
#lnp-74 环境安装脚本

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

#安装remi镜像源
yum -y install epel-release && rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

#安装php74
yum --enablerepo=remi -y install php74-php php74-php-fpm

#安装php74扩展
yum --enablerepo=remi -y install php74-php-xml php74-php-sockets php74-php-session php74-php-mysql php74-php-cli php74-php-bcmath php74-php-xml php74-php-pecl-redis php74-php-devel php74-php-common php74-php-json php74-php-mbstring php74-php-pdo php74-php-pear php74-php-process php74-php-intl

#替换php-fpm的www.conf配置文件
cp /usr/local/etc/www.conf /etc/opt/remi/php74/php-fpm.d/

#清理yum缓存
yum clean all