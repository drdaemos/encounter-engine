<template>
    <div class="game-preview">
        <h3 class="heading">{{ game.name }}</h3>
        <div class="description" v-html="game.description"></div>
    </div>
</template>

<script>
  import _ from 'underscore'
  import utils from 'scripts/utils'
  import moment from 'moment'

  export default {
    computed: {
      currentTime() {
        return this.$store.getters.currentTime
      },
      passing() {
        return this.$store.getters.passing
      },
      game() {
        return this.$store.getters.game
      },
    }
  }
</script>