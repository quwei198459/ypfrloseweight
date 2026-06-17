<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, UploadFile } from 'element-plus'
import {
  fetchPhotoRecognitionServiceConfig,
  updatePhotoRecognitionServiceConfig,
} from '../api/admin'
import type { PhotoRecognitionServiceConfig } from '../types/admin'

const configLoading = ref(false)
const configSaving = ref(false)
const configFormRef = ref<FormInstance>()
const configPreview = ref<PhotoRecognitionServiceConfig | null>(null)
const qrUploadFile = ref<File | null>(null)
const qrUploadPreview = ref('')
const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || '/api/v1').replace(/\/api\/v1\/?$/, '')

const configForm = reactive({
  servicePhone: '400-000-0000',
  serviceWechat: 'baohu-service',
  serviceQrImageUrl: '',
  remark: '',
  status: 1,
})

const resolvedQrPreview = computed(() => {
  return resolveQrImageUrl(
    qrUploadPreview.value || configPreview.value?.serviceQrImageUrl || configPreview.value?.serviceQrImagePath || ''
  )
})

function resolveQrImageUrl(raw: string) {
  if (!raw) return ''
  if (/^(https?:|blob:|data:)/i.test(raw)) return raw
  if (raw.startsWith('/')) return `${apiBaseUrl}${raw}`
  return `${apiBaseUrl}/${raw}`
}

async function loadConfig() {
  configLoading.value = true
  try {
    const cfg = await fetchPhotoRecognitionServiceConfig()
    configPreview.value = cfg
    configForm.servicePhone = cfg.servicePhone || '400-000-0000'
    configForm.serviceWechat = cfg.serviceWechat || 'baohu-service'
    configForm.serviceQrImageUrl = cfg.serviceQrImageUrl || ''
    configForm.remark = cfg.remark || ''
    configForm.status = cfg.status || 1
    qrUploadFile.value = null
    qrUploadPreview.value = cfg.serviceQrImageUrl || cfg.serviceQrImagePath || ''
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载客服配置失败')
  } finally {
    configLoading.value = false
  }
}

function handleQrFileChange(file: UploadFile) {
  qrUploadFile.value = file.raw instanceof File ? file.raw : null
  if (file.raw instanceof File) {
    qrUploadPreview.value = URL.createObjectURL(file.raw)
  }
}

function clearQrFile() {
  qrUploadFile.value = null
  qrUploadPreview.value = configPreview.value?.serviceQrImageUrl || configPreview.value?.serviceQrImagePath || ''
}

async function submitConfig() {
  const f = configFormRef.value
  if (!f) return
  try {
    await f.validate()
  } catch {
    return
  }
  configSaving.value = true
  try {
    const cfg = await updatePhotoRecognitionServiceConfig({
      servicePhone: configForm.servicePhone.trim(),
      serviceWechat: configForm.serviceWechat.trim(),
      serviceQrImageUrl: configForm.serviceQrImageUrl.trim() || undefined,
      serviceQrImageFile: qrUploadFile.value || undefined,
      remark: configForm.remark.trim() || undefined,
      status: configForm.status,
    })
    configPreview.value = cfg
    qrUploadFile.value = null
    qrUploadPreview.value = cfg.serviceQrImageUrl || cfg.serviceQrImagePath || ''
    ElMessage.success('客服配置已保存')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存客服配置失败')
  } finally {
    configSaving.value = false
  }
}

onMounted(loadConfig)
</script>

<template>
  <div class="photo-service-config-page">
    <el-card v-loading="configLoading">
      <template #header>
        <div class="photo-service-config-page__title">识图客服配置</div>
      </template>
      <div class="page-intro">
        <div class="page-intro__title">客服配置</div>
        <div class="page-intro__desc">维护小程序拍照识别拦截弹窗展示的客服电话、微信号和二维码。手机号权限和次数请在“食物识别白名单”页面维护。</div>
      </div>
      <div class="config-layout">
        <div class="config-form-wrap">
          <el-form ref="configFormRef" :model="configForm" label-width="110px">
            <el-form-item label="客服电话">
              <el-input v-model="configForm.servicePhone" />
            </el-form-item>
            <el-form-item label="客服微信号">
              <el-input v-model="configForm.serviceWechat" />
            </el-form-item>
            <el-form-item label="二维码图片URL">
              <el-input v-model="configForm.serviceQrImageUrl" placeholder="可填 /api/v1/public/avatars/photo-recognition/service-qr.png" />
            </el-form-item>
            <el-form-item label="二维码上传">
              <el-upload
                :auto-upload="false"
                :show-file-list="false"
                accept="image/png,image/jpeg"
                :on-change="handleQrFileChange"
                :on-remove="clearQrFile"
              >
                <el-button>选择二维码图片</el-button>
              </el-upload>
              <div class="upload-hint">支持 PNG / JPG，上传后会保存为后台可访问图片。</div>
            </el-form-item>
            <el-form-item label="备注">
              <el-input v-model="configForm.remark" type="textarea" :rows="2" />
            </el-form-item>
            <el-form-item label="状态">
              <el-radio-group v-model="configForm.status">
                <el-radio :label="1">启用</el-radio>
                <el-radio :label="0">停用</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="configSaving" @click="submitConfig">保存客服配置</el-button>
            </el-form-item>
          </el-form>
        </div>
        <div class="config-preview">
          <div class="config-preview__label">当前二维码预览</div>
          <div class="config-preview__box">
            <img v-if="resolvedQrPreview" :src="resolvedQrPreview" alt="客服二维码" />
            <div v-else class="config-preview__empty">暂无二维码图片</div>
          </div>
          <div class="config-preview__meta">
            <div>客服电话：{{ configPreview?.servicePhone || configForm.servicePhone }}</div>
            <div>客服微信：{{ configPreview?.serviceWechat || configForm.serviceWechat }}</div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.photo-service-config-page {
  display: grid;
  gap: 16px;
}

.photo-service-config-page__title {
  font-weight: 700;
}

.page-intro {
  margin-bottom: 16px;
  padding: 14px 16px;
  border: 1px solid #e5ebe8;
  border-radius: 12px;
  background: #fafdfb;
}

.page-intro__title {
  font-size: 16px;
  font-weight: 700;
  color: #0f2d28;
}

.page-intro__desc {
  margin-top: 6px;
  font-size: 13px;
  color: #64748b;
  line-height: 1.7;
}

.config-layout {
  display: grid;
  grid-template-columns: 1.6fr 1fr;
  gap: 16px;
}

.config-preview {
  border: 1px solid #e5ebe8;
  border-radius: 12px;
  padding: 16px;
  background: #fafdfb;
}

.config-preview__label {
  font-weight: 600;
  margin-bottom: 12px;
}

.config-preview__box {
  width: 100%;
  min-height: 240px;
  border: 1px dashed #cfdad4;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
}

.config-preview__box img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.config-preview__empty {
  color: #8a97a5;
}

.config-preview__meta {
  margin-top: 12px;
  font-size: 13px;
  color: #64748b;
  line-height: 1.8;
}

.upload-hint {
  margin-top: 8px;
  font-size: 12px;
  color: #8a97a5;
  line-height: 1.6;
}
</style>
