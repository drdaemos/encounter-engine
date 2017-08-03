import 'stylesheets/application.scss'
import 'jquery-ujs'
// import Vue from 'vue'
// import App from 'components/application.vue'
import NewGameView from 'components/new_game'
import moment from 'moment'

document.addEventListener('DOMContentLoaded', () => {
  $('[data-datetime-string]').each(function() {
    this.textContent = moment(this.textContent).format('DD-MM-YYYY HH:mm');
  });
  // const app = new Vue(App).$mount('#encounter-app')
})
