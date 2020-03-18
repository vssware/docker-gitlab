# Gitlab Docker Images

基于 *vssware/centos* 镜像创建。

## 初始化
### 数据卷初始化
```shell script
#初始化数据卷
mkdir -p /data/docker/gitlab/data && chmod -R 777 /data/docker/gitlab/data
mkdir -p /data/docker/gitlab/log && chmod -R 777 /data/docker/gitlab/log
```

### 初次启动
```shell script
docker run -it \
	--rm \
	--env 'INIT=true' \
	--env 'EXTERNAL_URL=http://localhost' \
	--env 'SMTP_SERVER=smtp.vssware.com' \
	--env 'SMTP_PORT=25' \
	--env 'SMTP_USER=jimmy@vssware.com' \
	--env 'SMTP_PASSWORD=abc' \
	--env 'SMTP_DOMAIN=vssware.com' \
	--env 'REDIS_ENABLE=false' \
	--env 'REDIS_SERVER=redis' \
	--env 'REDIS_PORT=6379' \
	--env 'REDIS_PASSWORD=vssware' \
	--env 'REDIS_DATABASE=0' \
	--env 'POSTGRESQL_ENABLE=false' \
	--env 'POSTGRESQL_SERVER=postgresql' \
	--env 'POSTGRESQL_PORT=5432' \
	--env 'POSTGRESQL_USER=gitlab' \
	--env 'POSTGRESQL_PASSWORD=gitlab' \
	-v /data/docker/gitlab/data:/var/opt/gitlab:Z \
    -v /data/docker/gitlab/log:/var/log/gitlab:Z \
    --privileged \
	vssware/gitlab
```
INIT=true: 初始化配置   
EXTERNAL_URL: 外部访问地址  
SMTP_SERVER: SMTP服务器地址  
SMTP_PORT: SMTP服务器端口  
SMTP_USER: SMTP用户名  
SMTP_PASSWORD: SMTP用户密码  
SMTP_DOMAIN: SMTP域名  

REDIS_ENABLE: 是否启用内部Redis，设置为true，不配置外部Redis服务器，下面REDIS_开头配置不生效  
REDIS_SERVER: Redis服务器地址  
REDIS_PORT: Redis服务器端口  
REDIS_PASSWORD: Redis服务密码  
REDIS_DATABASE: Redis Database  

POSTGRESQL_ENABLE: 是否启用内部Postgresql数据库，设置为true，不配置外部Postgresql数据库，下面POSTGRESQL_开头不生效  
POSTGRESQL_SERVER: Postgresql服务器地址  
POSTGRESQL_PORT: Postgresql服务器端口  
POSTGRESQL_USER: 数据库用户名  
POSTGRESQL_PASSWORD: 数据库用户密码  

## 常规运行
```shell script
docker run -d \
	-p 80:80 \
	-h gitlab \
	--name gitlab \
	-v /data/docker/gitlab/data:/var/opt/gitlab:Z \
    -v /data/docker/gitlab/log:/var/log/gitlab:Z \
	--privileged \
	vssware/gitlab
```

## 其他
若使用外部数据库，需要先初始化数据库，参考以下：
```shell script
create user gitlab with password 'gitlab';
create database gitlabhq_production with owner gitlab ENCODING 'UTF8';
grant all privileges on database gitlabhq_production to gitlab;
\\c gitlabhq_production;
CREATE EXTENSION pg_trgm;
```

