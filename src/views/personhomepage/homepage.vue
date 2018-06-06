<template>
  <div>
    <Row>
      <Col span="9">
      <Card>
        <p>
          <Icon type="android-contacts"></Icon>
          个人资料
          <Button v-if="isUserLogin" class="right-float" type="ghost" shape="circle" @click="showEditUserInfoModal = true">修改
          </Button>
        </p>
        <div class="user-img">
          <img src="../../images/user-img.jpg"/>
        </div>
        <div class="margin-top-10">
          <h4 class="text-weight">Aimee</h4>
          <p>
            <Icon type="location"></Icon>
            {{userInfo.address}}
          </p>
          <h5 class="text-weight">关于我</h5>
          <div>
            <p>技术：{{userInfo.skill}}</p>
            <p>简介：{{userInfo.introduction}}</p>
          </div>
        </div>
      </Card>
      </Col>
      <Col span="15" class="homepage-wrap padding-left-10">
      <Card>
        <p>
          <Icon type="ios-list"></Icon>
          项目时间轴
          <span v-if="isUserLogin">
            <Button class="right-float margin-left-10" type="ghost" shape="circle"
                       @click="showProjectTableModal = true">查看表格列表</Button>
            <Button class="right-float" type="ghost" shape="circle" @click="handleShowAddProjectModal">添加</Button>
          </span>
        </p>
        <Timeline class="timeLine-box" style="clear:both;" >
          <template v-for="item in projectList">
            <TimelineItem>
              <p class="time">{{item.time}}</p>
              <p class="content">{{item.introduction}}</p>
            </TimelineItem>
          </template>
        </Timeline>
      </Card>
      </Col>
    </Row>

    <!--修改用户信息弹框-->
    <Modal
      v-model="showEditUserInfoModal"
      title="修改用户信息">
      <p slot="footer">
        <Button type="ghost" @click="showEditUserInfoModal = false">取消</Button>
        <Button type="primary" @click="handleEditUserInfo">确定</Button>
      </p>
      <Form :model="editUserForm" ref="editUserForm" :rules="editUserFormValidate" :label-width="70">
        <FormItem label="地区：" prop="address">
          <Input v-model.trim="editUserForm.address"></Input>
        </FormItem>
        <FormItem label="技术：" prop="skill">
          <Input v-model.trim="editUserForm.skill"></Input>
        </FormItem>
        <FormItem label="简介：" prop="introduction">
          <Input v-model.trim="editUserForm.introduction"></Input>
        </FormItem>
      </Form>
    </Modal>

    <!--添加项目弹框-->
    <Modal
      v-model="showAddProjectModal"
      title="添加项目">
      <p slot="footer">
        <Button type="ghost" @click="showAddProjectModal = false">取消</Button>
        <Button type="primary" @click="handleAddProject">确定</Button>
      </p>
      <Form :model="addProjectForm" ref="addProjectForm" :rules="addProjectFormValidate"  :label-width="90">
        <FormItem label="项目时间：" prop="time">
          <DatePicker type="date" placeholder="请选择时间" v-model="addProjectForm.time"
                      style="width: 200px" :editable="false">
          </DatePicker>
        </FormItem>
        <FormItem label="项目介绍：" prop="introduction">
          <Input v-model.trim="addProjectForm.introduction"></Input>
        </FormItem>
        <FormItem label="项目链接：" prop="url">
          <Input v-model.trim="addProjectForm.url"></Input>
        </FormItem>
      </Form>
    </Modal>

    <!--项目表弹框-->
    <Modal
      v-model="showProjectTableModal"
      title="项目列表" width="800">
      <p slot="footer"></p>
      <Table ref="selection" :columns="tableColumns" :data="projectList">
      </Table>
    </Modal>

    <!--修改项目弹框-->
    <Modal
      v-model="showEditProjectModal"
      title="修改用户信息">
      <p slot="footer">
        <Button type="ghost" @click="showEditProjectModal = false">取消</Button>
        <Button type="primary" @click="handleEditProject">确定</Button>
      </p>
      <Form :model="editProjectForm" ref="editProjectForm" :rules="editProjectFormValidate" :label-width="90">
        <FormItem label="项目时间：" prop="time">
          <DatePicker type="date"  v-model="editProjectForm.time"
                      style="width: 200px" :editable="false">
          </DatePicker>
        </FormItem>
        <FormItem label="项目简介：" prop="introduction">
          <Input v-model.trim="editProjectForm.introduction"></Input>
        </FormItem>
        <FormItem label="项目链接：" prop="url">
          <Input v-model.trim="editProjectForm.url"></Input>
        </FormItem>
      </Form>
    </Modal>
  </div>
</template>
<script>
  export default {
    data() {
      return {
        isUserLogin: false,
        projectList: [],
        userInfo: {
          address: '',
          skill: '',
          introduction: ''
        },
        //修改用户信息弹框
        showEditUserInfoModal:false,
        editUserForm:{
          id:'',
          address:'',
          skill:'',
          introduction:'',
        },
        editUserFormValidate:{
          address:{required:true,message:'请输入地区',trigger: 'blur'},
          skill:{required:true,message:'请输入技术',trigger: 'blur'},
          introduction:{required:true,message:'请输入简介',trigger: 'blur'},
        },

        //添加项目弹框
        showAddProjectModal:false,
        addProjectForm:{
          time:'',
          introduction:'',
          url:'',
        },
        addProjectFormValidate:{
          time:{required:true,type: 'date',message:'请选择项目时间',trigger: 'change'},
          introduction:{required:true,message:'请输入项目介绍',trigger: 'blur'},
        },

        //项目表弹框
        showProjectTableModal: false,
        tableColumns: [
          {title: '项目时间', key: 'time', width: 130, align: 'center',},
          {title: '项目介绍', key: 'introduction', minWidth: 160, align: 'center'},
          {title: '项目链接', key: 'url', width: 160, align: 'center',},
          {
            title: '操作',
            key: '',
            width: 130,
            align: 'center',
            fixed: 'right',
            render: (h, params) => {
              return h('div', [
                h('Button', {
                  props: {
                    type: 'ghost',
                    size: 'small'
                  },
                  style: {
                    marginRight: '5px'
                  },
                  on: {
                    click: () => {
                      this.handleShowProjectEditModel(params.row)
                    }
                  }
                }, '修改')
               /* h('Button', {
                  props: {
                    type: 'ghost',
                    size: 'small'
                  },
                  on: {
                    click: () => {

                    }
                  }
                }, '删除')*/
              ]);
            }
          }
        ],
        //修改项目信息
        showEditProjectModal:false,
        editProjectForm:{
          id:'',
          time:'',
          introduction:'',
          url:'',
        },
        editProjectFormValidate:{
          time:{required:true,type: 'date',message:'请选择项目时间',trigger: 'change'},
          introduction:{required:true,message:'请输入项目介绍',trigger: 'blur'},
        }
      }
    },
    methods: {
      getUserInfo() {
        this.$api.getUserInfo().then((res) => {
          if (this.$util.checkResCode(this, res)) {
            let userInfo = res.data[0];
            this.userInfo = {
              address: userInfo.address,
              skill: userInfo.skill,
              introduction: userInfo.introduction
            }
            this.editUserForm = {
              id: userInfo.id,
              address: userInfo.address,
              skill: userInfo.skill,
              introduction: userInfo.introduction
            }
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      getProjectInfo(){
        this.$api.getProjectInfo().then((res) => {
          if (this.$util.checkResCode(this, res)) {
            this.projectList = res.data;
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })

      },
      handleEditUserInfo() {
        this.$refs.editUserForm.validate((valid) => {
          if (!valid) {
            return false;
          }
          let param = Object.assign(this.editUserForm);
          this.$api.editUserInfo(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              this.$Message.success('修改用户信息成功');
              this.showEditUserInfoModal = false;
              this.getUserInfo();
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err);
          })
        })
      },
      handleShowAddProjectModal(){
        this.showAddProjectModal = true;
        this.addProjectForm={
          time:'',
          introduction:'',
          url:'',
        };
        this.$refs['addProjectForm'].resetFields();
      },
      handleAddProject() {
        this.$refs.addProjectForm.validate((valid) => {
          console.log(this.addProjectForm.time)
          if (!valid) {
            console.log(this.addProjectForm.time)
            return false;
          }
          let param = Object.assign(this.addProjectForm);
          param.time = this.$util.formatToDate(param.time);
          this.$api.addProject(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              this.$Message.success('添加项目成功');
              this.showAddProjectModal = false;
              this.getProjectInfo();
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err);
          })
        })
      },
      handleShowProjectEditModel(row){
        this.showEditProjectModal = true;
        this.editProjectForm = {
          id: row.id,
          time: new Date(row.time.replace(/-/g, '/')),
          introduction: row.introduction,
          url: row.url,
        };
        this.$refs['editProjectForm'].resetFields();
      },
      handleEditProject() {
        console.log(this.editProjectForm.time);
        this.$refs.editProjectForm.validate((valid) => {
          if (!valid) {
            return false;
          }
          console.log(this.editProjectForm.time);
          let param = Object.assign(this.editProjectForm);
          param.time = this.$util.formatToDate(param.time);
          this.$api.editProject(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              this.$Message.success('修改项目成功');
              this.showEditProjectModal = false;
              this.getProjectInfo();
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err);
          })
        })
      },
    },
    mounted() {
      this.isUserLogin = window.sessionStorage.getItem('user') ? true : false;
      this.getUserInfo();
      this.getProjectInfo();
    }
  }
</script>
<style scoped lang="less">
  @import "../../styles/homepage.less";
  @import "../../styles/common/common.less";
</style>
