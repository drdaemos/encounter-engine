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
            <current-level></current-level>
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
  mounted: function () {    
    let stateContainer = document.querySelector('script[x-app-data]');
    let initialState = JSON.parse(stateContainer.innerHTML);

    this.$store.commit('UPDATE_INITIAL_STATE', initialState);
  },
  computed: {
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
