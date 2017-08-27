import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

let stateContainer = document.querySelector('script[x-app-data]');
let initialState = JSON.parse(stateContainer.innerHTML);

export default new Vuex.Store({
  state: initialState,
  getters: {
    game: (state) => state.game, 
    user: (state) => state.user, 
    passing: (state) => state.game_passing, 
    level: (state) => state.level, 
    hints: (state) => state.hints, 
    results_url: (state) => state.game_passing ? state.game_passing.results_url : null
  },
  mutations: {
    UPDATE_STATE: function (state, data) {
        state = Object.assign(state, data)
    }
  }
})