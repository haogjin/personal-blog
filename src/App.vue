<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style lang="less">
 @import "./styles/common/common.less";

  body{
    margin: 0px;
    padding: 0px;
    font-size: 14px;
    background-color: #F7F6F6;

  }
#app {
  font-size: 14px;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
