<template>
  <div>
    <Select v-model="directionId" placeholder="请选择方向" @on-change="handleSelect">
      <Option
        v-for="item in directions"
        :key="item.directionId"
        :value="item.directionId">
        {{item.directionName}}
      </Option>
    </Select>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        directionId: '',
        directions: []
      }
    },
    props: {
      sendDirectionInfo:{
        type:Object
      }
    },
    methods: {
      getDirectionOption() {
        if(this.directions.length > 0){
          return;
        }
        this.$api.getArticleDirection().then((res) => {
          if (this.$util.checkResCode(this, res)) {
            this.directions = res.data;
            this.directionId = this.sendDirectionInfo.directionId
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      handleSelect() {
        this.$emit('returnDirectionInfo',{
          directionId : this.directionId
        })
      }
    },
    mounted(){
      this.getDirectionOption();
    }
  }
</script>

<style>
</style>
