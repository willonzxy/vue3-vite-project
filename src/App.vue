<script setup lang="ts">
import { ref } from 'vue'
import { DocumentCopy, List, Setting } from '@element-plus/icons-vue'
import TodoList from './components/TodoList.vue'
import FruitInventory from './components/FruitInventory.vue'

type PageType = 'todo' | 'fruit'
const currentPage = ref<PageType>('fruit')
const isCollapse = ref(false)

const handleSelect = (key: string) => {
  currentPage.value = key as PageType
}
</script>

<template>
  <el-container class="app-container">
    <el-aside class="sidebar" :width="isCollapse ? '64px' : '250px'">
      <div class="logo-container">
        <div v-if="!isCollapse" class="logo-text">
          <h1>管理系统</h1>
        </div>
        <div v-else class="logo-icon">MS</div>
      </div>

      <el-menu
        :default-active="currentPage"
        :collapse="isCollapse"
        class="custom-menu"
        background-color="#667eea"
        text-color="#fff"
        active-text-color="#ffd700"
        @select="handleSelect"
      >
        <el-menu-item index="fruit">
          <DocumentCopy />
          <template #title>水果库存</template>
        </el-menu-item>
        <el-menu-item index="todo">
          <List />
          <template #title>待办事项</template>
        </el-menu-item>
        <el-divider style="margin: 10px 0; background-color: rgba(255, 255, 255, 0.2)" />
        <el-menu-item index="settings" disabled>
          <Setting />
          <template #title>系统设置</template>
        </el-menu-item>
      </el-menu>

      <div class="collapse-btn">
        <el-button
          :icon="isCollapse ? 'expand' : 'fold'"
          circle
          size="small"
          @click="isCollapse = !isCollapse"
        >
        </el-button>
      </div>
    </el-aside>

    <el-container class="main-wrapper">
      <el-header class="main-header">
        <div class="header-content">
          <h2>{{ currentPage === 'fruit' ? '水果库存管理' : '待办事项' }}</h2>
          <div class="user-info">
            <span>欢迎使用</span>
          </div>
        </div>
      </el-header>

      <el-main class="main-content">
        <TodoList v-if="currentPage === 'todo'" />
        <FruitInventory v-if="currentPage === 'fruit'" />
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
.app-container {
  height: 100vh;
  background-color: #f5f7fa;
}

.sidebar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow-y: auto;
  overflow-x: hidden;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
  transition: width 0.3s ease;

  :deep(.el-menu) {
    border-right: none;
    background-color: transparent;
  }

  :deep(.el-menu-item) {
    background-color: transparent !important;
    border-left: 3px solid transparent;
    transition: all 0.3s ease;

    &:hover {
      background-color: rgba(255, 255, 255, 0.1) !important;
    }

    &.is-active {
      background-color: rgba(255, 255, 255, 0.2) !important;
      border-left-color: #ffd700 !important;
    }
  }

  :deep(.el-menu-item.is-disabled) {
    opacity: 0.6;

    &:hover {
      background-color: transparent !important;
    }
  }

  :deep(.el-divider) {
    margin: 10px 0;
  }
}

.logo-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 80px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
}

.logo-text {
  color: white;
  text-align: center;
}

.logo-text h1 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
}

.logo-icon {
  width: 40px;
  height: 40px;
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 16px;
  font-weight: 600;
}

.custom-menu {
  padding: 10px 0;

  :deep(.el-menu-item) {
    padding-left: 16px !important;
    padding-right: 16px !important;
    height: 50px;
    line-height: 50px;

    .el-icon {
      font-size: 18px;
      margin-right: 12px;
    }
  }
}

.collapse-btn {
  display: flex;
  justify-content: center;
  padding: 15px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.2);

  :deep(.el-button) {
    border-color: rgba(255, 255, 255, 0.3);
    color: white;

    &:hover {
      border-color: rgba(255, 255, 255, 0.6);
      background-color: rgba(255, 255, 255, 0.1);
    }
  }
}

.main-wrapper {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.main-header {
  background-color: white;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
  padding: 0 30px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;

  h2 {
    margin: 0;
    font-size: 24px;
    color: #303133;
    font-weight: 600;
  }
}

.user-info {
  color: #606266;
  font-size: 14px;
}

.main-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

@media (max-width: 768px) {
  .sidebar {
    width: 64px !important;

    .logo-container {
      height: 60px;
    }

    :deep(.el-menu-item) {
      padding-left: 8px !important;
      padding-right: 8px !important;

      .el-icon {
        margin-right: 0;
      }
    }
  }

  .main-header {
    padding: 0 20px;

    h2 {
      font-size: 18px;
    }
  }

  .main-content {
    padding: 15px;
  }

  .collapse-btn {
    display: none;
  }
}
</style>
