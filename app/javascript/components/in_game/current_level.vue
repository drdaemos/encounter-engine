<template>
    <div class="current-level" v-if="loaded">
        <h3 class="heading">{{ level.name }}</h3>
        <div class="text" v-html="level.text"></div>
        <div class="time-container">
            <p>Время на уровне: <span class="time">{{ timeOnLevel }}</span></p>
            <p v-if="hasTimeLimit">Автопереход через: <span class="time">{{ timeLeftBeforeFail }}</span></p>
        </div>
        <div class="hints-container">
            <h4>Подсказки:</h4>
            <div class="next-hint" v-if="timeLeftForNextHint">До следующей подсказки {{ timeLeftForNextHint }}</div>
            <div class="hints" v-for="hint in hints">
                <div class="hint" :data-id="hint.id" v-html="hint.text"></div>
            </div>
            <div class="next-hint" v-if="!timeLeftForNextHint">Подсказок больше не будет</div>
        </div>
        <h4>Коды:</h4>
        <div class="valid-answers">
            <div class="caption">Правильных кодов введено: {{ passing.answered }} из {{ level.question_count }}</div>
        </div>
        <form id="level-answer-form" class="answer-form" method="POST" action="" @submit.prevent="onSubmit">
            <div class="row">
                <input type="text" name="answer" id="input-answer" placeholder="Введите код">
            </div>
        </form>
    </div>
</template>

<script>
  import _ from 'underscore'
  import moment from 'moment'

  export default {
    computed: {
      currentTime() {
        return this.$store.getters.currentTime
      },
      timeOnLevel() {
        const now = moment.utc(this.currentTime.toISOString())
        const entered_at = moment.utc(this.level.entered_at)
        const diff_msec = now.diff(entered_at)

        return moment.utc(diff_msec).format('HH:mm:ss')
      },
      timeLeftForNextHint() {
        if (!this.next_hint) {
          return null;
        }

        return this.timeLeftForNextHintDiff > 0
          ? moment.utc(Math.abs(this.timeLeftForNextHintDiff)).format('HH:mm:ss')
          : '-' + moment.utc(Math.abs(this.timeLeftForNextHintDiff)).format('HH:mm:ss')
      },
      timeLeftForNextHintDiff() {
        if (!this.next_hint) {
          return null;
        }

        const now = moment.utc(this.currentTime.toISOString())
        const next_hint = moment.utc(this.next_hint)

        return next_hint.diff(now);
      },
      hasTimeLimit() {
        return this.level.time_limit
      },
      timeLeftBeforeFail() {
        return this.timeLeftBeforeFailDiff > 0
          ? moment.utc(Math.abs(this.timeLeftBeforeFailDiff)).format('HH:mm:ss')
          : '-' + moment.utc(Math.abs(this.timeLeftBeforeFailDiff)).format('HH:mm:ss')
      },
      timeLeftBeforeFailDiff() {
        const now = moment.utc(this.currentTime.toISOString())
        const failTime = moment.utc(this.level.entered_at).add(this.level.time_limit, 'seconds')

        return failTime.diff(now);
      },
      passing() {
        return this.$store.getters.passing
      },
      level() {
        return this.$store.getters.level
      },
      hints() {
        return this.$store.getters.hints.available
          .filter((item) => item.level_id === this.level.id)
          .reverse()
      },
      next_hint() {
        return this.$store.getters.hints.next_hint;
      },
      loaded() {
        return typeof this.level !== 'undefined'
      },
    },
    methods: {
      onSubmit(event) {
        let form = event.currentTarget
        let params = $(form).serializeArray()
        let payload = _.object(_.pluck(params, 'name'), _.pluck(params, 'value'))

        this.$store.dispatch('postAnswer', payload)
          .then(
            () => form.reset(),
            () => console.error('could not send answer', payload)
          )
      }
    }
  }
</script>