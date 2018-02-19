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
                <input type="hidden" name="stub" value="0">
                <input type="text" name="answer" id="input-answer" placeholder="Введите код">
            </div>
        </form>
    </div>
</template>

<script>
  import _ from 'underscore'
  import utils from 'scripts/utils'
  import moment from 'moment'

  export default {
    mounted() {
      this.form = document.querySelector('#level-answer-form');
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

        var now = moment.utc(this.currentTime.toISOString());
        var next_hint = moment.utc(this.next_hint);
        var diff_msec = next_hint.diff(now)

        return diff_msec;
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
        var params = $(this.form).serializeArray()
        var payload = _.object(_.pluck(params, 'name'), _.pluck(params, 'value'))

        this.$store.dispatch('postAnswer', payload)
          .then(() => this.form.reset())
          .catch(() => console.error('could not send answer', payload))
      },
    }
  }
</script>