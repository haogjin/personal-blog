import {otherRouter, appRouter} from '@/router/router';
import Cookies from 'js-cookie';
import Vue from 'vue';
import Util from '@/scripts/common/util';

const app = {
  state: {
    cachePage: [],
    lang: '',
    isFullScreen: false,
    openedSubmenuArr: [], // 要展开的菜单数组
    menuTheme: 'light', // 主题
    themeColor: '',
    pageOpenedList: [{
      title: '首页',
      path: '',
      name: 'home_index'
    }],
    currentPageName: '',
    currentPath: [
      {
        title: '首页',
        path: '',
        name: 'home_index'
      }
    ], // 面包屑数组
    menuList: [],
    routers: [
      otherRouter,
     // ...appRouter,
    ],
    tagsList: [...otherRouter.children],
    articleList: [],
    recommendedArticleList: [],
    dontCache: [] // 在这里定义你不想要缓存的页面的name属性值(参见路由配置router.js)
  },
  mutations: {
    setArticleList(state, list) {
      state.articleList = list;
    },
    setRecommendedArticleList(state, list) {
      state.recommendedArticleList = list;
    },
    updateMenulist(state,routes) {
      let menuList = [];
      routes.forEach((item) => {
        if (item.children.length === 1) {
          menuList.push(item);
        } else {
          let len = menuList.push(item);
          let childrenArr = [];
          childrenArr = item.children.filter(child => child);
          if (childrenArr === undefined || childrenArr.length === 0) {
            menuList.splice(len - 1, 1);
          } else {
            let handledItem = JSON.parse(JSON.stringify(menuList[len - 1]));
            handledItem.children = childrenArr;
            menuList.splice(len - 1, 1, handledItem);
          }
        }
      });
      state.menuList = menuList;
    },
    changeMenuTheme(state, theme) {
      state.menuTheme = theme;
    },
    changeMainTheme(state, mainTheme) {
      state.themeColor = mainTheme;
    },
    addOpenSubmenu(state, route) {
      //这样有bug，当收缩两次父节点之后，再次点击子节点，父节点就会收缩
     /* let hasThisName = false, isEmpty = false;
      //获取frontend 与 backend 等，使其下级菜单展开
      if (route.name.indexOf('-') > -1) {
        let typeArr = route.name.split('-')
        route.name = typeArr[0];
      }
      if (route.name.length === 0) {
        isEmpty = true;
      }
      if (state.openedSubmenuArr.indexOf(route.name) > -1) {
        hasThisName = true;
      }
      if (!hasThisName && !isEmpty) {
        state.openedSubmenuArr.push(route.name);
      }*/
     //于是采用accordion：是否开启手风琴模式，开启后每次至多展开一个子菜单 ，这需要每次先清空其他的
      state.openedSubmenuArr = [];
      if (route.name.indexOf('-') > -1) {
        let typeArr = route.name.split('-')
        route.name = typeArr[0];
      }
      state.openedSubmenuArr.push(route.name);
    },
    closePage(state, name) {
      state.cachePage.forEach((item, index) => {
        if (item === name) {
          state.cachePage.splice(index, 1);
        }
      });
    },
    initCachepage(state) {
      if (localStorage.cachePage) {
        state.cachePage = JSON.parse(localStorage.cachePage);
      }
    },
    removeTag(state, name) {
      state.pageOpenedList.map((item, index) => {
        if (item.name === name) {
          state.pageOpenedList.splice(index, 1);
        }
      });
    },
    pageOpenedList(state, get) {
      let openedPage = state.pageOpenedList[get.index];
      if (get.argu) {
        openedPage.argu = get.argu;
      }
      if (get.query) {
        openedPage.query = get.query;
      }
      state.pageOpenedList.splice(get.index, 1, openedPage);
      localStorage.pageOpenedList = JSON.stringify(state.pageOpenedList);
    },
    setOpenedList(state) {
      state.pageOpenedList = localStorage.pageOpenedList ? JSON.parse(localStorage.pageOpenedList) : [otherRouter.children[0]];
    },
    setCurrentPath(state, pathArr) {
      state.currentPath = pathArr;
    },
    setCurrentPageName(state, name) {
      state.currentPageName = name;
    },
    setAvator(state, path) {
      localStorage.avatorImgPath = path;
    },
    switchLang(state, lang) {
      state.lang = lang;
      Vue.config.lang = lang;
    },
    clearOpenedSubmenu(state) {
      state.openedSubmenuArr.length = 0;
    },
    setMessageCount(state, count) {
      state.messageCount = count;
    },
    increateTag(state, tagObj) {
      if (!Util.oneOf(tagObj.name, state.dontCache)) {
        state.cachePage.push(tagObj.name);
        localStorage.cachePage = JSON.stringify(state.cachePage);
      }
      state.pageOpenedList.push(tagObj);
      localStorage.pageOpenedList = JSON.stringify(state.pageOpenedList);
    }
  }
};

export default app;
