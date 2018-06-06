<template>
  <div>
    <Row>
      <Col span="4" style="min-width: 200px;">
      <Card>
        <p>
          <Icon type="ios-list-outline"></Icon>
          树形菜单
        </p>
        <Tree :data="treeMenuList"
              @on-toggle-expand="handleToggleExpand"
              @on-select-change="handleSelectChange">
        </Tree>
      </Card>
      </Col>
      <Col span="20" class="padding-left-10">
      <div class="table-btn">
        <Button type="primary" @click="handleShowAddModel(1)">添加模块</Button>
        <Button type="primary" @click="handleShowAddModel(2)" :disabled="isAddMenuBtnDisabled||sels.length == 0">添加菜单</Button>
        <Button type="error" @click="handleDeleteMenu" :disabled="sels.length==0">批量删除</Button>
      </div>
      <Table ref="selection" :columns="tableColumns" :data="tableData"
             @on-selection-change="handleSelectionChange">
      </Table>
      </Col>
    </Row>
    <!--添加弹框-->
    <Modal
      v-model="showAddModal"
      :title="addModalTitle"
      @on-visible-change="handleVisibleChange">
      <p slot="footer">
        <Button type="ghost" @click="showAddModal = false">取消</Button>
        <Button type="primary" @click="handleAddMenu">确定</Button>
      </p>
      <Form :model="addMenuForm" ref="addMenuForm" :rules="addMenuFormValidate" :label-width="70">
        <FormItem label="父级：" prop="parent" v-if="addParentVisible">
          {{parentName}}
        </FormItem>
        <FormItem label="标题：" prop="title">
          <Input v-model.trim="addMenuForm.title" placeholder="用于显示的菜单标题"></Input>
        </FormItem>
        <FormItem label="名称：" prop="name">
          <Input v-model.trim="addMenuForm.name" placeholder="用于唯一判断的菜单名称"></Input>
        </FormItem>
        <FormItem label="路径：" prop="path">
          <Input v-model.trim="addMenuForm.path" placeholder="url"></Input>
        </FormItem>
        <FormItem label="图标：" prop="icon" v-if="!addParentVisible">
          <Input v-model.trim="addMenuForm.icon"></Input>
        </FormItem>
        <FormItem label="标识名：" prop="identifier">
          <Input v-model.trim="addMenuForm.identifier" placeholder="组件名称"></Input>
        </FormItem>
        <FormItem label="排序号：" prop="orders">
          <InputNumber :max="10" :min="1" v-model="addMenuForm.orders"></InputNumber>
        </FormItem>
      </Form>
    </Modal>
    <!--修改弹框-->
    <Modal
      v-model="showEditModal"
      :title="editModalTitle">
      <p slot="footer">
        <Button type="ghost" @click="showEditModal = false">取消</Button>
        <Button type="primary" @click="handleEditMenu">确定</Button>
      </p>
      <Form :model="editMenuForm" ref="editMenuForm" :rules="editMenuFormValidate" :label-width="70">
        <FormItem label="父级：" prop="parent" v-if="editMenuForm.parent">
          {{editParentName}}
        </FormItem>
        <FormItem label="标题：" prop="title">
          <Input v-model.trim="editMenuForm.title" placeholder="用于显示的菜单标题"></Input>
        </FormItem>
        <FormItem label="名称：" prop="name">
          <Input v-model.trim="editMenuForm.name" placeholder="用于唯一判断的菜单名称"></Input>
        </FormItem>
        <FormItem label="路径：" prop="path">
          <Input v-model.trim="editMenuForm.path" placeholder="url"></Input>
        </FormItem>
        <FormItem label="图标：" prop="icon" v-if="!editMenuForm.parent">
          <Input v-model.trim="editMenuForm.icon"></Input>
        </FormItem>
        <FormItem label="标识名：" prop="identifier">
          <Input v-model.trim="editMenuForm.identifier" placeholder="组件名称"></Input>
        </FormItem>
        <FormItem label="排序号：" prop="orders">
          <InputNumber :max="10" :min="1" v-model="editMenuForm.orders"></InputNumber>
        </FormItem>
      </Form>
    </Modal>
  </div>
</template>

<script>
  export default {
    data() {
      const validateAddIcon = (rule, value, callback) => {
        if(this.addParentVisible){
          return callback();
        }
        if (!value) {
          return callback(new Error('请输入图标'));
        }
        callback();
      };
      const validateEditIcon = (rule, value, callback, flag) => {
        if(this.editMenuForm.parent){
          return callback();
        }
        if (!value) {
          return callback(new Error('请输入图标'));
        }
        callback();
      };
      const validateAddIdentifier = (rule, value, callback) => {
        if(this.addParentVisible){
          return callback();
        }
        if (!value) {
          return callback(new Error('请输入标识名'));
        }
        callback();
      };
      const validateEditIdentifier = (rule, value, callback) => {
        if(this.editMenuForm.parent){
          return callback();
        }
        if (!value) {
          return callback(new Error('请输入标识名'));
        }
        callback();
      };
      return {
        treeMenuList: [],
        tableColumns: [
          {type: 'selection', width: 60, align: 'center'},
          {
            title: '父级', key: 'name', width: 100, align: 'center',
            render: (h, params) => {
              return h('div', {
                domProps: {
                  innerHTML: !params.row.parent ? '' : params.row.name.indexOf('-') > -1 ? params.row.name.split('-')[0] : params.row.title
                }
              })
            }
          },
          {title: '标题', key: 'title', width: 100, align: 'center'},
          {
            title: '名称', key: 'name', width: 100, align: 'center',
            render: (h, params) => {
              return h('div', {
                domProps: {
                  innerHTML: params.row.name.indexOf('-') > -1 ? params.row.name.split('-')[1] : params.row.name
                }
              })
            }
          },
          {title: '路径', key: 'path', width: 100, align: 'center'},
          {title: '图标', key: 'icon', width: 80, align: 'center'},
          {title: '操作标识', key: 'identifier', width: 150, align: 'center'},
          {title: '排序号', key: 'orders', minWidth: 80, align: 'center'},
         /* {title: '状态', key: 'status', minWidth: 60, align: 'center'},*/
          {
            title: '操作',
            key: '',
            width: 160,
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
                      this.handleShowEditModel(params.row)
                    }
                  }
                }, '修改'),
               /* h('Button', {
                  props: {
                    type: 'ghost',
                    size: 'small'
                  },
                  on: {
                    click: () => {
                      params.row.status == 1 ? this.setMenuStatus(params.row, 2) : this.setMenuStatus(params.row, 1)
                    }
                  }
                }, params.row.status == 1 ? '禁用' : '启用')*/
              ]);
            }
          }
        ],
        tableData: [],
        sels: [],//列表选中项
        showAddModal: false,
        addModalTitle: '',
        searchForm: {
          currentParentId: '',
        },
        parentName: '',
        addMenuForm: {
          parent: '',
          title: '',
          name: '',
          path: '',
          icon: '',
          identifier: '',
          type: '',
          orders: 1,
          status: '1',
        },
        addMenuFormValidate: {
          title:{required:true,message:'请输入标题',trigger: 'blur'},
          name:{required:true,message:'请输入名称',trigger: 'blur'},
          path:{required:true,message:'请输入路径',trigger: 'blur'},
          icon:{required:true,validator:validateAddIcon,trigger: 'blur'},
          identifier:{validator:validateAddIdentifier,trigger: 'blur'},
        },
        addParentVisible: false,
        addIdentifierVisible: false,
        isAddMenuBtnDisabled: true,

        showEditModal: false,
        editModalTitle: '',
        editParentName: '',
        editParentVisible: false,
        editMenuForm: {
          parent: '',
          title: '',
          name: '',
          path: '',
          icon: '',
          identifier: '',
          orders: null,
          status: '',
          type: '',
          menuId: ''
        },
        editMenuFormValidate: {
          title:{required:true,message:'请输入标题',trigger: 'blur'},
          name:{required:true,message:'请输入名称',trigger: 'blur'},
          path:{required:true,message:'请输入路径',trigger: 'blur'},
          icon:{required:true,validator:validateEditIcon,trigger: 'blur'},
          identifier:{required:true,validator:validateEditIdentifier,trigger: 'blur'},
        },
      }
    },
    methods: {
      initFields() {
        this.addMenuForm = {
          parent: '',
          title: '',
          name: '',
          path: '',
          icon: '',
          type: '',
          orders: 1,
          status: '1',
        }
      },
      //显示状态发生变化时触发-关闭时清空表单
      handleVisibleChange(show){
        if(!show){
          this.initFields();
        }
      },
      getMenuList() {
        let param = {
          currentParentId: this.searchForm.currentParentId
        }
        this.$api.getMenuList(param).then((res) => {
          if (this.$util.checkResCode(this, res)) {
            this.tableData = res.data;
            this.parentName = res.data.title;
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      getTreeMenuList() {
        let param = {
          currentParentId: this.searchForm.currentParentId
        }
        this.$api.getTreeMenuList(param).then((res) => {
          if (this.$util.checkResCode(this, res)) {
            let menuArr = res.data, objectData = [];
            for (let i = 0; i < menuArr.length; i++) {
              if (menuArr[i].haveChild == "true") {
                objectData.push({
                  parent: menuArr[i].parent,
                  id: menuArr[i].menuId,
                  title: menuArr[i].title,
                  children: [{
                    title: '',
                  }]
                });
              } else {
                objectData.push({
                  parent: menuArr[i].parent,
                  id: menuArr[i].menuId,
                  title: menuArr[i].title,
                  children: [],
                });
              }
            }
            var menuData = this.searchForm.currentParentId;
            if (menuData == '') {
              //加载一级菜单
              this.treeMenuList = objectData;
            } else {
              this.setChildrenList(this.treeMenuList, this.searchForm.currentParentId, objectData);
            }
            //加载完左侧菜单，查询列表页
            this.getMenuList();

          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      //递归
      setChildrenList(menuData, currentParentId, objectData) {
        if (menuData.length <= 0) {
          return;
        }
        for (var i = 0; i < menuData.length; i++) {
          if (menuData[i].id == currentParentId) {
            menuData[i].children = objectData;
          }
          if (menuData[i].children) {
            this.setChildrenList(menuData[i].children, currentParentId, objectData);
          }
        }
      },
      //树节点展开时--返回节点
      handleToggleExpand(node) {
        if (node.expand) {
          this.searchForm.currentParentId = node.id;
          //加载二级和三级菜单的数据
          this.getTreeMenuList();
        }
      },
      //点击节点时--返回选中节点的数组
      handleSelectChange(nodeArr) {
        this.searchForm.currentParentId = nodeArr[0].id;
        //加载二级和三级菜单的数据
        this.getMenuList();
      },
      //添加模块
      handleShowAddModel(identify) {
        this.showAddModal = true;
        this.$refs['addMenuForm'].resetFields();
        if (identify == 1) {
          this.addParentVisible = false;
          this.addModalTitle = '添加模块';
          return;
        }
        this.addParentVisible = true;
        this.addModalTitle = '添加菜单';
      },
      handleAddMenu() {
        this.$refs.addMenuForm.validate((valid) => {
          if (!valid) {
            return false;
          }
          let param = Object.assign({}, this.addMenuForm);
          this.$api.addMenu(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              this.$Message.success('添加菜单成功');
              this.showAddModal = false;
              this.initFields();
              this.getMenuList();
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err)
          })
        })
      },
      handleSelectionChange(sel) {
        this.sels = sel;
        if (this.sels.length >= 1 && this.sels[0].parent == 0) {
          this.isAddMenuBtnDisabled = false;
          this.addMenuForm.parent = this.sels[0].menuId;
          this.parentName = this.sels[0].title;
          this.addMenuForm.type = this.sels[0].name;
        } else {
          this.isAddMenuBtnDisabled = true;
        }
      },
      handleEditMenu() {
        this.$refs.editMenuForm.validate((valid) => {
          if (!valid) {
            return false;
          }
          let param = Object.assign({}, this.editMenuForm)
          this.$api.editMenu(param).then((res) => {
            if (this.$util.checkResCode(this, res)) {
              this.$Message.success('修改菜单成功');
              this.showEditModal = false;
              this.initFields();
              this.getMenuList();
            }
          }).catch((err) => {
            this.$util.showCatchErr(this, err)
          })
        })

      },
      handleShowEditModel(row) {
        this.showEditModal = true;
        console.log(row)
        this.editModalTitle = row.parent ? '修改菜单' : '修改模块';
        this.editParentName = !row.parent ? '' : row.name.indexOf('-') > -1 ? row.name.split('-')[0] : row.title;
        this.editMenuForm = {
          parent: row.parent,
          title: row.title,
          name: row.name,
          path: row.path,
          icon: row.icon,
          type: row.type,
          identifier: row.identifier,
          orders: row.orders,
          status: row.status,
          menuId: row.menuId
        };
      },
      setMenuStatus(row, status) {

      },
      handleDeleteMenu() {
        var menuIds = this.sels.map(item => item.menuId).toString();
        let param = {menuIds: menuIds};
        this.$Modal.confirm({
          title: '删除菜单',
          content: '<p>确定删除选中的菜单吗？</p>',
          onOk: () => {
            this.$api.deleteMenu(param).then((res) => {
              if (this.$util.checkResCode(this, res)) {
                this.$Message.success('删除菜单成功');
                this.getMenuList();
                this.getTreeMenuList();
                this.sels = [];
              }
            }).catch((err) => {
              this.$util.showCatchErr(this, err);
            });
          },
          onCancel: () => {

          }
        });
      }
    },
    mounted() {
      this.getMenuList();
      this.getTreeMenuList();
    }
  }
</script>

<style lang="less" scoped>
  @import '../../styles/menu-list.less';

</style>
