<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import {
  adjustTcmDetectionQuota,
  createTcmDetectionWhitelist,
  fetchTcmDetectionConsumeLogs,
  fetchTcmDetectionManualLogs,
  fetchTcmDetectionQuotaSummary,
  fetchTcmDetectionWhitelist,
  updateTcmDetectionWhitelist,
} from '../api/admin'
import type { TcmDetectionQuotaLogItem, TcmDetectionQuotaSummary, TcmDetectionWhitelist } from '../types/admin'

const loading = ref(false)
const saving = ref(false)
const quotaSaving = ref(false)
const detailLoading = ref(false)
const rows = ref<TcmDetectionWhitelist[]>([])
const keyword = ref('')
const statusFilter = ref<number | undefined>()
const dialogVisible = ref(false)
const quotaDialogVisible = ref(false)
const balanceDialogVisible = ref(false)
const consumeDialogVisible = ref(false)
const editingId = ref<number | undefined>()
const currentRow = ref<TcmDetectionWhitelist | null>(null)
const formRef = ref<FormInstance>()
const quotaFormRef = ref<FormInstance>()

const form = reactive<TcmDetectionWhitelist>({
  phone: '',
  remark: '',
  status: 1,
  totalTimes: 3,
})
const quotaForm = reactive({ delta: 0, remark: '' })
const quotaSummary = ref<TcmDetectionQuotaSummary | null>(null)
const manualLogs = ref<TcmDetectionQuotaLogItem[]>([])
const consumeLogs = ref<TcmDetectionQuotaLogItem[]>([])

const rules: FormRules = {
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1\d{10}$/, message: '请输入 11 位中国大陆手机号', trigger: 'blur' },
  ],
  totalTimes: [{ type: 'number', min: 0, message: '默认次数不能小于 0', trigger: 'blur' }],
}

const quotaRules: FormRules = {
  delta: [{ type: 'number', required: true, message: '请输入调整次数', trigger: 'blur' }],
}

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchTcmDetectionWhitelist({
      keyword: keyword.value.trim() || undefined,
      status: statusFilter.value,
    })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

function openCreate() {
  editingId.value = undefined
  form.phone = ''
  form.remark = ''
  form.status = 1
  form.totalTimes = 3
  dialogVisible.value = true
}

function openEdit(row: TcmDetectionWhitelist) {
  editingId.value = row.id
  form.phone = row.phone
  form.remark = row.remark || ''
  form.status = row.status
  form.totalTimes = row.totalTimes || 3
  dialogVisible.value = true
}

function openQuotaAdjust(row: TcmDetectionWhitelist) {
  currentRow.value = row
  quotaForm.delta = 0
  quotaForm.remark = ''
  quotaDialogVisible.value = true
}

async function openBalanceDetail(row: TcmDetectionWhitelist) {
  if (!row.id) return
  currentRow.value = row
  balanceDialogVisible.value = true
  detailLoading.value = true
  try {
    const [summary, logs] = await Promise.all([
      fetchTcmDetectionQuotaSummary(row.id),
      fetchTcmDetectionManualLogs(row.id),
    ])
    quotaSummary.value = summary
    manualLogs.value = logs
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载余额构成失败')
  } finally {
    detailLoading.value = false
  }
}

async function openConsumeDetail(row?: TcmDetectionWhitelist) {
  const target = row || currentRow.value
  if (!target?.id) return
  currentRow.value = target
  consumeDialogVisible.value = true
  detailLoading.value = true
  try {
    consumeLogs.value = await fetchTcmDetectionConsumeLogs(target.id)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载使用明细失败')
  } finally {
    detailLoading.value = false
  }
}

async function submitForm() {
  const f = formRef.value
  if (!f) return
  try { await f.validate() } catch { return }
  saving.value = true
  try {
    const payload = {
      phone: form.phone.trim(),
      remark: form.remark?.trim() || null,
      status: form.status,
      totalTimes: form.totalTimes ?? 3,
    }
    if (editingId.value) {
      await updateTcmDetectionWhitelist(editingId.value, payload)
      ElMessage.success('已更新')
    } else {
      await createTcmDetectionWhitelist(payload)
      ElMessage.success('已添加')
    }
    dialogVisible.value = false
    await loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    saving.value = false
  }
}

async function submitQuotaAdjust() {
  const f = quotaFormRef.value
  if (!f || !currentRow.value?.id) return
  try { await f.validate() } catch { return }
  if (quotaForm.delta === 0) {
    ElMessage.warning('调整次数不能为 0')
    return
  }
  quotaSaving.value = true
  try {
    await adjustTcmDetectionQuota(currentRow.value.id, {
      delta: quotaForm.delta,
      remark: quotaForm.remark.trim() || undefined,
    })
    ElMessage.success('次数已调整')
    quotaDialogVisible.value = false
    await loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '调整失败')
  } finally {
    quotaSaving.value = false
  }
}

function getBalance(row: TcmDetectionWhitelist) {
  return (row.totalTimes || 0) - (row.usedTimes || 0)
}

function quotaTypeLabel(type: string) {
  if (type === 'grant') return '手工赠送'
  if (type === 'reduce') return '手工扣减'
  if (type === 'consume') return '检测扣减'
  return type
}

onMounted(loadRows)
</script>

<template>
  <div class="tcm-whitelist-page">
    <el-card class="page-intro" shadow="never">
      <div class="page-intro__title">中医体检白名单/次数管理</div>
      <div class="page-intro__desc">独立管理可使用中医体检的手机号、启停状态、总次数和使用明细；不与食物识别白名单混用。</div>
    </el-card>

    <el-card>
      <template #header>
        <div class="member-header">
          <div class="member-header__left">
            <el-input v-model="keyword" placeholder="搜索手机号" clearable style="width: 220px" />
            <el-select v-model="statusFilter" placeholder="状态" clearable style="width: 140px">
              <el-option label="启用" :value="1" />
              <el-option label="停用" :value="0" />
            </el-select>
            <el-button type="primary" @click="loadRows">查询</el-button>
          </div>
          <el-button type="success" @click="openCreate">新增手机号</el-button>
        </div>
      </template>

      <el-alert title="新增手机号默认 3 次；只有绑定该手机号且白名单启用、剩余次数大于 0 的用户，才能提交中医体检。" type="info" show-icon :closable="false" class="member-tip" />

      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="90" />
        <el-table-column prop="phone" label="手机号" min-width="150" />
        <el-table-column prop="remark" label="备注" min-width="220" show-overflow-tooltip />
        <el-table-column label="状态" width="100">
          <template #default="{ row }"><el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '启用' : '停用' }}</el-tag></template>
        </el-table-column>
        <el-table-column label="总次数" width="100"><template #default="{ row }">{{ row.totalTimes || 0 }}</template></el-table-column>
        <el-table-column label="已使用" width="100"><template #default="{ row }"><el-button link type="primary" @click="openConsumeDetail(row)">{{ row.usedTimes || 0 }}</el-button></template></el-table-column>
        <el-table-column label="剩余次数" width="110"><template #default="{ row }"><el-button link type="success" @click="openBalanceDetail(row)">{{ getBalance(row) }}</el-button></template></el-table-column>
        <el-table-column prop="createdAt" label="创建时间" min-width="180" />
        <el-table-column label="操作" width="210" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
            <el-button link type="success" @click="openQuotaAdjust(row)">调整次数</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑手机号' : '新增手机号'" width="460px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="手机号" prop="phone"><el-input v-model="form.phone" maxlength="11" placeholder="请输入用户绑定的手机号" /></el-form-item>
        <el-form-item v-if="!editingId" label="默认次数" prop="totalTimes"><el-input-number v-model="form.totalTimes" :min="0" :step="1" /></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="form.status"><el-radio :label="1">启用</el-radio><el-radio :label="0">停用</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" maxlength="255" show-word-limit placeholder="可填写来源、开通原因等" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialogVisible = false">取消</el-button><el-button type="primary" :loading="saving" @click="submitForm">保存</el-button></template>
    </el-dialog>

    <el-dialog v-model="quotaDialogVisible" title="调整中医体检次数" width="460px">
      <el-form ref="quotaFormRef" :model="quotaForm" :rules="quotaRules" label-width="100px">
        <el-form-item label="手机号">{{ currentRow?.phone }}</el-form-item>
        <el-form-item label="当前剩余">{{ currentRow ? getBalance(currentRow) : 0 }}</el-form-item>
        <el-form-item label="调整次数" prop="delta"><el-input-number v-model="quotaForm.delta" :step="1" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="quotaForm.remark" type="textarea" maxlength="255" show-word-limit placeholder="例如：客服赠送、误加回收" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="quotaDialogVisible = false">取消</el-button><el-button type="primary" :loading="quotaSaving" @click="submitQuotaAdjust">保存调整</el-button></template>
    </el-dialog>

    <el-dialog v-model="balanceDialogVisible" title="余额构成" width="680px">
      <div v-loading="detailLoading">
        <el-table :data="manualLogs" border>
          <el-table-column prop="createdAt" label="时间" min-width="170" />
          <el-table-column label="类型" width="110"><template #default="{ row }">{{ quotaTypeLabel(row.changeType) }}</template></el-table-column>
          <el-table-column label="变化" width="90"><template #default="{ row }">{{ row.changeCount > 0 ? '+' : '' }}{{ row.changeCount }}</template></el-table-column>
          <el-table-column prop="remark" label="备注" min-width="160" show-overflow-tooltip />
        </el-table>
        <div class="summary-row" @click="openConsumeDetail()">已使用汇总：-{{ quotaSummary?.usedCount || 0 }}，点击查看检测扣减明细</div>
        <div class="summary-total">当前剩余：{{ quotaSummary?.currentBalance || 0 }}</div>
      </div>
    </el-dialog>

    <el-dialog v-model="consumeDialogVisible" title="检测扣减明细" width="760px">
      <el-table :data="consumeLogs" v-loading="detailLoading" border>
        <el-table-column prop="createdAt" label="时间" min-width="170" />
        <el-table-column label="变化" width="80"><template #default="{ row }">{{ row.changeCount }}</template></el-table-column>
        <el-table-column prop="recordId" label="检测记录ID" min-width="120" />
        <el-table-column prop="userId" label="用户ID" min-width="100" />
        <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
      </el-table>
    </el-dialog>
  </div>
</template>

<style scoped>
.tcm-whitelist-page { display: grid; gap: 16px; }
.page-intro { border: 1px solid #e5ebe8; background: #fafdfb; }
.page-intro__title { font-size: 16px; font-weight: 700; color: #0f2d28; }
.page-intro__desc { margin-top: 6px; font-size: 13px; color: #64748b; line-height: 1.7; }
.member-header { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.member-header__left { display: flex; align-items: center; gap: 8px; }
.member-tip { margin-bottom: 14px; }
.summary-row { margin-top: 12px; padding: 10px 12px; border: 1px dashed #95d5b2; border-radius: 8px; color: #15803d; cursor: pointer; background: #f0fdf4; }
.summary-total { margin-top: 10px; font-weight: 700; text-align: right; }
</style>
