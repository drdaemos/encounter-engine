import 'whatwg-fetch'
import ActionCable from 'actioncable'
import _ from 'underscore'

class Utils {
  createSocket () {
    if (!this.$cable) {
      this.$cable = ActionCable.createConsumer()
    }

    return this.$cable
  }

  getCsrfToken () {
    return _.find(document.getElementsByTagName('meta'), (meta) => {
      return meta.name === 'csrf-token'
    }).content
  }

  getCableUrl () {
    return _.find(document.getElementsByTagName('meta'), (meta) => {
      return meta.name === 'action-cable-url'
    }).content
  }

  get (url, params) {
    return fetch(url, {
      method: 'GET',
      body: Utils.processPayload(params),
      headers: {
        'Accept': 'application/json',
      },
      credentials: 'same-origin'
    })
  }

  post (url, params) {
    return fetch(url, {
      method: 'POST',
      body: Utils.processPayload(params),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-Token': this.getCsrfToken(),
      },
      credentials: 'same-origin'
    })
  }

  static processPayload (params) {
    if (_.isObject(params)) {
      const data = new URLSearchParams();
      for (const prop in params) {
        if (params.hasOwnProperty(prop)) data.set(prop, params[prop]);
      }
      return data
    }

    return params
  }
}

export default new Utils()