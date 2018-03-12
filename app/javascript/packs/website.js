import 'foundation-sites'
import 'stylesheets/website.scss'
import 'jquery-ujs'
import moment from 'moment'

import '../components/new_game'
import '../components/froala_textarea'
import '../components/game_stats'
import '../components/mobile_menu'

document.addEventListener('DOMContentLoaded', () => {
  $(document).foundation();
  $('[data-datetime-string]').each(function() {
    this.textContent = moment(this.textContent).format('DD-MM-YYYY HH:mm');
  });
  // const app = new Vue(App).$mount('#encounter-app')
})
