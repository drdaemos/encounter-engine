<template>
    <div class="level-header" v-if="loaded">
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
  import _ from 'underscore'
  import utils from 'scripts/utils'
  import moment from 'moment'

  export default {
    mounted() {
    },
    computed: {
      currentTime() {
        return this.$store.getters.currentTime
      },
      timeOnLevel() {
        var now = moment.utc(this.currentTime.toISOString());
        var entered_at = moment.utc(this.level.entered_at);
        var diff_msec = now.diff(entered_at)

        return moment.utc(diff_msec).format('HH:mm:ss')
      },
      timeLeftForNextHint() {
        if (!this.next_hint) {
          return null
        }

        return this.timeLeftForNextHintDiff > 0
          ? moment.utc(Math.abs(this.timeLeftForNextHintDiff)).format('HH:mm:ss')
          : '-' + moment.utc(Math.abs(this.timeLeftForNextHintDiff)).format('HH:mm:ss')
      },
      timeLeftForNextHintDiff() {
        if (!this.next_hint) {
          return null;
        }

        var now = moment.utc(this.currentTime.toISOString());
        var next_hint = moment.utc(this.next_hint);
        var diff_msec = next_hint.diff(now)

        return diff_msec
      },
      hasTimeLimit() {
        return Boolean(this.level.time_limit)
      },
      timeLeftBeforeFail() {
        return this.timeLeftBeforeFailDiff > 0
          ? moment.utc(Math.abs(this.timeLeftBeforeFailDiff)).format('HH:mm:ss')
          : '-' + moment.utc(Math.abs(this.timeLeftBeforeFailDiff)).format('HH:mm:ss')
      },
      timeLeftBeforeFailDiff() {
        var now = moment.utc(this.currentTime.toISOString());
        var failTime = moment.utc(this.level.entered_at).add(this.level.time_limit, 'seconds');
        var diff_msec = failTime.diff(now);

        return diff_msec;
      },
      passing() {
        return this.$store.getters.passing
      },
      level() {
        return this.$store.getters.level
      },
      game() {
        return this.$store.getters.game
      },
      loaded() {
        return typeof this.game !== 'undefined' && typeof this.level !== 'undefined'
      },
      hints() {
        return this.$store.getters.hints.available
          .filter((item) => item.level_id === this.level.id)
          .reverse()
      },
      next_hint() {
        return this.$store.getters.hints.next_hint;
      }
    },
  }
</script>