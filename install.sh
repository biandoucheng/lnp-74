# 更新包列表并安装 Nginx 和其他必要的工具
apt-get update && apt-get install -y \
gpg \
openssl \
libssl-dev \
curl \
wget \
dnsutils \
cron \
lsb-release \
build-essential \
zlib1g-dev \
libpcre3 \
libpcre3-dev \
git \
libpng-dev \
libjpeg-dev \
libwebp-dev \
libfreetype6-dev \
libzip-dev \
libonig-dev \
libpq-dev

#进入安装文件夹
cd /usr/local/

#下载nginx-1.20.2
wget http://nginx.org/download/nginx-1.20.2.tar.gz

#解压nginx-1.20.2
tar -zxvf nginx-1.20.2.tar.gz && rm -f ./nginx-1.20.2.tar.gz && cd nginx-1.20.2

#执行nginx 安装
./configure --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module  --with-http_stub_status_module && make && make install
rm -rf ./nginx-1.20.2

#创建nginx命令软连接
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

# 更新pecl源
pecl channel-update pecl.php.net

# pecl安装 php 扩展
pecl install igbinary
pecl install  redis
pecl install  mongodb
docker-php-ext-enable redis && docker-php-ext-enable mongodb  && docker-php-ext-enable igbinary

# 安装 php 扩展
docker-php-ext-install zip  bcmath  dba  calendar exif  mysqli  opcache pdo  pdo_mysql sockets mbstring  pdo_pgsql pgsql 

# 编译安装 image 扩展
docker-php-ext-configure gd --with-webp=/usr/include/webp --with-jpeg=/usr/include --with-freetype=/usr/include/freetype2/ && docker-php-ext-install -j$(nproc) gd

# 安装composer
cd /root
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" 
# 执行安装composer脚本文件
php composer-setup.php 
# composer.phar，这样 composer 就可以进行全局调用
chmod +x composer.phar 
mv composer.phar /usr/local/bin/composer 
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ 
# 更新 composer
composer selfupdate 

# 修改php.ini名称
cd /usr/local/etc/php && mv php.ini-production conf.d/php.ini

#安装python3.10
cd /usr/local
mkdir -p ~/.pip
cp /usr/local/etc/pip.conf ~/.pip/pip.conf
wget https://www.python.org/ftp/python/3.10.1/Python-3.10.1.tgz
tar -zxvf  Python-3.10.1.tgz && rm -f ./Python-3.10.1.tgz
cd ./Python-3.10.1
./configure --with-ssl
make && make install
ln -s /usr/local/Python-3.10.1/python /usr/bin/python3
pip3 install pymysql pymongo redis aiohttp pytz DBUtils arrow xlrd xlwt crypto pyquery
rm -rf ./Python-3.10.1

#安装Supervisor
cd /usr/local
pip3 install supervisor
echo_supervisord_conf > /etc/supervisord.conf
echo '[include]' >> /etc/supervisord.conf
echo 'files = /usr/local/etc/*_svd.ini' >> /etc/supervisord.conf

# 创建必要目录
mkdir -p /var/log/php-fpm/ /home/wwwroot/ /home/wwwlogs/

#添加 www:www 用户组
groupadd -f www && useradd -g www www
chown -R www:www /home/wwwroot/ /home/wwwlogs/

#创建nginx日志目录
mkdir /var/log/nginx

#替换nginx的配置文件
cp /usr/local/etc/nginx.conf /usr/local/nginx/conf/

# 替换php-fpm配置文件
cp /usr/local/etc/www.conf /usr/local/etc/php-fpm.d/www.conf

# 重命名docker给的默认配置文件,使其失效(影响正常php-fpm配置文件的生效)
mv /usr/local/etc/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf.bk
mv /usr/local/etc/php-fpm.d/docker.conf /usr/local/etc/php-fpm.d/docker.conf.bk

# 清理安装缓存
apt-get clean
pear clear-cache
rm -rf /tmp/pear /tmp/pear/temp
