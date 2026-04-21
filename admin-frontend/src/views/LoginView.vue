<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { adminLogin } from '../api/admin'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const auth = useAuthStore()
const loading = ref(false)
const form = reactive({
  username: 'admin',
  password: '123456',
})

async function onSubmit() {
  loading.value = true
  try {
    const resp = await adminLogin(form)
    auth.setAuth(resp.token, resp.username)
    ElMessage.success('登录成功')
    router.replace('/dashboard')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '登录失败')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-bg" aria-hidden="true" />
    <div class="login-card-wrap">
      <div class="login-brand">
        <img class="login-brand__logo" src="/logo-baohu.png" alt="宝护健康" />
        <div class="login-brand__text">
          <div class="login-brand__title">宝护健康瘦</div>
          <div class="login-brand__sub">管理后台</div>
        </div>
      </div>
      <el-card class="login-card" shadow="never">
        <template #header>
          <span class="login-card__header-title">账号登录</span>
        </template>
        <el-form label-position="top" size="large" @submit.prevent="onSubmit">
          <el-form-item label="账号">
            <el-input v-model="form.username" clearable placeholder="请输入账号" />
          </el-form-item>
          <el-form-item label="密码">
            <el-input v-model="form.password" type="password" show-password clearable placeholder="请输入密码" />
          </el-form-item>
          <el-button type="primary" :loading="loading" class="login-submit" native-type="button" @click="onSubmit">
            登 录
          </el-button>
        </el-form>
      </el-card>
      <p class="login-foot">仅限授权人员使用</p>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 24px;
  overflow: hidden;
}

.login-bg {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 80% 50% at 50% -20%, rgba(18, 163, 130, 0.35), transparent),
    linear-gradient(165deg, #0f2d28 0%, #1a4d42 45%, #0d2830 100%);
  z-index: 0;
}

.login-card-wrap {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 420px;
}

.login-brand {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
  padding: 0 4px;
}

.login-brand__logo {
  width: 64px;
  height: 64px;
  object-fit: contain;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.12);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
}

.login-brand__title {
  font-size: 26px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 0.06em;
  line-height: 1.2;
}

.login-brand__sub {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.75);
  margin-top: 4px;
}

.login-card {
  background: rgba(255, 255, 255, 0.97) !important;
  backdrop-filter: blur(12px);
}

.login-card__header-title {
  font-size: 16px;
  font-weight: 600;
  color: #0f2d28;
}

.login-submit {
  width: 100%;
  margin-top: 8px;
  height: 44px;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0.2em;
}

.login-foot {
  text-align: center;
  margin-top: 20px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.45);
}
</style>
