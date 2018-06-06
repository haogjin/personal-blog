import {otherRouter} from "../../router/router";

let util = {};

//检测请求码
util.checkResCode = (obj, res) => {
  if (res.msgCode == 0) {
    return true;
  }
  /*if (res.msgCode == 3099) {
    obj.$Modal.warning({
      title: '提示',
      content: res.msg,
      okText: '确定'
    })
    window.sessionStorage.setItem('token',res.token);
    //window.location.href = '/login';
    return false;
  }*/
  obj.$Modal.warning({
    title: '提示',
    content: res.msg,
    okText: '确定'
  });
  return false;
},
//请求失败
  util.showCatchErr = (obj, err, msg) => {
    let errorMsg = "请求服务器失败，请稍后重试"
    if(err.toString().indexOf("Error: Request failed with status code")!=-1){
      errorMsg="请求服务器失败，状态码为"+err.toString().substring(err.toString().lastIndexOf(" "),err.toString().length);
    }
    if (err.toString().indexOf("timeout") != -1) {
      errorMsg = "请求超时";
    }
    if (err.toString() == "Error: Network Error") {
      errorMsg = "服务器失联，请稍后重试";
    }
    if (err.toString().indexOf("TypeError") != -1) {//前端代码异常或后台返回
      errorMsg = "页面数据异常";
    }
    obj.$Modal.warning({
      title: '提示',
      content: msg ? (msg + "，" + errorMsg) : errorMsg,
      okText: '确定'
    })
    return false;
  };

//时间格式
let SIGN_REGEXP = /([yMdhsm])(\1*)/g;
let DEFAULT_PATTERN = 'yyyy-MM-dd';
function padding(s, len) {
  var len = len - (s + '').length;
  for (var i = 0; i < len; i++) {
    s = '0' + s;
  }
  return s;
};
util.formatTime = (date, pattern) => {
  pattern = pattern || DEFAULT_PATTERN;
  return pattern.replace(SIGN_REGEXP, function ($0) {
    switch ($0.charAt(0)) {
      case 'y':
        return padding(date.getFullYear(), $0.length);
      case 'M':
        return padding(date.getMonth() + 1, $0.length);
      case 'd':
        return padding(date.getDate(), $0.length);
      case 'w':
        return date.getDay() + 1;
      case 'h':
        return padding(date.getHours(), $0.length);
      case 'm':
        return padding(date.getMinutes(), $0.length);
      case 's':
        return padding(date.getSeconds(), $0.length);
    }
  });
};
//变成yyyy-MM-dd hh:mm:ss格式
util.formatToDate = (time)=> {
  if (!time) {
    return;
  }
  return util.formatTime(new Date(time), 'yyyy-MM-dd');
};

util.title = function (title) {
  title = title || 'Aimee的个人网站';
  window.document.title = title;
};

util.inOf = function (arr, targetArr) {
  let res = true;
  arr.forEach(item => {
    if (targetArr.indexOf(item) < 0) {
      res = false;
    }
  });
  return res;
};

util.oneOf = function (ele, targetArr) {
  if (targetArr.indexOf(ele) >= 0) {
    return true;
  } else {
    return false;
  }
};

util.showThisRoute = function (itAccess, currentAccess) {
  if (typeof itAccess === 'object' && Array.isArray(itAccess)) {
    return util.oneOf(currentAccess, itAccess);
  } else {
    return itAccess === currentAccess;
  }
};

util.getRouterObjByName = function (routers, name) {
  if (!name || !routers || !routers.length) {
    return null;
  }
  // debugger;
  let routerObj = null;
  for (let item of routers) {
    if (item.name == name) {
      return item;
    }
    routerObj = util.getRouterObjByName(item.children, name);
    if (routerObj) {
      return routerObj;
    }
  }
  return null;
};

util.handleTitle = function (vm, item) {
  if (typeof item.title === 'object') {
    return vm.$t(item.title.i18n);
  } else {
    return item.title;
  }
};

//面包屑路径
util.setCurrentPath = function (vm, route) {
  let title = '';
  let isOtherRouter = false;
  //拼接得到所有的路由
  vm.$store.state.app.routers = [... vm.$store.state.app.routers,...vm.$store.state.app.menuList];
  vm.$store.state.app.routers.forEach(item => {
    if (item.children.length === 1) {
      if (item.children[0].name === route.name) {
        title = util.handleTitle(vm, item);
        if (item.name === 'otherRouter') {
          isOtherRouter = true;
        }
      }
    } else {
      item.children.forEach(child => {
        if (child.name === route.name) {
          title = util.handleTitle(vm, child);
          if (item.name === 'otherRouter') {
            isOtherRouter = true;
          }
        }
      });
    }
  });
  let currentPathArr = [];
  if (route.name === 'home_index') {
    currentPathArr = [
      {
        title: util.handleTitle(vm, util.getRouterObjByName(vm.$store.state.app.routers, 'home_index')),
        path: '',
        name: 'home_index'
      }
    ];
  } else if (route.name !== 'home_index') {
    if (route.name.indexOf('_index') >= 0) {
      currentPathArr = [
        {
          title: title,
          path: '',
          name: route.name
        }
      ];
    } else if (otherRouter) {
      let currentPathObj = vm.$store.state.app.routers.filter(item => {
        if (item.children.length <= 1) {
          return item.children[0].name === route.name;
        } else {
          let i = 0;
          let childArr = item.children;
          let len = childArr.length;
          while (i < len) {
            if (childArr[i].name == route.name) {
              return true;
            }
            i++;
          }
          return false;
        }
      })[0];
      if (currentPathObj.children.length <= 1 && currentPathObj.name === 'home') {
        currentPathArr = [
          {
            title: '首页',
            path: '',
            name: 'home_index'
          }
        ];
      } else if (currentPathObj.children.length <= 1 && currentPathObj.name !== 'home') {
        currentPathArr = [
          {
            title: currentPathObj.title,
            path: '',
            name: route.name
          }
        ];
      } else {
        let typeArr = '';
        //route.query.category：前端-frontend-javascript /后端-backend-node.js 等
        if (route.query.category.indexOf('-') > -1) {
          typeArr = route.query.category.split('-')
        }
        currentPathArr = [
          {
            title: typeArr ? typeArr[0]=='frontend'?'前端':typeArr[0]=='backend'? '后端':typeArr[0]=='database'? '数据库':typeArr[0]=='server'?'服务器':'': '',
            path: '',
            name: route.query.category
          },
          {
            title: typeArr ? typeArr[1] : '',
            path: '',
            name: route.query.category
          }
        ];
      }
    }
  } else {
  }
  vm.$store.commit('setCurrentPath', currentPathArr);
  return currentPathArr;
};

util.openNewPage = (vm, name, argu, query) => {
  /*
  vm.$store报undefined 参考：https://segmentfault.com/q/1010000010827028/a-1020000010827916
  */
  //let pageOpenedList = vm.$store.state.app.pageOpenedList;
  let pageOpenedList = vm.$options.store.state.app.pageOpenedList;
  let openedPageLen = pageOpenedList.length;
  let i = 0;
  let tagHasOpened = false;
  while (i < openedPageLen) {
    if (name === pageOpenedList[i].name) { // 页面已经打开
      vm.$options.store.commit('pageOpenedList', {
        index: i,
        argu: argu,
        query: query
      });
      tagHasOpened = true;
      break;
    }
    i++;
  }
  if (!tagHasOpened) {
    let tag = vm.$options.store.state.app.tagsList.filter((item) => {
      if (item.children) {
        return name === item.children[0].name;
      } else {
        return name === item.name;
      }
    });
    tag = tag[0];
    if (tag) {
      tag = tag.children ? tag.children[0] : tag;
      if (argu) {
        tag.argu = argu;
      }
      if (query) {
        tag.query = query;
      }
      vm.$options.store.commit('increateTag', tag);
    }
  }
  vm.$options.store.commit('setCurrentPageName', name);
};

util.toDefaultPage = function (routers, name, route, next) {
  let len = routers.length;
  let i = 0;
  let notHandle = true;
  while (i < len) {
    if (routers[i].name === name && routers[i].children && routers[i].redirect === undefined) {
      route.replace({
        name: routers[i].children[0].name
      });
      notHandle = false;
      next();
      break;
    }
    i++;
  }
  if (notHandle) {
    next();
  }
};

util.fullscreenEvent = function (vm) {
  vm.$store.commit('initCachepage');
  // 权限菜单过滤相关
  vm.$store.commit('updateMenulist');
  // 全屏相关
};


export default util;
