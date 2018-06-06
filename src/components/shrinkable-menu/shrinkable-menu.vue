<style lang="less">
  @import 'styles/menu.less';
</style>

<template>
  <div :style="{background: bgColor}" class="ivu-shrinkable-menu">
    <slot name="top"></slot>
    <sidebar-menu
      class="not-shrink-menu"
      :menu-theme="theme"
      :menu-list="menuList"
      :open-names="openNames"
      @on-change="handleChange"
    ></sidebar-menu>
    <sidebar-menu-shrink
      class="shrink-menu"
      :menu-theme="theme"
      :menu-list="menuList"
      :icon-color="shrinkIconColor"
      @on-change="handleChange"
    ></sidebar-menu-shrink>
  </div>
</template>

<script>
  import sidebarMenu from './components/sidebarMenu.vue';
  import sidebarMenuShrink from './components/sidebarMenuShrink.vue';
  import util from '@/scripts/common/util';

  export default {
    name: 'shrinkableMenu',
    components: {
      sidebarMenu,
      sidebarMenuShrink
    },
    props: {
      //控制菜单的收缩与展开，这里没用到，采用的是媒体类型控制
      shrink: {
        type: Boolean,
        default: false
      },
      menuList: {
        type: Array,
        required: true
      },
      theme: {
        type: String,
        default: 'dark',
        validator(val) {
          return util.oneOf(val, ['dark', 'light']);
        }
      },
      beforePush: {
        type: Function
      },
      openNames: {
        type: Array
      }
    },
    computed: {
      bgColor() {
        return this.theme === 'dark' ? '#495060' : '#fff';
      },
      shrinkIconColor() {
        return this.theme === 'dark' ? '#fff' : '#495060';
      }
    },
    methods: {
      handleChange(name) {
        let willpush = true;
        if (this.beforePush !== undefined) {
          if (!this.beforePush(name)) {
            willpush = false;
          }
        }
        if (willpush) {
          //个人主页路由的话直接跳到原本路径
          if (name == 'homepage_index') {
            this.$router.push({
              name: name,
            });
            return;
          }
          //菜单管理路由的话直接跳到原本路径
          if (name == 'menu_index') {
            this.$router.push({
              name: name,
            });
            return;
          }
          //知识点分类的路由全部跳到公共的组件页面，并传参
         /* let category = name.split('-');
          category.shift();*/
          this.$router.push({
            path: '/article',
            query: { category: name},
          });
        }
        this.$emit('on-change', name);
      }
    }
  };
</script>
