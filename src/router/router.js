
import Login from '@/views/Login'
import Main from '@/views/Main'
import KnowledgePage from '@/components/knowledge-page'
import Homepage from '@/views/personhomepage/homepage'
import Menu from '@/views/menu/menu-list.vue'
import Home from '@/views/home/home.vue'
import WriteArticle from '@/views/article/article-publish.vue'
import ArticleDetail from '@/views/article/article-detail.vue'
import ArticleSearch from '@/views/article/article-search.vue'

/*import VueJs from '@/views/frontend/vueJs'
import NodeJs from '@/views/backend/nodeJs'
import Javascript from '@/views/frontend/javascript'*/

// 不作为Main组件的子页面展示的页面单独写，如下
export const loginRouter = {
  path: '/login',
  name: 'login',
  meta: {
    title: 'Aimee的个人网站 - 登录'
  },
  component: Login
};

export const articleRouter = [
  {
    path: '/write-article',
    name: 'write-article',
    meta: {
      title: 'Aimee的个人网站 - 写文章'
    },
    component: WriteArticle
  },
  {
    path: '/article-detail',
    name: 'article-detail',
    meta: {
      title: '文章详情'
    },
    component: ArticleDetail
  },
  {
    path: '/article-search',
    name: 'article-search',
    meta: {
      title: '文章查询'
    },
    component: ArticleSearch
  },
];



// 作为Main组件的子页面展示但是不在左侧菜单显示的路由写在otherRouter里
export const otherRouter = {
  path: '/',
  redirect:'/home',
  name: 'otherRouter',
  component: Main,
  children: [
    { path: 'home', title:'首页', name: 'home_index', component: Home},
    { path: 'article', title:'', name: 'article',component: KnowledgePage},
  ]
};


// 作为Main组件的子页面展示并且在左侧菜单显示的路由写在appRouter里 这个从后台获取
export const appRouter = [
  /*{
    path: '/homepage',
    component: Main,
    icon:'home',
    title: '个人主页',
    name: 'homepage',
    children:[
      {path:'index',title:'个人主页',name:'homepage_index',component:Homepage}
    ]
  },
  //这里是以name作为唯一标识传递参数，为了实现刷新的时候默认展开子菜单，必须传递父菜单的name。
  {
    path: '/frontend',
    component: Main,
    title: '前端',
    icon:'pin',
    name: 'frontend',
    children: [
      {path: 'javascript', title:'javascript',name: '前端-frontend-javascript',type:'frontend'},
      {path: 'vue.js',title:'vue.js', name: '前端-frontend-vue.js',type:'frontend'}
    ]
  },
  {
    path: '/backend',
    component: Main,
    title: '后端',
    icon: 'pin',
    name: 'backend',
    children: [
      {path: 'node.js', title:'node.js',name: '后端-backend-node.js',type:'backend'},
      {path: 'java', title:'java',name: '后端-backend-java',type:'backend'}
    ]
  },
  {
    path: '/menu',
    component: Main,
    icon:'ios-list',
    title: '菜单管理',
    name: 'menu',
    children:[
      {path:'index',title:'菜单管理',name:'menu_index',component:Menu}
    ]
  },*/

]

// 所有上面定义的路由都要写在下面的routers里
export const routers = [
  loginRouter,
  ...articleRouter,
  otherRouter,
  /*preview,
  locking,*/
  ...appRouter,
  /*page500,
  page403,
  page404*/
];
