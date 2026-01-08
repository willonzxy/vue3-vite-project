<script setup lang="ts">
import { ref } from 'vue'
import { Document, List } from '@element-plus/icons-vue'
import TodoList from './components/TodoList.vue'
import FruitInventory from './components/FruitInventory.vue'

type PageType = 'todo' | 'fruit'
const currentPage = ref<PageType>('fruit')

const menuItems = [
  { label: '待办事项', value: 'todo', icon: List },
  { label: '水果库存', value: 'fruit', icon: Document }
]
</script>

<template>
  <div class="app-container">
    <div class="sidebar">
      <div class="logo">
        <h1>管理系统</h1>
      </div>
      <div class="menu">
        <div
          v-for="item in menuItems"
          :key="item.value"
          :class="['menu-item', { active: currentPage === item.value }]"
          @click="currentPage = item.value as PageType"
        >
          <component :is="item.icon" class="menu-icon" />
          <span>{{ item.label }}</span>
        </div>
      </div>
    </div>

    <div class="main-content">
      <TodoList v-if="currentPage === 'todo'" />
      <FruitInventory v-if="currentPage === 'fruit'" />
    </div>
  </div>
</template>

<style scoped>
.app-container {
  display: flex;
  height: 100vh;
  background-color: #f5f7fa;
}

.sidebar {
  width: 250px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  overflow-y: auto;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
}

.logo {
  padding: 30px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.logo h1 {
  margin: 0;
  font-size: 22px;
  font-weight: 600;
  text-align: center;
}

.menu {
  padding: 20px 0;
}

.menu-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-left: 3px solid transparent;
  color: rgba(255, 255, 255, 0.8);
}

.menu-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.menu-item.active {
  background-color: rgba(255, 255, 255, 0.2);
  border-left-color: white;
  color: white;
}

.menu-icon {
  font-size: 20px;
}

.main-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

@media (max-width: 768px) {
  .app-container {
    flex-direction: column;
  }

  .sidebar {
    width: 100%;
    height: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .logo {
    padding: 15px 20px;
    border-bottom: none;
    border-right: 1px solid rgba(255, 255, 255, 0.2);
  }

  .logo h1 {
    font-size: 18px;
  }

  .menu {
    display: flex;
    padding: 0;
    flex: 1;
  }

  .menu-item {
    flex: 1;
    border-left: none;
    border-bottom: 3px solid transparent;
    padding: 12px;
    justify-content: center;
  }

  .menu-item.active {
    border-left: none;
    border-bottom-color: white;
  }
}
</style>
