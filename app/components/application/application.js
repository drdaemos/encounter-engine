import Vue from 'vue'
import App from './app.vue'
import 'stylesheets/master.css'

document.addEventListener('DOMContentLoaded', () => {
  document.body.appendChild(document.createElement('hello'))
  const app = new Vue(App).$mount('hello')
})
