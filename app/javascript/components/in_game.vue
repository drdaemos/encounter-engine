<template>
    <div class="encounter-game">
        <div class="app-grid">

            <div class="header-container">
                <level-header></level-header>
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
  import LevelHeader from './level_header'
  import store from 'stores/in_game.js'
  import _ from 'underscore'

  export default {
    el: 'encounter-game',
    store,
    data () {
      return {
        currentTime: new Date(),
        gameChannel: null
      }
    },
    mounted: function () {
      this.$store.dispatch('createTimer')
      this.$store.dispatch('createChannel', {
        cable: this.$cable,
        onReceived: this.onReceived.bind(this)
      })
    },
    watch: {
      game_finished: function (newValue, oldValue) {
        if (newValue === true) {
          this.$toasted.success('Игра пройдена!')
          window.location.reload()
        }
      }
    },
    computed: {
      results_url () {
        return this.$store.getters.resultsUrl
      },
      game_finished () {
        return this.$store.getters.passing.finished
      },
      team_id () {
        return this.$store.getters.user.team_id
      },
      game () {
        return this.$store.getters.game
      },
      level () {
        return this.$store.getters.level
      },
    },
    methods: {
      onReceived (data) {
        this.processMessages(data.messages)
        this.processFlashes(data.flashes)
      },
      processMessages (messages) {
      },
      processFlashes (flashes) {
        if (flashes) {
          for (var key in flashes) {
            this.$toasted.show(flashes[key].text, {
              duration: 5000
            })
          }
        }
      }
    },
    components: {
      CurrentLevel,
      LevelHeader
    }
  }
</script>
