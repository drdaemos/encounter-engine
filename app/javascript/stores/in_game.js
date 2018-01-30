import Vue from 'vue'
import Vuex from 'vuex'
import _ from 'underscore'

Vue.use(Vuex)

let stateContainer = document.querySelector('script[x-app-data]')
let initialState = JSON.parse(stateContainer.innerHTML)

export default new Vuex.Store({
  state: Object.assign(initialState, {
    channel: null,
    timer: new Date(),
  }),
  getters: {
    currentTime: (state) => state.timer,
    channel: (state) => state.channel,
    game: (state) => state.game,
    user: (state) => state.user,
    passing: (state) => state.game_passing,
    level: (state) => state.level,
    hints: (state) => state.hints,
    results_url: (state) => state.game_passing ? state.game_passing.results_url : null
  },
  mutations: {
    setChannel: function (state, channel) {
      state.channel = channel
    },
    updateState: function (state, data) {
      state = Object.assign(state, data)
    },
    timerTick: function (state, value) {
      state.timer = value
    }
  },
  actions: {
    createTimer (context) {
      let timer = operative((callback) => {
        setInterval(() => callback(new Date()), 1000)
      })

      timer(function (time) {
        context.commit('timerTick', time)
        context.dispatch('requestState')
      })
    },
    createChannel (context, options) {
      let gameChannel = options.cable.subscriptions.create({
        channel: 'GameChannel',
        team: context.getters.user.team_id,
        game: context.getters.game.id
      }, {
        received: (data) => {
          var state = _.omit(data, ['messages', 'flashes'])
          context.commit('updateState', state)
          if (typeof(options.onReceived) !== 'undefined') {
            options.onReceived(data)
          }
        }
      })

      context.commit('setChannel', gameChannel)
    },
    requestState (context) {
      if (!context.state.channel || !context.state.channel.send({action: 'request_state'})) {
        console.error('could not request state')
      }
    },
    postAnswer (context, payload) {
      return new Promise((resolve, reject) => {
        if (!context.state.channel) {
          reject()
        }

        let data = {
          action: 'post_answer',
          payload: payload
        }

        if (context.state.channel.send(data)) {
          resolve()
        } else {
          reject()
        }
      })
    }
  }
})