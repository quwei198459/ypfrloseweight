<template>
  <view class="member-page">
    <scroll-view class="scroll-container" scroll-y :show-scrollbar="false" :enable-back-to-top="true">
      <view class="scroll-container__inner">
        <view class="member-hero-wrap">
          <image class="member-hero-img" :src="vipHeroSrc" mode="widthFix" />
        </view>

        <view class="member-plan-block">
          <MemberPlanSelector :plans="planList" @select="onSelectPlan" />
          <text class="member-tip-text">不会自动续费，请放心购买~</text>
        </view>

        <MemberNoticeBar :lines="noticeLines" />

        <view class="member-benefits-section">
          <view class="member-benefits-section__header">
            <text class="member-benefits-section__dash">──</text>
            <text class="member-benefits-section__title">会员特权</text>
            <text class="member-benefits-section__dash">──</text>
          </view>
          <view class="member-benefits-section__list">
            <MemberBenefitItem
              v-for="item in benefitList"
              :key="item.id"
              :title="item.title"
              :desc="item.desc"
              :icon="item.icon || ''"
            />
          </view>
        </view>
      </view>
    </scroll-view>

    <MemberFixedBottomBar
      :agreement-checked="agreementChecked"
      @primary="onOpenVip"
      @toggle-agreement="onToggleAgreement"
    />
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import MemberPlanSelector from '@/components/member/MemberPlanSelector.vue'
import MemberNoticeBar from '@/components/member/MemberNoticeBar.vue'
import MemberBenefitItem from '@/components/member/MemberBenefitItem.vue'
import MemberFixedBottomBar from '@/components/member/MemberFixedBottomBar.vue'
import { fetchVipProducts, type VipProductDto } from '@/api/vip'
import { buildMemberPurchaseNotices } from '@/constants/memberPurchaseNotices'
import vipHero from '@/static/member/vip-hero.png'

const vipHeroSrc = vipHero

const DEFAULT_PLANS = [
  {
    id: 'lifetime',
    title: '永久会员',
    desc: '一次买断，终生有效',
    price: 168,
    originPrice: 360,
    selected: true,
    tag: '92%人选择',
  },
  {
    id: 'quarter',
    title: '季度会员',
    desc: '',
    price: 48,
    originPrice: 75,
    selected: false,
    tag: '',
  },
  {
    id: 'year',
    title: '年费会员',
    desc: '',
    price: 148,
    originPrice: 198,
    selected: false,
    tag: '',
  },
]

const planList = ref([...DEFAULT_PLANS])

type PlanRow = (typeof DEFAULT_PLANS)[number]

function mergePlansFromApi(dtos: VipProductDto[]): PlanRow[] {
  const sel = planList.value.find((p) => p.selected)?.id ?? 'lifetime'
  const map = new Map(dtos.map((d) => [d.code, d]))
  const codes = ['lifetime', 'quarter', 'year'] as const
  const out: PlanRow[] = []
  for (const code of codes) {
    const d = map.get(code)
    const base = DEFAULT_PLANS.find((p) => p.id === code)
    if (!base) continue
    if (!d) {
      out.push({ ...base, selected: code === sel })
      continue
    }
    out.push({
      id: d.code,
      title: d.title,
      desc: d.subtitle ?? '',
      price: d.priceYuan,
      originPrice: d.originPriceYuan,
      selected: code === sel,
      tag: d.cornerTag ?? '',
    })
  }
  return out
}

const benefitList = ref([
  {
    id: 'photo',
    title: '拍照识别热量',
    desc: '每日免费20次，精准识别热量，免除手动录入的麻烦。',
    icon: '',
  },
  {
    id: 'plan',
    title: '专属饮食计划',
    desc: '基于减重目标，量身定制计划，定时提醒。',
    icon: '',
  },
  {
    id: 'recommend',
    title: '食谱推荐',
    desc: '根据你的热量预算和已摄入饮食，动态推荐食谱。',
    icon: '',
  },
  {
    id: 'analysis',
    title: '饮食建议分析',
    desc: '分析饮食营养分布，科学建议推荐食物和饮食方式。',
    icon: '',
  },
  {
    id: 'fasting',
    title: '轻断食提醒',
    desc: '8+16轻断食提醒，助你瘦的更快，更简单！',
    icon: '',
  },
])

const noticeLines = ref(buildMemberPurchaseNotices(50))

const agreementChecked = ref(false)

onMounted(() => {
  void fetchVipProducts()
    .then((list) => {
      if (list.length > 0) {
        planList.value = mergePlansFromApi(list)
      }
    })
    .catch(() => {
      /* 保持 DEFAULT */
    })
})

function onSelectPlan(id: string) {
  planList.value = planList.value.map((p) => ({
    ...p,
    selected: p.id === id,
  }))
}

function onToggleAgreement() {
  agreementChecked.value = !agreementChecked.value
}

function onOpenVip() {
  if (!agreementChecked.value) {
    uni.showToast({
      title: '请先阅读并同意会员服务协议',
      icon: 'none',
    })
    return
  }
  uni.showToast({
    title: '暂未开通',
    icon: 'none',
  })
}
</script>

<style lang="scss" scoped>
.member-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: #f5f7fa;
  box-sizing: border-box;
}

.scroll-container {
  flex: 1;
  min-height: 0;
  height: 0;
  box-sizing: border-box;
}

.scroll-container__inner {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  padding: 24rpx 32rpx;
  padding-bottom: calc(200rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
}

.member-hero-wrap {
  width: 100%;
  border-radius: 32rpx;
  overflow: hidden;
  background: #ffffff;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.member-hero-img {
  width: 100%;
  display: block;
}

.member-plan-block {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  width: 100%;
}

.member-tip-text {
  display: block;
  width: 100%;
  margin-top: 0;
  padding: 0 4rpx;
  font-size: 24rpx;
  color: #999999;
  line-height: 1.5;
  text-align: left;
  box-sizing: border-box;
}

.member-benefits-section {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  width: 100%;
}

.member-benefits-section__header {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 16rpx;
}

.member-benefits-section__title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333333;
}

.member-benefits-section__dash {
  font-size: 24rpx;
  color: #f3a73f;
}

.member-benefits-section__list {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
</style>
