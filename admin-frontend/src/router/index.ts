import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import AdminLayout from '../layouts/AdminLayout.vue'
import DashboardView from '../views/DashboardView.vue'
import FoodCategoryView from '../views/FoodCategoryView.vue'
import FoodView from '../views/FoodView.vue'
import LoginView from '../views/LoginView.vue'
import SportView from '../views/SportView.vue'
import PhotoRecognitionMemberView from '../views/PhotoRecognitionMemberView.vue'
import PhotoRecognitionServiceConfigView from '../views/PhotoRecognitionServiceConfigView.vue'
import SkinDetectionWhitelistView from '../views/SkinDetectionWhitelistView.vue'
import SkinDetectionRecordView from '../views/SkinDetectionRecordView.vue'
import SkinDetectionItemConfigView from '../views/SkinDetectionItemConfigView.vue'
import SkinDetectionAiPromptView from '../views/SkinDetectionAiPromptView.vue'
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
        {
          path: '/photo-recognition-service-config',
          name: 'photo-recognition-service-config',
          component: PhotoRecognitionServiceConfigView,
          meta: { title: '识图客服配置' },
        },
        {
          path: '/photo-recognition-members',
          name: 'photo-recognition-members',
          component: PhotoRecognitionMemberView,
          meta: { title: '手机号管理' },
        },
        {
          path: '/skin-detection-whitelist',
          name: 'skin-detection-whitelist',
          component: SkinDetectionWhitelistView,
          meta: { title: '皮肤检测白名单' },
        },
        {
          path: '/skin-detection-records',
          name: 'skin-detection-records',
          component: SkinDetectionRecordView,
          meta: { title: '皮肤检测记录' },
        },
        {
          path: '/skin-detection-item-configs',
          name: 'skin-detection-item-configs',
          component: SkinDetectionItemConfigView,
          meta: { title: '皮肤检测项配置' },
        },
        {
          path: '/skin-detection-ai-prompts',
          name: 'skin-detection-ai-prompts',
          component: SkinDetectionAiPromptView,
          meta: { title: 'AI提示词配置' },
        },
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
