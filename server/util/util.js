var jwt = require('jsonwebtoken');
let util = {};

/**
 * 原本打算通过token有效期限制登录用户，但是这里是异步的，用回调的方式也不行，暂时先不弄了....
* */
util.checkToken = (req,res,cb)=>{
  var token = req.body.token || req.query.token || req.headers["x-access-token"]; // 从body或query或者header中获取token
  console.log(token)
  jwt.verify(token, 'secret', (err, decoded)=> {
    if (!err){
      console.log('有效的token');  //会输出123，如果过了60秒，则有错误。
      return true;
    }
   /* if(err.message == 'jwt expired'|| 'invalid token'){
      console.log('token过期或伪造/无效的token');
      res.json({msgCode: 3099, msg: '登录过期，请重新登录'});
      console.log(token);
      return false;
    }*/
    //res.json({msgCode: 3099, msg: '登录过期，请重新登录',token:''});
    cb(res)
    console.log(err)
    return false;
  })
}
util.returnMsg = (res)=>{
  res.json({msgCode: 3099, msg: '登录过期，请重新登录',token:''});
}

module.exports = util;
