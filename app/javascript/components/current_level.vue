<template>
  <div class="current-level">
    <h3 class="heading">{{ level.name }}</h3>
    <div class="text" v-html="level.text"></div>
    <div class="time-container">
        <p>Время на уровне: <span class="time">{{ timeOnLevel }}</span></p>
        <p>Автопереход через: <span class="time">{{ timeLeftBeforeFail }}</span></p>
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
        <div class="caption">Правильных кодов введено: {{ passing.answered }} из {{ level.question_count }} </div>
    </div>
    <form class="answer-form" method="POST">
        <div class="row">
            <label for="input-answer">Код: </label>
            <input name="answer" id="input-answer">
        </div>
    </form>
  </div>
</template>

<script>
import _ from 'underscore'
import utils from 'scripts/utils'
import moment from 'moment'

export default {
  props: ['gameChannel'],
  data () {
    return {
        currentTime: new Date(),
    }
  },
  mounted () {
    this.$form = $(this.$el).find('form');
    this.$form.submit(this.onSubmit);

    var timer = operative((callback) => {
        setInterval(() => callback(new Date()), 1000)
    });

    timer(this.updateTimer);
  },
  computed: {
    timeOnLevel () {        
        var now = moment.utc(this.currentTime.toISOString());
        var entered_at = moment.utc(this.level.entered_at);
        var diff_msec = now.diff(entered_at)

        return moment.utc(diff_msec).format('HH:mm:ss')
    },
    timeLeftForNextHint () {
        if (!this.next_hint) {
            return null;
        } 

        return this.timeLeftForNextHintDiff > 0 
            ? moment.utc(Math.abs(this.timeLeftForNextHintDiff)).format('HH:mm:ss')
            : '-' + moment.utc(Math.abs(this.timeLeftForNextHintDiff)).format('HH:mm:ss')
    },
    timeLeftForNextHintDiff () {
        if (!this.next_hint) {
            return null;
        } 

        var now = moment.utc(this.currentTime.toISOString());
        var next_hint = moment.utc(this.next_hint);
        var diff_msec = next_hint.diff(now)

        return diff_msec;
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
    passing () {
        return this.$store.getters.passing
    },
    level () {
        return this.$store.getters.level
    },
    hints () {
        return this.$store.getters.hints.available
            .filter((item) => item.level_id === this.level.id)
            .reverse()
    },
    next_hint () {
        return this.$store.getters.hints.next_hint;
    }
  },
  methods: {
    updateTimer (m) {
        this.currentTime = m;
        if (this.timeLeftForNextHintDiff < 0 || this.timeLeftBeforeFailDiff < 0) {
            this.requestState();
        }
    },
    requestState() {
        if (!this.gameChannel.send({ action: 'request_state' })) {
            console.error('could not request state');
        };
    },
    onSubmit(event) {
        event.preventDefault();
        var params = this.$form.serializeArray()
        var data = {
            action: 'post_answer',
            payload: _.object(_.pluck(params, 'name'), _.pluck(params, 'value'))
        }

        if (this.gameChannel.send(data)) {
            this.$form.get(0).reset();
        } else {
            console.error('could not send answer', data);
        };
    },
    onFinish: function() {
    },
  }
}
</script>