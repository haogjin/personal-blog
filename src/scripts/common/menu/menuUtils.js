import lazyLoading from './lazyLoading'
import Vue from 'vue';

export default (routers, data) => {
  //这里之所以要重新遍历一下，是因为，通常我们动态路由的时候，是获取服务端数据，这个component属性是一个字符串，或者可能连字段名都是其他的key
  //所以这里要做一些转换
  generaMenu(routers, data)
}

function generaMenu(routers, data) {
  if (data) {
    data.forEach((item) => {
      let menu = Object.assign({}, item);
      if(menu.component){
        if (menu.component == "Main") {
          menu.component = require("@/views/Main.vue");
          //console.log(menu.component)
        }else {
          //按需加载获取不到组件 template or render function not defined.降低vue-loader版本可行 import和require的形式都可以
          menu.component = lazyLoading(menu.component);
          //menu.component = require("@/views/"+menu.component+".vue")
          // 首先require引入options及模板，然后调用Vue.extend方法生成构造函数，最后new创建组件实例   但仍然会报错
          /* const temp = require("@/views/"+menu.component+".vue").default;
           const Constructor = Vue.extend(temp)
           menu.component = new Constructor()
           */
        }
      }else{
        //没有component 必须置为 null ，为''会报错
        menu.component = null;
      }
      if (item.children) {//有子菜单
        menu.children = [];
        generaMenu(menu.children, item.children)
      }
      routers.push(menu);
    })
  }
}
