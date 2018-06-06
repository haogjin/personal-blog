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
      <Form ref="articleForm" label-position="left" :label-width="100" style="width:90%;margin:auto;padding-top:20px;">
        <FormItem :label="isEditModel?'文章标题：':''" :style="isEditModel?'':{'margin-left':'-100px'}" prop="title">
          <Row>
            <Col span="18" v-if="!isEditModel">
            <div class="detail-article-title">{{articleForm.title}}</div>
            </Col>
            <Col span="10" v-else>
            <Input v-model="articleForm.title" type="textarea" :autosize="{minRows: 1,maxRows: 5}"></Input>
            </Col>
            <Col :span="!isEditModel? 6 : 14" style="text-align: right" v-if="isUserLogin">
              <Button class="edit-btn" type="ghost" shape="circle" @click="handleEdit" v-if="isEditModel">发布文章</Button>
              <span v-else>
                <Button class="edit-btn" type="ghost" shape="circle" @click="handleEditArticle">编辑文章</Button>
                <Button class="edit-btn margin-left-10" type="ghost" shape="circle" @click="handleDelete">删除文章</Button>
              </span>
              <Button class="cancel-btn margin-left-10" type="ghost" shape="circle" v-if="isEditModel"
                      @click="$router.go(0);">取消
              </Button>
            </Col>
          </Row>
        </FormItem>
        <FormItem :label="isEditModel?'文章类别：':''" :style="isEditModel?'':{'margin-left':'-100px'}">
          <div v-if="!isEditModel" class="article-type">{{articleForm.type}}</div>
          <Row v-else>
            <Col span="4">
            <FormItem prop="directionId">
              <direction-select :sendDirectionInfo="sendDirection"
                                @returnDirectionInfo="returnDirection"
                                ref="callDirection">
              </direction-select>
            </FormItem>
            </Col>
            <Col span="1" style="text-align: center">
            .</Col>
            <Col span="4">
            <FormItem prop="categoryId">
              <category-select :sendCategoryInfo="sendCategory"
                               @returnCategoryInfo="returnCategory"
                               ref="callCategory">
              </category-select>
            </FormItem>
            </Col>
          </Row>
        </FormItem>
        <FormItem :label="isEditModel?'文章摘要：':''" :style="isEditModel?'':{'margin-left':'-100px'}" prop="summary">
          <div v-if="!isEditModel">摘要：{{articleForm.summary}}</div>
          <Row v-else>
            <Col span="10">
            <Input v-model="articleForm.summary" type="textarea" :autosize="{minRows: 2,maxRows: 6}"></Input>
            </Col>
          </Row>
        </FormItem>
        <FormItem prop="content" style="margin-left:-100px;">
          <div id="editor">
            <mavon-editor v-if="!isEditModel" class="editor-content" :editable="false"
                          defaultOpen="preview" ref=md    v-model="articleForm.content"
                          :toolbarsFlag="false" :subfield="false" :value="articleForm.content">
            </mavon-editor>
            <mavon-editor v-else class="editor-content" ref=md    @imgAdd="handleImgAdd" @imgDel="$imgDel"
                          v-model="articleForm.content">
            </mavon-editor>
          </div>
        </FormItem>
      </Form>
    </div>
    <BackTop></BackTop>
  </div>
</template>

<script>
  import axios from 'axios'
  import directionSelect from '../../components/article/direction-select.vue'
  import categorySelect from '../../components/article/category-select.vue'

  export default {
    data() {
      return {
        isUserLogin: false,
        flag: false,//判断是否是修改时
        searchText: '',
        isEditModel: false,
        articleForm: {
          title: '',
          type: '',
          summary: '',
          content: '',
          user_name: '',
          directionId: '',
          categoryId: '',
          articleId: '',
        },
        sendDirection: {
          directionId: ''
        },
        sendCategory: {
          directionId: '',
          categoryId: ''
        }
      }
    },
    components: {
      directionSelect,
      categorySelect
    },
    methods: {
      getArticleDetail() {
        let param = {articleId: this.$route.query.articleId}
        //console.log(param)
        this.$api.getArticleDetail(param).then((res) => {
          if (this.$util.checkResCode(this, res)) {
            //console.log(res)
            let article = res.data[0];
            this.articleForm.content = article.content;
            this.articleForm.summary = article.summary;
            this.articleForm.title = article.title;
            this.articleForm.type = article.directionName + ' -- ' + article.categoryName;
            this.articleForm.directionId = article.directionId;
            this.articleForm.categoryId = article.categoryId;
          }
        })
      },
      returnDirection(data) {
        this.articleForm.directionId = data.directionId;
        this.sendCategory.directionId = data.directionId;
        this.sendDirection.directionId = data.directionId;
        if (data.directionId) {
          if (!this.flag) {
            this.sendCategory.categoryId = '';
          } else {
            this.flag = false;
          }
          this.$refs.callCategory.getCategoryOption();
        }
        this.articleForm.categoryId = '';
      },
      returnCategory(data) {
        this.articleForm.categoryId = data.categoryId;
      },
      handleEditArticle() {
        this.isEditModel = true;
        this.sendDirection.directionId = this.articleForm.directionId;
        this.sendCategory.directionId = this.articleForm.directionId;
        this.sendCategory.categoryId = this.articleForm.categoryId;
        this.flag = true;
      },
      // 绑定@imgAdd event
      handleImgAdd(pos, $file) {
        let formData = new FormData();
        formData.append('file-upload', $file);
        this.$api.uploadFile(formData).then((res) => {
          if (this.$util.checkResCode(this, res)) {
            this.$refs.md.$img2Url(pos, res.url);
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      $imgDel(pos) {
        delete this.img_file[pos];
      },
      handleEdit() {
        this.$refs.articleForm.validate((valid) => {
          if (!valid) {
            return;
          }
          this.articleForm.user_name = sessionStorage.getItem('user');
          this.articleForm.articleId = this.$route.query.articleId;
          let param = Object.assign({}, this.articleForm);
          this.$api.editArticle(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              this.$router.go(0);
              /* this.$router.push({
                 path:'/article-detail',
                 query:{articleId:this.$route.query.articleId},
               })*/
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err);
          })
        })
      },
      handleDelete() {
        this.$Modal.confirm({
          title: '删除文章',
          content: '<p>确定删除该文章吗？</p>',
          onOk: () => {
            this.$api.deleteArticle({articleId:this.$route.query.articleId}).then((res) => {
              if (this.$util.checkResCode(this, res)) {
                this.$router.push('/home');
              }
            }).catch((err) => {
              this.$util.showCatchErr(this, err);
            })
          },
          onCancel: () => {

          }
        });
      },
      handleWriteArticle() {
        window.location.href = '/write-article';
      },
      handleSearch(){
        this.$router.push({
          path:'/article-search',
          query:{t:this.searchText},
        })
      },
      handleLogout() {
        this.$store.commit('logout', this);
        this.$store.commit('clearOpenedSubmenu');
        this.$router.push({
          name: 'login'
        });
      }
    },
    mounted() {
      this.isUserLogin = window.sessionStorage.getItem('user') ? true : false;
      this.getArticleDetail();
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
