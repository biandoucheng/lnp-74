#!/bin/bash
# author:biandou
#容器启动脚本 作为启动参考和启动测试

#启动php和nginx
php-fpm
nginx

#开启linux 定时任务常驻窗口
/usr/sbin/cron -f