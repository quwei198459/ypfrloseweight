<template>
  <view class="tcm-detail-page">
    <view v-if="loading" class="empty-card">详情加载中...</view>
    <template v-else-if="item">
      <view class="hero-card">
        <text class="eyebrow">望诊特征详情</text>
        <view class="hero-main">
          <view class="hero-text">
            <text class="item-title">{{ item.itemName }}</text>
            <text v-if="groupLabel" class="item-subtitle">{{ groupLabel }}</text>
          </view>
          <view class="level-badge" :class="isAbnormal ? 'level-badge--abnormal' : 'level-badge--normal'">
            <text class="level-text">{{ item.level || '正常' }}</text>
          </view>
        </view>
      </view>

      <view class="card">
        <text class="section-title">特征解读</text>
        <text class="paragraph">{{ item.resultText || '暂无解读' }}</text>
      </view>

      <view v-if="metricsRows.length" class="card">
        <text class="section-title">特征信息</text>
        <view class="meta-row" v-for="row in metricsRows" :key="row.label">
          <text class="meta-label">{{ row.label }}</text>
          <text class="meta-value">{{ row.value }}</text>
        </view>
      </view>
    </template>
    <view v-else class="empty-card">未找到该望诊特征详情</view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getTcmDetectionReport, type TcmDetectionItemVo, type TcmItemMetrics } from '@/api/tcmDetection'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const loading = ref(true)
const item = ref<TcmDetectionItemVo | null>(null)

const isAbnormal = computed(() => (item.value?.level || '').trim() === '异常')

const metrics = computed<TcmItemMetrics>(() => {
  const raw = item.value?.metricsJson
  if (!raw) return {}
  try {
    const obj = JSON.parse(raw)
    return obj && typeof obj === 'object' ? (obj as TcmItemMetrics) : {}
  } catch {
    return {}
  }
})

const groupLabel = computed(() => {
  const m = metrics.value
  return [item.value?.scaleType, m.group].filter(Boolean).join(' · ')
})

const metricsRows = computed(() => {
  const m = metrics.value
  const rows: { label: string; value: string }[] = []
  if (m.group) rows.push({ label: '所属分组', value: m.group })
  if (m.featureName) rows.push({ label: '特征名称', value: m.featureName })
  if (m.situation) rows.push({ label: '当前表现', value: m.situation })
  if (m.category) rows.push({ label: '所属类别', value: m.category })
  return rows
})

onLoad(async (query) => {
  const recordId = Number(query?.recordId)
  const itemCode = String(query?.itemCode || '')
  if (!userStore.token || !recordId || !itemCode) {
    uni.showToast({ title: '详情参数无效', icon: 'none' })
    loading.value = false
    return
  }
  try {
    const report = await getTcmDetectionReport(userStore.token, recordId)
    item.value = report.items.find((entry) => entry.itemCode === itemCode) || null
  } catch (e) {
    uni.showToast({ title: e instanceof Error ? e.message : '详情加载失败', icon: 'none' })
  } finally {
    loading.value = false
  }
})
</script>

<style lang="scss" scoped>
.tcm-detail-page {
  min-height: 100vh;
  padding: 18px 16px 32px;
  background: linear-gradient(180deg, #f7fbf7 0%, #f3f0fb 100%);
  box-sizing: border-box;
}
.empty-card,
.hero-card,
.card {
  padding: 20px 18px;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid #edf1e7;
  box-sizing: border-box;
  box-shadow: 0 10px 30px rgba(119, 142, 105, 0.08);
}
.empty-card { text-align: center; color: #7a857a; }
.hero-card {
  background: linear-gradient(135deg, #dcebc5 0%, #efe8ff 100%);
}
.eyebrow {
  font-size: 13px;
  color: #5f8f4f;
  font-weight: 800;
}
.hero-main {
  margin-top: 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}
.hero-text { flex: 1; }
.item-title {
  display: block;
  font-size: 26px;
  line-height: 1.2;
  color: #1f2a1f;
  font-weight: 900;
}
.item-subtitle {
  display: block;
  margin-top: 6px;
  font-size: 14px;
  color: #607060;
}
.level-badge {
  padding: 6px 16px;
  border-radius: 18px;
  flex-shrink: 0;
}
.level-badge--normal { background: #eef6e8; }
.level-badge--abnormal { background: #fdecea; }
.level-text { font-size: 15px; font-weight: 900; }
.level-badge--normal .level-text { color: #5fa854; }
.level-badge--abnormal .level-text { color: #e25a4a; }
.card {
  margin-top: 14px;
}
.section-title {
  display: block;
  font-size: 17px;
  color: #1f2a1f;
  font-weight: 900;
}
.paragraph {
  display: block;
  margin-top: 10px;
  font-size: 14px;
  line-height: 1.8;
  color: #4c594c;
}
.meta-row {
  margin-top: 12px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
}
.meta-label {
  font-size: 14px;
  color: #7a857a;
  flex-shrink: 0;
}
.meta-value {
  font-size: 14px;
  color: #384438;
  font-weight: 700;
  text-align: right;
}
</style>
