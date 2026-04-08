// Mock 数据

export const mockUser = {
  id: 1,
  nickname: '小明',
  avatar: '',
  age: 25,
  sex: '男',
  height: 175,
  currentWeight: 72.5,
  targetWeight: 65.0,
  initialWeight: 80.0,
  targetDate: '2024-06-01',
  bmr: 1750,
  tdee: 2100,
  dailyCalorieGoal: 1600,
}

export const mockToday = {
  date: '2024-03-17',
  totalCalories: 1245,
  goalCalories: 1600,
  burnedCalories: 320,
  remainingCalories: 675,
  breakfast: {
    calories: 385,
    items: [
      { id: 1, name: '全麦面包', calories: 120, weight: 60, unit: 'g' },
      { id: 2, name: '鸡蛋', calories: 155, weight: 100, unit: 'g' },
      { id: 3, name: '牛奶', calories: 110, weight: 200, unit: 'ml' },
    ],
  },
  lunch: {
    calories: 620,
    items: [
      { id: 4, name: '米饭', calories: 260, weight: 200, unit: 'g' },
      { id: 5, name: '番茄炒蛋', calories: 180, weight: 150, unit: 'g' },
      { id: 6, name: '青菜', calories: 30, weight: 100, unit: 'g' },
      { id: 7, name: '豆腐汤', calories: 150, weight: 300, unit: 'ml' },
    ],
  },
  dinner: {
    calories: 240,
    items: [
      { id: 8, name: '燕麦粥', calories: 150, weight: 200, unit: 'g' },
      { id: 9, name: '苹果', calories: 90, weight: 150, unit: 'g' },
    ],
  },
  sport: [
    { id: 1, name: '跑步', duration: 30, calories: 200, icon: '🏃' },
    { id: 2, name: '跳绳', duration: 15, calories: 120, icon: '🤸' },
  ],
}

export const mockWeekData = [
  { date: '03/11', weight: 73.2, calories: 1520 },
  { date: '03/12', weight: 73.0, calories: 1480 },
  { date: '03/13', weight: 72.8, calories: 1550 },
  { date: '03/14', weight: 72.6, calories: 1490 },
  { date: '03/15', weight: 72.5, calories: 1600 },
  { date: '03/16', weight: 72.3, calories: 1420 },
  { date: '03/17', weight: 72.1, calories: 1245 },
]

export const mockWeightRecords = [
  { date: '2024-03-17', weight: 72.1 },
  { date: '2024-03-16', weight: 72.3 },
  { date: '2024-03-15', weight: 72.5 },
  { date: '2024-03-14', weight: 72.6 },
  { date: '2024-03-13', weight: 72.8 },
  { date: '2024-03-12', weight: 73.0 },
  { date: '2024-03-11', weight: 73.2 },
  { date: '2024-03-01', weight: 74.5 },
  { date: '2024-02-01', weight: 76.0 },
  { date: '2024-01-01', weight: 78.0 },
]

export const mockFoodDatabase = [
  { id: 1, name: '白米饭', calories: 130, protein: 2.6, fat: 0.3, carbs: 28, unit: '100g', category: '主食' },
  { id: 2, name: '全麦面包', calories: 246, protein: 8.5, fat: 3.5, carbs: 45, unit: '100g', category: '主食' },
  { id: 3, name: '鸡胸肉', calories: 133, protein: 24, fat: 3.1, carbs: 0, unit: '100g', category: '肉类' },
  { id: 4, name: '鸡蛋', calories: 155, protein: 13, fat: 11, carbs: 1.1, unit: '100g', category: '蛋类' },
  { id: 5, name: '牛奶', calories: 55, protein: 3, fat: 3.2, carbs: 4.8, unit: '100ml', category: '乳制品' },
  { id: 6, name: '苹果', calories: 60, protein: 0.3, fat: 0.2, carbs: 14, unit: '100g', category: '水果' },
  { id: 7, name: '香蕉', calories: 95, protein: 1.1, fat: 0.2, carbs: 23, unit: '100g', category: '水果' },
  { id: 8, name: '西兰花', calories: 34, protein: 2.8, fat: 0.4, carbs: 6.6, unit: '100g', category: '蔬菜' },
  { id: 9, name: '番茄', calories: 18, protein: 0.9, fat: 0.2, carbs: 3.9, unit: '100g', category: '蔬菜' },
  { id: 10, name: '燕麦', calories: 389, protein: 17, fat: 7, carbs: 66, unit: '100g', category: '主食' },
  { id: 11, name: '三文鱼', calories: 206, protein: 20, fat: 13, carbs: 0, unit: '100g', category: '鱼类' },
  { id: 12, name: '豆腐', calories: 76, protein: 8.1, fat: 4.2, carbs: 1.9, unit: '100g', category: '豆制品' },
  { id: 13, name: '酸奶', calories: 72, protein: 3.5, fat: 1.9, carbs: 11, unit: '100g', category: '乳制品' },
  { id: 14, name: '核桃', calories: 654, protein: 15, fat: 65, carbs: 14, unit: '100g', category: '坚果' },
  { id: 15, name: '可乐', calories: 41, protein: 0, fat: 0, carbs: 10.6, unit: '100ml', category: '饮料' },
]

export const mockSportDatabase = [
  { id: 1, name: '跑步', caloriesPerMin: 6.5, icon: '🏃', category: '有氧' },
  { id: 2, name: '跳绳', caloriesPerMin: 8.0, icon: '🤸', category: '有氧' },
  { id: 3, name: '游泳', caloriesPerMin: 7.0, icon: '🏊', category: '有氧' },
  { id: 4, name: '骑行', caloriesPerMin: 5.5, icon: '🚴', category: '有氧' },
  { id: 5, name: '健步走', caloriesPerMin: 4.0, icon: '🚶', category: '有氧' },
  { id: 6, name: '瑜伽', caloriesPerMin: 3.0, icon: '🧘', category: '柔韧' },
  { id: 7, name: '俯卧撑', caloriesPerMin: 5.0, icon: '💪', category: '力量' },
  { id: 8, name: '深蹲', caloriesPerMin: 5.5, icon: '🏋️', category: '力量' },
]

export const mockFreePlan = {
  targetCalories: 1600,
  meals: [
    {
      type: 'breakfast',
      name: '早餐',
      targetCalories: 400,
      suggestions: ['燕麦粥 + 鸡蛋', '全麦面包 + 牛奶', '杂粮粥 + 小菜'],
    },
    {
      type: 'lunch',
      name: '午餐',
      targetCalories: 600,
      suggestions: ['米饭 + 鸡胸肉 + 蔬菜', '杂粮饭 + 鱼 + 沙拉', '面条 + 豆腐 + 青菜'],
    },
    {
      type: 'dinner',
      name: '晚餐',
      targetCalories: 400,
      suggestions: ['轻食沙拉', '燕麦粥 + 水果', '蒸蔬菜 + 豆腐'],
    },
  ],
}
