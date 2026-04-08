<template>
  <view class="weight-page">
    <view class="nav-bar">
      <view class="back-btn" @click="goBack"><text class="back-ico">‹</text></view>
      <text class="nav-title">体重记录</text>
      <view class="add-btn" @click="showAddPopup = true"><text class="add-txt">+ 记录</text></view>
    </view>

    <scroll-view scroll-y class="scroll-content">
      <!-- 当前体重展示 -->
      <view class="current-card">
        <view class="cc-left">
          <text class="cc-big">{{ mockUser.currentWeight }}</text>
          <text class="cc-unit">kg</text>
        </view>
        <view class="cc-right">
          <view class="cc-stat">
            <text class="cs-label">目标体重</text>
            <text class="cs-val orange">{{ mockUser.targetWeight }} kg</text>
          </view>
          <view class="cc-stat">
            <text class="cs-label">距目标</text>
            <text class="cs-val green">{{ (mockUser.currentWeight - mockUser.targetWeight).toFixed(1) }} kg</text>
          </view>
          <view class="cc-stat">
            <text class="cs-label">BMI</text>
            <text class="cs-val">{{ bmi }}</text>
          </view>
        </view>
      </view>

      <!-- 体重趋势图 -->
      <view class="chart-card">
        <text class="chart-title">近7天趋势</text>
        <view class="mini-chart">
          <view v-for="(d, i) in mockWeekData" :key="i" class="mc-col">
            <text class="mc-num">{{ d.weight }}</text>
            <view class="mc-bar-wrap">
              <view class="mc-bar" :style="{ height: barH(d.weight) + 'rpx' }"></view>
            </view>
            <text class="mc-date">{{ d.date.split('/')[1] }}日</text>
          </view>
        </view>
      </view>

      <!-- 历史记录 -->
      <view class="section-head">
        <text class="section-ttl">历史记录</text>
      </view>
      <view class="record-card">
        <view v-for="(r, i) in mockWeightRecords" :key="i" class="record-row">
          <view class="rr-left">
            <text class="rr-date">{{ r.date }}</text>
            <text class="rr-change" :class="i < mockWeightRecords.length - 1 ? (r.weight < mockWeightRecords[i+1].weight ? 'green' : 'red') : ''">{{ weightChange(i) }}</text>
          </view>
          <text class="rr-weight">{{ r.weight }} kg</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 添加体重弹窗 -->
    <view v-if="showAddPopup" class="overlay" @click="showAddPopup = false">
      <view class="bottom-sheet" @click.stop>
        <view class="sheet-handle"></view>
        <view class="sheet-head">
          <text class="sheet-title">记录今日体重</text>
          <text class="sheet-close" @click="showAddPopup = false">✕</text>
        </view>
        <view class="sheet-body">
          <view class="weight-input-wrap">
            <input v-model="newWeight" class="weight-input" type="digit" placeholder="请输入体重" />
            <text class="weight-input-unit">kg</text>
          </view>
          <text class="weight-today">今天 {{ todayStr }}</text>
        </view>
        <view class="sheet-footer">
          <view class="sheet-btn" @click="confirmAdd"><text>确认记录</text></view>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { mockUser, mockWeekData, mockWeightRecords } from '../../utils/mock'

export default defineComponent({
  name: 'Weight',
  data() {
    return {
      mockUser,
      mockWeekData,
      mockWeightRecords,
      showAddPopup: false,
      newWeight: '',
      todayStr: new Date().toLocaleDateString('zh-CN'),
    }
  },
  computed: {
    bmi(): string {
      const h = mockUser.height / 100
      return (mockUser.currentWeight / (h * h)).toFixed(1)
    },
  },
  methods: {
    barH(weight: number): number {
      const weights = this.mockWeekData.map(d => d.weight)
      const min = Math.min(...weights)
      const max = Math.max(...weights)
      return 30 + ((weight - min) / (max - min || 1)) * 80
    },
    weightChange(i: number): string {
      if (i >= this.mockWeightRecords.length - 1) return ''
      const diff = this.mockWeightRecords[i].weight - this.mockWeightRecords[i + 1].weight
      return diff > 0 ? `+${diff.toFixed(1)}` : diff.toFixed(1)
    },
    confirmAdd() {
      if (!this.newWeight) return
      uni.showToast({ title: '记录成功', icon: 'success' })
      this.showAddPopup = false
      this.newWeight = ''
    },
    goBack() { uni.navigateBack() },
  },
})
</script>

<style lang="scss" scoped>
$green: #79c791;
$orange: #ff9a3c;
$red: #ff5c5c;
$page-bg: #f4f6f9;
$card-bg: #fff;

.weight-page { display: flex; flex-direction: column; height: 100vh; background: $page-bg; }
.nav-bar { display: flex; align-items: center; justify-content: space-between; padding: 50rpx 24rpx 20rpx; background: $green; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; }
.back-ico { font-size: 44rpx; color: #fff; }
.nav-title { font-size: 34rpx; font-weight: 700; color: #fff; }
.add-btn { padding: 12rpx 28rpx; background: rgba(255,255,255,0.2); border-radius: 32rpx; }
.add-txt { font-size: 26rpx; color: #fff; }
.scroll-content { flex: 1; }

.current-card {
  margin: 24rpx 24rpx 0;
  background: linear-gradient(135deg, #79c791, #5ba86d);
  border-radius: 24rpx; padding: 32rpx;
  display: flex; align-items: center;
}
.cc-left { display: flex; align-items: baseline; margin-right: 24rpx; }
.cc-big { font-size: 80rpx; font-weight: 700; color: #fff; }
.cc-unit { font-size: 28rpx; color: rgba(255,255,255,0.8); margin-left: 8rpx; }
.cc-right { flex: 1; display: flex; flex-direction: column; }
.cc-stat + .cc-stat { margin-top: 12rpx; }
.cc-stat { display: flex; justify-content: space-between; }
.cs-label { font-size: 22rpx; color: rgba(255,255,255,0.7); }
.cs-val { font-size: 24rpx; color: #fff; font-weight: 600; }
.cs-val.orange { color: #ffd166; }
.cs-val.green { color: #c8f0d4; }

.chart-card { margin: 16rpx 24rpx 0; background: $card-bg; border-radius: 20rpx; padding: 24rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.05); }
.chart-title { font-size: 28rpx; font-weight: 700; color: #1a1a2e; margin-bottom: 20rpx; display: block; }
.mini-chart { display: flex; align-items: flex-end; justify-content: space-between; height: 160rpx; }
.mc-col { display: flex; flex-direction: column; align-items: center; flex: 1; }
.mc-num { font-size: 18rpx; color: #aaa; }
.mc-bar-wrap { flex: 1; display: flex; align-items: flex-end; margin-top: 6rpx; }
.mc-bar { width: 24rpx; background: linear-gradient(180deg, $green, #a8d9b0); border-radius: 4rpx; min-height: 20rpx; }
.mc-date { font-size: 18rpx; color: #bbb; margin-top: 6rpx; }

.section-head { padding: 28rpx 32rpx 12rpx; }
.section-ttl { font-size: 30rpx; font-weight: 700; color: #1a1a2e; }

.record-card { margin: 0 24rpx; background: $card-bg; border-radius: 20rpx; overflow: hidden; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.05); }
.record-row { display: flex; align-items: center; justify-content: space-between; padding: 24rpx; border-bottom: 1rpx solid #f5f5f5; }
.record-row:last-child { border-bottom: none; }
.rr-left { display: flex; flex-direction: column; }
.rr-date { font-size: 26rpx; color: #333; }
.rr-change { font-size: 20rpx; color: #aaa; margin-top: 4rpx; }
.rr-change.green { color: $green; }
.rr-change.red { color: $red; }
.rr-weight { font-size: 32rpx; font-weight: 700; color: #1a1a2e; }

.safe-bottom { height: 60rpx; }
.overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.45); z-index: 100; display: flex; align-items: flex-end; }
.bottom-sheet { width: 100%; background: #fff; border-radius: 32rpx 32rpx 0 0; padding-bottom: 40rpx; }
.sheet-handle { width: 72rpx; height: 8rpx; border-radius: 4rpx; background: #ddd; margin: 16rpx auto 0; }
.sheet-head { display: flex; align-items: center; justify-content: space-between; padding: 24rpx 32rpx 16rpx; border-bottom: 1rpx solid #f0f0f0; }
.sheet-title { font-size: 32rpx; font-weight: 700; color: #1a1a2e; }
.sheet-close { font-size: 32rpx; color: #aaa; }
.sheet-body { padding: 32rpx; }
.sheet-footer { padding: 0 32rpx; }
.sheet-btn { background: $green; border-radius: 12rpx; padding: 24rpx; text-align: center; color: #fff; font-size: 28rpx; font-weight: 600; }
.weight-input-wrap { display: flex; align-items: baseline; border-bottom: 2rpx solid $green; padding-bottom: 12rpx; margin-bottom: 16rpx; }
.weight-input { flex: 1; font-size: 56rpx; font-weight: 700; color: #1a1a2e; }
.weight-input-unit { font-size: 28rpx; color: #aaa; margin-left: 12rpx; }
.weight-today { font-size: 24rpx; color: #aaa; display: block; text-align: center; }
</style>
