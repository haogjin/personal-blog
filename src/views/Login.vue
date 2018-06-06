<template>
  <div class="login-wrap">
    <div class="login-container" @keyup.enter="handleLogin('loginForm')">
      <h1 class="title">{{title = loginFormVisible ? 'Welcome to Aimee\'s blog~' : 'Regist'}}</h1>
      <Form ref="loginForm" :model="loginForm" :rules="loginFormRules" v-if="loginFormVisible">
        <FormItem prop="user">
          <Input type="text" v-model="loginForm.username" placeholder="用户名">
          <Icon type="ios-person-outline" slot="prepend"></Icon>
          </Input>
        </FormItem>
        <FormItem prop="password">
          <Input type="password" v-model="loginForm.password" placeholder="密码">
          <Icon type="ios-locked-outline" slot="prepend"></Icon>
          </Input>
        </FormItem>
        <FormItem>
          <Button type="primary" class="login-btn" @click="handleLogin('loginForm')">登 录</Button>
        <!--  <a class="regist" @click="loginFormVisible = false">没有账号？点击注册</a>-->
        </FormItem>
      </Form>
     <!-- <Form ref="registerForm" :model="registerForm" :rules="registerFormRules" v-else>
        <FormItem prop="user">
          <Input type="text" v-model="registerForm.username" placeholder="用户名">
          <Icon type="ios-person-outline" slot="prepend"></Icon>
          </Input>
        </FormItem>
        <FormItem prop="password">
          <Input type="password" v-model="registerForm.password" placeholder="密码">
          <Icon type="ios-locked-outline" slot="prepend"></Icon>
          </Input>
        </FormItem>
        <FormItem>
          <Button type="primary" class="regist-btn" @click="handleRegist('registerForm')">注 册</Button>
          <Button type="primary" class="regist-cancel-btn" @click="loginFormVisible = true">取 消</Button>
        </FormItem>
      </Form>-->
    </div>
  </div>
 </template>

 <script>
   import MenuUtils from '../scripts/common/menu/menuUtils'
   export default {
     data () {
       return {
         title:'',
         loginForm:{
           username:'',
           password:''
         },
         loginFormRules:{
           username:{required:true,message:'请输入用户名',trigger: 'blur'},
           password:{required:true,message:'请输入密码',trigger: 'blur'},
         },
        /* registerForm:{
           username:'',
           password:''
         },
         registerFormRules:{
           username:{required:true,message:'请输入用户名',trigger: 'blur'},
           password:{required:true,message:'请输入密码',trigger: 'blur'},
         },*/
         loginFormVisible:true,
       }
     },
     components:{},
     methods: {
       handleLogin(formName){
         this.$refs[formName].validate((valid)=>{
           if(!valid){
             return;
           }
           let params = {
               user_name:this.loginForm.username,
               user_password:this.loginForm.password
           }
           this.$api.login(params).then((res)=>{
             if(this.$util.checkResCode(this,res)){
              // window.location.href = '/home';
               sessionStorage.setItem('user', this.loginForm.username);
               sessionStorage.setItem('token', res.token);
               //登录的时候需要重新加载一遍菜单
               this.$api.getCategoryMenu().then((res)=>{
                 if(this.$util.checkResCode(this,res)){
                   let menuData = res.data;
                   if (!menuData) {
                     return;
                   }
                   this.$router.push({
                     name: 'home_index'
                   });
                 }
               }).catch((err)=>{
                 this.$util.showCatchErr(this,err);
               })

             }else{
               this.$Modal.warning({
                 title: '提示',
                 content: '登录失败，'+ res.msg,
                 okText: '确定'
               })
             }
           }).catch(err=>{
             this.$util.showCatchErr(this, err,"登录失败");
           })
         })

       },
      /* handleRegist(formName){
         this.$refs[formName].validate((valid)=>{
           if(!valid){
             return;
           }
           let param = {
             user_name:this.registerForm.username,
             user_password:this.registerForm.password
           }
           this.$api.register(param).then((res)=>{
             if(this.$util.checkResCode(this,res)){
               this.$Modal.confirm({
                 title: '提示',
                 content: '用户注册成功，请问是否现在登录？',
                 okText: '现在登录',
                 cancelText: '取消',
                 onOk:(()=>{
                   window.location.href = '/home';
                 }),
                 onCancel:(()=>{
                   this.loginFormVisible = true;
                 })
               })
             }
           }).catch(err=>{
             this.$util.showCatchErr(this, err,"注册失败");
           })
         })
       }*/
     }
    }
</script>

<style  scoped  lang="less">
  @import '../styles/login.less';
</style>
