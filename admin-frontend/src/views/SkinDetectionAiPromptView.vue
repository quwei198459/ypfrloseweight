<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance } from 'element-plus'
import { fetchSkinDetectionAiPrompts, updateSkinDetectionAiPrompt } from '../api/admin'
import type { SkinDetectionAiPromptTemplate } from '../types/admin'

const loading = ref(false)
const saving = ref(false)
const rows = ref<SkinDetectionAiPromptTemplate[]>([])
const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const formRef = ref<FormInstance>()

const form = reactive({
  promptKey: '',
  promptType: '',
  itemCode: '',
  promptName: '',
  templateContent: '',
  outputSchema: '',
  model: 'deepseek-chat',
  temperature: 0.2,
  status: 1,
  remark: '',
})

const rules = {
  promptName: [{ required: true, message: '请输入模板名称', trigger: 'blur' }],
  templateContent: [{ required: true, message: '请输入提示词内容', trigger: 'blur' }],
  model: [{ required: true, message: '请输入模型名', trigger: 'blur' }],
  temperature: [{ required: true, message: '请输入 temperature', trigger: 'blur' }],
}

const promptTypeLabel = computed(() => {
  if (form.promptType === 'overall') return '综合报告'
  if (form.promptType === 'item') return '分项报告'
  return form.promptType || '--'
})

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchSkinDetectionAiPrompts()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载提示词模板失败')
  } finally {
    loading.value = false
  }
}

function openEdit(row: SkinDetectionAiPromptTemplate) {
  editingId.value = row.id
  form.promptKey = row.promptKey
  form.promptType = row.promptType
  form.itemCode = row.itemCode || ''
  form.promptName = row.promptName
  form.templateContent = row.templateContent
  form.outputSchema = row.outputSchema || ''
  form.model = row.model || 'deepseek-chat'
  form.temperature = Number(row.temperature ?? 0.2)
  form.status = row.status
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
    await updateSkinDetectionAiPrompt(currentId, {
      promptName: form.promptName.trim(),
      templateContent: form.templateContent.trim(),
      outputSchema: form.outputSchema.trim() || null,
      model: form.model.trim(),
      temperature: Number(form.temperature),
      status: form.status,
      remark: form.remark.trim() || null,
    })
    ElMessage.success('AI 提示词模板已保存')
    dialogVisible.value = false
    await loadRows()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    saving.value = false
  }
}

function typeText(type: string) {
  if (type === 'overall') return '综合'
  if (type === 'item') return '分项'
  return type
}

function statusText(status: number) {
  return status === 1 ? '启用' : '停用'
}

function statusType(status: number) {
  return status === 1 ? 'success' : 'info'
}

onMounted(loadRows)
</script>

<template>
  <div class="skin-prompt-page">
    <el-card class="page-intro" shadow="never">
      <div class="page-intro__title">皮肤检测 AI 提示词配置</div>
      <div class="page-intro__desc">维护综合报告和各检测分项的 DeepSeek 提示词模板。模板支持变量：{{ '{' }}{{ '{' }}userProfileText{{ '}' }}{{ '}' }}、{{ '{' }}{{ '{' }}itemsFactsText{{ '}' }}{{ '}' }}、{{ '{' }}{{ '{' }}itemFactsText{{ '}' }}{{ '}' }}。</div>
    </el-card>

    <el-card>
      <template #header>
        <div class="card-header">
          <span>提示词模板列表</span>
          <el-button type="primary" plain @click="loadRows">刷新</el-button>
        </div>
      </template>
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="promptName" label="模板名称" min-width="160" />
        <el-table-column label="类型" width="80">
          <template #default="{ row }">{{ typeText(row.promptType) }}</template>
        </el-table-column>
        <el-table-column prop="itemCode" label="itemCode" width="120" />
        <el-table-column prop="promptKey" label="promptKey" min-width="190" show-overflow-tooltip />
        <el-table-column prop="model" label="模型" width="130" />
        <el-table-column prop="temperature" label="温度" width="90" />
        <el-table-column prop="version" label="版本" width="80" />
        <el-table-column label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="160" show-overflow-tooltip />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" title="编辑 AI 提示词模板" width="960px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-row :gutter="12">
          <el-col :span="12">
            <el-form-item label="promptKey">
              <el-input v-model="form.promptKey" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="类型">
              <el-input :model-value="promptTypeLabel" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="itemCode">
              <el-input v-model="form.itemCode" disabled placeholder="综合模板为空" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="模板名称" prop="promptName">
          <el-input v-model="form.promptName" />
        </el-form-item>
        <el-row :gutter="12">
          <el-col :span="10">
            <el-form-item label="模型" prop="model">
              <el-input v-model="form.model" />
            </el-form-item>
          </el-col>
          <el-col :span="7">
            <el-form-item label="temperature" prop="temperature">
              <el-input-number v-model="form.temperature" :min="0" :max="2" :step="0.1" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="7">
            <el-form-item label="状态">
              <el-radio-group v-model="form.status">
                <el-radio :label="1">启用</el-radio>
                <el-radio :label="0">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="提示词内容" prop="templateContent">
          <el-input v-model="form.templateContent" type="textarea" :rows="18" resize="vertical" />
        </el-form-item>
        <el-form-item label="输出结构">
          <el-input v-model="form.outputSchema" type="textarea" :rows="4" resize="vertical" placeholder="JSON schema，可选" />
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
.skin-prompt-page { display: grid; gap: 16px; }
.page-intro { border: 1px solid #e5ebe8; background: #fafdfb; }
.page-intro__title { font-size: 16px; font-weight: 700; color: #0f2d28; }
.page-intro__desc { margin-top: 6px; font-size: 13px; color: #64748b; line-height: 1.7; }
.card-header { display: flex; align-items: center; justify-content: space-between; font-weight: 700; }
</style>
