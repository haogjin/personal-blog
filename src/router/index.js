import Vue from 'vue'
import iView from 'iview';
import Router from 'vue-router'
//import {routers, otherRouter, appRouter} from './router';
import {routers} from './router';
import Util from '../scripts/common/util';
Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: routers
})

router.beforeEach((to,from,next) => {
  let token = window.sessionStorage.getItem('token');
  let user = window.sessionStorage.getItem('user');
  console.log(1)
  console.log(user)
  console.log(token)
  iView.LoadingBar.start();
  Util.title(to.meta.title);
/*  if(user){
    if(!token){
      //next({path: '/login'})
      window.location.href = '/login';
      return false;
    }
    next();
  }*/
  if(to.path == '/login'){
    sessionStorage.removeItem('user');
    sessionStorage.removeItem('password');
    sessionStorage.removeItem('token');
  }
  if(to.path == '/write-article'){
    if(!token){
      window.location.href = '/home';
      return false;
    }
    next();
  }
  next();
});
router.afterEach((to) => {
  Util.openNewPage(router.app, to.name, to.params, to.query);
  iView.LoadingBar.finish();
  window.scrollTo(0, 0);
});
export default router;
