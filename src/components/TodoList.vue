<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Delete, Check, Close } from '@element-plus/icons-vue'
import { supabase, type Todo } from '../lib/supabase'

const todos = ref<Todo[]>([])
const newTodoTitle = ref('')
const loading = ref(false)

const fetchTodos = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('todos')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    todos.value = data || []
  } catch (error) {
    ElMessage.error('加载待办事项失败')
    console.error('Error fetching todos:', error)
  } finally {
    loading.value = false
  }
}

const addTodo = async () => {
  if (!newTodoTitle.value.trim()) {
    ElMessage.warning('请输入待办事项内容')
    return
  }

  try {
    const { data, error } = await supabase
      .from('todos')
      .insert([{ title: newTodoTitle.value, completed: false }])
      .select()
      .maybeSingle()

    if (error) throw error
    if (data) {
      todos.value.unshift(data)
      newTodoTitle.value = ''
      ElMessage.success('添加成功')
    }
  } catch (error) {
    ElMessage.error('添加失败')
    console.error('Error adding todo:', error)
  }
}

const toggleTodo = async (todo: Todo) => {
  try {
    const { error } = await supabase
      .from('todos')
      .update({ completed: !todo.completed })
      .eq('id', todo.id)

    if (error) throw error
    todo.completed = !todo.completed
    ElMessage.success(todo.completed ? '已完成' : '已取消完成')
  } catch (error) {
    ElMessage.error('更新失败')
    console.error('Error toggling todo:', error)
  }
}

const deleteTodo = async (id: string) => {
  try {
    const { error } = await supabase
      .from('todos')
      .delete()
      .eq('id', id)

    if (error) throw error
    todos.value = todos.value.filter(t => t.id !== id)
    ElMessage.success('删除成功')
  } catch (error) {
    ElMessage.error('删除失败')
    console.error('Error deleting todo:', error)
  }
}

onMounted(() => {
  fetchTodos()
})
</script>

<template>
  <div class="todo-container">
    <el-card class="todo-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <h2>待办事项</h2>
          <el-tag type="info">{{ todos.length }} 项任务</el-tag>
        </div>
      </template>

      <div class="add-todo">
        <el-input
          v-model="newTodoTitle"
          placeholder="添加新的待办事项..."
          size="large"
          @keyup.enter="addTodo"
        >
          <template #append>
            <el-button type="primary" @click="addTodo" :loading="loading">
              添加
            </el-button>
          </template>
        </el-input>
      </div>

      <el-divider />

      <el-space direction="vertical" :size="10" style="width: 100%">
        <el-empty v-if="!loading && todos.length === 0" description="暂无待办事项" />

        <div v-for="todo in todos" :key="todo.id" class="todo-item">
          <el-card :body-style="{ padding: '12px 16px' }">
            <div class="todo-content">
              <div class="todo-left">
                <el-checkbox
                  :model-value="todo.completed"
                  @change="toggleTodo(todo)"
                  size="large"
                />
                <span
                  :class="['todo-title', { completed: todo.completed }]"
                  @click="toggleTodo(todo)"
                >
                  {{ todo.title }}
                </span>
              </div>

              <div class="todo-actions">
                <el-tag v-if="todo.completed" type="success" size="small" :icon="Check">
                  已完成
                </el-tag>
                <el-tag v-else type="warning" size="small" :icon="Close">
                  未完成
                </el-tag>
                <el-button
                  type="danger"
                  :icon="Delete"
                  circle
                  size="small"
                  @click="deleteTodo(todo.id)"
                />
              </div>
            </div>
          </el-card>
        </div>
      </el-space>
    </el-card>
  </div>
</template>

<style scoped>
.todo-container {
  max-width: 800px;
  margin: 40px auto;
  padding: 0 20px;
}

.todo-card {
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

.add-todo {
  margin-bottom: 20px;
}

.todo-item {
  width: 100%;
  transition: transform 0.2s;
}

.todo-item:hover {
  transform: translateX(4px);
}

.todo-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.todo-left {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.todo-title {
  font-size: 16px;
  color: #303133;
  cursor: pointer;
  user-select: none;
  transition: color 0.3s;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.todo-title.completed {
  color: #909399;
  text-decoration: line-through;
}

.todo-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

@media (max-width: 600px) {
  .todo-container {
    margin: 20px auto;
  }

  .todo-content {
    flex-direction: column;
    align-items: flex-start;
  }

  .todo-actions {
    width: 100%;
    justify-content: flex-end;
  }
}
</style>
