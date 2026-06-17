<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { fetchSystemConfig, updateSystemConfig } from '../api/admin'
import type { SystemConfig } from '../types/admin'

const loading = ref(false)
const photoRecognitionWhitelistEnabled = ref(true)
const skinDetectionWhitelistEnabled = ref(true)
const tcmDetectionWhitelistEnabled = ref(true)
const savingPhoto = ref(false)
const savingSkin = ref(false)
const savingTcm = ref(false)

async function loadConfig() {
  loading.value = true
  try {
    const cfg = await fetchSystemConfig()
    photoRecognitionWhitelistEnabled.value = cfg.photoRecognitionWhitelistEnabled !== false
    skinDetectionWhitelistEnabled.value = cfg.skinDetectionWhitelistEnabled !== false
    tcmDetectionWhitelistEnabled.value = cfg.tcmDetectionWhitelistEnabled !== false
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载系统配置失败')
  } finally {
    loading.value = false
  }
}

async function toggle(
  key: keyof SystemConfig,
  nextValue: boolean,
  model: typeof photoRecognitionWhitelistEnabled,
  saving: typeof savingPhoto,
  label: string,
) {
  // nextValue 为开关「白名单限制」的目标值：false=关闭限制
  if (!nextValue) {
    try {
      await ElMessageBox.confirm(
        `关闭后，所有用户无需在白名单内、也不消耗次数即可使用「${label}」。确认关闭白名单限制？`,
        '确认关闭白名单限制',
        { type: 'warning', confirmButtonText: '确认关闭', cancelButtonText: '取消' },
      )
    } catch {
      return
    }
  }
  saving.value = true
  try {
    const cfg = await updateSystemConfig({ [key]: nextValue } as Partial<SystemConfig>)
    photoRecognitionWhitelistEnabled.value = cfg.photoRecognitionWhitelistEnabled !== false
    skinDetectionWhitelistEnabled.value = cfg.skinDetectionWhitelistEnabled !== false
    tcmDetectionWhitelistEnabled.value = cfg.tcmDetectionWhitelistEnabled !== false
    ElMessage.success(nextValue ? '已开启白名单限制' : '已关闭白名单限制')
  } catch (e) {
    model.value = !nextValue // 回滚
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    saving.value = false
  }
}

function onPhotoChange(val: boolean) {
  void toggle('photoRecognitionWhitelistEnabled', val, photoRecognitionWhitelistEnabled, savingPhoto, '拍照识别食物热量')
}

function onSkinChange(val: boolean) {
  void toggle('skinDetectionWhitelistEnabled', val, skinDetectionWhitelistEnabled, savingSkin, '皮肤检测')
}

function onTcmChange(val: boolean) {
  void toggle('tcmDetectionWhitelistEnabled', val, tcmDetectionWhitelistEnabled, savingTcm, '中医体检')
}

onMounted(loadConfig)
</script>

<template>
  <div v-loading="loading" class="system-config">
    <el-card shadow="never" class="system-config__card">
      <template #header>
        <div class="system-config__header">
          <span class="system-config__title">白名单限制</span>
          <span class="system-config__desc">
            开关用于控制对应功能是否需要在手机号白名单内才能使用。关闭后该功能对所有用户开放，且不消耗赠送次数。
          </span>
        </div>
      </template>

      <div class="system-config__row">
        <div class="system-config__info">
          <div class="system-config__name">拍照识别食物热量</div>
          <div class="system-config__hint">
            开启：仅白名单手机号可用并计次；关闭：所有用户可用、不计次。
          </div>
        </div>
        <div class="system-config__control">
          <el-switch
            v-model="photoRecognitionWhitelistEnabled"
            :loading="savingPhoto"
            inline-prompt
            active-text="限制开启"
            inactive-text="已关闭"
            @change="onPhotoChange"
          />
          <el-tag :type="photoRecognitionWhitelistEnabled ? 'success' : 'info'" effect="plain" size="small">
            {{ photoRecognitionWhitelistEnabled ? '白名单限制生效中' : '已关闭限制' }}
          </el-tag>
        </div>
      </div>

      <el-divider class="system-config__divider" />

      <div class="system-config__row">
        <div class="system-config__info">
          <div class="system-config__name">皮肤检测</div>
          <div class="system-config__hint">
            开启：仅白名单手机号可用并计次；关闭：所有用户可用、不计次。
          </div>
        </div>
        <div class="system-config__control">
          <el-switch
            v-model="skinDetectionWhitelistEnabled"
            :loading="savingSkin"
            inline-prompt
            active-text="限制开启"
            inactive-text="已关闭"
            @change="onSkinChange"
          />
          <el-tag :type="skinDetectionWhitelistEnabled ? 'success' : 'info'" effect="plain" size="small">
            {{ skinDetectionWhitelistEnabled ? '白名单限制生效中' : '已关闭限制' }}
          </el-tag>
        </div>
      </div>

      <el-divider class="system-config__divider" />

      <div class="system-config__row">
        <div class="system-config__info">
          <div class="system-config__name">中医体检</div>
          <div class="system-config__hint">
            开启：仅白名单手机号可用并计次；关闭：所有用户可用、不计次。
          </div>
        </div>
        <div class="system-config__control">
          <el-switch
            v-model="tcmDetectionWhitelistEnabled"
            :loading="savingTcm"
            inline-prompt
            active-text="限制开启"
            inactive-text="已关闭"
            @change="onTcmChange"
          />
          <el-tag :type="tcmDetectionWhitelistEnabled ? 'success' : 'info'" effect="plain" size="small">
            {{ tcmDetectionWhitelistEnabled ? '白名单限制生效中' : '已关闭限制' }}
          </el-tag>
        </div>
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.system-config {
  max-width: 760px;
}

.system-config__header {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.system-config__title {
  font-size: 15px;
  font-weight: 600;
  color: #0f2d28;
}

.system-config__desc {
  font-size: 12px;
  color: #64748b;
  line-height: 1.6;
}

.system-config__row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 6px 0;
}

.system-config__name {
  font-size: 14px;
  font-weight: 600;
  color: #1f2d2a;
}

.system-config__hint {
  margin-top: 6px;
  font-size: 12px;
  color: #8a9a95;
  line-height: 1.5;
}

.system-config__control {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.system-config__divider {
  margin: 12px 0;
}
</style>
