<template>
  <view class="member-plan-selector">
    <view class="member-plan-selector__left">
      <MemberPlanCard
        v-if="lifetimePlan"
        variant="featured"
        :plan="lifetimePlan"
        :selected="isSelected(lifetimePlan.id)"
        @select="onSelect"
      />
    </view>
    <view class="member-plan-selector__right">
      <MemberPlanCard
        v-for="p in stackPlans"
        :key="p.id"
        variant="compact"
        :plan="p"
        :selected="isSelected(p.id)"
        @select="onSelect"
      />
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import MemberPlanCard from '@/components/member/MemberPlanCard.vue'

const props = defineProps({
  plans: {
    type: Array,
    default: () => [],
  },
})

const emit = defineEmits(['select'])

const lifetimePlan = computed(() => props.plans.find((p) => p.id === 'lifetime') || null)

const stackPlans = computed(() =>
  props.plans.filter((p) => p.id === 'quarter' || p.id === 'year'),
)

function isSelected(id) {
  const row = props.plans.find((p) => p.id === id)
  return !!(row && row.selected)
}

function onSelect(id) {
  emit('select', id)
}
</script>

<style lang="scss" scoped>
.member-plan-selector {
  display: flex;
  flex-direction: row;
  align-items: stretch;
  gap: 24rpx;
  width: 100%;
  box-sizing: border-box;
}

.member-plan-selector__left,
.member-plan-selector__right {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.member-plan-selector__right {
  gap: 32rpx;
}
</style>
