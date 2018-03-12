<template>
    <div class="game-preview" v-if="loaded">
        <h3 class="heading">{{ game.name }}</h3>
        <div class="metadata">Начало игры: {{ startTime }}</div>
        <div class="description" v-html="game.description"></div>
        <div class="game-preview-counter">
            <div class="time-before-start">{{ timeLeftBeforeStart }}</div>
            <div class="auto-notice">Переход произойдет автоматически</div>
        </div>
    </div>
</template>

<script>
  import moment from 'moment'

  export default {
    computed: {
      timeLeftBeforeStart() {
        if (this.timeLeftBeforeStartDiff > 86400) {
          return "Начало игры: " + moment.utc(this.game.starts_at).fromNow()
        } else if (this.timeLeftBeforeStartDiff > 0) {
          return "До начала игры: " + moment.utc(Math.abs(this.timeLeftBeforeStartDiff)).format('HH:mm:ss')
        } else {
          return 'Игра начинается'
        }
      },
      timeLeftBeforeStartDiff() {
        const now = moment.utc(this.currentTime.toISOString())
        const startTime = moment.utc(this.game.starts_at)

        return startTime.diff(now);
      },
      startTime() {
        return moment.utc(this.game.starts_at).format('L HH:mm:ss')
      },
      currentTime() {
        return this.$store.getters.currentTime
      },
      passing() {
        return this.$store.getters.passing
      },
      game() {
        return this.$store.getters.game
      },
      loaded() {
        return typeof this.game !== 'undefined'
      }
    }
  }
</script>