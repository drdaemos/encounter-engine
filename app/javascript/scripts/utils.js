import 'whatwg-fetch'
import ActionCable from 'actioncable'
import _ from 'underscore'

class Utils {
    createSocket() {
        if (!this.$cable) {
            this.$cable = ActionCable.createConsumer()
        }

        return this.$cable
    }

    getCsrfToken() {
        return _.find(document.getElementsByTagName('meta'), (meta) => {
          return meta.name === 'csrf-token'
        }).content
    } 

    getCableUrl() {
        return _.find(document.getElementsByTagName('meta'), (meta) => {
          return meta.name === 'action-cable-url'
        }).content
    } 

    post(url, params) {
        return fetch(url, {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-CSRF-Token': this.getCsrfToken(),
            },
            credentials: 'same-origin'
        })
    }       
}

export default new Utils();