import 'foundation-sites'
import 'stylesheets/website.scss'
import {} from 'jquery-ujs'
import moment from 'moment'

import '../components/flashes'
import '../components/froala_textarea'
import '../components/game_stats'
import '../components/forms/game'
import '../components/forms/level'
import '../components/forms/question'
import '../components/mobile_menu'

document.addEventListener('DOMContentLoaded', () => {
  $(document).foundation();
  $('[data-datetime-string]').each(function() {
    this.textContent = moment(this.textContent).format('DD-MM-YYYY HH:mm');
  });
  // const app = new Vue(App).$mount('#encounter-app')
})
