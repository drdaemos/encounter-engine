import 'stylesheets/in_game.scss'
import 'jquery-ujs'
import 'operative'
import Vue from 'vue'
import utils from '../scripts/utils'
import Toasted from 'vue-toasted'
import App from '../components/in_game/app'

Vue.prototype.$cable = utils.createSocket()
Vue.use(Toasted)

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue(App)
  
    // navigator.serviceWorker.register('/sw.js');
    // Notification.requestPermission(function(result) {
    //   if (result === 'granted') {
    //     navigator.serviceWorker.ready.then(function(registration) {
    //       registration.showNotification('Notification with ServiceWorker');
    //     });
    //   }
    // });awdaw
})
