import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../views/Dashboard.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Dashboard,
      meta: { title: 'Dashboard' }
    },
    {
      path: '/servers',
      name: 'servers',
      component: () => import('../views/Servers.vue'),
      meta: { title: 'MCP Servers' }
    },
    {
      path: '/tools',
      name: 'tools',
      component: () => import('../views/Tools.vue'),
      meta: { title: 'Tools' }
    },
    {
      path: '/tokens',
      name: 'tokens',
      component: () => import('../views/Tokens.vue'),
      meta: { title: 'Access Tokens' }
    }
  ]
})

router.beforeEach((to, from, next) => {
  document.title = `${to.meta.title || 'Nexus'} - MCP Gateway`
  next()
})

export default router
