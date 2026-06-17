<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import type { FormInstance } from 'element-plus'
import { adminChangePassword } from '../api/admin'
import { useAuthStore } from '../stores/auth'

const auth = useAuthStore()
const router = useRouter()
const route = useRoute()
const pageTitle = computed(() => (route.meta?.title as string) || '')

const pwdVisible = ref(false)
const pwdSubmitting = ref(false)
const pwdFormRef = ref<FormInstance>()
const pwdForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: '',
})

const pwdRules = {
  oldPassword: [{ required: true, message: '请输入原密码', trigger: 'blur' }],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 64, message: '新密码长度 6～64 位', trigger: 'blur' },
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    {
      validator: (_: unknown, v: string, cb: (e?: Error) => void) => {
        if (v !== pwdForm.newPassword) cb(new Error('两次输入的新密码不一致'))
        else cb()
      },
      trigger: 'blur',
    },
  ],
}

function openPwdDialog() {
  pwdForm.oldPassword = ''
  pwdForm.newPassword = ''
  pwdForm.confirmPassword = ''
  pwdVisible.value = true
}

async function submitPwd() {
  const form = pwdFormRef.value
  if (!form) return
  try {
    await form.validate()
  } catch {
    return
  }
  pwdSubmitting.value = true
  try {
    await adminChangePassword({
      oldPassword: pwdForm.oldPassword,
      newPassword: pwdForm.newPassword,
    })
    ElMessage.success('密码已更新，请重新登录')
    pwdVisible.value = false
    auth.logout()
    router.replace('/login')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '修改失败')
  } finally {
    pwdSubmitting.value = false
  }
}

function handleLogout() {
  auth.logout()
  router.replace('/login')
}
</script>

<template>
  <el-container class="admin-shell">
    <el-aside width="232px" class="admin-side">
      <div class="admin-side__brand">
        <img class="admin-side__logo" src="/logo-baohu.png" alt="宝护健康" />
        <div class="admin-side__titles">
          <div class="admin-side__name">宝护健康瘦</div>
          <div class="admin-side__hint">管理后台</div>
        </div>
      </div>
      <el-menu
        :default-active="$route.path"
        router
        class="admin-menu"
        background-color="transparent"
        text-color="rgba(255,255,255,0.82)"
        active-text-color="#7ee8c8"
      >
        <el-menu-item index="/dashboard">
          <span>首页</span>
        </el-menu-item>
        <el-menu-item index="/users">
          <span>用户列表</span>
        </el-menu-item>
        <el-menu-item index="/food-categories">
          <span>食物分类</span>
        </el-menu-item>
        <el-menu-item index="/foods">
          <span>食物管理</span>
        </el-menu-item>
        <el-menu-item index="/sports">
          <span>运动管理</span>
        </el-menu-item>
        <el-menu-item index="/photo-recognition-service-config">
          <span>识图客服配置</span>
        </el-menu-item>
        <el-menu-item index="/photo-recognition-members">
          <span>食物识别白名单</span>
        </el-menu-item>
        <el-menu-item index="/skin-detection-whitelist">
          <span>皮肤检测白名单</span>
        </el-menu-item>
        <el-menu-item index="/skin-detection-records">
          <span>皮肤检测记录</span>
        </el-menu-item>
        <el-menu-item index="/skin-detection-item-configs">
          <span>皮肤检测项配置</span>
        </el-menu-item>
        <el-menu-item index="/skin-detection-ai-prompts">
          <span>AI提示词配置</span>
        </el-menu-item>
        <el-menu-item index="/tcm-detection-whitelist">
          <span>中医体检白名单</span>
        </el-menu-item>
        <el-menu-item index="/tcm-detection-records">
          <span>中医体检记录</span>
        </el-menu-item>
        <el-menu-item index="/tcm-detection-item-configs">
          <span>中医体检项配置</span>
        </el-menu-item>
        <el-menu-item index="/tcm-detection-ai-prompts">
          <span>中医AI提示词</span>
        </el-menu-item>
        <el-menu-item index="/system-config">
          <span>系统配置</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container class="admin-body">
      <el-header class="admin-header" height="var(--admin-header-h)">
        <div class="admin-header__left">
          <span class="admin-header__crumb">{{ pageTitle }}</span>
        </div>
        <div class="admin-header__right">
          <span class="admin-header__welcome">欢迎，{{ auth.username || '管理员' }}</span>
          <el-button type="primary" plain size="small" round @click="openPwdDialog">修改密码</el-button>
          <el-button type="danger" plain size="small" round @click="handleLogout">退出登录</el-button>
        </div>
      </el-header>
      <el-main class="admin-main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>

  <el-dialog
    v-model="pwdVisible"
    title="修改密码"
    width="420px"
    destroy-on-close
    class="admin-pwd-dialog"
    @closed="pwdFormRef?.resetFields()"
  >
    <el-form ref="pwdFormRef" :model="pwdForm" :rules="pwdRules" label-width="96px">
      <el-form-item label="原密码" prop="oldPassword">
        <el-input v-model="pwdForm.oldPassword" type="password" show-password autocomplete="current-password" />
      </el-form-item>
      <el-form-item label="新密码" prop="newPassword">
        <el-input v-model="pwdForm.newPassword" type="password" show-password autocomplete="new-password" />
      </el-form-item>
      <el-form-item label="确认新密码" prop="confirmPassword">
        <el-input v-model="pwdForm.confirmPassword" type="password" show-password autocomplete="new-password" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="pwdVisible = false">取消</el-button>
      <el-button type="primary" :loading="pwdSubmitting" @click="submitPwd">确定</el-button>
    </template>
  </el-dialog>
</template>

<style scoped>
.admin-shell {
  height: 100vh;
  background: #e8f0ed;
}

.admin-side {
  flex-shrink: 0;
  background: linear-gradient(180deg, var(--admin-side-from) 0%, var(--admin-side-to) 100%);
  box-shadow: 4px 0 24px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
}

.admin-side__brand {
  height: var(--admin-header-h);
  padding: 0 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.admin-side__logo {
  width: 40px;
  height: 40px;
  object-fit: contain;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.1);
}

.admin-side__name {
  font-size: 15px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 0.04em;
}

.admin-side__hint {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.55);
  margin-top: 2px;
}

.admin-menu {
  flex: 1;
  border-right: none !important;
  padding: 8px 0 16px;
}

.admin-menu :deep(.el-menu-item) {
  margin: 4px 10px;
  border-radius: 10px;
  height: 44px;
  line-height: 44px;
}

.admin-menu :deep(.el-menu-item:hover) {
  background: rgba(255, 255, 255, 0.08) !important;
}

.admin-menu :deep(.el-menu-item.is-active) {
  background: rgba(18, 163, 130, 0.22) !important;
  color: #b8f5e0 !important;
  font-weight: 600;
}

.admin-body {
  flex-direction: column;
  min-width: 0;
}

.admin-header {
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  border-bottom: 1px solid #e5ebe8;
  box-shadow: 0 1px 0 rgba(15, 45, 40, 0.04);
}

.admin-header__crumb {
  font-size: 15px;
  font-weight: 600;
  color: #0f2d28;
}

.admin-header__right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.admin-header__welcome {
  font-size: 13px;
  color: #64748b;
  margin-right: 4px;
}

.admin-main {
  padding: 20px 24px 28px;
  overflow: auto;
}
</style>
