/*
* 弃用
* */
var jwt = require('jsonwebtoken');//用来创建和确认用户信息摘要
// 检查用户会话
module.exports = function(req, res, next) {
  console.log('检查post的信息或者url查询参数或者头信息');
  //检查post的信息或者url查询参数或者头信息
  var token = req.body.token || req.query.token || req.headers['Authorization'];
  // 解析 token
  if (token) {
    // 确认token
    jwt.verify(token, 'secret)', function(err, decoded) {
      if (err) {
        return res.json({msgCode: 3099, msg: '登录过期，请重新登录',token:''});
      } else {
        try {
          //var decoded = jwt.decode(token, app.get('jwtTokenSecret'));
            if (decoded.exp <= Date.now()) {
            res.end('登录过期', 400);
          }
        } catch (err) {
           next();
        }
      }
    });
  } else {
    // 如果没有token，则返回错误
    return res.json({msgCode: 3199, msg: 'token为空'});
  }
};
