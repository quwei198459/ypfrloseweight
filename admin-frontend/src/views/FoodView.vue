<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  createFood,
  deleteFood,
  fetchFoodCategories,
  fetchFoods,
  updateFood,
} from '../api/admin'
import type { FoodCategoryItem, FoodItem } from '../types/admin'

const loading = ref(false)
const rows = ref<FoodItem[]>([])
const categories = ref<FoodCategoryItem[]>([])
const visible = ref(false)
const editingId = ref<number | null>(null)
const keyword = ref('')
const form = reactive<FoodItem>({
  categoryId: 0,
  name: '',
  image: '',
  giLevel: '',
  caloriesPer100g: 0,
  caloriesPerUnit: 0,
  unitName: '份',
  standardWeightG: 0,
  ediblePortionRate: 1,
  proteinPer100g: 0,
  fatPer100g: 0,
  carbPer100g: 0,
  keywords: '',
  status: 1,
})

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchFoods({ keyword: keyword.value || undefined })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

async function loadCategories() {
  categories.value = await fetchFoodCategories()
}

function openCreate() {
  editingId.value = null
  Object.assign(form, {
    categoryId: categories.value[0]?.id || 0,
    name: '',
    image: '',
    giLevel: '',
    caloriesPer100g: 0,
    caloriesPerUnit: 0,
    unitName: '份',
    standardWeightG: 0,
    ediblePortionRate: 1,
    proteinPer100g: 0,
    fatPer100g: 0,
    carbPer100g: 0,
    keywords: '',
    status: 1,
  })
  visible.value = true
}

function openEdit(row: FoodItem) {
  editingId.value = row.id || null
  Object.assign(form, row)
  visible.value = true
}

async function submit() {
  try {
    if (editingId.value) {
      await updateFood(editingId.value, form)
    } else {
      await createFood(form)
    }
    visible.value = false
    ElMessage.success('保存成功')
    loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  }
}

async function onDelete(id: number) {
  await ElMessageBox.confirm('确认删除该食物？', '提示', { type: 'warning' })
  await deleteFood(id)
  ElMessage.success('删除成功')
  loadRows()
}

onMounted(async () => {
  await loadCategories()
  await loadRows()
})
</script>

<template>
  <el-card>
    <template #header>
      <div style="display: flex; gap: 8px">
        <el-input v-model="keyword" placeholder="食物名搜索" style="width: 240px" />
        <el-button type="primary" @click="loadRows">查询</el-button>
        <el-button type="success" @click="openCreate">新增食物</el-button>
      </div>
    </template>
    <el-table :data="rows" v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="名称" min-width="140" />
      <el-table-column prop="categoryId" label="分类ID" width="100" />
      <el-table-column prop="caloriesPer100g" label="每100g热量" width="120" />
      <el-table-column prop="unitName" label="单位" width="90" />
      <el-table-column prop="status" label="状态" width="90" />
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
          <el-button link type="danger" @click="onDelete(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>

  <el-dialog v-model="visible" title="食物信息" width="640px">
    <el-form label-width="120px">
      <el-form-item label="名称"><el-input v-model="form.name" /></el-form-item>
      <el-form-item label="分类">
        <el-select v-model="form.categoryId" style="width: 100%">
          <el-option v-for="x in categories" :key="x.id" :value="x.id" :label="x.name" />
        </el-select>
      </el-form-item>
      <el-form-item label="图片URL"><el-input v-model="form.image" /></el-form-item>
      <el-form-item label="GI等级"><el-input v-model="form.giLevel" /></el-form-item>
      <el-form-item label="每100g热量"><el-input-number v-model="form.caloriesPer100g" :min="0" /></el-form-item>
      <el-form-item label="每单位热量"><el-input-number v-model="form.caloriesPerUnit" :min="0" /></el-form-item>
      <el-form-item label="单位"><el-input v-model="form.unitName" /></el-form-item>
      <el-form-item label="标准重量(g)"><el-input-number v-model="form.standardWeightG" :min="0" /></el-form-item>
      <el-form-item label="可食率"><el-input-number v-model="form.ediblePortionRate" :min="0" :step="0.01" /></el-form-item>
      <el-form-item label="蛋白质"><el-input-number v-model="form.proteinPer100g" :min="0" /></el-form-item>
      <el-form-item label="脂肪"><el-input-number v-model="form.fatPer100g" :min="0" /></el-form-item>
      <el-form-item label="碳水"><el-input-number v-model="form.carbPer100g" :min="0" /></el-form-item>
      <el-form-item label="关键词"><el-input v-model="form.keywords" /></el-form-item>
      <el-form-item label="状态">
        <el-select v-model="form.status">
          <el-option :value="1" label="启用" />
          <el-option :value="0" label="禁用" />
        </el-select>
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="submit">保存</el-button>
    </template>
  </el-dialog>
</template>
