<template>
  <view class="page">
    <view class="calendar-section">
      <view class="date-row">
        <text class="date-text">{{ dateText }}</text>
        <view class="legend">
          <view class="legend-dot" />
          <text class="legend-text">已记录饮食</text>
        </view>
      </view>
      <!-- 横向日期条：固定 scroll-view 高度 + 内层单行 flex，避免小程序里子 view 块级纵向堆叠 -->
      <scroll-view
        class="date-strip-scroll"
        scroll-x
        :scroll-into-view="calendarScrollIntoView"
        scroll-with-animation
        :show-scrollbar="false"
      >
        <view class="date-strip-row">
          <view
            v-for="it in dayStripItems"
            :key="it.fullDate"
            :id="'d' + it.fullDate.replace(/-/g, '')"
            class="date-cell"
            @tap.stop="onPickDate(it.fullDate)"
          >
            <text class="cell-week">{{ it.weekLabel }}</text>
            <view class="day-mark">
              <view v-if="it.isSelected" class="today-pill">
                <text class="today-text">{{ it.isToday ? '今' : String(it.day) }}</text>
              </view>
              <view v-else-if="it.isToday" class="today-pill today-pill--outline">
                <text class="today-text today-text--outline">今</text>
              </view>
              <text v-else class="date-num">{{ it.day }}</text>
            </view>
          </view>
        </view>
      </scroll-view>
    </view>

    <nutrition-summary-card
      :remaining-calories="remainingCalories"
      :target-calories="dailyTargetCalories"
      :intake-calories="dailyIntakeCalories"
      :sport-calories="dailySportCalories"
      :macros="dailyMacros"
    />

    <view class="timeline-section">
      <text class="section-title">今日记录</text>
      <view v-if="timelineItems.length === 0" class="timeline-empty">
        <text class="timeline-empty-text">没有记录饮食哦～</text>
      </view>
      <view v-else class="timeline-list">
        <view
          v-for="(it, idx) in timelineItems"
          :key="selectedDateYmd + '_' + it.kind + '_' + it.id + '_' + idx"
          class="timeline-row"
          :class="{ 'is-last': idx === timelineItems.length - 1 }"
        >
          <view v-if="idx !== timelineItems.length - 1" class="timeline-connector" />
          <view class="timeline-rail">
            <view class="rail-dot" />
          </view>
          <view class="timeline-main">
            <timeline-record-group
              :type="it.kind"
              :title="it.headerTitle"
              :time="it.timeText"
              :sport-name="it.sportName"
              :sport-detail="it.sportDetail"
              :meal-title="it.mealTitle"
              :meal-calories="it.mealCalories"
              :food-name="it.foodName"
              :food-amount="it.foodAmount"
              :food-calories="it.foodCalories"
            />
          </view>
        </view>
      </view>
    </view>

    <meal-quick-bar
      :checked-keys="['snack', 'sport']"
      :active-meal-key="mealBarActiveKey"
      @click="onQuickClick"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, nextTick, ref } from 'vue'
import { onLoad, onReady, onShow } from '@dcloudio/uni-app'
import { fetchDashboard, fetchDailyRecord } from '@/api/loseweight'
import {
  addDaysToYmd,
  enumerateYmdRange,
  formatLocalDate,
  parseLocalYmd,
} from '@/utils/date'
import type { DailyMacroDto } from '@/api/types'

const MEAL_ICON_STORAGE = 'ypfw_meal_icon_active'

const WEEK_LABELS = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']

const mealBarActiveKey = ref<string | null>(null)

function syncMealBarHighlight() {
  const v = uni.getStorageSync(MEAL_ICON_STORAGE)
  mealBarActiveKey.value = typeof v === 'string' && v.length > 0 ? v : null
}

type DayStripItem = {
  fullDate: string
  day: number
  weekLabel: string
  monthDay: string
  isToday: boolean
  isSelected: boolean
}

const autoNavDone = ref(false)
const pendingMealType = ref<string | undefined>(undefined)

type TimelineItem = {
  kind: 'meal' | 'sport'
  id: number
  headerTitle: string
  timeText: string
  sportName?: string
  sportDetail?: string
  mealTitle?: string
  mealCalories?: string
  foodName?: string
  foodAmount?: string
  foodCalories?: string
}

const selectedDateYmd = ref(formatLocalDate(new Date()))
const calendarScrollIntoView = ref('')

const dateText = computed(() => {
  const [y, m, d] = selectedDateYmd.value.split('-').map(Number)
  const dt = new Date(y, m - 1, d)
  const week = WEEK_LABELS[dt.getDay()]
  return `${y}年${m}月${d}日 ${week}`
})

/** 顶部横向日期条：以「今天」为中心 ±120 天，选中日期落在范围外时自动扩窗 */
function stripRange(todayYmd: string, selectedYmd: string): { start: string; end: string } {
  let start = addDaysToYmd(todayYmd, -120)
  let end = addDaysToYmd(todayYmd, 120)
  if (selectedYmd < start) start = addDaysToYmd(selectedYmd, -30)
  if (selectedYmd > end) end = addDaysToYmd(selectedYmd, 30)
  return { start, end }
}

const dayStripItems = computed((): DayStripItem[] => {
  const todayYmd = formatLocalDate(new Date())
  const sel = selectedDateYmd.value
  const { start, end } = stripRange(todayYmd, sel)
  return enumerateYmdRange(start, end).map((fullDate) => {
    const dt = parseLocalYmd(fullDate)
    const day = dt.getDate()
    const mo = dt.getMonth() + 1
    return {
      fullDate,
      day,
      weekLabel: WEEK_LABELS[dt.getDay()],
      monthDay: `${String(mo).padStart(2, '0')}.${String(day).padStart(2, '0')}`,
      isToday: fullDate === todayYmd,
      isSelected: fullDate === sel,
    }
  })
})

/**
 * 仅用于页面首次就绪时做一次初始定位（例如 deep link 带 date）。
 * 不要在用户点击切换日期或 onShow 时调用：scroll-into-view 在微信端会把子节点对齐到滚动区域起始侧，
 * 造成「每次点击都跳到最左边」的跳动。
 */
function scrollCalendarStripInitialIntoView() {
  const id = 'd' + selectedDateYmd.value.replace(/-/g, '')
  nextTick(() => {
    calendarScrollIntoView.value = id
    nextTick(() => {
      calendarScrollIntoView.value = ''
    })
  })
}

// 预算与营养：初始为 0，由接口填充
const remainingCalories = ref(0)
const dailyTargetCalories = ref(0)
const dailyIntakeCalories = ref(0)
const dailySportCalories = ref(0)
const dailyMacros = ref<DailyMacroDto>({
  carbsG: 0,
  fatG: 0,
  proteinG: 0,
  carbTargetG: 250,
  fatTargetG: 60,
  proteinTargetG: 90,
})

const timelineItems = ref<TimelineItem[]>([])

/** 快速切换日期时丢弃过期的 dashboard/daily-records 响应，避免旧数据覆盖新选中日期 */
let dietLoadSeq = 0

function toYmdFromQuery(q: unknown): string | null {
  if (typeof q !== 'string') return null
  const t = q.trim()
  if (!/^\d{4}-\d{2}-\d{2}$/.test(t)) return null
  return t
}

function timeTextFromRecordedAt(iso: string | null | undefined): string {
  if (!iso) return ''
  const t = iso.includes('T') ? iso.split('T')[1] : iso
  const m = /(\d{2}):(\d{2})/.exec(t)
  if (!m) return ''
  return `${m[1]}:${m[2]}分`
}

function mapTimelineItem(it: any): TimelineItem {
  if (it?.kind === 'sport') {
    const sportName = typeof it.title === 'string' ? it.title.split(' · ')[1] : ''
    return {
      kind: 'sport',
      id: Number(it.id ?? 0),
      headerTitle: '记录运动',
      timeText: timeTextFromRecordedAt(it.recordedAt),
      sportName: sportName || '',
      sportDetail: it.subtitle || '',
    }
  }

  const mealTitle = it?.title || ''
  const segs = typeof mealTitle === 'string' ? mealTitle.split(' · ') : []
  const mealKind = segs?.[0] || '饮食'
  const foodName = segs?.[1] || ''

  const subtitle: string = it?.subtitle || ''
  const subParts = subtitle ? subtitle.split(' · ') : []
  const foodAmount = subParts?.[0] || ''
  const foodCalories = subParts?.[1] || (it?.calories != null ? `${it.calories} 千卡` : '')

  const mealCalories = it?.calories != null ? `${it.calories} 千卡` : ''

  return {
    kind: 'meal',
    id: Number(it.id ?? 0),
    headerTitle: `记录${mealKind}`,
    timeText: timeTextFromRecordedAt(it.recordedAt),
    mealTitle: mealTitle,
    mealCalories: mealCalories,
    foodName: foodName,
    foodAmount: foodAmount,
    foodCalories: foodCalories,
  }
}

/**
 * 按指定日期拉取 dashboard + daily-records（时间线内已含餐/运动聚合，本页不单独调 meal-records GET）
 * @param date yyyy-MM-dd，须与当前要展示的日期一致
 */
async function refreshDailyDietPage(date: string) {
  const seq = ++dietLoadSeq
  try {
    const [dash, daily] = await Promise.all([fetchDashboard(date), fetchDailyRecord(date)])
    if (seq !== dietLoadSeq) return

    remainingCalories.value = dash.remainingCalories
    dailyTargetCalories.value = dash.dailyBudget
    dailyIntakeCalories.value = dash.intakeCalories
    dailySportCalories.value = dash.sportCalories

    const m = daily?.macros
    if (m) {
      dailyMacros.value = {
        carbsG: Number(m.carbsG) || 0,
        fatG: Number(m.fatG) || 0,
        proteinG: Number(m.proteinG) || 0,
        carbTargetG:
          m.carbTargetG != null && Number(m.carbTargetG) > 0
            ? Number(m.carbTargetG)
            : 250,
        fatTargetG:
          m.fatTargetG != null && Number(m.fatTargetG) > 0
            ? Number(m.fatTargetG)
            : 60,
        proteinTargetG:
          m.proteinTargetG != null && Number(m.proteinTargetG) > 0
            ? Number(m.proteinTargetG)
            : 90,
      }
    } else {
      dailyMacros.value = {
        carbsG: 0,
        fatG: 0,
        proteinG: 0,
        carbTargetG: 250,
        fatTargetG: 60,
        proteinTargetG: 90,
      }
    }

    const timeline = Array.isArray(daily?.timeline) ? daily.timeline : []
    timelineItems.value = timeline.map((x) => mapTimelineItem(x))
  } catch (e: unknown) {
    if (seq !== dietLoadSeq) return
    const msg = e instanceof Error ? e.message : '加载失败，请稍后重试'
    uni.showToast({ title: msg, icon: 'none' })
  }
}

function onPickDate(ymd: string) {
  if (ymd === selectedDateYmd.value) return
  selectedDateYmd.value = ymd
  void refreshDailyDietPage(ymd)
  /* 不滚动日期条：保持用户当前横向滑动位置，仅更新选中态与数据 */
}

onLoad((query) => {
  // 如果从首页进入这里，并带有 mealType，则自动进入食物搜索页
  const mt = query?.mealType as string | undefined
  const qDate = toYmdFromQuery(query?.date)
  if (qDate) selectedDateYmd.value = qDate

  if (!mt || autoNavDone.value) {
    return
  }
  pendingMealType.value = mt
})

onReady(() => {
  scrollCalendarStripInitialIntoView()

  if (!pendingMealType.value || autoNavDone.value) return
  autoNavDone.value = true

  // 避免“首次页面切换尚未完成就再次 navigateTo”导致超时
  setTimeout(() => {
    uni.navigateTo({
      url: `/pages/food-search/index?mealType=${encodeURIComponent(pendingMealType.value as string)}`,
    })
  }, 100)
})

/** 返回本页时按当前选中日期重新拉数；与后端 daily_summary 写入对齐 */
onShow(() => {
  void refreshDailyDietPage(selectedDateYmd.value)
  syncMealBarHighlight()
  /* 不触发日期条 scroll-into-view，避免从子页返回时横向位置被重置到最左侧 */
})

const onQuickClick = (key: string) => {
  uni.setStorageSync(MEAL_ICON_STORAGE, key)
  mealBarActiveKey.value = key
  if (key === 'sport') {
    uni.navigateTo({ url: '/pages/sport-search/index' })
  } else {
    uni.navigateTo({ url: `/pages/food-search/index?mealType=${key}` })
  }
}
</script>

<style scoped lang="scss">
.page {
  min-height: 100vh;
  background: #f7fbf7;
  padding: 16px 16px 90px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.calendar-section {
  border-radius: 16px;
  background: #ffffff;
  padding: 10px 12px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.date-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.date-text {
  font-size: 13px;
  color: #222222;
}

.legend {
  display: flex;
  align-items: center;
  gap: 6px;
}

.legend-dot {
  width: 8px;
  height: 8px;
  border-radius: 4px;
  background: #9ebc86;
}

.legend-text {
  font-size: 10px;
  color: #777777;
}

/* scroll-x 区域必须限高，否则子节点块级堆叠时会把整段撑成「纵向长列表」 */
.date-strip-scroll {
  width: 100%;
  height: 64px;
  padding: 2px 0 4px;
  box-sizing: border-box;
}

/* 内层单行横向 flex：总宽大于屏宽即可横向拖动 */
.date-strip-row {
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  align-items: flex-end;
  justify-content: flex-start;
  width: max-content;
  min-height: 52px;
  box-sizing: border-box;
}

.date-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-end;
  flex-shrink: 0;
  flex-grow: 0;
  width: 44px;
  min-width: 44px;
  max-width: 44px;
  padding: 0 2px;
  box-sizing: border-box;
}

.cell-week {
  font-size: 11px;
  color: #777777;
  line-height: 1.2;
  margin-bottom: 6px;
}

.day-mark {
  min-height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.date-num {
  font-size: 14px;
  color: #222222;
}

.today-pill--outline {
  background: #ffffff !important;
  border: 2px solid #9ebc86;
  box-sizing: border-box;
}

.today-text--outline {
  color: #6f8a52 !important;
}

.today-pill {
  width: 28px;
  height: 28px;
  border-radius: 14px;
  background: #9ebc86;
  display: flex;
  align-items: center;
  justify-content: center;
}

.today-text {
  font-size: 13px;
  font-weight: 600;
  color: #ffffff;
}

.timeline-section {
  margin-top: 4px;
  border-radius: 24px;
  background: #ffffff;
  padding: 12px 16px 80px;
  box-sizing: border-box;
  flex: 1;
  margin-bottom: 16px;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #222222;
}

.timeline-list {
  margin-top: 8px;
  display: flex;
  flex-direction: column;
}

.timeline-row {
  position: relative;
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  gap: 8px;
  padding-bottom: 16px;
}

.timeline-row.is-last {
  padding-bottom: 0;
}

.timeline-connector {
  position: absolute;
  left: 15px;
  top: 14px;
  bottom: 0;
  width: 2px;
  background: #d5e7b1;
  z-index: 0;
}

.timeline-rail {
  width: 32px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.rail-dot {
  width: 10px;
  height: 10px;
  border-radius: 5px;
  background: #9ebc86;
  margin-top: 2px;
  position: relative;
  z-index: 1;
  flex-shrink: 0;
}

.timeline-main {
  flex: 1;
  min-width: 0;
}

.timeline-empty {
  margin-top: 24px;
  padding: 24px 8px;
  display: flex;
  justify-content: center;
}

.timeline-empty-text {
  font-size: 13px;
  color: #999999;
}
</style>

