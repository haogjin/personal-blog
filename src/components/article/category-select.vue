<template>
    <Select v-model="categoryId" placeholder="请选择类型" @on-change="handleSelect">
      <Option
        v-for="item in categories"
        :key="item.categoryId"
        :value="item.categoryId">
        {{item.categoryName}}
      </Option>
    </Select>
</template>

<script>
  export default {
    data() {
      return {
        categoryId: '',
        categories: []
      }
    },
    props: {
      sendCategoryInfo:{
        type:Object
      }
    },
    methods: {
      getCategoryOption() {
        console.log(4)
        console.log(this.sendCategoryInfo.categoryId)
        let param ={
          directionId: this.sendCategoryInfo.directionId
        }
        this.$api.getCategoryByDirection(param).then((res) => {
          if (this.$util.checkResCode(this, res)) {
            this.categories = res.data;
            this.categoryId = this.sendCategoryInfo.categoryId;
          }
        }).catch((err) => {
          this.$util.showCatchErr(this, err);
        })
      },
      handleSelect() {
        console.log(22)
        this.$emit('returnCategoryInfo',{
          categoryId : this.categoryId
        })
      }
    }
  }
</script>

<style>
</style>
