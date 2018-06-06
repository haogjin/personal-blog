<style lang="less">
  @import "../../styles/home.less";
  @import "../../styles/common/common.less";
  @import "../../styles/common/ellipsis.less";
</style>
<template>
  <div class="home-wrap">
    <Row>
      <Col span="16" :class="$route.query.t?'padding-top-15 padding-left-10':''">
      <Scroll :on-reach-bottom="handleReachBottom" :height="$route.query.t?'750':'700'">
        <Card>
          <p v-show="!$route.query.t">
            <Icon type="bookmark"></Icon>
            最新
          </p>
          <ul class="article new-article margin-top-10">
            <div v-show="articleList.length == 0" class="no-date">暂时没有相关的文章内容~</div>
            <li v-for="item in articleList">
              <Row>
                <Col span="24">
                <div class="article-title notwrap title" @click="handleShowArticleDetail(item)">{{item.title}}</div>
                <div class="ellipsis">
                  <div><p>{{item.summary}}</p></div>
                </div>
                </Col>
               <!-- <Col span="4" class="padding-left-10">
                <img src="../../images/js.png" class="new-article-img"/>
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
      <Col span="8"
           :class="$route.query.t?'padding-top-15 padding-left-10 right-col padding-right-10':'padding-left-10 right-col'">
      <Card>
        <p>
          <Icon type="android-contacts"></Icon>
          个人资料
        </p>
        <div class="user-info margin-top-10">
          <dl>
            <dt class="user-avatar">
              <a>
                <img src="../../images/user-img.jpg" class="avatar-pic"/>
              </a>
            </dt>
            <dd>
              <h3>
                <a>
                  Aimee
                </a>
              </h3>
            </dd>
          </dl>
          <div class="explain-info">
            <span class="padding-left-8">文章数：{{articleCount}}</span>
            <span class="margin-left-20">访问量：{{visitorCount}}</span>
          </div>
        </div>
      </Card>
      <Card class="margin-top-10" v-if="!$route.query.t">
        <p>
          <Icon type="star"></Icon>
          推荐
        </p>
        <div class="margin-top-10">
          <ul class="article new-article">
            <li v-for="item in recommendedArticleList" class="recommended-li">
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
  export default {
    name: 'home',
    components: {},
    data() {
      return {
        articleList: [],
        recommendedArticleList: [],
        articleCount: '',
        visitorCount: '',
        pageNum: 1,
        showMore: true,
      };
    },
    computed: {
      /*t(){
        return this.$store.state.app.searchContent;
      }*/
    },
    methods: {
      getArticleList() {
        //存在查询条件
        if (this.$route.query.t) {
          let param = {
            pageNum: this.pageNum,
            t: this.$route.query.t
          }
          this.$api.getSearchArticle(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              console.log(res.data)
              if (res.data.length > 0) {
                this.articleList = this.articleList.concat(res.data);
                this.pageNum = this.pageNum + 1;
              } else {
                this.showMore = false;
              }
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err);
          })
          return;
        }
        this.$api.getArticleList({pageNum: this.pageNum}).then((res) => {
          if (this.$util.checkResCode(this, res)) {
            if (res.data.length > 0) {
              this.articleList = this.articleList.concat(res.data);
              this.pageNum = this.pageNum + 1;
            } else {
              this.showMore = false;
            }
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      getRecommendedArticle() {
        this.$api.getRecommendedArticle().then((res) => {
          if (this.$util.checkResCode(this, res)) {
            this.recommendedArticleList = res.data;
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      handleShowArticleDetail(item) {
        this.$router.push({
          path: '/article-detail',
          query: {articleId: item.articleId},
        })
      },
      //下拉加载
      handleReachBottom() {
        if (!this.showMore) {
          return;
        }
        return new Promise(resolve => {
          setTimeout(() => {
            this.getArticleList();
            resolve();
          }, 1000);
        });
      }
    },
    watch: {
      '$route'() {
        this.pageNum = 1;
        this.articleList = [];
        this.getArticleList();
      }
    },
    created() {
      this.getArticleList();
      this.getRecommendedArticle();
    }
  };
</script>
