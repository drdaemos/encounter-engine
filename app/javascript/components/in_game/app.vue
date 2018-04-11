<template>
    <div class="encounter-game">
        <div class="app-grid" v-if="isLoaded">
            <div class="header-container" v-if="game_started">
                <level-header/>
            </div>
            <div class="main-container" v-if="game_started">
                <current-level/>
            </div>
            <div class="main-container" v-else>
                <game-preview/>
            </div>
        </div>
    </div>
</template>

<script>
  import CurrentLevel from './current_level.vue'
  import LevelHeader from './level_header'
  import GamePreview from './game_preview'
  import store from './stores/in_game'
  import moment from 'moment'
  import {mapGetters} from 'vuex'

  moment.locale('ru')

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
      this.$store.dispatch('createChannel', {
        cable: this.$cable,
        onReceived: this.onReceived.bind(this)
      })

      this.$store.dispatch('timings/start')
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
      ...mapGetters([
        'passing',
        'game',
        'user',
        'isLoaded'
      ]),
      game_started () {
        return this.game.started
      },
      game_finished () {
        return this.passing.finished
      },
      team_id () {
        return this.user.team_id
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
      LevelHeader,
      GamePreview
    }
  }
</script>
