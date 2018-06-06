<template>
    <div class="main">
      <Header class="wrap-header">
        <div class="user">Aimee</div>
        <div class="search center">
          <span class="search-text center">
            <Input type="text" placeholder="请输入搜索内容"
                   v-model="searchText" clearable>
            </Input>
          </span>
          <span class="search-btn center">
           <Button type="primary" shape="circle" icon="ios-search" @click="handleSearch" :disabled="!searchText"></Button>
          </span>
        </div>
        <div class="write-article" v-if="isUserLogin">
          <Button type="primary" shape="circle"  icon="ios-compose-outline" @click="handleWriteArticle">写文章</Button>
        </div>
        <div class="user-logout" v-if="isUserLogin" @click="handleLogout">
          <Tooltip content="退出登录" placement="bottom">
            <Icon type="share" :size="25" ></Icon>
          </Tooltip>
        </div>
      </Header>
      <div class="content-wrap">
        <div class="sidebar-menu-con">
          <shrinkable-menu
            @on-change="handleSubmenuChange"
            :theme="menuTheme"
            :active-name="$route.name"
            :before-push="beforePush"
            :open-names="openedSubmenuArr"
            :menu-list="menuList">
          </shrinkable-menu>
        </div>
        <div class="main-header-con">
          <div class="main-header">
            <div class="navicon-con" @click="goHome">
              <Tooltip content="回到首页" placement="bottom">
                <Icon type="ios-home" :size="25" :style="$route.path=='/home'?{'color':'#2D8CF0'} : ''"></Icon>
              </Tooltip>
            </div>
            <!--<div class="header-middle-con">
              <div class="main-breadcrumb">
                <breadcrumb-nav :currentPath="currentPath"></breadcrumb-nav>
              </div>
            </div>-->
          </div>
        </div>
        <div class="single-page-con">
          <div class="single-page">
            <keep-alive :include="cachePage">
              <router-view></router-view>
            </keep-alive>
          </div>
        </div>
      </div>
      <div class="footer-wrap">
        <Footer class="layout-footer-center">2018 &copy; Aimee</Footer>
      </div>

    </div>

</template>
<script>
  import shrinkableMenu from '../components/shrinkable-menu/shrinkable-menu.vue';
  import breadcrumbNav from '../components/breadcrumb-nav.vue';
  import util from '@/scripts/common/util';
  import Cookies from 'js-cookie'

  export default {
    data() {
      return {
        searchText: '',
        isUserLogin:false,
        //openedSubmenuArr: this.$store.state.app.openedSubmenuArr
      };
    },
    components: {
      shrinkableMenu,
      breadcrumbNav,
    },
    computed: {
      menuList() {
        return this.$store.state.app.menuList;
      },
      openedSubmenuArr(){
        return this.$store.state.app.openedSubmenuArr;
      },
      pageTagsList() {
        return this.$store.state.app.pageOpenedList; // 打开的页面的页面对象
      },
      currentPath() {
        return this.$store.state.app.currentPath; // 当前面包屑数组
      },
      cachePage() {
        return this.$store.state.app.cachePage;
      },
      lang() {
        return this.$store.state.app.lang;
      },
      menuTheme() {
        return this.$store.state.app.menuTheme;
      }
    },
    methods: {
      goHome(){
        this.$router.push('/home')
      },
      init() {
        let pathArr = util.setCurrentPath(this, this.$route);
        if (pathArr.length >= 1) {
          this.$store.commit('addOpenSubmenu', pathArr[0]);
        }
        this.isUserLogin = window.sessionStorage.getItem('user')? true:false;
      },
      handleSubmenuChange(val) {
        // console.log(val)
      },
      beforePush(name) {
        return true;
      },
      handleWriteArticle(){
        window.location.href = '/write-article'
      },
      handleLogout(){
        this.$store.commit('logout', this);
        this.$store.commit('clearOpenedSubmenu');
        this.$router.push({
          name: 'login'
        });
      },
      handleSearch(){
        this.$router.push({
          path:'/article-search',
          query:{t:this.searchText},
        })
      }
    },
    watch: {
      '$route'(to) {
        this.$store.commit('setCurrentPageName', to.name);
        let pathArr = util.setCurrentPath(this, to);
        if (pathArr.length >= 1) {
          this.$store.commit('addOpenSubmenu', pathArr[0]);
        }
        localStorage.currentPageName = to.name;
      },
     /* lang() {
        util.setCurrentPath(this, this.$route); // 在切换语言时用于刷新面包屑
      }*/
    },
    mounted() {
      this.init();
    },
    created() {
      // 显示打开的页面的列表
      this.$store.commit('setOpenedList');
    }
  };
</script>
<style scoped lang="less">
  @import "../styles/main.less";
</style>
