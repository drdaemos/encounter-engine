import Vue from 'vue'
import Vuex from 'vuex'
import Timings from './timings'
import {TIME_THRESHOLD} from "../consts"
import utils from "../../../scripts/utils"

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
      lastUpdate: null,
      channel: null,
      onReceived: undefined
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
    questions: (state) => state.data.questions,
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
    updateState: function (state, payload) {
      Vue.set(state, 'lastUpdate', Date.now())
      let data = payload
      if (state.onReceived) {
        data = state.onReceived(payload)
      }
      Vue.set(state, 'data', data)
    },
    updateOnReceived: function (state, handlers) {
      Vue.set(state, 'onReceived', handlers)
    }
  },
  actions: {
    createChannel (context, options) {
      if (typeof(options.onReceived) !== 'undefined') {
        context.commit('updateOnReceived', options.onReceived)
      }

      let gameChannel = options.cable.subscriptions.create({
        channel: 'GameChannel',
        team: context.getters.user.team_id,
        game: context.getters.game.id
      }, {
        connected: () => {
          context.commit('setChannel', gameChannel)
          context.dispatch('requestState')
        },
        disconnected: () => {
          context.commit('setChannel', null)
          context.dispatch('requestState')
        },
        received: (data) => {
          context.commit('updateState', data)
        }
      })

      setTimeout(() => {
        if (!context.state.channel) {
          context.dispatch('requestState')
        }
      }, 1000)
    },
    requestState (context) {
      if (!context.state.channel || !context.state.channel.send({action: 'request_state'})) {
        utils.get(window.location)
          .then((response) => {
            return response.json()
          })
          .then((json) => {
            context.commit('updateState', json)
            return json
          })
      }
    },
    postAnswer (context, payload) {
      if (!context.state.channel) {
        return utils.post(window.location, payload)
          .then((response) => {
            return response.json()
          })
          .then((json) => {
            context.commit('updateState', json)
            return json
          })
      }

      return new Promise((resolve, reject) => {
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