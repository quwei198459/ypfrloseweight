<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createSport, deleteSport, fetchSports, updateSport } from '../api/admin'
import type { SportItem } from '../types/admin'

const loading = ref(false)
const rows = ref<SportItem[]>([])
const visible = ref(false)
const editingId = ref<number | null>(null)
const keyword = ref('')
const form = reactive<SportItem>({
  name: '',
  icon: '',
  caloriesPer60min: 0,
  category: 'other',
  sortNo: 0,
  status: 1,
})

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchSports({ keyword: keyword.value || undefined })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

function openCreate() {
  editingId.value = null
  Object.assign(form, { name: '', icon: '', caloriesPer60min: 0, category: 'other', sortNo: 0, status: 1 })
  visible.value = true
}

function openEdit(row: SportItem) {
  editingId.value = row.id || null
  Object.assign(form, row)
  visible.value = true
}

async function submit() {
  try {
    if (editingId.value) {
      await updateSport(editingId.value, form)
    } else {
      await createSport(form)
    }
    visible.value = false
    ElMessage.success('保存成功')
    loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  }
}

async function onDelete(id: number) {
  await ElMessageBox.confirm('确认删除该运动项目？', '提示', { type: 'warning' })
  await deleteSport(id)
  ElMessage.success('删除成功')
  loadRows()
}

function fmtKcal(v: unknown) {
  if (v == null || v === '') return '—'
  const n = Number(v)
  return Number.isFinite(n) ? `${n}` : String(v)
}

onMounted(loadRows)
</script>

<template>
  <el-card class="page-card">
    <template #header>
      <div class="page-toolbar">
        <el-input v-model="keyword" placeholder="运动名称搜索" clearable class="page-toolbar__search" />
        <el-button type="primary" @click="loadRows">查询</el-button>
        <el-button type="success" plain @click="openCreate">新增运动</el-button>
      </div>
    </template>
    <el-table :data="rows" v-loading="loading" stripe class="page-table">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="名称" min-width="160" />
      <el-table-column label="60分钟消耗（千卡）" width="160">
        <template #default="{ row }">{{ fmtKcal(row.caloriesPer60min) }}</template>
      </el-table-column>
      <el-table-column prop="category" label="分类" width="120" />
      <el-table-column prop="sortNo" label="排序" width="90" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'" size="small">
            {{ row.status === 1 ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="160" fixed="right">
        <template #default="{ row }">
          <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
          <el-button link type="danger" @click="onDelete(row.id!)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>

  <el-dialog v-model="visible" title="运动项目信息" width="520px">
    <el-form label-width="120px">
      <el-form-item label="名称"><el-input v-model="form.name" /></el-form-item>
      <el-form-item label="图标URL"><el-input v-model="form.icon" /></el-form-item>
      <el-form-item label="60分钟消耗"><el-input-number v-model="form.caloriesPer60min" :min="0" /></el-form-item>
      <el-form-item label="分类"><el-input v-model="form.category" /></el-form-item>
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

<style scoped>
.page-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items: center;
}
.page-toolbar__search {
  width: 240px;
  max-width: 100%;
}
.page-table {
  border-radius: 8px;
}
</style>
