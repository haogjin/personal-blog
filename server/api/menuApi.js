let models = require('../db/db');
let express = require('express');
let router = express.Router();
let fs = require('fs');
let http = require('http');
let mysql = require('mysql');
let async = require('async'); //异步执行
let util= require('../util/util');
let $sql = require('../db/sqlMap');
let sqlMenu = $sql.menu;
// 连接数据库
let conn = mysql.createConnection(models.mysql);
conn.connect();

/**
 * 添加菜单
 * parent,title,name,path,icon,type,orders,status,create_time
 */
router.post('/addMenu', (req, res) => {
 /* if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  if (!param.token) {
    res.json({msgCode: 3010, msg: 'token不存在，不具备添加权限'});
    return;
  }
  conn.query(sqlMenu.add, [param.parent, param.title, param.name, param.path, param.icon, param.identifier, param.type, param.orders, param.status, new Date()], (err, result) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '添加菜单失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '添加菜单失败'});
      return;
    }
    res.json({msgCode: 0, msg: '添加菜单成功'});
  })
})
/**
 * 修改菜单
 * update menu set parent=?,title=?,name=?,path=?,icon=?,identifier=?,type=?,orders=?,status=?,update_time=? where menu_id = ?
 */
router.post('/editMenu', (req, res) => {
 /* if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  if (!param.token) {
    res.json({msgCode: 3010, msg: 'token不存在，不具备添加权限'});
    return;
  }
  conn.query(sqlMenu.edit, [param.parent, param.title, param.name, param.path, param.icon, param.identifier, param.type, param.orders, param.status, new Date(),param.menuId], (err, result) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '修改菜单失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '修改菜单失败'});
      return;
    }
    res.json({msgCode: 0, msg: '修改菜单成功'});
  })
})

/**
 * 根据菜单列表用于前端显示分类菜单
 */
function getChildList(data, initItem) {
  if (data.length <= 0) {
    return;
  }
  data.map((item) => {
    if (item.menuId == initItem.parent) {
      item.children.push(initItem)
    }
    if (data.children) {
      getChildList(data.children, initItem)
    }
  })
  return data;
}
//sort方法对对象数组按照对象属性进行排序
function compare(property){
  return function(obj1,obj2){
    var value1 = obj1[property];
    var value2 = obj2[property];
    return value1 - value2;     // 升序
  }
}
router.post('/getCategoryMenu', (req, res) => {
  let menuData = [];//存储菜单
  conn.query(sqlMenu.queryAll, (err, result) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '查询菜单失败'});
      return;
    }
    result.map((item) => {
      if (!item.parent) {
        item = Object.assign({}, item, {children: []});
        if(!req.body.token && item.title =='菜单管理' ){
          return;
        }
        menuData.push(item);
        menuData.sort(compare("orders"));
      } else {
        getChildList(menuData, item);
      }
    });
    res.json({msgCode: 0, msg: '查询成功', data: menuData})
  })
})


/**
 * 根据父级id分级获取父级下的菜单列表
 */
router.post('/getMenuList', (req, res) => {
  /*if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  let parentId = param.currentParentId ? param.currentParentId : '';
  conn.query(sqlMenu.queryByParent, parentId, (err, result) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '查询菜单失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功', data: result})
  })
})

/**
 * 根据父级id分级返回树形菜单
 */
router.post('/getTreeMenuList', (req, res) => {
  /*if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  conn.query(sqlMenu.queryByParent, param.currentParentId, (err, data) => {
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '查询菜单失败'});
      return;
    }
    //异步执行，保证数据库遍历查询完之后返回数据给前端
    //但是这里应该把子节点的父级也一起返回。。。目前还没做
    async.map(data, (item, callback) => {
      conn.query(sqlMenu.queryAll, item.menuId, (err, result) => {
        if (err) {
          console.log(err);
          res.json({msgCode: 3003, msg: '查询菜单失败'});
          return;
        }
        if (!result) {
          item = Object.assign({}, item, {haveChild: 'false'});
          return;
        }
        item = Object.assign({}, item, {haveChild: 'true'});
        callback(null, item);
      })
    }, (err, data) => {
      res.json({msgCode: 0, msg: '查询成功', data: data})
    });
  })
})

/**
 * 批量删除菜单列表
 */
router.post('/deleteMenu', (req, res) => {
 /* if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  let menuIdsArr = param.menuIds.split(',');
  let menuIds = "'" + menuIdsArr.join("','") + "'";
  conn.query('delete from menu where menu_id in ('+ menuIds +')' , (err, result) => {
 // conn.query(sqlMenu.delete,"("+ menuIds +")" , (err, result) => {//报错
    if (err) {
      console.log(err);
      res.json({msgCode: 3003, msg: '删除菜单失败'});
      return;
    }
    res.json({msgCode: 0, msg: '删除成功', data: result})
  })
})

module.exports = router;
