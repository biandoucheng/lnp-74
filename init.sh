#!/bin/bash
# author:biandou
#laravel 项目初始化脚本示例

#初始化php配置
sed -i 's/max_children.*[0-9]\+/max_children = 30/g' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/start_servers.*[0-9]\+/start_servers = 15/g' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/min_spare_servers.*[0-9]\+/min_spare_servers = 10/g' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/max_spare_servers.*[0-9]\+/max_spare_servers = 20/g' /etc/opt/remi/php74/php-fpm.d/www.conf
sed -i 's/serialize_precision.*[0-9]\+/serialize_precision = 14/g' /etc/opt/remi/php74/php-fpm.d/www.conf

echo 'zend_extension=opcache' >> /etc/opt/remi/php74/php.ini
echo 'opcache.enable=1' >> /etc/opt/remi/php74/php.ini
echo 'opcache.enable_cli=1' >> /etc/opt/remi/php74/php.ini
echo 'opcache.memory_consumption=128' >> /etc/opt/remi/php74/php.ini
echo 'opcache.interned_strings_buffer=8' >> /etc/opt/remi/php74/php.ini
echo 'opcache.max_accelerated_files=10000' >> /etc/opt/remi/php74/php.ini
echo 'opcache.revalidate_freq=60' >> /etc/opt/remi/php74/php.ini
echo 'opcache.fast_shutdown=1' >> /etc/opt/remi/php74/php.ini

#尝试解决DNS解析超时
echo 'options single-request-reopen' >> /etc/resolv.conf

#配置站点权限
chown -R www:www public
setfacl -R -d -m user:www:rwx  ./storage/logs/
setfacl -R -d -m group:www:rwx  ./storage/logs/
chmod -R 777 storage
chmod -R 755 public

#初始化laravel三方库加载及配置参数和路由缓存加载
composer install --optimize-autoloader --no-dev
php artisan config:cache
php artisan route:cache

#启动php和nginx
php-fpm
nginx

#启动项目定时任务
echo '* * * * * root cd /usr/local/nginx/html && php artisan schedule:run' >> /etc/crontab

#开启linux 定时任务常驻窗口
/usr/sbin/crond -n