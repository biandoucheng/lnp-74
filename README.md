### 环境
`
php7.4
nginx1.21.0
debian.11
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
	FROM xxx/lnp-74-debian:1.0.0
2、设置端口
	EXPOSE 80
3、设置运行目录 
	WORKDIR /home/wwwroot/app 
4、复制项目文件到容器环境 
	COPY . /home/wwwroot/app
5、执行启动脚本进行项目依赖处理环境配置 
	RUN chmod +x ./start.sh
	ENTRYPOINT ["/bin/bash","-c","./start.sh"]
6、执行窗口占据命令 可以放在上一步的 init.sh文件中
`

### 注意事项
`
1、该环境nginx配置根路径在 /home/wwwroot/app/public 这是laravel项目的公共文件夹
2、nginx环境运行用户组为 www:www
3、根路径权限为 755
`

### 镜像本地调试命令
`
docker run --platform linux/amd64 -d  --name my_web_service  -p 8080:80/tcp   -v /xyz/app:/home/wwwroot/app imageId
`

### 镜像构建命令
`
docker build --platform=Linux/amd64 --force-rm -t xxx/lnp-74-debian:1.0.0 .

-- 跳过缓存
--no-cache
`

### 版本记录
+ 1.0 版本 debian11 + nginx1.21.0 + php7.4 + php-redis + php-mongodb + opcache + composer + git + python3.10 + supervisor