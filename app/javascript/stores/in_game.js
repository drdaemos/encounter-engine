import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

console.log('vuex initialized')
export default new Vuex.Store({
  state: {
    user: {
        team: null,
        is_captain: null
    },
    game: {
        id: null,
        name: null,
        is_testing: true
    }, 
    game_passing: {
        time: null,
        answered: null
    }, 
    level: { 
        id: null,
        name: null, 
        text: null,
        position: null,
        multi_question: null,
        question_count: null
    },
    hints: {
        available: [],
        next_hint: null
    }
  },
  getters: {
    game: (state) => state.game, 
    user: (state) => state.user, 
    passing: (state) => state.game_passing, 
    level: (state) => state.level, 
    hints: (state) => state.hints, 
  },
  mutations: {
    UPDATE_INITIAL_STATE: function (state, data) {
        state = Object.assign(state, data)
    }
  }
})