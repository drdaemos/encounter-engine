import 'stylesheets/in_game.scss'
import 'jquery-ujs'
import 'whatwg-fetch'
import Vue from 'vue'
import App from 'components/in_game.vue'
import ActionCable from 'actioncable'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue(App)
  
    // navigator.serviceWorker.register('/sw.js');
    // Notification.requestPermission(function(result) {
    //   if (result === 'granted') {
    //     navigator.serviceWorker.ready.then(function(registration) {
    //       registration.showNotification('Notification with ServiceWorker');
    //     });
    //   }
    // });

    // var cable = ActionCable.createConsumer('ws://localhost:5000/websocket')

    // cable.subscriptions.create('TestChannel', {
    //     received: function (data) {
    //         console.log(data);

    //         new Notification('New message', {
    //             body: data.message
    //         });
    //     }
    // });
})
