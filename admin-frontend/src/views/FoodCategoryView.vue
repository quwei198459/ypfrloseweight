<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createFoodCategory, deleteFoodCategory, fetchFoodCategories, updateFoodCategory } from '../api/admin'
import type { FoodCategoryItem } from '../types/admin'

const loading = ref(false)
const rows = ref<FoodCategoryItem[]>([])
const visible = ref(false)
const editingId = ref<number | null>(null)
const form = reactive<FoodCategoryItem>({
  name: '',
  code: '',
  parentId: 0,
  type: 'food',
  sortNo: 0,
  status: 1,
})

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchFoodCategories()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

function openCreate() {
  editingId.value = null
  Object.assign(form, { name: '', code: '', parentId: 0, type: 'food', sortNo: 0, status: 1 })
  visible.value = true
}

function openEdit(row: FoodCategoryItem) {
  editingId.value = row.id || null
  Object.assign(form, row)
  visible.value = true
}

async function submit() {
  try {
    if (editingId.value) {
      await updateFoodCategory(editingId.value, form)
    } else {
      await createFoodCategory(form)
    }
    visible.value = false
    ElMessage.success('保存成功')
    loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  }
}

async function onDelete(id: number) {
  await ElMessageBox.confirm('确认删除该分类？', '提示', { type: 'warning' })
  await deleteFoodCategory(id)
  ElMessage.success('删除成功')
  loadRows()
}

onMounted(loadRows)
</script>

<template>
  <el-card>
    <template #header>
      <el-button type="primary" @click="openCreate">新增分类</el-button>
    </template>
    <el-table :data="rows" v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="分类名" />
      <el-table-column prop="code" label="编码" />
      <el-table-column prop="sortNo" label="排序" width="90" />
      <el-table-column prop="status" label="状态" width="90" />
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
          <el-button link type="danger" @click="onDelete(row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>

  <el-dialog v-model="visible" title="分类信息" width="480px">
    <el-form label-width="100px">
      <el-form-item label="名称"><el-input v-model="form.name" /></el-form-item>
      <el-form-item label="编码"><el-input v-model="form.code" /></el-form-item>
      <el-form-item label="父级ID"><el-input-number v-model="form.parentId" :min="0" /></el-form-item>
      <el-form-item label="类型"><el-input v-model="form.type" /></el-form-item>
      <el-form-item label="排序"><el-input-number v-model="form.sortNo" :min="0" /></el-form-item>
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
