<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Delete, Edit, Plus } from '@element-plus/icons-vue'
import { supabase, type FruitInventory } from '../lib/supabase'

const inventoryList = ref<FruitInventory[]>([])
const loading = ref(false)
const dialogVisible = ref(false)
const isEditing = ref(false)
const currentId = ref<string | null>(null)

const form = ref({
  fruit_name: '',
  type: 'in' as 'in' | 'out',
  quantity: 0,
  unit_price: 0,
  description: ''
})

const formRules = {
  fruit_name: [{ required: true, message: '请输入水果名称', trigger: 'blur' }],
  type: [{ required: true, message: '请选择进出货类型', trigger: 'change' }],
  quantity: [{ required: true, message: '请输入数量', trigger: 'blur' }],
  unit_price: [{ required: true, message: '请输入单价', trigger: 'blur' }]
}

const inTotal = computed(() => {
  return inventoryList.value
    .filter(item => item.type === 'in')
    .reduce((sum, item) => sum + item.total_amount, 0)
    .toFixed(2)
})

const outTotal = computed(() => {
  return inventoryList.value
    .filter(item => item.type === 'out')
    .reduce((sum, item) => sum + item.total_amount, 0)
    .toFixed(2)
})

const fetchInventory = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('fruit_inventory')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    inventoryList.value = data || []
  } catch (error) {
    ElMessage.error('加载数据失败')
    console.error('Error fetching inventory:', error)
  } finally {
    loading.value = false
  }
}

const openDialog = (item?: FruitInventory) => {
  if (item) {
    isEditing.value = true
    currentId.value = item.id
    form.value = {
      fruit_name: item.fruit_name,
      type: item.type,
      quantity: item.quantity,
      unit_price: item.unit_price,
      description: item.description
    }
  } else {
    isEditing.value = false
    currentId.value = null
    form.value = {
      fruit_name: '',
      type: 'in',
      quantity: 0,
      unit_price: 0,
      description: ''
    }
  }
  dialogVisible.value = true
}

const closeDialog = () => {
  dialogVisible.value = false
}

const saveItem = async () => {
  const total_amount = form.value.quantity * form.value.unit_price

  try {
    if (isEditing.value && currentId.value) {
      const { error } = await supabase
        .from('fruit_inventory')
        .update({
          fruit_name: form.value.fruit_name,
          type: form.value.type,
          quantity: form.value.quantity,
          unit_price: form.value.unit_price,
          total_amount,
          description: form.value.description
        })
        .eq('id', currentId.value)

      if (error) throw error
      ElMessage.success('更新成功')
    } else {
      const { error } = await supabase
        .from('fruit_inventory')
        .insert([
          {
            fruit_name: form.value.fruit_name,
            type: form.value.type,
            quantity: form.value.quantity,
            unit_price: form.value.unit_price,
            total_amount,
            description: form.value.description
          }
        ])

      if (error) throw error
      ElMessage.success('添加成功')
    }

    closeDialog()
    await fetchInventory()
  } catch (error) {
    ElMessage.error(isEditing.value ? '更新失败' : '添加失败')
    console.error('Error saving item:', error)
  }
}

const deleteItem = async (id: string) => {
  try {
    await ElMessageBox.confirm('确定删除此记录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    const { error } = await supabase
      .from('fruit_inventory')
      .delete()
      .eq('id', id)

    if (error) throw error
    ElMessage.success('删除成功')
    await fetchInventory()
  } catch (error: any) {
    if (error.message !== 'User cancelled') {
      ElMessage.error('删除失败')
      console.error('Error deleting item:', error)
    }
  }
}

const getTypeLabel = (type: string) => {
  return type === 'in' ? '进货' : '出货'
}

const getTypeColor = (type: string) => {
  return type === 'in' ? 'success' : 'warning'
}

onMounted(() => {
  fetchInventory()
})
</script>

<template>
  <div class="inventory-container">
    <el-card class="inventory-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <h2>水果进出货管理</h2>
          <el-button type="primary" :icon="Plus" @click="openDialog">
            添加记录
          </el-button>
        </div>
      </template>

      <div class="statistics">
        <el-statistic title="总进货" :value="inTotal" />
        <el-statistic title="总出货" :value="outTotal" />
        <el-statistic title="总记录" :value="inventoryList.length" />
      </div>

      <el-divider />

      <el-table
        :data="inventoryList"
        stripe
        style="width: 100%"
        v-loading="loading"
        max-height="600"
      >
        <el-table-column prop="fruit_name" label="水果名称" width="120" />
        <el-table-column label="类型" width="80">
          <template #default="{ row }">
            <el-tag :type="getTypeColor(row.type)">
              {{ getTypeLabel(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="quantity" label="数量(kg)" width="100" />
        <el-table-column prop="unit_price" label="单价(元/kg)" width="120" />
        <el-table-column prop="total_amount" label="总金额(元)" width="120" />
        <el-table-column prop="description" label="备注" min-width="150" />
        <el-table-column
          prop="created_at"
          label="日期"
          width="180"
          :formatter="(row: any) => new Date(row.created_at).toLocaleString('zh-CN')"
        />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button
              type="primary"
              :icon="Edit"
              circle
              size="small"
              @click="openDialog(row)"
            />
            <el-button
              type="danger"
              :icon="Delete"
              circle
              size="small"
              @click="deleteItem(row.id)"
            />
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog
      v-model="dialogVisible"
      :title="isEditing ? '编辑记录' : '添加记录'"
      width="500px"
    >
      <el-form :model="form" :rules="formRules" label-width="100px">
        <el-form-item label="水果名称" prop="fruit_name">
          <el-input
            v-model="form.fruit_name"
            placeholder="如：苹果、香蕉等"
          />
        </el-form-item>
        <el-form-item label="进出货类型" prop="type">
          <el-select v-model="form.type" placeholder="选择类型">
            <el-option label="进货" value="in" />
            <el-option label="出货" value="out" />
          </el-select>
        </el-form-item>
        <el-form-item label="数量(kg)" prop="quantity">
          <el-input-number
            v-model="form.quantity"
            :min="1"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="单价(元/kg)" prop="unit_price">
          <el-input-number
            v-model="form.unit_price"
            :min="0"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="备注">
          <el-input
            v-model="form.description"
            type="textarea"
            placeholder="输入备注信息"
            :rows="3"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="closeDialog">取消</el-button>
        <el-button type="primary" @click="saveItem">
          {{ isEditing ? '更新' : '添加' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.inventory-container {
  max-width: 1200px;
  margin: 40px auto;
  padding: 0 20px;
}

.inventory-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #303133;
}

.statistics {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

@media (max-width: 768px) {
  .statistics {
    grid-template-columns: 1fr;
  }
}
</style>
