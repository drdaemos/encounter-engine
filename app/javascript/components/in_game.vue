<template>
  <div class="encounter-game">
    <div class="app-grid">

      <div class="header-container">
        <span class="game-name">Игра "<strong>{{ game.name }}</strong>"</span>
        <span>Задание #{{ level.position }}</span>      
      </div>
      
      <div class="center-container">
        <div class="main-container">
          <article>
            <current-level :game-channel="gameChannel"></current-level>
          </article>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import CurrentLevel from './current_level.vue'
import store from 'stores/in_game.js'

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
        console.log(data);
        this.$store.commit('UPDATE_STATE', data);
      }
    });
  },
  computed: {
    team_id () {
      return this.$store.getters.user.team_id;
    },
    game () {
      return this.$store.getters.game
    },
    level () {
      return this.$store.getters.level
    }
  },
  components: {
    CurrentLevel
  }
}
</script>
