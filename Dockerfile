#基础环境
FROM php:7.4-fpm

#复制脚本及配置文件到环境
COPY ./install.sh ./start.sh ./nginx.conf ./www.conf ./pip.conf /usr/local/etc/

#执行lnp环境安装脚本
RUN chmod +x /usr/local/etc/install.sh && /bin/bash -c /usr/local/etc/install.sh

# 启动切入点
RUN chmod +x /usr/local/etc/start.sh
ENTRYPOINT ["/bin/bash","-c","/usr/local/etc/start.sh"]