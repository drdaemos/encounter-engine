import moment from 'moment'

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
    beforeStart: (state, getters, rootState, rootGetters) => {
      try {
        return getTimeDiff(rootGetters.game.starts_at, getters.isoCurrent)
      } catch (e) {}
      return null
    },
    onLevel: (state, getters, rootState, rootGetters) => {
      try {
        return getTimeDiff(getters.isoCurrent, rootGetters.level.entered_at)
      } catch (e) {}
      return null
    },
    beforeNextHint: (state, getters, rootState, rootGetters) => {
      try {
        return getTimeDiff(getters.isoCurrent, rootGetters.hints.next_hint)
      } catch (e) {}
      return null
    },
    beforeLevelFail: (state, getters, rootState, rootGetters) => {
      try {
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