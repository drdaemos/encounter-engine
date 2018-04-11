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
    currentTime: (state) => state.current,
    isoCurrent: (state) => state.current.toISOString(),
    onLevel: (state, getters, rootState, rootGetters) => {
      try {
        // add full second to compensate for non-full second which is lost on rounding
        return getTimeDiff(getters.isoCurrent, rootGetters.level.entered_at) + 1000
      } catch (e) {}
      return null
    },
    beforeStart: (state, getters, rootState, rootGetters) => {
      try {
        if (rootGetters.game.started) {
          return null
        }

        return getTimeDiff(rootGetters.game.starts_at, getters.isoCurrent)
      } catch (e) {}
      return null
    },
    beforeNextHint: (state, getters, rootState, rootGetters) => {
      try {
        if (!rootGetters.hints.next_hint) {
          return null
        }

        return getTimeDiff(getters.isoCurrent, rootGetters.hints.next_hint)
      } catch (e) {}
      return null
    },
    beforeLevelFail: (state, getters, rootState, rootGetters) => {
      try {
        if (!rootGetters.level.time_limit) {
          return null
        }

        let failTime = moment.utc(rootGetters.level.entered_at).add(rootGetters.level.time_limit, 'seconds')
        return getTimeDiff(failTime, getters.isoCurrent)
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