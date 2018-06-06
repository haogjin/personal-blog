// node 后端服务器入口
const userApi = require('./api/userApi');
const articleApi = require('./api/articleApi');
const menuApi = require('./api/menuApi');
const projectApi = require('./api/projectApi');
const fs = require('fs');
const path = require('path');
const bodyParser = require('body-parser');
const express = require('express');
const app = express();
/*const jwtauth = require('./util/jwtauth.js');*/


app.all('*',function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Content-Length, Authorization, Accept, X-Requested-With');
  res.header('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS');

  if (req.method == 'OPTIONS') {
    res.sendStatus(200); //让options请求快速返回/
  }
  else {
    next();
  }
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

//注册api路由
app.use('/user', userApi);
app.use('/article', articleApi);
app.use('/menu', menuApi);
app.use('/project', projectApi);
/*app.all('/!*', [bodyParser, jwtauth]);*/
// 监听端口
app.listen(3000);
console.log('success listen at port:3000......');
