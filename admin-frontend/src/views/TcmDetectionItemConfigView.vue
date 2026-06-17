<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance } from 'element-plus'
import { fetchTcmDetectionItemConfigs, updateTcmDetectionItemConfig } from '../api/admin'
import type { TcmDetectionItemConfig } from '../types/admin'

const loading = ref(false)
const saving = ref(false)
const rows = ref<TcmDetectionItemConfig[]>([])
const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const formRef = ref<FormInstance>()

const form = reactive({
  itemCode: '',
  vendorField: '',
  itemName: '',
  displayName: '',
  sortOrder: 1,
  enabled: 1,
  scaleType: 'constitution',
  scoreDirection: 'higher_better',
  promptKey: '',
  remark: '',
})

const rules = {
  itemName: [{ required: true, message: '请输入展示名称', trigger: 'blur' }],
  displayName: [{ required: true, message: '请输入短名称', trigger: 'blur' }],
  sortOrder: [{ required: true, message: '请输入排序', trigger: 'blur' }],
  scaleType: [{ required: true, message: '请选择分档类型', trigger: 'change' }],
  scoreDirection: [{ required: true, message: '请选择分数方向', trigger: 'change' }],
  promptKey: [{ required: true, message: '请输入提示词 key', trigger: 'blur' }],
}

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchTcmDetectionItemConfigs()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载体质项配置失败')
  } finally {
    loading.value = false
  }
}

function openEdit(row: TcmDetectionItemConfig) {
  editingId.value = row.id
  form.itemCode = row.itemCode
  form.vendorField = row.vendorField
  form.itemName = row.itemName
  form.displayName = row.displayName
  form.sortOrder = row.sortOrder
  form.enabled = row.enabled
  form.scaleType = row.scaleType
  form.scoreDirection = row.scoreDirection
  form.promptKey = row.promptKey
  form.remark = row.remark || ''
  dialogVisible.value = true
}

async function submit() {
  const currentId = editingId.value
  if (!currentId) return
  const currentForm = formRef.value
  if (!currentForm) return
  try {
    await currentForm.validate()
  } catch {
    return
  }
  saving.value = true
  try {
    await updateTcmDetectionItemConfig(currentId, {
      itemName: form.itemName.trim(),
      displayName: form.displayName.trim(),
      sortOrder: form.sortOrder,
      enabled: form.enabled,
      scaleType: form.scaleType,
      scoreDirection: form.scoreDirection,
      promptKey: form.promptKey.trim(),
      remark: form.remark.trim() || null,
    })
    ElMessage.success('体质项配置已保存')
    dialogVisible.value = false
    await loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    saving.value = false
  }
}

function enabledType(enabled: number) {
  return enabled === 1 ? 'success' : 'info'
}

function enabledText(enabled: number) {
  return enabled === 1 ? '启用' : '停用'
}

onMounted(loadRows)
</script>

<template>
  <div class="tcm-config-page">
    <el-card class="page-intro" shadow="never">
      <div class="page-intro__title">中医体检项配置</div>
      <div class="page-intro__desc">维护九种体质项的启用状态、展示名称、排序、分档类型和对应 AI 提示词。itemCode 和厂商字段为关键接口字段，不在此页面修改。</div>
    </el-card>

    <el-card>
      <template #header>
        <div class="card-header">
          <span>体质项列表</span>
          <el-button type="primary" plain @click="loadRows">刷新</el-button>
        </div>
      </template>
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column prop="displayName" label="展示名" width="110" />
        <el-table-column prop="itemCode" label="itemCode" width="130" />
        <el-table-column prop="vendorField" label="厂商字段" width="130" />
        <el-table-column label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="enabledType(row.enabled)">{{ enabledText(row.enabled) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="scaleType" label="分档类型" width="120" />
        <el-table-column prop="scoreDirection" label="分数方向" width="140" />
        <el-table-column prop="promptKey" label="提示词 key" min-width="180" show-overflow-tooltip />
        <el-table-column prop="remark" label="备注" min-width="160" show-overflow-tooltip />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" title="编辑体质项配置" width="640px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="itemCode">
          <el-input v-model="form.itemCode" disabled />
        </el-form-item>
        <el-form-item label="厂商字段">
          <el-input v-model="form.vendorField" disabled />
        </el-form-item>
        <el-form-item label="展示名称" prop="itemName">
          <el-input v-model="form.itemName" />
        </el-form-item>
        <el-form-item label="短名称" prop="displayName">
          <el-input v-model="form.displayName" />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="form.sortOrder" :min="1" :max="999" />
        </el-form-item>
        <el-form-item label="状态" prop="enabled">
          <el-radio-group v-model="form.enabled">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="分档类型" prop="scaleType">
          <el-select v-model="form.scaleType" style="width: 100%">
            <el-option label="体质 constitution" value="constitution" />
            <el-option label="严重度 severity" value="severity" />
          </el-select>
        </el-form-item>
        <el-form-item label="分数方向" prop="scoreDirection">
          <el-select v-model="form.scoreDirection" style="width: 100%">
            <el-option label="分数越高越好" value="higher_better" />
            <el-option label="分数越低越好" value="lower_better" />
          </el-select>
        </el-form-item>
        <el-form-item label="提示词 key" prop="promptKey">
          <el-input v-model="form.promptKey" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="submit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.tcm-config-page { display: grid; gap: 16px; }
.page-intro { border: 1px solid #e5ebe8; background: #fafdfb; }
.page-intro__title { font-size: 16px; font-weight: 700; color: #0f2d28; }
.page-intro__desc { margin-top: 6px; font-size: 13px; color: #64748b; line-height: 1.7; }
.card-header { display: flex; align-items: center; justify-content: space-between; font-weight: 700; }
</style>
