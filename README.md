#### 技术

vue.js+iview+node.js+espress+mysql

#### 效果查看
https://www.jianshu.com/p/11dd7d8dbae2

#### 运行步骤

``` bash
1、在本地数据库建立myblog数据库，运行数据库脚本文件myblog.sql，数据库连接设置路径server/db/db.js

2、下载依赖：npm install

3、进入server文件夹目录运行node：node app

4、直接运行会进入用户查看界面：npm run dev

5、管理员界面入口：/login
   账号：Aimee   密码：111111
```
#### 说明
``` bash
1、用户：提供查看和搜索权限
2、管理员：登陆后可以对个人信息、文章、菜单进行增删改查操作
3、写文章添加修改文件（如图片）的时候涉及文件上传，采用的是nginx服务器，配置文件路径：
nginx目录/files/images，nginx.conf文件代码：
```
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    tcp_nopush     on;
    sendfile_max_chunk 256K;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    gzip on;
    gzip_min_length  1k;
    gzip_buffers     4 8k;
    gzip_http_version 1.1;
    gzip_types text/plain application/javascript application/x-javascript text/javascript text/xml text/css;
    
    upstream localhost {
        server localhost:3000;#node服务器
    }
	 server {       
	  listen   8080;
	    large_client_header_buffers 4 16k;
	    client_max_body_size 30m;
	    client_body_buffer_size 128k;

	    location / {
	    root   D:/nginx/nginx-1.6.3/files/images;
	    index  index.html index.htm;
	    }
	  }

    server {
        listen       80;
        server_name  localhost;
        
        
        #开启索引功能
        autoindex    on;
        
        #关闭计算文件确切大小
        autoindex_exact_size off;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        #上传操作由node服务器处理
        location / {
            proxy_pass    http://localhost;
            index    index.html;
        }
        
        #映射图片访问url
        location /image/ {
            expires 30d;#缓存时间
            root   D:/nginx/nginx-1.6.3/files/images;
        }
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|woff|ttf|eot|svg)$ {
           expires 1y;
        }

        location ~ .*\.(js|css)$ {
          expires 1y;
        }


        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
```

4、动态菜单管理模块是根据自己订的规则进行添加修改的
5、访问量和文章数的获取后续进行添加
```
For a detailed explanation on how things work, check out the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).
