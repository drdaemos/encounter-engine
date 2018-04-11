<template>
    <div class="level-header" v-if="isLoaded">
        <div class="heading">
            <span class="game-name">Игра "<strong>{{ game.name }}</strong>"</span>
            <span>Задание #{{ level.position }}</span>
        </div>
        <div class="level-limits">
            <div class="time-left" v-if="hasTimeLimit">Осталось <span class="value">{{ timeLeftBeforeFail }}</span></div>
            <div class="answers">Коды: <span class="value">{{ passing.answered }}/{{ level.question_count }}</span></div>
        </div>
    </div>
</template>

<script>
  import moment from 'moment'
  import {mapGetters} from 'vuex'
  import {TIME_THRESHOLD} from './consts'

  export default {
    mounted() {
    },
    computed: {
      ...mapGetters([
        'passing',
        'game',
        'level',
        'isLoaded'
      ]),
      ...mapGetters('timings', [
        'beforeLevelFail'
      ]),
      hasTimeLimit() {
        return Boolean(this.level.time_limit)
      },
      timeLeftBeforeFail() {
        return this.beforeLevelFail > TIME_THRESHOLD
          ? moment.utc(Math.abs(this.beforeLevelFail)).format('HH:mm:ss')
          : '...'
      }
    },
  }
</script>