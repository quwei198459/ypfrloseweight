import { computed, onUnmounted, ref } from 'vue'
import { resolveUserId } from '@/config/api'
import {
  createDefaultPhotographMock,
  MEAL_TYPE_LABEL,
} from '@/mocks/photographFlow.mock'
import type { MealTypeKey, PhotographMockFood, PhotographMockResult, PhotographPhase } from '@/types/photograph'
import { confirmMealPhoto, submitMealPhoto, type MealPhotoFoodItemVo } from '@/api/recognize'
import { formatLocalDate } from '@/utils/date'
import { readLocalFileAsBase64 } from '@/utils/file'

/** 设为 true 时不调后端，仅用本地动画 mock（联调请保持 false） */
const USE_MOCK_PIPELINE = import.meta.env.VITE_PHOTOGRAPH_USE_MOCK === 'true'

const PHASE_DELAYS_MS = {
  uploading: 700,
  recognizing_type: 650,
  recognizing_weight: 700,
} as const

const MEAL_KEYS: MealTypeKey[] = ['breakfast', 'lunch', 'dinner', 'snack']

function isMealTypeKey(s: string): s is MealTypeKey {
  return MEAL_KEYS.includes(s as MealTypeKey)
}

function sumFoodCalories(foods: PhotographMockFood[]): number {
  return foods.reduce((a, f) => a + (Number(f.calories) || 0), 0)
}

/** 用户改「总热量」时按原比例分摊到各行 */
function redistributeCalories(foods: PhotographMockFood[], newTotal: number): PhotographMockFood[] {
  if (foods.length === 0) {
    return [
      {
        lineId: '1',
        foodName: '食物',
        calories: Math.max(0, Math.round(newTotal)),
        giLabel: '低 GI',
      },
    ]
  }
  if (foods.length === 1) {
    return [{ ...foods[0], calories: Math.max(0, Math.round(newTotal)) }]
  }
  const oldSum = sumFoodCalories(foods)
  if (oldSum <= 0) {
    const per = Math.max(0, Math.round(newTotal / foods.length))
    return foods.map((f, i) => ({
      ...f,
      calories: i === 0 ? Math.max(0, Math.round(newTotal - per * (foods.length - 1))) : per,
    }))
  }
  const factor = newTotal / oldSum
  const next = foods.map((f) => ({
    ...f,
    calories: Math.max(0, Math.round(f.calories * factor)),
  }))
  const drift = Math.round(newTotal) - sumFoodCalories(next)
  if (drift !== 0 && next[0]) {
    next[0] = { ...next[0], calories: Math.max(0, next[0].calories + drift) }
  }
  return next
}

function mapApiFood(f: MealPhotoFoodItemVo, index: number): PhotographMockFood {
  return {
    lineId: String(f.lineId ?? String(index + 1)),
    foodName: f.foodName || '识别食物',
    calories: Math.max(0, Math.round(Number(f.calories) || 0)),
    giLabel: f.giLabel || '低 GI',
    foodId: f.foodId,
  }
}

function applyRecognizeSuccess(res: {
  foods?: MealPhotoFoodItemVo[] | null
  recommendedEatRatio?: number | null
  intakeCaloriesToday?: number | null
  dailyBudgetCalories?: number | null
  badgeProgressPercent?: number | null
  totalRecognizedCalories?: number | null
  recommendedMealType?: string | null
}): PhotographMockResult {
  const raw = res.foods && res.foods.length > 0 ? res.foods.map(mapApiFood) : []
  const foods =
    raw.length > 0
      ? raw
      : [
          {
            lineId: '1',
            foodName: '识别食物',
            calories: Math.max(0, Math.round(Number(res.totalRecognizedCalories) || 0)),
            giLabel: '低 GI',
          },
        ]
  const total =
    res.totalRecognizedCalories != null
      ? Math.max(0, Math.round(res.totalRecognizedCalories))
      : sumFoodCalories(foods)
  const adjusted =
    foods.length === 1 ? [{ ...foods[0], calories: total }] : redistributeCalories(foods, total)

  return {
    foods: adjusted,
    recommendedEatRatio: res.recommendedEatRatio ?? 1,
    intakeCaloriesToday: res.intakeCaloriesToday ?? 0,
    dailyBudgetCalories: res.dailyBudgetCalories ?? 0,
    badgeProgressPercent: res.badgeProgressPercent ?? 0,
  }
}

export type PhotographPickImageOptions = {
  /** 仅开发：走本地失败动画，不调接口 */
  failDemo?: boolean
  /** 选图来源，上报后端 source 字段 */
  source?: 'camera' | 'album'
}

export function usePhotographFlow() {
  const phase = ref<PhotographPhase>('idle')
  const previewSrc = ref('')
  const selectedMealType = ref<MealTypeKey>('dinner')
  const mockResult = ref<PhotographMockResult>(createDefaultPhotographMock())
  /** 当前识图任务 id，确认写库必填 */
  const photoJobId = ref<number | null>(null)
  const recordDateStr = ref(formatLocalDate(new Date()))
  /** 卡片展示总热量（与多食物分摊后一致） */
  const displayCalories = ref(sumFoodCalories(createDefaultPhotographMock().foods))
  const calorieDraft = ref(String(displayCalories.value))
  const ratioPercent = ref(100)

  const timers: ReturnType<typeof setTimeout>[] = []

  function clearTimers() {
    while (timers.length) {
      const t = timers.pop()
      if (t !== undefined) clearTimeout(t)
    }
  }

  function after(ms: number, fn: () => void) {
    const id = setTimeout(fn, ms)
    timers.push(id)
  }

  const mealLabel = computed(() => MEAL_TYPE_LABEL[selectedMealType.value])

  const processingFillPercent = computed(() => {
    switch (phase.value) {
      case 'uploading':
        return 28
      case 'recognizing_type':
        return 55
      case 'recognizing_weight':
        return 88
      default:
        return 0
    }
  })

  const processingLabel = computed(() => {
    switch (phase.value) {
      case 'uploading':
        return '正在上传图片'
      case 'recognizing_type':
        return '正在识别食物种类'
      case 'recognizing_weight':
        return '正在识别每种食物重量'
      default:
        return ''
    }
  })

  const recommendedPercentLabel = computed(() => {
    const p = Math.round(mockResult.value.recommendedEatRatio * 100)
    return `${p}%`
  })

  const totalStripText = computed(() => {
    return `总热量 ${displayCalories.value} 千卡，推荐吃 ${recommendedPercentLabel.value}`
  })

  const ratioKcalText = computed(() => {
    const a = mockResult.value.intakeCaloriesToday
    const b = mockResult.value.dailyBudgetCalories
    return `${a} / ${b} 千卡`
  })

  const sheetDisplayedCalories = computed(() => {
    const base = displayCalories.value
    return Math.max(0, Math.round((base * ratioPercent.value) / 100))
  })

  const isProcessing = computed(
    () =>
      phase.value === 'uploading' ||
      phase.value === 'recognizing_type' ||
      phase.value === 'recognizing_weight',
  )

  function resetToIdle() {
    clearTimers()
    phase.value = 'idle'
    previewSrc.value = ''
    photoJobId.value = null
    mockResult.value = createDefaultPhotographMock()
    displayCalories.value = sumFoodCalories(mockResult.value.foods)
    calorieDraft.value = String(displayCalories.value)
    ratioPercent.value = 100
  }

  function startMockSuccessPipeline(path: string) {
    clearTimers()
    previewSrc.value = path
    phase.value = 'uploading'
    after(PHASE_DELAYS_MS.uploading, () => {
      phase.value = 'recognizing_type'
    })
    after(
      PHASE_DELAYS_MS.uploading + PHASE_DELAYS_MS.recognizing_type,
      () => {
        phase.value = 'recognizing_weight'
      },
    )
    after(
      PHASE_DELAYS_MS.uploading +
        PHASE_DELAYS_MS.recognizing_type +
        PHASE_DELAYS_MS.recognizing_weight,
      () => {
        mockResult.value = createDefaultPhotographMock()
        displayCalories.value = sumFoodCalories(mockResult.value.foods)
        calorieDraft.value = String(displayCalories.value)
        photoJobId.value = null
        phase.value = 'success'
      },
    )
  }

  function startMockFailPipeline(path: string) {
    clearTimers()
    previewSrc.value = path
    phase.value = 'uploading'
    after(PHASE_DELAYS_MS.uploading, () => {
      phase.value = 'recognizing_type'
    })
    after(
      PHASE_DELAYS_MS.uploading + PHASE_DELAYS_MS.recognizing_type,
      () => {
        photoJobId.value = null
        phase.value = 'failed'
      },
    )
  }

  function runRealRecognize(path: string, source: 'camera' | 'album') {
    clearTimers()
    previewSrc.value = path
    recordDateStr.value = formatLocalDate(new Date())
    photoJobId.value = null
    phase.value = 'uploading'

    after(320, () => {
      void (async () => {
        phase.value = 'recognizing_type'
        try {
          const base64 = await readLocalFileAsBase64(path)
          phase.value = 'recognizing_weight'
          const res = await submitMealPhoto({
            userId: resolveUserId(),
            source,
            mealType: selectedMealType.value,
            recordDate: recordDateStr.value,
            imageBase64: base64,
          })
          photoJobId.value = res.photoJobId

          if (res.recognizeStatus === 'fail') {
            uni.showToast({
              title: res.errorMessage || '识图失败',
              icon: 'none',
              duration: 2500,
            })
            phase.value = 'failed'
            return
          }

          if (res.recognizeStatus !== 'success') {
            uni.showToast({ title: '识图未完成，请重试', icon: 'none' })
            phase.value = 'failed'
            return
          }

          mockResult.value = applyRecognizeSuccess(res)
          displayCalories.value = sumFoodCalories(mockResult.value.foods)
          calorieDraft.value = String(displayCalories.value)

          if (res.recommendedMealType && isMealTypeKey(res.recommendedMealType)) {
            selectedMealType.value = res.recommendedMealType
          }

          ratioPercent.value = Math.round((mockResult.value.recommendedEatRatio ?? 1) * 100)
          ratioPercent.value = Math.min(100, Math.max(0, ratioPercent.value))

          phase.value = 'success'
        } catch (e) {
          const msg = e instanceof Error ? e.message : '识图请求失败'
          uni.showToast({ title: msg, icon: 'none', duration: 2500 })
          phase.value = 'failed'
        }
      })()
    })
  }

  function handleImagePicked(path: string, options?: PhotographPickImageOptions) {
    if (!path) return
    const failDemo = options?.failDemo === true
    const source = options?.source ?? 'album'

    if (USE_MOCK_PIPELINE) {
      if (failDemo) startMockFailPipeline(path)
      else startMockSuccessPipeline(path)
      return
    }

    if (failDemo) {
      startMockFailPipeline(path)
      return
    }

    runRealRecognize(path, source)
  }

  function openMealDropdown() {
    if (phase.value === 'success') phase.value = 'mealtype_dropdown_open'
  }

  function closeMealDropdown() {
    if (phase.value === 'mealtype_dropdown_open') phase.value = 'success'
  }

  function selectMealType(key: MealTypeKey) {
    selectedMealType.value = key
    phase.value = 'success'
  }

  function openCalorieEdit() {
    if (phase.value === 'success' || phase.value === 'mealtype_dropdown_open') {
      calorieDraft.value = String(displayCalories.value)
      phase.value = 'editing_calorie'
    }
  }

  function confirmCalorieEdit() {
    const n = Number(calorieDraft.value)
    if (!Number.isFinite(n) || n <= 0) {
      uni.showToast({ title: '请输入有效热量', icon: 'none' })
      return
    }
    const nextFoods = redistributeCalories(mockResult.value.foods, Math.round(n))
    mockResult.value = { ...mockResult.value, foods: nextFoods }
    displayCalories.value = sumFoodCalories(nextFoods)
    phase.value = 'success'
  }

  function cancelCalorieEdit() {
    phase.value = 'success'
  }

  function openRatioSheet() {
    if (phase.value === 'success') {
      ratioPercent.value = Math.round((mockResult.value.recommendedEatRatio ?? 1) * 100)
      ratioPercent.value = Math.min(100, Math.max(0, ratioPercent.value))
      phase.value = 'adjusting_ratio'
    }
  }

  function closeRatioSheet() {
    if (phase.value === 'adjusting_ratio') phase.value = 'success'
  }

  function goSavedThenDailyRecord() {
    if (USE_MOCK_PIPELINE) {
      uni.showToast({ title: 'Mock 模式未写库，仅跳转', icon: 'none', duration: 1800 })
      phase.value = 'saved'
      after(900, () => {
        uni.navigateTo({
          url: `/pages/daily-record/index?date=${encodeURIComponent(recordDateStr.value)}`,
        })
        resetToIdle()
      })
      return
    }

    if (!photoJobId.value) {
      uni.showToast({ title: '缺少识图任务，请重新拍照', icon: 'none' })
      return
    }
    if (ratioPercent.value <= 0) {
      uni.showToast({ title: '食用比例需大于 0', icon: 'none' })
      return
    }

    const ratioDec = Math.round(ratioPercent.value) / 100
    const items = mockResult.value.foods.map((f) => {
      const kcal = Math.round(f.calories * ratioDec * 100) / 100
      return {
        lineId: f.lineId,
        foodId: f.foodId,
        confirmedFoodName: f.foodName,
        confirmedCalories: Math.max(0.01, kcal),
        confirmedEatRatio: ratioDec,
      }
    })

    void (async () => {
      uni.showLoading({ title: '写入中', mask: true })
      try {
        await confirmMealPhoto({
          userId: resolveUserId(),
          photoJobId: photoJobId.value!,
          confirmedMealType: selectedMealType.value,
          recordDate: recordDateStr.value,
          items,
        })
        uni.hideLoading()
        phase.value = 'saved'
        after(900, () => {
          uni.navigateTo({
            url: `/pages/daily-record/index?date=${encodeURIComponent(recordDateStr.value)}`,
          })
          resetToIdle()
        })
      } catch (e) {
        uni.hideLoading()
        const msg = e instanceof Error ? e.message : '保存失败'
        uni.showToast({ title: msg, icon: 'none' })
      }
    })()
  }

  function onConfirmMain() {
    goSavedThenDailyRecord()
  }

  function onAddFromSheet() {
    goSavedThenDailyRecord()
  }

  function onContinuePhoto() {
    resetToIdle()
  }

  function onExitPhoto() {
    clearTimers()
    const stack = getCurrentPages()
    if (stack.length > 1) {
      uni.navigateBack({
        delta: 1,
        fail: () => {
          resetToIdle()
        },
      })
      return
    }
    // Tab 等入口无上一页时 navigateBack 无效，回到 idle 拍照态
    resetToIdle()
  }

  onUnmounted(() => {
    clearTimers()
  })

  return {
    phase,
    previewSrc,
    selectedMealType,
    mockResult,
    photoJobId,
    recordDateStr,
    displayCalories,
    calorieDraft,
    ratioPercent,
    mealLabel,
    processingFillPercent,
    processingLabel,
    recommendedPercentLabel,
    totalStripText,
    ratioKcalText,
    sheetDisplayedCalories,
    isProcessing,
    handleImagePicked,
    openMealDropdown,
    closeMealDropdown,
    selectMealType,
    openCalorieEdit,
    confirmCalorieEdit,
    cancelCalorieEdit,
    openRatioSheet,
    closeRatioSheet,
    onConfirmMain,
    onAddFromSheet,
    onContinuePhoto,
    onExitPhoto,
    resetToIdle,
  }
}
