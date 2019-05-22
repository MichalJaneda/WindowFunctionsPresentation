import Vue from 'vue'
import Router from 'vue-router'
import Index from './views/Index'
import NoStreak from './views/NoStreak'

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
      {
        path: '/',
        name: 'index',
        component: Index
      },
    {
      path: '/no_streak',
      name: 'no_streak',
      component: NoStreak
    },
      /*
  {
    path: '/payments_in_month',
    name: 'payments_in_month',
    component: PaymentsInMonth
  }*/
  ]
})
