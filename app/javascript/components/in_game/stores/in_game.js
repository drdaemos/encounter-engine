import Vue from 'vue'
import Vuex from 'vuex'
import _ from 'underscore'
import Timings from './timings'
import {TIME_THRESHOLD} from "../consts"

Vue.use(Vuex)

let stateContainer = document.querySelector('script[x-app-data]')
let initialData = JSON.parse(stateContainer.innerHTML)

let lessThan = (value, threshold) => {
  if (value !== null && !isNaN(value)) {
    return value < threshold
  }

  return false
}

export default new Vuex.Store({
  state () {
    return {
      data: initialData,
      channel: null,
    }
  },
  modules: {
    timings: Timings
  },
  getters: {
    channel: (state) => state.channel,
    game: (state) => state.data.game,
    user: (state) => state.data.user,
    passing: (state) => state.data.game_passing,
    level: (state) => state.data.level,
    hints: (state) => state.data.hints,
    isLoaded: (state, getters) => typeof getters.game !== 'undefined' && typeof getters.level !== 'undefined',
    shouldReload: (state, getters) => {
      return lessThan(getters['timings/beforeStart'], TIME_THRESHOLD)
        || lessThan(getters['timings/beforeNextHint'], TIME_THRESHOLD)
        || lessThan(getters['timings/beforeLevelFail'], TIME_THRESHOLD)
    }
  },
  mutations: {
    setChannel: function (state, channel) {
      state.channel = channel
    },
    updateState: function (state, data) {
      Vue.set(state, 'data', data)
    }
  },
  actions: {
    createChannel (context, options) {
      let gameChannel = options.cable.subscriptions.create({
        channel: 'GameChannel',
        team: context.getters.user.team_id,
        game: context.getters.game.id
      }, {
        connected: () => {
          context.commit('setChannel', gameChannel)
          context.dispatch('requestState')
        },
        received: (data) => {
          var state = _.omit(data, ['messages', 'flashes'])
          context.commit('updateState', state)
          if (typeof(options.onReceived) !== 'undefined') {
            options.onReceived(data)
          }
        }
      })
    },
    requestState (context) {
      if (!context.state.channel || !context.state.channel.send({action: 'request_state'})) {
        throw new Error('Server connection failed')
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