#基础环境
FROM centos:centos7.9.2009@sha256:dead07b4d8ed7e29e98de0f4504d87e8880d4347859d839686a31da35a3b532f

#复制脚本及配置文件到环境

COPY ./install.sh ./
COPY ./nginx.conf ./www.conf ./pip.conf /usr/local/etc/

#执行lnp环境安装脚本
RUN yum install -y dos2unix && chmod +x ./install.sh && dos2unix ./install.sh && /bin/bash -c ./install.sh