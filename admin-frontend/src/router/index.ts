import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import AdminLayout from '../layouts/AdminLayout.vue'
import DashboardView from '../views/DashboardView.vue'
import FoodCategoryView from '../views/FoodCategoryView.vue'
import FoodView from '../views/FoodView.vue'
import LoginView from '../views/LoginView.vue'
import SportView from '../views/SportView.vue'
import UserListView from '../views/UserListView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', name: 'login', component: LoginView, meta: { public: true } },
    {
      path: '/',
      component: AdminLayout,
      children: [
        { path: '', redirect: '/dashboard' },
        { path: '/dashboard', name: 'dashboard', component: DashboardView, meta: { title: '首页' } },
        { path: '/users', name: 'users', component: UserListView, meta: { title: '用户列表' } },
        {
          path: '/food-categories',
          name: 'food-categories',
          component: FoodCategoryView,
          meta: { title: '食物分类' },
        },
        { path: '/foods', name: 'foods', component: FoodView, meta: { title: '食物管理' } },
        { path: '/sports', name: 'sports', component: SportView, meta: { title: '运动管理' } },
      ],
    },
  ],
})

router.beforeEach((to) => {
  const auth = useAuthStore()
  if (to.meta.public) {
    if (auth.isAuthed && to.path === '/login') return '/dashboard'
    return true
  }
  if (!auth.isAuthed) return '/login'
  return true
})

export default router
