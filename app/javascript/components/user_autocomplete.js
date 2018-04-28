import 'selectize-scss/src/'
import '../../assets/stylesheets/_selectize.scss'
import 'selectize-scss/src/selectize.scss'

export default class UserAutocomplete {
  constructor (el) {
    if (!document.querySelector(el)) {
      return
    }

    this.render(el)
  }

  render (el) {
    this.getList().then((list) => {
      $(el).selectize({
        options: list
      })
    })
  }

  getList () {
    return fetch('/user_list', {
      credentials: 'same-origin'
    })
      .then(response => response.json())
      .then((list) => list.map(item => {
        return {
          value: item.id,
          text: item.nickname
        }
      }))
      .catch(alert);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // new UserAutocomplete('#invitation_recepient_nickname')
})