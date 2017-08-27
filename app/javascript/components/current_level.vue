<template>
  <div class="current-level">
    <h3 class="heading">{{ level.name }}</h3>
    <p class="text">{{ level.text }}</p>
    <div class="hints-container">
        <h4>Подсказки:</h4>
        <div class="next-hint" v-if="timeLeftForNextHint">До следующей подсказки {{ timeLeftForNextHint }}</div>
        <div class="hints" v-for="hint in hints">
            <div class="hint" :data-id="hint.id">{{ hint.text }}</div>
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

export default {
  props: ['gameChannel'],
  data () {
    return {
    }
  },
  mounted () {
    this.$form = $(this.$el).find('form');
    this.$form.submit(this.onSubmit);
  },
  computed: {
    timeLeftForNextHint () {
        return null;
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
    }
  },
  methods: {
    onSubmit(event) {
        event.preventDefault();
        var params = this.$form.serializeArray()
        var url = ""
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
        console.log('yay')
    },
  }
}
</script>