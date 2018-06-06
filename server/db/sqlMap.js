/*
  返回到前台得msgCode:
  0:成功


 */

var sqlMap = {
  // 用户
  user: {
    add: 'insert into users(user_name,user_password) values (?, ?) ',
    queryAll: 'select id,address,skill,introduction from users ',
    login: 'select * from users where user_name = ? ',
    edit: 'update users set address = ?, skill = ?, introduction = ? where id = ? ',
  },
  // 项目
  project: {
    add: 'insert into project_info(time,introduction,url) values (?, ?, ?) ',
    queryAll: 'select id,date_format(time +\'\',\'%Y-%m-%d\') as time,introduction,url from project_info order by time desc ',
    edit: 'update project_info set time = ?, introduction = ?, url = ? where id = ? ',
  },
  //文章
  article:{
    add: 'insert into articles(article_id,user_name,title,directionId,categoryId,summary,content,create_time) values (replace(uuid(), \'-\', \'\'),?, ?, ?, ?, ?, ?, ?)',
    queryAll: 'select article_id as articleId,title,articles.directionId,directionName,articles.categoryId,categoryName,summary,open_count as openCount ,date_format(create_time +\'\',\'%Y-%m-%d %H:%m:%S\') as createTime from articles left join article_type on (articles.directionId = article_type.directionId and articles.categoryId = article_type.categoryId) order by create_time desc limit ?, ? ',
    querySearchedAll:'select article_id as articleId,title,articles.directionId,directionName,articles.categoryId,categoryName,summary,content,open_count as openCount ,date_format(create_time +\'\',\'%Y-%m-%d %H:%m:%S\') as createTime from articles left join article_type on (articles.directionId = article_type.directionId and articles.categoryId = article_type.categoryId) where title like ? order by create_time desc limit ?, ? ',
    queryArticleDetail:'select * from articles left join article_type on (articles.directionId = article_type.directionId and articles.categoryId = article_type.categoryId) where article_id = ? ',
    queryArticleByType:'select article_id as articleId,title,articles.directionId,directionName,articles.categoryId,categoryName,summary,open_count as openCount ,date_format(create_time +\'\',\'%Y-%m-%d %H:%m:%S\') as createTime from articles left join article_type on (articles.directionId = article_type.directionId and articles.categoryId = article_type.categoryId) where categoryName = ?  order by create_time desc limit ?, ?  ',
    queryRecommendedArticle:'select article_id as articleId,title from articles order by open_count desc limit 0,10',
    queryRecommendedArticleByType:'select article_id as articleId,title from articles left join article_type on (articles.directionId = article_type.directionId and articles.categoryId = article_type.categoryId) where categoryName = ? order by open_count desc limit 0,10 ',
    updateOpenCount:'update articles set open_count = open_count+1 where article_id = ? ',
    edit: 'update articles set title = ?,directionId = ?,categoryId = ?,summary = ?,content = ?,update_time = ? where article_id = ? ',
    delete: 'delete from articles where article_id = ?'
  },
  //分类
  article_type:{
    add: 'insert into article_type(direction,category) values (? ,?)',
    queryDirection: 'select distinct directionId, directionName from article_type',
    queryCategoryByDirection: 'select distinct categoryId, categoryName  from article_type where directionId = ? ',
  },
  menu:{
    add:'insert into menu(menu_id,parent,title,name,path,icon,identifier,type,orders,status,create_time) values (replace(uuid(), \'-\', \'\'),?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ',
    edit:'update menu set parent=?,title=?,name=?,path=?,icon=?,identifier=?,type=?,orders=?,status=?,update_time=? where menu_id = ? ',
    queryByParent: 'select menu_id as menuId,parent,title,name,path,icon,orders,type,identifier,status from menu where parent = ? ',
    queryAll: 'select menu_id as menuId,parent,title,name,path,icon,type,orders,identifier as component from menu',
    delete: 'delete from menu where menu_id in ? '
  }
}
module.exports = sqlMap;
