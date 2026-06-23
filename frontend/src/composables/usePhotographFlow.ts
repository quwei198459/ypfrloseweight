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

/** 按当前时间推算默认餐次（与后端 MealRecommendedMealTypeUtil 口径一致），避免硬编码导致餐次与推荐语不符 */
function defaultMealByTime(): MealTypeKey {
  const h = new Date().getHours()
  if (h >= 5 && h < 10) return 'breakfast'
  if (h >= 10 && h < 14) return 'lunch'
  if (h >= 14 && h < 17) return 'snack'
  if (h >= 17 && h < 21) return 'dinner'
  return 'snack'
}

function roundKcal(n: number): number {
  return Math.max(0, Math.round(n))
}

function roundKcalForSubmit(n: number): number {
  return Math.round(Math.max(0, n) * 100) / 100
}

function normalizeRatioPercent(v: number): number {
  if (!Number.isFinite(v)) return 100
  return Math.min(100, Math.max(0, Math.round(v)))
}

function normalizeQuantity(v: number): number {
  if (!Number.isFinite(v) || v <= 0) return 100
  return Math.round(v * 10) / 10
}

function formatQuantityValue(v: number): string {
  const n = normalizeQuantity(v)
  return Number.isInteger(n) ? String(n) : String(n).replace(/\.0$/, '')
}

function getFoodActualQuantity(food: PhotographMockFood, ratioPercent: number): number {
  const quantity = normalizeQuantity(Number(food.quantity ?? 100))
  return Math.round(quantity * normalizeRatioPercent(ratioPercent)) / 100
}

function cleanGiLabel(v?: string | null): string {
  return typeof v === 'string' ? v.trim() : ''
}

function initRatioPercentMap(foods: PhotographMockFood[]): Record<string, number> {
  const map: Record<string, number> = {}
  for (const f of foods) {
    map[f.lineId] = 100
  }
  return map
}

function mapApiFood(f: MealPhotoFoodItemVo, index: number): PhotographMockFood {
  const caloriesPer100 = roundKcal(Number(f.caloriesPer100 ?? f.calories) || 0)
  const quantity = normalizeQuantity(Number(f.quantity ?? 100))
  return {
    lineId: String(f.lineId ?? String(index + 1)),
    foodName: f.foodName || '识别食物',
    calories: roundKcal((caloriesPer100 * quantity) / 100),
    caloriesPer100,
    quantity,
    quantityUnit: f.quantityUnit || 'g/ml',
    type: f.type,
    giLabel: cleanGiLabel(f.giLabel),
    gi: typeof f.gi === 'number' && Number.isFinite(f.gi) ? f.gi : undefined,
    foodId: f.foodId,
  }
}

function applyRecognizeSuccess(res: {
  foods?: MealPhotoFoodItemVo[] | null
  recommendedEatRatio?: number | null
  recommendText?: string | null
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
            calories: roundKcal(Number(res.totalRecognizedCalories) || 0),
            caloriesPer100: roundKcal(Number(res.totalRecognizedCalories) || 0),
            quantity: 100,
            quantityUnit: 'g/ml',
            type: 1,
            giLabel: '',
          },
        ]

  return {
    foods,
    recommendedEatRatio: res.recommendedEatRatio ?? 1,
    recommendText: res.recommendText ?? null,
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
  const selectedMealType = ref<MealTypeKey>(defaultMealByTime())
  /** 用户是否手动选过餐次：选过则不再被后端推荐餐次覆盖 */
  const mealTypeTouched = ref(false)
  const mockResult = ref<PhotographMockResult>(createDefaultPhotographMock())
  /** 当前识图任务 id，确认写库必填 */
  const photoJobId = ref<number | null>(null)
  const recordDateStr = ref(formatLocalDate(new Date()))
  const ratioPercentMap = ref<Record<string, number>>(initRatioPercentMap(createDefaultPhotographMock().foods))
  const quantityDraft = ref('')
  const foodNameDraft = ref('')
  const editingFoodLineId = ref<string | null>(null)

  const editingFood = computed(() => {
    const lineId = editingFoodLineId.value
    return lineId ? mockResult.value.foods.find((f) => f.lineId === lineId) ?? null : null
  })

  const editingFoodEstimatedCalories = computed(() => {
    const food = editingFood.value
    if (!food) return 0
    const quantity = normalizeQuantity(Number(quantityDraft.value || food.quantity))
    const per100 = Number(food.caloriesPer100 ?? food.calories) || 0
    return roundKcal((per100 * quantity * getFoodRatioPercent(food.lineId)) / 100 / 100)
  })

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

  function getFoodRatioPercent(lineId: string): number {
    return normalizeRatioPercent(ratioPercentMap.value[lineId] ?? 100)
  }

  function getFoodDisplayedCalories(food: PhotographMockFood): number {
    const per100 = Number(food.caloriesPer100 ?? food.calories) || 0
    const actualQuantity = getFoodActualQuantity(food, getFoodRatioPercent(food.lineId))
    return roundKcal((per100 * actualQuantity) / 100)
  }

  function getFoodQuantityLabel(food: PhotographMockFood): string {
    const actualQuantity = getFoodActualQuantity(food, getFoodRatioPercent(food.lineId))
    return `${formatQuantityValue(actualQuantity)} ${food.quantityUnit || 'g/ml'}`
  }

  function syncFoods(nextFoods: PhotographMockFood[]) {
    mockResult.value = { ...mockResult.value, foods: nextFoods }
    const nextRatios: Record<string, number> = {}
    for (const f of nextFoods) {
      nextRatios[f.lineId] = getFoodRatioPercent(f.lineId)
    }
    ratioPercentMap.value = nextRatios
  }

  function applyFoodsFromRecognize(next: PhotographMockResult) {
    mockResult.value = next
    ratioPercentMap.value = initRatioPercentMap(next.foods)
    quantityDraft.value = ''
    foodNameDraft.value = ''
    editingFoodLineId.value = null
  }

  const displayCalories = computed(() => {
    return mockResult.value.foods.reduce((total, f) => total + getFoodDisplayedCalories(f), 0)
  })

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
    const tip = mockResult.value.recommendText
    if (tip && tip.trim()) {
      return `总热量 ${displayCalories.value} 千卡 · ${tip.trim()}`
    }
    return `总热量 ${displayCalories.value} 千卡，推荐吃 ${recommendedPercentLabel.value}`
  })

  const ratioSummaryText = computed(() => {
    return `本次预计摄入 ${displayCalories.value} 千卡`
  })

  const isProcessing = computed(
    () =>
      phase.value === 'uploading' ||
      phase.value === 'recognizing_type' ||
      phase.value === 'recognizing_weight',
  )

  function resetToIdle() {
    clearTimers()
    const next = createDefaultPhotographMock()
    phase.value = 'idle'
    previewSrc.value = ''
    photoJobId.value = null
    mockResult.value = next
    ratioPercentMap.value = initRatioPercentMap(next.foods)
    quantityDraft.value = ''
    foodNameDraft.value = ''
    editingFoodLineId.value = null
    selectedMealType.value = defaultMealByTime()
    mealTypeTouched.value = false
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
        applyFoodsFromRecognize(createDefaultPhotographMock())
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

          applyFoodsFromRecognize(applyRecognizeSuccess(res))

          // 仅当用户未手动选餐次时，用后端按拍照时间推算的餐次纠正显示；用户已选则尊重其选择
          if (!mealTypeTouched.value && res.recommendedMealType && isMealTypeKey(res.recommendedMealType)) {
            selectedMealType.value = res.recommendedMealType
          }

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
    mealTypeTouched.value = true
    phase.value = 'success'
  }

  function openCalorieEdit(lineId: string) {
    if (phase.value !== 'success' && phase.value !== 'mealtype_dropdown_open') return
    const food = mockResult.value.foods.find((f) => f.lineId === lineId)
    if (!food) return
    editingFoodLineId.value = lineId
    quantityDraft.value = formatQuantityValue(food.quantity)
    foodNameDraft.value = food.foodName
    phase.value = 'editing_calorie'
  }

  function confirmCalorieEdit() {
    const n = Number(quantityDraft.value)
    if (!Number.isFinite(n) || n <= 0) {
      uni.showToast({ title: '请输入有效数量', icon: 'none' })
      return
    }
    const name = foodNameDraft.value.trim()
    if (!name) {
      uni.showToast({ title: '请输入食物名称', icon: 'none' })
      return
    }
    const lineId = editingFoodLineId.value
    if (!lineId) {
      phase.value = 'success'
      return
    }
    const nextFoods = mockResult.value.foods.map((f) => {
      if (f.lineId !== lineId) return f
      const quantity = normalizeQuantity(n)
      return {
        ...f,
        foodName: name.slice(0, 40),
        quantity,
        calories: roundKcal(((Number(f.caloriesPer100 ?? f.calories) || 0) * quantity) / 100),
      }
    })
    syncFoods(nextFoods)
    editingFoodLineId.value = null
    quantityDraft.value = ''
    foodNameDraft.value = ''
    phase.value = 'success'
  }

  function cancelCalorieEdit() {
    editingFoodLineId.value = null
    quantityDraft.value = ''
    foodNameDraft.value = ''
    phase.value = 'success'
  }

  function deleteFood(lineId: string) {
    const nextFoods = mockResult.value.foods.filter((f) => f.lineId !== lineId)
    syncFoods(nextFoods)
  }

  function setFoodRatioPercent(lineId: string, percent: number) {
    if (!mockResult.value.foods.some((f) => f.lineId === lineId)) return
    ratioPercentMap.value = {
      ...ratioPercentMap.value,
      [lineId]: normalizeRatioPercent(percent),
    }
  }

  function openRatioSheet() {
    if (phase.value === 'success') {
      phase.value = 'adjusting_ratio'
    }
  }

  function closeRatioSheet() {
    if (phase.value === 'adjusting_ratio') phase.value = 'success'
  }

  function buildConfirmItems() {
    return mockResult.value.foods
      .map((f) => {
        const ratioPercent = getFoodRatioPercent(f.lineId)
        const ratioDec = ratioPercent / 100
        const actualQuantity = getFoodActualQuantity(f, ratioPercent)
        const per100 = Number(f.caloriesPer100 ?? f.calories) || 0
        const kcal = roundKcalForSubmit((per100 * actualQuantity) / 100)
        return {
          lineId: f.lineId,
          foodId: f.foodId,
          confirmedFoodName: f.foodName,
          confirmedCalories: kcal,
          confirmedEatRatio: ratioDec,
          confirmedQuantity: actualQuantity,
          confirmedQuantityUnit: f.quantityUnit || 'g/ml',
          caloriesPer100: per100,
        }
      })
      .filter((it) => it.confirmedCalories > 0 && it.confirmedEatRatio > 0)
  }

  function validateConfirmItems() {
    const items = buildConfirmItems()
    if (items.length === 0) {
      uni.showToast({ title: '至少保留 1 个食物', icon: 'none' })
      return null
    }
    return items
  }

  function goSavedThenDailyRecord() {
    const items = validateConfirmItems()
    if (!items) return

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
    quantityDraft,
    foodNameDraft,
    editingFood,
    editingFoodEstimatedCalories,
    ratioPercentMap,
    mealLabel,
    processingFillPercent,
    processingLabel,
    recommendedPercentLabel,
    totalStripText,
    ratioSummaryText,
    isProcessing,
    getFoodDisplayedCalories,
    getFoodQuantityLabel,
    getFoodRatioPercent,
    handleImagePicked,
    openMealDropdown,
    closeMealDropdown,
    selectMealType,
    openCalorieEdit,
    confirmCalorieEdit,
    cancelCalorieEdit,
    deleteFood,
    setFoodRatioPercent,
    openRatioSheet,
    closeRatioSheet,
    onConfirmMain,
    onAddFromSheet,
    onContinuePhoto,
    onExitPhoto,
    resetToIdle,
  }
}
