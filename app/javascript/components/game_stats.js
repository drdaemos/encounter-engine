export default class GameStatsView {
  constructor (el) {
    if (!document.querySelector(el)) {
      return
    }

    this.render()
  }

  render () {

  }
}

document.addEventListener('DOMContentLoaded', () => {
  new GameStatsView('.game-stats-page')
})