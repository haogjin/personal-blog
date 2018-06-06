<template>
  <div>
    <div class="write-article-header">
      <div class="title">
        <span class="title-logo">Aimee</span>
        <span class="title-meta">写文章</span>
      </div>
      <div class="return-home">
        <Button type="primary" icon="paper-airplane" @click="handleIssue">发布</Button>
        <Button type="ghost" icon="reply" class="margin-left-10" @click="handleGoBack">回首页</Button>
      </div>
    </div>
    <div class="editor-wrap">
      <Form :model="addForm" ref="addForm"  :rules="addFormValidate" label-position="left" :label-width="100">
        <FormItem label="文章标题：" prop="title">
          <Row>
            <Col span="10">
              <Input v-model="addForm.title" type="textarea" :autosize="{minRows: 1,maxRows: 5}"></Input>
            </Col>
          </Row>
        </FormItem>
        <FormItem label="文章类别：" required>
          <Row>
            <Col span="4">
            <FormItem prop="directionId">
             <direction-select :sendDirectionInfo="sendDirection"
                               @returnDirectionInfo="returnDirection"
                                ref="callDirection">
             </direction-select>
            </FormItem>
            </Col>
            <Col span="1" style="text-align: center">.</Col>
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
        <FormItem label="文章摘要：" prop="summary">
          <Row>
            <Col span="10">
             <Input v-model="addForm.summary" type="textarea" :autosize="{minRows: 2,maxRows: 6}"></Input>
            </Col>
          </Row>
        </FormItem>
        <FormItem prop="content" style="margin-left:-100px;">
          <div id="editor">
            <mavon-editor class="editor-content" ref=md  @imgAdd="handleImgAdd" @imgDel="$imgDel" v-model="addForm.content"></mavon-editor>
          </div>
        </FormItem>
      </Form>

    </div>
  </div>

</template>

<script>
  //import axios from 'axios'
  import directionSelect from '../../components/article/direction-select.vue'
  import categorySelect from '../../components/article/category-select.vue'
  export default {
    data() {
      return {
        addForm:{
          user_name:'',
          title:'',
          directionId:'',
          categoryId:'',
          content:'',
          summary:'',
        },
        addFormValidate:{
          user_name:[
            {required: true, message: '用户名为空'}
          ],
          title:[
            {required: true, message: '请输入标题', trigger: 'blur'}
          ],
          directionId:[
            {required: true, message: '请选择文章方向', trigger: 'change'}
          ],
          categoryId:[
            {required: true, message: '请选择文章类型', trigger: 'change'}
          ],
          summary:[
            {required: true, message: '请输入摘要', trigger: 'blur'}
          ],
          content:[
            {required: true, message: '请输入内容', trigger: 'blur'}
          ],
        },
        sendDirection:{
          directionId:''
        },
        sendCategory:{
          directionId:'',
          categoryId:''
        }
      }
    },
    components:{
      directionSelect,
      categorySelect
    },
    methods: {
      returnDirection(data){
        this.addForm.directionId =  data.directionId;
        this.sendCategory.directionId = data.directionId;
        this.sendDirection.directionId = data.directionId;
        if (data.directionId) {
          this.sendCategory.categoryId = '';
          this.$refs.callCategory.getCategoryOption();
        }
        this.addForm.categoryId = '';
      },
      returnCategory(data){
        this.addForm.categoryId =  data.categoryId;
      },
      handleIssue() {
        this.$refs.addForm.validate((valid)=>{
          if(!valid){
            return;
          }
          this.addForm.user_name = sessionStorage.getItem('user');
          let param = Object.assign({},this.addForm);
          this.$api.addArticle(param).then((res)=>{
            if(this.$util.checkResCode(this,res)){
              this.$Message.success('添加文章成功');
              window.location.href = '/home';
            }
          }).catch((err)=>{
            this.$util.showCatchErr(this,err);
          })
        })
      },
      handleGoBack(){
        window.location.href = '/home';
      },
      // 绑定@imgAdd event
      handleImgAdd(pos, $file){
        let formData = new FormData();
        formData.append('file-upload', $file);
        this.$api.uploadFile(formData).then((res)=>{
          if(this.$util.checkResCode(this,res)){
            this.$refs.md.$img2Url(pos, res.url);
          }
        }).catch((err)=>{
          this.$util.showCatchErr(this,err);
        })
        /*axios({
          url: baseURL + 'article/upload',
          method: 'post',
          data: formData,
          headers: { 'Content-Type': 'multipart/form-data' },
        }).then((res) => {
          console.log(res)
          // 第二步.将返回的url替换到文本原位置![...](./0) -> ![...](url)
          // $vm.$img2Url 详情见本页末尾
          this.$refs.md.$img2Url(pos, res.data.url);
        })*/
      },
      $imgDel(pos){
        delete this.img_file[pos];
      }
    }
  }
</script>

<style lang="less" >
  @import '../../styles/article-publish.less';
  .v-note-wrapper .v-note-panel {
    min-height: 600px;
    box-shadow:0px 0px 0px rgba(255,255,255,255)!important;
  }
</style>
