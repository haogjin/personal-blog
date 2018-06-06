let models = require('../db/db');
let express = require('express');
let router = express.Router();
let fs = require('fs');
let http = require('http');
let mysql = require('mysql');
let $sql = require('../db/sqlMap');
let util= require('../util/util');

let sqlArticle = $sql.article;
let sqlArticleType = $sql.article_type;
// 连接数据库
let conn = mysql.createConnection(models.mysql);
conn.connect();

let multer = require('multer');
const path = require('path');
let setting = require('../config/setting.json');

/*
get与post方法区别
1. get是从服务器上获取数据，post是向服务器传送数据。
2. get是把参数数据队列加到提交表单的ACTION属性所指的URL中，值和表单内各个字段一一对应，在URL中可以看到。post是通过HTTP post机制，将表单内各个字段与其内容放置在HTML HEADER内一起传送到ACTION属性所指的URL地址。用户看不到这个过程。
3. 对于get方式，服务器端用Request.QueryString获取变量的值，对于post方式，服务器端用Request.Form获取提交的数据。
4. get传送的数据量较小，不能大于2KB。post传送的数据量较大，一般被默认为不受限制。但理论上，IIS4中最大量为80KB，IIS5中为100KB。
5. get安全性非常低，post安全性较高。但是执行效率却比Post方法好。
建议：
1、get方式的安全性较Post方式要差些，包含机密信息的话，建议用Post数据提交方式；
2、在做数据查询时，建议用Get方式；而在做数据添加、修改或删除时，建议用Post方式；
 */

/**
 * 单文件上传配置
 */
let uploadSingle = multer({
  dest: 'uploads/'
});

/**
 * 获取文章方向（前端、后端....）
 */
router.post('/getDirection',(req, res)=>{
 /* if(!util.checkToken(req,res)){
    return;
  }*/
  conn.query(sqlArticleType.queryDirection, (err, result)=>{
    if(err){
      console.log(err);
      return;
    }
    console.log(result)
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})

/**
 * 通过文章方向获取对应的类别
 */
router.post('/getCategoryByDirection',(req, res)=>{
 /* if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  conn.query(sqlArticleType.queryCategoryByDirection, param.directionId, (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章类型失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})

/**
 * 发布文章
 */
router.post('/addArticle',(req, res)=>{
  /*if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  if(!param.token){
    res.json({msgCode: 3010, msg: 'token不存在，不具备添加权限'});
    return;
  }
  conn.query(sqlArticle.add,[param.user_name, param.title, param.directionId, param.categoryId,param.summary,param.content, new Date()], (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '添加文章失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '添加文章失败'});
      return;
    }
    res.json({msgCode:0,msg:'添加文章成功'});
  })
})

/**
 * 编辑文章
 */
router.post('/editArticle',(req, res)=>{
 /* if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  if(!param.token){
    res.json({msgCode: 3010, msg: 'token不存在，不具备编辑权限'});
    return;
  }
  conn.query(sqlArticle.edit,[param.title, param.directionId, param.categoryId, param.summary, param.content, new Date(),param.articleId], (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '更新文章失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '更新文章失败'});
      return;
    }
    res.json({msgCode:0,msg:'修改文章成功'});
  })
})

/**
 * 删除文章
 */
router.post('/deleteArticle',(req, res)=>{
  /*if(!util.checkToken(req,res)){
    return;
  }*/
  let param = req.body;
  if(!param.token){
    res.json({msgCode: 3010, msg: 'token不存在，不具备删除权限'});
    return;
  }
  conn.query(sqlArticle.delete,param.articleId, (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '删除文章失败'});
      return;
    }
    if (!result) {
      res.json({msgCode: 3004, msg: '删除文章失败'});
      return;
    }
    res.json({msgCode:0,msg:'删除文章成功'});
  })
})

/**
 * 获取所有的文章列表
 */
router.post('/getArticleList',(req, res)=>{
  // 获取前台页面传过来的参数
  //let param = req.query || req.body;
  let param = req.body;
  let pageNum = parseInt(param.pageNum || 1);// 页码
  let end = 5 //parseInt(param.pageSize || 10); // 默认页数
  let start = (pageNum - 1) * end;
  conn.query(sqlArticle.queryAll,[start, end], (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章失败'});
      return;
    }
    //console.log(result.length)
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})
/**
 * 通过全局查询条件获取所有的文章列表
 */
router.post('/getSearchArticle',(req, res)=>{
  // 获取前台页面传过来的参数
  //let param = req.query || req.body;
  let param = req.body;
  let pageNum = parseInt(param.pageNum || 1);// 页码
  let end = 5 //parseInt(param.pageSize || 10); // 默认页数
  let start = (pageNum - 1) * end;
  conn.query(sqlArticle.querySearchedAll,["%"+ param.t +"%", start, end], (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章失败'});
      return;
    }
    //console.log(result.length)
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})


/**
 * 获取推荐的文章列表
 */
router.post('/getRecommendedArticle',(req, res)=>{
  conn.query(sqlArticle.queryRecommendedArticle, (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})

/**
 * 获取对应类型的推荐文章列表
 */
router.post('/getRecommendedArticleByType',(req, res)=>{
  let param = req.body;
  conn.query(sqlArticle.queryRecommendedArticleByType,param.type,(err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})

/**
 * 获取对应类型的所有文章列表
 */
router.post('/getArticleListByType',(req, res)=>{
  let param = req.body;
  let pageNum = parseInt(param.pageNum || 1);// 页码
  let end = 5 //parseInt(param.pageSize || 10); // 默认页数
  let start = (pageNum - 1) * end;
  conn.query(sqlArticle.queryArticleByType,[param.type, start, end],(err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功',data:result})
  })
})

/**
 * 获取文章详情
 */
router.post('/getArticleDetail',(req, res)=>{
  let param = req.body;
  conn.query(sqlArticle.queryArticleDetail,param.articleId, (err, result)=>{
    if(err){
      console.log(err);
      res.json({msgCode: 3003, msg: '查询文章失败'});
      return;
    }
    res.json({msgCode: 0, msg: '查询成功',data:result});
    if(param.token){
      return;
    }
    conn.query(sqlArticle.updateOpenCount,param.articleId, (err, result)=>{
      if(err){
        console.log(err);
        res.json({msgCode: 3003, msg: '更新阅读数失败'});
        return;
      }
      console.log('更新阅读数成功');
    })
  })
})

/**
 * 单文件上传
 */
router.post('/upload', uploadSingle.single('file-upload'), (req, res) => {
  /*if(!util.checkToken(req,res)){
    return;
  }*/
  // 没有附带文件
  if (!req.file) {
    res.json({ ok: false });
    return;
  }
  /*// 输出文件信息
  console.log('====================================================');
  console.log('fieldname: ' + req.file.fieldname);
  console.log('originalname: ' + req.file.originalname);
  console.log('encoding: ' + req.file.encoding);
  console.log('mimetype: ' + req.file.mimetype);
  console.log('size: ' + (req.file.size / 1024).toFixed(2) + 'KB');
  console.log('destination: ' + req.file.destination);
  console.log('filename: ' + req.file.filename);
  console.log('path: ' + req.file.path);*/
  //图片存放目录
  var imageDir = setting.image_dir;
  //图片完整路径
  var imagePath = path.resolve(imageDir, req.file.originalname);
  fs.rename(req.file.path, imagePath, (err) => {
    if (err) {
      res.json({msgCode: 3001});
      console.log(err);
      return;
    }
    var image_url = setting.image_url + req.file.originalname;
    res.json({msgCode:0,msg: '文件上传成功',url:image_url})
  });
});


module.exports = router;
