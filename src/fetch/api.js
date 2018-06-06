import axios from 'axios'
import qs from 'qs'

// axios 配置
let instance = axios.create({
  baseURL: 'http://127.0.0.1:3000/',
});

//拦截器
/*axios.interceptors.request.use(
  config => {
    if ( window.sessionStorage.getItem('token')) {  // 判断是否存在token，如果存在的话，则每个http header都加上token
     // Object.assign(config.headers, { 'X-Auth-Token': window.sessionStorage.getItem('token') });
      config.headers.Authorization = ` JWT ${window.sessionStorage.getItem('token')}`;
    }
    return config;
  },
  err => {
    return Promise.reject(err);
  });*/
export function fetch(url, param, method = 'post', isFormType = false, timeout = 600000) {
  return new Promise((resolve, reject) => {
    let userParam = {
      user: window.sessionStorage.getItem('user'),
      token: window.sessionStorage.getItem('token'),
    };
    let params = qs.stringify(Object.assign(userParam, param));
    let contentType = 'application/x-www-form-urlencoded;charset=UTF-8';
    if (isFormType) {
      //form表单所需contentType
      contentType = 'multipart/form-data';
      //myUserName和token也要以表单的形式传进去
      params = param;
    }
    let config = {
      headers: {'Content-Type': contentType},
      timeout: timeout
    };
    if (method == 'post') {
      instance.post(url, params, config)
        .then(response => {
          resolve(response.data);
        }, err => {
          reject(err);
        })
        .catch((error) => {
          reject(error)
        })
    } else {
      instance.get(url, params, config)
        .then(response => {
          resolve(response.data);
        }, err => {
          reject(err);
        })
        .catch((error) => {
          reject(error)
        })
    }
  })
}

export default {
  /**
   * 用户
   */
  login(params) {
    return fetch('user/login', params)
  },
  /* register(params) {
     return fetch('user/addUser', params)
   },*/
  getUserInfo(params) {
    return fetch('user/getUserInfo', params)
  },
  editUserInfo(params) {
    return fetch('user/editUserInfo', params)
  },
  /**
   * 项目
   */
  addProject(params) {
    return fetch('project/addProject', params)
  },
  getProjectInfo(params) {
    return fetch('project/getProjectInfo', params)
  },
  editProject(params) {
    return fetch('project/editProject', params)
  },
  /**
   * 文章
   */
  getArticleDirection(params) {
    return fetch('article/getDirection', params)
  },
  getCategoryByDirection(params) {
    return fetch('article/getCategoryByDirection', params)
  },
  addArticle(params) {
    return fetch('article/addArticle', params)
  },
  editArticle(params) {
    return fetch('article/editArticle', params)
  },
  deleteArticle(params) {
    return fetch('article/deleteArticle', params)
  },
  getArticleList(params) {
    return fetch('article/getArticleList', params)
  },
  getSearchArticle(params) {
    return fetch('article/getSearchArticle', params)
  },
  getRecommendedArticle(params) {
    return fetch('article/getRecommendedArticle', params)
  },
  getArticleListByType(params) {
    return fetch('article/getArticleListByType', params)
  },
  getRecommendedArticleByType(params) {
    return fetch('article/getRecommendedArticleByType', params)
  },
  getArticleDetail(params) {
    return fetch('article/getArticleDetail', params)
  },
  uploadFile(params) {
    return fetch('article/upload', params, 'post', true);
  },
  /**
   * 菜单
   */
  addMenu(params) {
    return fetch('menu/addMenu', params)
  },
  editMenu(params) {
    return fetch('menu/editMenu', params)
  },
  getMenuList(params) {
    return fetch('menu/getMenuList', params)
  },
  getTreeMenuList(params) {
    return fetch('menu/getTreeMenuList', params)
  },
  getCategoryMenu(params) {
    return fetch('menu/getCategoryMenu', params)
  },
  deleteMenu(params) {
    return fetch('menu/deleteMenu', params)
  },
}
