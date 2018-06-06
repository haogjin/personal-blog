<template>
  <div>
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
        <Button type="primary" shape="circle" icon="ios-compose-outline" @click="handleWriteArticle">写文章</Button>
      </div>
      <div class="user-logout">
        <span @click="$router.push('/home')">
          <Tooltip content="回到首页" placement="bottom">
            <Icon type="ios-home" :size="25"></Icon>
          </Tooltip>
        </span>
        <span @click="handleLogout" class="margin-left-20 btn-margin">
          <Tooltip content="退出登录" placement="bottom" v-if="isUserLogin">
            <Icon type="share" :size="25"></Icon>
          </Tooltip>
        </span>
      </div>
    </Header>
    <div class="content-wrap">
     <home :sendArticleInfo="sendArticle"></home>
    </div>
    <div class="footer-wrap">
      <Footer class="layout-footer-center">2018 &copy; Aimee</Footer>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
  import home from '../home/home.vue'
  export default {
    data() {
      return {
        isUserLogin: false,
        flag: false,//判断是否是修改时
        searchText: '',
        isEditModel: false,

        sendArticle: {
          title: ''
        },
      }
    },
    components: {
      home
    },
    methods: {
      handleWriteArticle(){
        window.location.href = '/write-article'
      },
      handleSearch(){
        this.$router.push({
          path:'/article-search',
          query:{t:this.searchText},
        })
      },
      handleLogout(){
        this.$store.commit('logout', this);
        this.$store.commit('clearOpenedSubmenu');
        this.$router.push({
          name: 'login'
        });
      },
    },
    mounted() {
      this.isUserLogin = window.sessionStorage.getItem('user') ? true : false;
    }
  }
</script>

<style lang="less">
  @import '../../styles/common/header.less';
  @import '../../styles/article-detail.less';

  .v-note-wrapper .v-note-panel {
    min-height: 600px;
    box-shadow: 0px 0px 0px rgba(255, 255, 255, 255) !important;
  }

</style>
