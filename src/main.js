// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import Vuex from 'vuex'
import VueRouter from 'vue-router';
import App from './App';
import router from './router';
import store from './store/index';
import iView from 'iview';
import 'iview/dist/styles/iview.css';
import 'font-awesome/css/font-awesome.min.css';
import VueI18n from 'vue-i18n';
import api from './fetch/api';
import util from './scripts/common/util';
import usLang from 'iview/src/locale/lang/en-US';
import cnLang from 'iview/src/locale/lang/zh-CN';
import {appRouter} from './router/router';
import mavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'

import MenuUtils from './scripts/common/menu/menuUtils'
// use
Vue.use(mavonEditor)

Vue.use(VueRouter)
Vue.use(Vuex);
Vue.use(iView)
Vue.use(VueI18n);
Vue.config.productionTip = false;
Vue.prototype.$api = api;
Vue.prototype.$util = util;

/*
* vue 报错解决：TypeError: Cannot read property '_t' of undefined"
* 原因：https://github.com/iview/iview/issues/1090
* */
const messages = {
  'en-US': {
    message: {
      hello: 'hello my friend'
    }
  },
  'zh-CN': {
    message: {
      hello: '你好'
    }
  }
}
const mixLang = {
  'en-US': {},
  'zh-CN': {}
}
mixLang['en-US'] = Object.assign(messages['en-US'], usLang)
mixLang['zh-CN'] = Object.assign(messages['zh-CN'], cnLang)
const i18n = new VueI18n({
  locale: 'zh-CN',
  messages: mixLang
});

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  i18n,
  //render: h => h(App),
  render: h => h(App),
  /*data: {
    currentPageName: ''
  },*/
  mounted () {
    //this.currentPageName = this.$route.name;
    // 显示打开的页面的列表
    //this.$store.commit('setOpenedList');
    //this.$store.commit('initCachepage');
    // 权限菜单过滤相关
    //this.$store.commit('updateMenulist');
    this.$api.getCategoryMenu().then((res)=>{
      if(this.$util.checkResCode(this,res)){
        let menuData = res.data;
        if (!menuData) {
          return;
        }
        let routes = [];
        MenuUtils(routes, menuData);
        this.$store.commit('updateMenulist',routes);
        router.addRoutes(routes);
      }
    }).catch((err)=>{
      this.$util.showCatchErr(this,err);
    })
    //this.$router.go()
  },
  created () {


  }
})
