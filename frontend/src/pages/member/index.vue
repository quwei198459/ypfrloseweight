<template>
  <view class="member-page">
    <scroll-view class="scroll-container" scroll-y :show-scrollbar="false" :enable-back-to-top="true">
      <view class="scroll-container__inner">
        <view class="member-top-intro">
          <view class="member-top-intro__row">
            <view class="member-top-intro__text-block">
              <text class="member-top-intro__line1">你的减脂计划制作已完成</text>
              <text class="member-top-intro__line2">推荐开通永久会员，解锁全部能力</text>
            </view>
            <view class="member-top-intro__image-placeholder" />
          </view>
        </view>

        <view class="member-highlight-data">
          <view class="member-highlight-data__row">
            <view class="member-highlight-data__tag">
              <text class="member-highlight-data__tag-text">4周内减重15斤</text>
            </view>
            <view class="member-highlight-data__tag">
              <text class="member-highlight-data__tag-text">热量预算 1500 大卡</text>
            </view>
          </view>
          <view class="member-highlight-data__row">
            <view class="member-highlight-data__tag">
              <text class="member-highlight-data__tag-text">8+16 轻断食</text>
            </view>
          </view>
        </view>

        <view class="member-plan-block">
          <MemberPlanSelector :plans="planList" @select="onSelectPlan" />
          <text class="member-tip-text">不会自动续费，请放心购买~</text>
        </view>

        <MemberNoticeBar :text="noticeText" />

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

        <text class="support-contact-text">如遇到问题，请通过kf@small-circle.cn联系客服</text>
      </view>
    </scroll-view>

    <PaymentLoadingMask :visible="isPaying" />

    <MemberFixedBottomBar
      :agreement-checked="agreementChecked"
      @primary="onOpenVip"
      @toggle-agreement="onToggleAgreement"
    />
  </view>
</template>

<script setup>
import { ref, onUnmounted } from 'vue'
import MemberPlanSelector from '@/components/member/MemberPlanSelector.vue'
import MemberNoticeBar from '@/components/member/MemberNoticeBar.vue'
import MemberBenefitItem from '@/components/member/MemberBenefitItem.vue'
import PaymentLoadingMask from '@/components/member/PaymentLoadingMask.vue'
import MemberFixedBottomBar from '@/components/member/MemberFixedBottomBar.vue'

const planList = ref([
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
])

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

const noticeText = ref('旋***成为了年费会员')

const isPaying = ref(false)
const agreementChecked = ref(false)

let payTimer = null

function onSelectPlan(id) {
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
  isPaying.value = true
  if (payTimer) {
    clearTimeout(payTimer)
  }
  payTimer = setTimeout(() => {
    isPaying.value = false
    payTimer = null
  }, 2000)
}

onUnmounted(() => {
  if (payTimer) {
    clearTimeout(payTimer)
    payTimer = null
  }
})
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
  gap: 24rpx;
  padding: 24rpx 32rpx;
  padding-bottom: calc(280rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
}

.member-top-intro {
  background: #ffffff;
  border-radius: 40rpx;
  padding: 32rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
  box-sizing: border-box;
}

.member-top-intro__row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 24rpx;
}

.member-top-intro__text-block {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.member-top-intro__line1 {
  font-size: 30rpx;
  font-weight: 600;
  color: #333333;
  line-height: 1.4;
}

.member-top-intro__line2 {
  font-size: 24rpx;
  color: #888888;
  line-height: 1.45;
}

.member-top-intro__image-placeholder {
  flex-shrink: 0;
  width: 200rpx;
  height: 200rpx;
  border-radius: 32rpx;
  background: #fff3e0;
  border: 2rpx solid #e8dcc8;
}

.member-highlight-data {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
  width: 100%;
}

.member-highlight-data__row {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 24rpx;
}

.member-highlight-data__tag {
  padding: 20rpx 40rpx;
  background: #fff3d5;
  border-radius: 80rpx;
}

.member-highlight-data__tag-text {
  font-size: 24rpx;
  color: #5d4037;
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
  gap: 32rpx;
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
  gap: 32rpx;
}

.support-contact-text {
  display: block;
  width: 100%;
  font-size: 22rpx;
  color: #aaaaaa;
  text-align: center;
  line-height: 1.5;
  padding: 8rpx 0 32rpx;
}
</style>
