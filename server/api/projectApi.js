let models = require('../db/db');
let express = require('express');
let router = express.Router();
let util= require('../util/util');
let mysql = require('mysql');
let $sql = require('../db/sqlMap');
let sqlProject = $sql.project;
// 连接数据库
let conn = mysql.createConnection(models.mysql);
conn.connect();

/**
 * 获取项目信息
 */
router.post('/getProjectInfo',(req, res)=>{
  conn.query(sqlProject.queryAll, (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询项目信息失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})
/**
 * 添加项目
 * insert into project_info(time,introduction,url) values (?, ?, ?)
 */
router.post('/addProject', (req, res) => {
  let param = req.body;
  if (!param.token) {
    res.json({msgCode: 3010, msg: 'token不存在，不具备添加权限'});
    return;
  }
  conn.query(sqlProject.add, [param.time, param.introduction, param.url], (err, result) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '添加项目失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '添加项目失败'});
      return;
    }
    res.json({msgCode: 0, msg: '添加项目成功'});
  })
})

/**
 * 修改项目
 * update users set time = ?, introduction = ?, url = ? where id = ?
 */
router.post('/editProject', (req, res) => {
  let param = req.body;
  if (!param.token) {
    res.json({msgCode: 3010, msg: 'token不存在，不具备添加权限'});
    return;
  }
  conn.query(sqlProject.edit, [param.time, param.introduction, param.url, param.id], (err, result) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '修改项目失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '修改项目失败'});
      return;
    }
    res.json({msgCode: 0, msg: '修改项目成功'});
  })
})

module.exports = router;
