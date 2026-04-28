<template>
  <view class="budget-help-page">
    <scroll-view class="budget-help-scroll" scroll-y :show-scrollbar="false">
      <view class="budget-help-inner">
        <!-- ① 顶部预算说明卡片 -->
        <view class="budget-summary-card">
          <view class="summary-top-row">
            <view class="summary-col summary-col-side">
              <text class="side-label">饮食摄入</text>
              <text class="side-value">{{ intakeCalories }}</text>
            </view>

            <view class="summary-col summary-col-center">
              <HomeCalorieGauge
                :value="remainingCalories"
                :max="dailyBudget"
                status="normal"
                :clickable="false"
                :show-arrow="true"
                :gradient-arc="true"
              />
            </view>

            <view class="summary-col summary-col-side">
              <text class="side-label">运动消耗</text>
              <text class="side-value">{{ sportCalories }}</text>
            </view>
          </view>

          <view class="budget-summary-divider" />

          <!-- 公式区：上下两行 -->
          <view class="budget-formula-card">
            <view class="budget-formula-header-row">
              <text class="formula-h formula-h--narrow">还可吃</text>
              <text class="formula-h">每日预算</text>
              <text class="formula-h formula-h--narrow">饮食</text>
              <text class="formula-h formula-h--narrow">运动</text>
            </view>
            <view class="budget-formula-value-row">
              <text class="formula-v formula-v--remain">{{ remainingCalories }}</text>
              <text class="formula-v formula-op">=</text>
              <text class="formula-v">{{ dailyBudget }}</text>
              <text class="formula-v formula-op">-</text>
              <text class="formula-v">{{ intakeCalories }}</text>
              <text class="formula-v formula-op">+</text>
              <text class="formula-v">{{ sportCalories }}</text>
            </view>
          </view>
        </view>

        <!-- ③ 装饰连接线 -->
        <view class="card-connector-strip">
          <view class="card-connector card-connector-left">
            <view class="conn-dot" />
            <view class="conn-line" />
            <view class="conn-dot" />
          </view>
          <view class="card-connector card-connector-right">
            <view class="conn-dot" />
            <view class="conn-line" />
            <view class="conn-dot" />
          </view>
        </view>

        <!-- ④ 文案说明卡片 -->
        <view class="budget-explain-card">
          <view class="explain-para">
            <text>多运动和控制饮食，使得每日还可吃&gt;0，即可达成减重目标。（可调整</text>
            <text class="explain-link" @tap="goAccountEdit">个人信息</text>
            <text>更新每日预算）</text>
          </view>

          <view v-if="bmr != null && deficitCalories != null" class="explain-para explain-para--mt">
            <text>每日预算：根据您的减重目标每日预算({{ dailyBudget }})=</text>
            <text class="explain-formula-red">
              基础代谢({{ bmr }})-减重所需热量缺口 ({{ deficitCalories }})
            </text>
          </view>
          <text v-else class="explain-para explain-para--mt">
            每日预算：根据您的减重目标与基础代谢、热量缺口计算得出，可在个人信息中调整目标后更新每日预算。
          </text>

          <text class="explain-para explain-para--mt">
            饮食热量：根据您记录的饮食计算热量，保证每日记录2次及以上饮食才有效哦。
          </text>
          <text class="explain-para explain-para--mt">
            运动能量：运动能增加热量消耗，如果今日热量超标了请通过运动让今日还可吃保持&gt;0哦~
          </text>
        </view>

        <view class="bottom-spacer-before-cta" />
      </view>
    </scroll-view>

    <!-- ⑤ 底部按钮 -->
    <view class="budget-help-footer">
      <view class="custom-bmr-bottom-button" @tap="openDialog">
        <text class="custom-bmr-bottom-button-text">自定义基础代谢</text>
      </view>
    </view>

    <CustomBmrDialog
      v-model:visible="dialogVisible"
      :default-bmr="dialogDefaultBmr"
      @restore="onDialogRestore"
      @confirm="onDialogConfirm"
    />
  </view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'
import { fetchCurrentUser, fetchDashboard } from '@/api/loseweight'
import HomeCalorieGauge from '@/components/home/HomeCalorieGauge.vue'
import CustomBmrDialog from '@/components/home/CustomBmrDialog.vue'
import { formatLocalDate } from '@/utils/date'
import { useUserStore } from '@/stores/user'

const intakeCalories = ref(0)
const sportCalories = ref(0)
const dailyBudget = ref(0)
const remainingCalories = ref(0)
const bmr = ref<number | null>(null)
const userStore = useUserStore()
const dialogSubmitting = ref(false)

const deficitCalories = computed(() => {
  const b = bmr.value
  const d = dailyBudget.value
  if (b == null || b <= 0) return null
  return Math.max(0, Math.round(b - d))
})

const dialogVisible = ref(false)
const dialogDefaultBmr = ref(0)

function loadData() {
  const date = formatLocalDate(new Date())
  fetchDashboard(date)
    .then((data) => {
      intakeCalories.value = data.intakeCalories
      sportCalories.value = data.sportCalories
      dailyBudget.value = data.dailyBudget
      remainingCalories.value = data.remainingCalories
    })
    .catch((e: Error) => {
      uni.showToast({ title: e.message || '数据加载失败', icon: 'none' })
    })

  fetchCurrentUser()
    .then((u) => {
      bmr.value = u.bmr != null && u.bmr > 0 ? Math.round(u.bmr) : null
      if (bmr.value != null) {
        dialogDefaultBmr.value = bmr.value
      }
    })
    .catch(() => {
      /* 静默 */
    })
}

onShow(() => {
  loadData()
})

function openDialog() {
  dialogDefaultBmr.value = bmr.value != null && bmr.value > 0 ? bmr.value : 0
  dialogVisible.value = true
}

async function onDialogRestore() {
  if (!userStore.token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  if (dialogSubmitting.value) return
  dialogSubmitting.value = true
  try {
    uni.showLoading({ title: '恢复中', mask: true })
    await userStore.updateUserProfile({
      useCustomBmr: 0,
    })
    uni.hideLoading()
    uni.showToast({ title: '已恢复系统计算', icon: 'success' })
    dialogVisible.value = false
    loadData()
  } catch (e: unknown) {
    uni.hideLoading()
    const msg = e instanceof Error ? e.message : '恢复失败'
    uni.showToast({ title: msg, icon: 'none' })
  } finally {
    dialogSubmitting.value = false
  }
}

async function onDialogConfirm(nextBmr: number) {
  if (!userStore.token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  if (!Number.isFinite(nextBmr) || nextBmr <= 0) {
    uni.showToast({ title: '请输入有效基础代谢', icon: 'none' })
    return
  }
  if (dialogSubmitting.value) return
  dialogSubmitting.value = true
  try {
    uni.showLoading({ title: '保存中', mask: true })
    await userStore.updateUserProfile({
      useCustomBmr: 1,
      customBmr: Math.round(nextBmr),
    })
    uni.hideLoading()
    uni.showToast({ title: '已保存', icon: 'success' })
    dialogVisible.value = false
    loadData()
  } catch (e: unknown) {
    uni.hideLoading()
    const msg = e instanceof Error ? e.message : '保存失败'
    uni.showToast({ title: msg, icon: 'none' })
  } finally {
    dialogSubmitting.value = false
  }
}

function goAccountEdit() {
  uni.navigateTo({ url: '/pages/user/account-edit' })
}
</script>

<style lang="scss" scoped>
.budget-help-page {
  height: 100vh;
  min-height: 100vh;
  background-color: #eef4e8;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}

.budget-help-scroll {
  flex: 1;
  height: 0;
  width: 100%;
}

.budget-help-inner {
  padding: 16px;
  padding-bottom: 8px;
  box-sizing: border-box;
}

.budget-summary-card {
  background-color: #ffffff;
  border-radius: 16px;
  border: 1px solid #e8e8e8;
  padding: 16px;
  box-sizing: border-box;
}

.summary-top-row {
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: space-between;
  align-items: center;
  padding: 4px 0 8px;
  box-sizing: border-box;
}

.summary-col-side {
  width: 78px;
  flex: 0 0 78px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 140px;
  box-sizing: border-box;
}

.summary-col-center {
  flex: 1;
  min-width: 0;
  display: flex;
  justify-content: center;
  align-items: center;
}

.side-label {
  font-size: 12px;
  color: #333333;
  text-align: center;
  line-height: 1.2;
}

.side-value {
  margin-top: 10px;
  font-size: 22px;
  font-weight: 800;
  color: #222222;
  text-align: center;
  line-height: 1.1;
}

.budget-summary-divider {
  height: 1px;
  margin: 8px 0 12px;
  background: transparent;
  border-top: 1px dashed #cccccc;
}

.budget-formula-card {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.budget-formula-header-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 0 2px;
  box-sizing: border-box;
}

.formula-h {
  flex: 1;
  font-size: 11px;
  color: #666666;
  text-align: center;
}

.formula-h--narrow {
  flex: 0.85;
}

.budget-formula-value-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 0 2px;
  box-sizing: border-box;
}

.formula-v {
  flex: 1;
  font-size: 13px;
  color: #333333;
  text-align: center;
  font-weight: 400;
}

.formula-v--remain {
  color: #5fa854;
  font-weight: 700;
}

.formula-op {
  flex: 0.35;
  font-weight: 400;
}

/* ③ 连接线 */
.card-connector-strip {
  position: relative;
  height: 32px;
  width: 100%;
}

.card-connector {
  position: absolute;
  top: 0;
  width: 48px;
  height: 32px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
}

.card-connector-left {
  left: 8px;
}

.card-connector-right {
  right: 8px;
}

.conn-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background-color: #bfd9a3;
  flex-shrink: 0;
}

.conn-line {
  width: 2px;
  flex: 1;
  min-height: 18px;
  background-color: #9ebc86;
}

.budget-explain-card {
  margin-top: 0;
  background-color: #ffffff;
  border-radius: 16px;
  border: 2px solid #bfd9a3;
  padding: 16px;
  box-sizing: border-box;
}

.explain-para {
  display: block;
  font-size: 13px;
  color: #333333;
  line-height: 1.65;
}

.explain-para--mt {
  margin-top: 12px;
}

.explain-link {
  color: #3b7ddd;
}

.explain-formula-red {
  color: #e57373;
}

.bottom-spacer-before-cta {
  height: 44px;
}

.budget-help-footer {
  flex-shrink: 0;
  padding: 0 16px calc(12px + env(safe-area-inset-bottom));
  background-color: #eef4e8;
  box-sizing: border-box;
}

.custom-bmr-bottom-button {
  width: 100%;
  height: 48px;
  border-radius: 24px;
  background-color: #d5e7b1;
  border: 1px solid #9ebc86;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.custom-bmr-bottom-button-text {
  font-size: 15px;
  font-weight: 700;
  color: #222222;
}
</style>
