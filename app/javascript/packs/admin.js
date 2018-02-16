import 'foundation-sites'
import 'stylesheets/admin.scss'
import 'jquery-ujs'
import NewGameView from '../components/new_game'
import FroalaTextarea from '../components/froala_textarea'
import moment from 'moment'

document.addEventListener('DOMContentLoaded', () => {
  $(document).foundation();
  $('[data-datetime-string]').each(function() {
    this.textContent = moment(this.textContent).format('DD-MM-YYYY HH:mm');
  });
  // const app = new Vue(App).$mount('#encounter-app')
})
