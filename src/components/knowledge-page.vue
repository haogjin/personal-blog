<style lang="less">
  @import "../styles/home.less";
  @import "../styles/common/common.less";
  @import "../styles/common/ellipsis.less";
</style>
<template>
  <div class="home-wrap">
    <Row>
      <Col span="16">
      <Scroll :on-reach-bottom="handleReachBottom" height="700">
        <Card>
          <p class="card-title">
            <span :style="{color:'#2D8CF0','font-size' :'16px'}">{{type}}</span>
          </p>
          <ul class="article new-article margin-top-10">
            <div v-show="articleList.length == 0" class="no-date">暂无内容，敬请期待~</div>
            <li v-for="item in articleList">
              <Row>
                <Col span="24">
                <div class="article-title notwrap title" @click="handleShowArticleDetail(item)">{{item.title}}</div>
                <div class="ellipsis">
                  <div> <p>{{item.summary}}</p></div>
                </div>
                </Col>
               <!-- <Col span="4" class="padding-left-10">
                <img src="../images/js.png" class="new-article-img"/>
                </Col>-->
              </Row>
              <Row>
              <span class="article-meta">
                <Icon type="ios-eye-outline" :size="14"></Icon>
                {{item.openCount}}
              </span>
                <span class="article-meta margin-left-10">
                <Icon type="ios-clock-outline"></Icon>
                {{item.createTime}}
              </span>
              </Row>
            </li>
          </ul>
        </Card>
      </Scroll>
      </Col>
      <Col span="8" class="padding-left-10 right-col">
        <Card>
          <p>
            <Icon type="star"></Icon>
            推荐
          </p>
          <div class="margin-top-10">
            <ul class="article new-article margin-top-10">
              <div v-show="recommendedArticleList.length == 0" class="no-date">暂无内容，敬请期待~</div>
              <li  v-for="item in recommendedArticleList">
                <div class="notwrap title" @click="handleShowArticleDetail(item)">{{item.title}}</div>
              </li>
            </ul>
          </div>
        </Card>
      </Col>
    </Row>
  </div>
</template>

<script>
  /*
  * 这里直接通过main组件传参过来再请求后台展示数据。
  * 实际上公共组件是用来展示数据的，请求后台是业务逻辑，不应该把业务逻辑和公共组件耦合在一起
  * 为增加复用性，比如有可能其他的数据展示也会用这个组件，在外面请求数据传进来更好一些
  * 也可以用状态管理，状态管理可以达到缓存的目的，依需求而定
  * 把url传进去 或者 传一个handler进去 每次加载数据就调一下handler 然后这个handler返回一个promise，这个意思不太懂，要查一下。。。
  */
  export default {
    name: 'home',
   /* props: {
      sendKnowledgeInfo:Object
    },*/
    data () {
      return {
        showMore:true,
        pageNum:1,
      };
    },
    computed:{
      type(){
        let category = this.$route.query.category;
        if(category.indexOf('-') <= -1){
          return '';
        }
        this.$store.commit('setArticleList', []);
        return category.split('-')[1];
      },
      //这里采用状态管理，主要是起缓存作用
      articleList(){
        return this.$store.state.app.articleList;
      },
      recommendedArticleList(){
        return this.$store.state.app.recommendedArticleList;
      }
    },
    methods: {
      getArticleListByType(){
        let param ={
          type:this.type,
          pageNum:this.pageNum
        }
        this.$api.getArticleListByType(param).then((res)=>{
          if(this.$util.checkResCode(this,res)){
            //this.$store.commit('setArticleList',res.data)
            if(res.data.length > 0){
              //this.articleList = this.articleList.concat(res.data);
              this.pageNum = this.pageNum + 1;
              this.$store.commit('setArticleList', this.articleList.concat(res.data));
            }else{
              this.showMore = false;
            }
          }
        }).catch((err)=>{
          this.$util.showCatchErr(this,err);
        })
      },
      getRecommendedArticleByType(){
        let param ={
          type:this.type
        }
        this.$api.getRecommendedArticleByType(param).then((res)=>{
          if(this.$util.checkResCode(this,res)){
            this.$store.commit('setRecommendedArticleList', res.data);
          }
        }).catch((err)=>{
          this.$util.showCatchErr(this,err);
        })
      },
      handleShowArticleDetail(item){
        this.$router.push({
          path:'/article-detail',
          query:{articleId:item.articleId},
        })
      },
      //下拉加载
      handleReachBottom(){
        if(!this.showMore){
          return;
        }
        return new Promise(resolve => {
          setTimeout(() => {
            this.getArticleListByType();
            resolve();
          }, 1000);
        });
      }
    },
    watch:{
      '$route'(){
        //路由变化的时候重置
        this.pageNum = 1;
        this.$store.commit('setArticleList', []);
        //this.$store.commit('setRecommendedArticleList', []);
        this.showMore = true;
        this.getArticleListByType();
        this.getRecommendedArticleByType();
      }
    },
    created(){
      this.getArticleListByType();
      this.getRecommendedArticleByType();
    }
  };
</script>
