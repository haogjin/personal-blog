<style lang="less">
  @import '../styles/menu.less';
</style>

<template>
  <Menu ref="sideMenu" :active-name="$route.name=='article'?$route.query.category:$route.name" :open-names="openNames" :theme="menuTheme" width="auto" @on-select="changeMenu" accordion>
    <template v-for="item in menuList">
      <MenuItem v-if="item.children.length<=1" :name="item.children[0].name" :key="'menuitem' + item.name">
        <Icon :type="item.children[0].icon || item.icon" :size="iconSize" :key="'menuicon' + item.name"></Icon>
        <span class="layout-text" :key="'title' + item.name">{{item.children[0].title}}</span>
      </MenuItem>

      <Submenu v-if="item.children.length > 1" :name="item.name" :key="item.name">
        <template slot="title">
          <Icon :type="item.icon" :size="iconSize"></Icon>
          <span class="layout-text">{{item.title}}</span>
        </template>
        <template v-for="child in item.children">
          <MenuItem :name="child.name" :key="'menuitem' + child.name">
            <Icon :type="child.icon" :size="iconSize" :key="'icon' + child.name"></Icon>
            <span class="layout-text" :key="'title' + child.name">{{child.title}}</span>
          </MenuItem>
        </template>
      </Submenu>
    </template>
  </Menu>
</template>

<script>
  export default {
    name: 'sidebarMenu',
    props: {
      menuList: Array,
      iconSize: Number,
      menuTheme: {
        type: String,
        default: 'light'
      },
      openNames: {
        type: Array
      }
    },
    methods: {
      changeMenu(active) {
        this.$emit('on-change', active);
      },
      itemTitle(item) {
        if (typeof item.title === 'object') {
          return this.$t(item.title.i18n);
        } else {
          return item.title;
        }
      }
    },
    updated() {
      //更新展开的子目录、当前选择项
      this.$nextTick(() => {
        if (this.$refs.sideMenu) {
          this.$refs.sideMenu.updateOpened();
          this.$refs.sideMenu.updateActiveName();
        }
      });
    }
  };
</script>
