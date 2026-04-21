<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchAdminUsers } from '../api/admin'
import type { AdminUserItem } from '../types/admin'

const loading = ref(false)
const rows = ref<AdminUserItem[]>([])
const pager = reactive({
  page: 1,
  pageSize: 20,
  total: 0,
})
const keyword = ref('')

async function loadUsers() {
  loading.value = true
  try {
    const resp = await fetchAdminUsers({
      keyword: keyword.value.trim() || undefined,
      page: pager.page,
      pageSize: pager.pageSize,
    })
    rows.value = resp.list
    pager.total = resp.total
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

onMounted(loadUsers)
</script>

<template>
  <el-card>
    <template #header>
      <div style="display: flex; gap: 8px; align-items: center">
        <el-input v-model="keyword" placeholder="昵称/手机号" style="width: 240px" />
        <el-button type="primary" @click="pager.page = 1; loadUsers()">查询</el-button>
      </div>
    </template>
    <el-table :data="rows" v-loading="loading" border>
      <el-table-column prop="id" label="用户ID" width="90" />
      <el-table-column prop="nickname" label="昵称" min-width="140" />
      <el-table-column prop="phone" label="手机号" min-width="140" />
      <el-table-column prop="status" label="状态" width="90" />
      <el-table-column prop="gender" label="性别" width="90" />
      <el-table-column prop="age" label="年龄" width="90" />
      <el-table-column prop="currentWeightKg" label="当前体重(kg)" width="130" />
      <el-table-column prop="targetWeightKg" label="目标体重(kg)" width="130" />
      <el-table-column prop="createdAt" label="注册时间" min-width="180" />
    </el-table>
    <div style="margin-top: 12px; display: flex; justify-content: flex-end">
      <el-pagination
        v-model:current-page="pager.page"
        v-model:page-size="pager.pageSize"
        :total="pager.total"
        layout="total, prev, pager, next, sizes"
        @current-change="loadUsers"
        @size-change="pager.page = 1; loadUsers()"
      />
    </div>
  </el-card>
</template>
