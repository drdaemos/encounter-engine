<template>
  <div id="app">
  </div>
</template>

<script>
export default {
  data: function () {
    return {
    }
  },
  computed: {
    msg: () => this.$store.getters.message
  }
}
</script>

<style scoped>

</style>
