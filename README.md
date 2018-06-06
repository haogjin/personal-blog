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

3、动态菜单管理模块是根据自己订的规则进行添加修改的

4、访问量和文章数的获取后续进行添加

5、写文章添加修改文件（如图片）的时候涉及文件上传，采用的是nginx服务器，配置文件路径：
nginx目录/files/images，nginx.conf文件相关代码：
server {       
  listen   8080;
  large_client_header_buffers 4 16k;
  client_max_body_size 30m;
  client_body_buffer_size 128k;

  location / {
  root   D:/nginx/nginx-1.6.3/files/images;
  index  index.html index.htm;
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
}

```

