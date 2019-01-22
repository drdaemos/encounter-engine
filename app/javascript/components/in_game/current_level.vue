<template>
    <div class="current-level" v-if="isLoaded">
        <h3 class="heading">{{ level.name }}</h3>
        <div class="text fr-view" v-html="level.text"></div>
        <hr>
        <div class="time-container">
            <p>Время на уровне: <span class="time">{{ timeOnLevel }}</span></p>
            <p v-if="hasTimeLimit">Автопереход через: <span class="time">{{ timeLeftBeforeFail }}</span></p>
        </div>
        <div class="hints-container" v-if="visibleHints.length > 0 || timeLeftForNextHint">
            <div class="next-hint" v-if="timeLeftForNextHint">До следующей подсказки: {{ timeLeftForNextHint }}</div>
            <div class="hints" v-if="visibleHints.length > 0">
                <div class="hint fr-view" v-for="hint in visibleHints" :data-id="hint.id" v-html="hint.text"></div>
            </div>
            <div class="next-hint" v-if="!timeLeftForNextHint">Подсказок больше не будет</div>
        </div>
        <div class="answers-container">
            <h5>Принято кодов: {{ passing.answered }} из {{ questions.count }}</h5>
            <div class="valid-answers" v-if="questions.answered.length > 0">
                <div class="answer" v-for="answer in questions.answered">{{ answer }}</div>
            </div>
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
  import {mapGetters} from 'vuex'
  import {TIME_THRESHOLD} from "./consts"

  export default {
    computed: {
      ...mapGetters([
        'passing',
        'level',
        'hints',
        'questions',
        'game',
        'user',
        'isLoaded'
      ]),
      ...mapGetters('timings', [
        'beforeStart',
        'beforeNextHint',
        'beforeLevelFail',
        'onLevel'
      ]),
      timeOnLevel () {
        return moment.utc(this.onLevel).format('HH:mm:ss')
      },
      timeLeftForNextHint () {
        if (!this.next_hint) {
          return null
        }

        return this.beforeNextHint > TIME_THRESHOLD
          ? moment.utc(Math.abs(this.beforeNextHint)).format('HH:mm:ss')
          : '...'
      },
      hasTimeLimit () {
        return this.level.time_limit
      },
      timeLeftBeforeFail () {
        return this.beforeLevelFail > TIME_THRESHOLD
          ? moment.utc(Math.abs(this.beforeLevelFail)).format('HH:mm:ss')
          : '...'
      },
      visibleHints () {
        return this.hints.available
          .filter((item) => item.level_id === this.level.id)
          .reverse()
      },
      next_hint () {
        return this.hints.next_hint
      }
    },
    methods: {
      onSubmit (event) {
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