<template>
    <div class="game-preview" v-if="isLoaded">
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
  import {mapGetters} from 'vuex'
  import {TIME_THRESHOLD, DAY_THRESHOLD} from "./consts"

  export default {
    computed: {
      ...mapGetters([
        'passing',
        'game',
        'isLoaded',
        'timings/beforeStart'
      ]),
      ...mapGetters('timings', [
        'beforeStart'
      ]),
      timeLeftBeforeStart() {
        if (this.beforeStart > DAY_THRESHOLD) {
          return "Начало игры: " + moment.utc(this.game.starts_at).fromNow()
        } else if (this.beforeStart > TIME_THRESHOLD) {
          return "До начала игры: " + moment.utc(Math.abs(this.beforeStart)).format('HH:mm:ss')
        } else {
          return 'Игра начинается'
        }
      },
      startTime() {
        return moment.utc(this.game.starts_at).format('L HH:mm:ss')
      }
    }
  }
</script>