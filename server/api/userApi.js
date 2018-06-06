const models = require('../db/db');
const express = require('express');
const router = express.Router();
const mysql = require('mysql');
const $sql = require('../db/sqlMap');
const util= require('../util/util');
const jwt = require('jsonwebtoken');
const sql = $sql.user;
// 连接数据库
let conn = mysql.createConnection(models.mysql);
conn.connect();

// 增加用户接口--post
/*router.post('/addUser', (req, res) => {
  let params = req.body ||req.query;
  let isExitUser = false;
  conn.query(sql.queryAll, (err, result)=>{
    if(err) {
      res.json({msgCode:3001,msg:'查询用户失败'});
      return;
    }
    if(result){
      console.log(result);
      isExitUser = result.some((item)=>{
        if(item.user_name == params.user_name){
          return true;
        }
        return false;
      });
    }
    if(isExitUser){
      res.json({msgCode: 3002, msg: '该用户名已存在，请重新注册'});
      return;
    }
    conn.query(sql.add, [params.user_name, params.user_password], (err, result)=> {
      if (err) {
        res.json({msgCode: 3003, msg: '注册用户失败'});
        return;
      }
      if (result) {
        res.json({msgCode: 0, msg: '注册用户成功'});
        return;
      }
      res.json({msgCode:3004,msg:'注册用户失败'});
    })
  })
});*/
// 登录接口--post
router.post('/login', (req, res) => {
  let param = req.body;
  if(!param.user_name || !param.user_password){
    return;
  }
  conn.query(sql.login,[param.user_name], (err, result) => {
      if(err){
        console.log(err);
        return;
      }
      if(result.length == 0){
        console.log('用户名不存在');
        res.json({msgCode: 3005, msg: '用户不存在'});
        return;
      }
      if(param.user_password != result[0].user_password){
        //req.session.error = '密码错误';
        res.json({msgCode: 3006, msg: '密码错误'});
        return;
      }
    // 创建token
     // var token = jwt.sign(JSON.stringify(result), 'app.get(superSecret)');
    let token = jwt.sign({
      name: 'blog web'
    }, 'secret', {
      expiresIn:  60 //秒到期时间
    });
      res.json({msgCode: 0, msg: '登录成功',token:token});
    });
});

/**
 * 获取用户详情
 */
router.post('/getUserInfo',(req, res)=>{
  conn.query(sql.queryAll, (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询用户信息失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询用户信息成功',data:result})
  })
})

/**
 * 修改用户信息
 * update users set address = ?, skill = ?, introduction = ? where id = ?'
 */
router.post('/editUserInfo',(req, res)=>{
  /*if(!util.checkToken(req,res,util.returnMsg)){
    return;
  }*/
  let param = req.body;
  if(!param.token){
    res.json({msgCode: 3010, msg: 'token不存在，不具备编辑权限'});
    return;
  }
  conn.query(sql.edit,[param.address, param.skill, param.introduction, param.id], (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '修改用户信息失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '修改用户信息失败'});
      return;
    }
    res.json({msgCode:0,msg:'修改用户信息成功'});
  })
})
module.exports = router;
