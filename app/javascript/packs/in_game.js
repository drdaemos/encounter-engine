import 'stylesheets/in_game.scss'
import 'jquery-ujs'
import Vue from 'vue'
import App from 'components/in_game.vue'
import utils from 'scripts/utils'

Vue.prototype.$cable = utils.createSocket()

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
