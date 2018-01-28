<template>
  <div class="encounter-game">
    <div class="app-grid">

      <div class="header-container">
        <span class="game-name">Игра "<strong>{{ game.name }}</strong>"</span>
        <span>Задание #{{ level.position }}</span>      
      </div>

      <div class="main-container">
        <article>
          <current-level :game-channel="gameChannel"></current-level>
        </article>
      </div>

    </div>
  </div>
</template>

<script>
import CurrentLevel from './current_level.vue'
import store from 'stores/in_game.js'
import _ from 'underscore'

export default {
  el: 'encounter-game',
  store,
  data () {
    return {
      gameChannel: null      
    }
  },
  mounted: function () {
    this.gameChannel = this.$cable.subscriptions.create({
      channel: 'GameChannel',
      team: this.team_id,
      game: this.game.id
    }, {
      received: (data) => {
        this.processMessages(data.messages)
        this.processFlashes(data.flashes)
        var state = _.omit(data, ['messages', 'flashes']);
        this.$store.commit('UPDATE_STATE', state);
      }
    });
  },
  watch: {
    game_finished: function(newValue, oldValue) {
      if (newValue === true) {
        this.$toasted.success('Игра пройдена!')
        window.location.reload()
      }
    }
  }, 
  computed: {
    results_url () {
      return this.$store.getters.resultsUrl;
    },
    game_finished () {
      return this.$store.getters.passing.finished;
    },
    team_id () {
      return this.$store.getters.user.team_id;
    },
    game () {
      return this.$store.getters.game
    },
    level () {
      return this.$store.getters.level
    },
  },
  methods: {
    processMessages (messages) {
    },
    processFlashes (flashes) {
      if (flashes) {
        for (var key in flashes) {
          this.$toasted.show(flashes[key].text)
        }
      }
    }
  },
  components: {
    CurrentLevel
  }
}
</script>
