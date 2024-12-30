### 环境
`
php7.4
nginx1.20.2
centos7.6
`

### 路由重写规则
`
location / {
    try_files $uri $uri/ /index.php?$query_string;
}
`

### 项目部署流程
`
1、拉取镜像 
	FROM zhugecheng/lnp-74:1.0
2、设置端口
	EXPOSE 80
3、设置运行目录 
	WORKDIR /usr/local/nginx/html 4、赋值项目文件到容器环境 
	COPY . /usr/local/nginx/html
5、执行启动脚本进行项目依赖处理环境配置 
	RUN chmod +x ./init.sh
	ENTRYPOINT ["/bin/bash","-c","./init.sh"]
6、执行窗口占据命令 可以放在上一步的 init.sh文件中
`

### 注意事项
`
1、该环境nginx配置根路径在 /usr/local/nginz/html/public 这是laravel项目的公共文件夹
2、nginx环境运行用户组为 www:www
3、根路径权限为 755
`

### 镜像构建命令
`
docker build --platform=Linux/adm64 --force-rm -t zhugecheng/lnp-74:1.1 .
`

### 版本记录
+ 1.0 版本 centos7.6 + nginx1.20.2 + php7.4 + opcache + composer + git
+ 1.1 版本 centos7.6 + nginx1.20.2 + php7.4 + opcache + composer + git + python3.10(python3) + supervisor
+ 1.1.2 版本 + php74-php-pgsql; cenots:7.9:linux/adm64;