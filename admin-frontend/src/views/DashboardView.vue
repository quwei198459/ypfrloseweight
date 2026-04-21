<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchAdminDashboardStats } from '../api/admin'
import type { AdminDashboardStats } from '../types/admin'

const loading = ref(true)
const stats = ref<AdminDashboardStats>({
  userTotal: 0,
  foodTotal: 0,
  todayMealRecordTotal: 0,
})

function fmtNum(n: number) {
  if (!Number.isFinite(n)) return '0'
  return n.toLocaleString('zh-CN')
}

async function load() {
  loading.value = true
  try {
    stats.value = await fetchAdminDashboardStats()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载统计失败')
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<template>
  <div v-loading="loading" class="dash">
    <div class="dash__title">
      <h1 class="dash__h1">数据概览</h1>
      <p class="dash__sub">用户总数、食物库规模、今日饮食餐次（按上海时区「今天」统计）</p>
    </div>
    <el-row :gutter="20" class="dash__row">
      <el-col :xs="24" :sm="8">
        <el-card class="stat-card stat-card--users" shadow="never">
          <div class="stat-card__inner">
            <div class="stat-card__icon" aria-hidden="true">用</div>
            <div class="stat-card__body">
              <div class="stat-card__label">用户总数</div>
              <div class="stat-card__value">{{ fmtNum(stats.userTotal) }}</div>
              <div class="stat-card__hint">lw_user 全表</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card class="stat-card stat-card--foods" shadow="never">
          <div class="stat-card__inner">
            <div class="stat-card__icon" aria-hidden="true">食</div>
            <div class="stat-card__body">
              <div class="stat-card__label">食物数量</div>
              <div class="stat-card__value">{{ fmtNum(stats.foodTotal) }}</div>
              <div class="stat-card__hint">food 全表</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card class="stat-card stat-card--today" shadow="never">
          <div class="stat-card__inner">
            <div class="stat-card__icon" aria-hidden="true">今</div>
            <div class="stat-card__body">
              <div class="stat-card__label">今日记录数</div>
              <div class="stat-card__value">{{ fmtNum(stats.todayMealRecordTotal) }}</div>
              <div class="stat-card__hint">meal_record 当日餐次头</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-button type="primary" plain class="dash__refresh" :loading="loading" @click="load">刷新数据</el-button>
  </div>
</template>

<style scoped>
.dash {
  max-width: 1200px;
}

.dash__title {
  margin-bottom: 20px;
}

.dash__h1 {
  margin: 0 0 8px;
  font-size: 22px;
  font-weight: 700;
  color: #0f2d28;
  letter-spacing: 0.02em;
}

.dash__sub {
  margin: 0;
  font-size: 13px;
  color: #64748b;
  line-height: 1.5;
}

.dash__row {
  margin-bottom: 16px;
}

.stat-card {
  border-radius: 14px !important;
  overflow: hidden;
  margin-bottom: 16px;
  border: 1px solid #e5ebe8 !important;
}

.stat-card__inner {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 4px 0;
}

.stat-card__icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 22px;
  font-weight: 800;
}

.stat-card--users .stat-card__icon {
  background: linear-gradient(135deg, #e0f7f1 0%, #b8ebd9 100%);
  color: #0d7a5f;
}

.stat-card--foods .stat-card__icon {
  background: linear-gradient(135deg, #fff4e5 0%, #ffe0b8 100%);
  color: #c45c00;
}

.stat-card--today .stat-card__icon {
  background: linear-gradient(135deg, #e8eeff 0%, #c9d8ff 100%);
  color: #3451d1;
}

.stat-card__label {
  font-size: 14px;
  color: #64748b;
  margin-bottom: 6px;
}

.stat-card__value {
  font-size: 32px;
  font-weight: 800;
  color: #0f2d28;
  line-height: 1.1;
  letter-spacing: -0.02em;
}

.stat-card__hint {
  margin-top: 8px;
  font-size: 12px;
  color: #94a3b8;
  line-height: 1.4;
}

.dash__refresh {
  margin-top: 4px;
}
</style>
