import moment from 'moment'
import {TIME_THRESHOLD} from "../consts"

let timer = operative((callback) => {
  callback()
  setInterval(() => callback(), 1000)
})

let getTimeDiff = (from, to) => {
  const utcTo = moment.utc(to)
  const utcFrom = moment.utc(from)

  return utcFrom.diff(utcTo);
}

export default {
  namespaced: true,
  state () {
    return {
      current: new Date(),
    }
  },
  getters: {
    passedFromUpdate: (state, getters, rootState) => {
      return moment(state.current).diff(moment(rootState.lastUpdate))
    },
    onLevel: (state, getters, rootState, rootGetters) => {
      try {
        // add full second to compensate for non-full second which is lost on rounding
        return (rootGetters.level.entered_at + getters.passedFromUpdate) + 1000
      } catch (e) {}
      return null
    },
    beforeStart: (state, getters, rootState, rootGetters) => {
      try {
        if (rootGetters.game.started) {
          return null
        }

        return (rootGetters.game.starts_at - getters.passedFromUpdate)
      } catch (e) {}
      return null
    },
    beforeNextHint: (state, getters, rootState, rootGetters) => {
      try {
        if (!rootGetters.hints.next_hint) {
          return null
        }

        return rootGetters.hints.next_hint - getters.passedFromUpdate
      } catch (e) {}
      return null
    },
    beforeLevelFail: (state, getters, rootState, rootGetters) => {
      try {
        if (!rootGetters.level.time_left) {
          return null
        }

        return rootGetters.level.time_left - getters.passedFromUpdate
      } catch (e) {}
      return null
    },
  },
  mutations: {
    TIMER_TICK (state) {
      state.current = new Date()
    }
  },
  actions: {
    start (context) {
      timer(function () {
        context.commit('TIMER_TICK')
        if (context.rootGetters.shouldReload) {
          context.dispatch('requestState', null, { root: true })
        }
      })
    },
  }
}