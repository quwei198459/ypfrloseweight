<template>
  <view class="page-root">
    <scroll-view
      class="scroll-area"
      scroll-y
      :show-scrollbar="false"
      :enable-back-to-top="true"
    >
      <view class="scroll-inner">
        <PlanSummaryCard
          :duration="planData.duration"
          :start-weight="planData.startWeight"
          :target-weight="planData.targetWeight"
          :weekly-loss="planData.weeklyLoss"
        />
        <PlanBmiCard
          :bmi-value="planData.bmi"
          :bmi-level="planData.bmiLevel"
          :bmi-description="planData.bmiDescription"
        />
        <PlanProgressCard
          :plan-weeks="planData.planWeeks"
          :total-loss="planData.totalLoss"
          :social-proof-percent="planData.socialProofPercent"
          :section-title="planData.progressSectionTitle"
          :milestones="planData.weightMilestones"
          :timeline-start-label="planData.timelineStartLabel"
          :timeline-end-label="planData.timelineEndLabel"
        />
        <PlanStrategyCard
          :calorie-label="planData.calorieLabel"
          :calorie-value="planData.calorieValue"
          :exercise-label="planData.exerciseLabel"
          :exercise-value="planData.exerciseValue"
          :diet-pattern-label="planData.dietPatternLabel"
          :diet-pattern-value="planData.dietPatternValue"
          :diet-recommend-label="planData.dietRecommendLabel"
          :diet-recommend-value="planData.dietRecommendValue"
        />
        <PlanUserCaseCard />
      </view>
    </scroll-view>

    <FixedBottomBar
      :slogan="planData.bottomSlogan"
      :button-text="planData.primaryButtonText"
      :show-vip="planData.showVipBadge"
      @primary="handleStartPlan"
    />
  </view>
</template>

<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import PlanSummaryCard from '@/components/plan/PlanSummaryCard.vue'
import PlanBmiCard from '@/components/plan/PlanBmiCard.vue'
import PlanProgressCard from '@/components/plan/PlanProgressCard.vue'
import PlanStrategyCard from '@/components/plan/PlanStrategyCard.vue'
import PlanUserCaseCard from '@/components/plan/PlanUserCaseCard.vue'
import FixedBottomBar from '@/components/plan/FixedBottomBar.vue'
import { PLAN_PAGE_FALLBACK } from '@/api/adapters/planPreview'
import { fetchPlanPageData } from '@/api/plan'

const planData = reactive({ ...PLAN_PAGE_FALLBACK })

onMounted(() => {
  void fetchPlanPageData()
    .then((d) => {
      Object.assign(planData, d)
    })
    .catch(() => {
      /* 保持 PLAN_PAGE_FALLBACK */
    })
})

function handleStartPlan() {
  uni.navigateTo({
    url: '/pages/member/index',
  })
}
</script>

<style scoped>
.page-root {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: #f0f7ed;
  box-sizing: border-box;
}

.scroll-area {
  flex: 1;
  min-height: 0;
  height: 0;
  box-sizing: border-box;
}

.scroll-inner {
  display: flex;
  flex-direction: column;
  gap: 40rpx;
  padding: 24rpx 32rpx;
  padding-bottom: calc(240rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
}
</style>
