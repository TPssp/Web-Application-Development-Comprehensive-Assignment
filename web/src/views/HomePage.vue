<template>
  <!-- 主体布局 -->
  <el-container class="common-layout">
    <!-- 头部 -->
    <el-header class="header">
      <!-- 修改密码按钮 -->
      <div class="button" @click="changePassword">
        <el-icon>
          <EditPen/>
        </el-icon>
        <span>修改密码</span>
      </div>
      <!-- 退出登录按钮 -->
      <div class="button" @click="logout">
        <el-icon>
          <SwitchButton/>
        </el-icon>
        <span>退出登录</span>
      </div>
    </el-header>
    <!-- 内容区域 -->
    <el-container class="container">
      <!-- 侧边栏 -->
      <el-aside width="200px" class="aside">
        <el-col class="aside-content">
          <!-- 垂直菜单 -->
          <el-menu class="vertical-menu" default-active="1" :default-openeds="['1', '2', '3', '4']" >
            <!-- 班级学员管理 -->
            <el-sub-menu index="1">
              <template #title>
                <el-icon><User /></el-icon>
                <span >班级学员管理</span>
              </template>
              <!-- 班级管理 -->
              <el-menu-item index="1-1" @click="goto('/class')">班级管理</el-menu-item>
              <!-- 学员管理 -->
              <el-menu-item index="1-2" @click="goto('/stud')">学员管理</el-menu-item>
            </el-sub-menu>
            <!-- 系统信息管理 -->
            <el-sub-menu index="2">
              <template #title>
                <el-icon><Setting /></el-icon>
                <span>系统信息管理</span>
              </template>
              <!-- 部门管理 -->
              <el-menu-item index="2-1" @click="goto('/dept')">部门管理</el-menu-item>
              <!-- 员工管理 -->
              <el-menu-item index="2-2" @click="goto('/emp')">员工管理</el-menu-item>
            </el-sub-menu>
            <!-- 数据统计管理 -->
            <el-sub-menu index="3">
              <template #title>
                <el-icon><PieChart /></el-icon>
                <span>数据统计管理</span>
              </template>
              <!-- 员工信息统计 -->
              <el-menu-item index="3-1" @click="goto('/empstat')">员工信息统计</el-menu-item>
              <!-- 学员信息统计 -->
              <el-menu-item index="3-2" @click="goto('/studstat')">学员信息统计</el-menu-item>
            </el-sub-menu>
            <!-- 课程教务管理 -->
            <el-sub-menu index="4">
              <template #title>
                <el-icon><More /></el-icon>
                <span>课程教务管理</span>
              </template>
              <!-- 课程管理 -->
              <el-menu-item index="4-1" @click="goto('/course')">课程管理</el-menu-item>
              <!-- 课程安排 -->
              <el-menu-item index="4-2" @click="goto('/schedule')">课程安排</el-menu-item>
            </el-sub-menu>
          </el-menu>
        </el-col>
      </el-aside>
      <!-- 主要内容 -->
      <el-main class="main-content">
        <!-- 路由视图 -->
        <router-view/>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import {
  User,
  Tools,
  TrendCharts,
  Management,
  SwitchButton,
  EditPen,
  HomeFilled,
  Avatar,
  Setting,
  PieChart,
  More
} from '@element-plus/icons-vue'
import {useRouter} from 'vue-router'

const router = useRouter()

// 跳转至指定路由
function goto(path) {
  router.push(path)
}

// 修改密码
function changePassword() {
  // 在此处实现修改密码的逻辑
}

// 退出登录
function logout() {
  // 清除本地存储的用户信息等操作
  localStorage.removeItem('token')
  // 跳转至登录页面
  router.push('/')
}
</script>

<style scoped>
.common-layout {
  height: 700px;
  border: 1px solid #eee;
}

.header {
  display: flex;
  justify-content: right;
  align-items: center;
  font-size: 20px; 
  background-color: rgb(70, 76, 91); color: white}

.button {
  display: flex;
  align-items: center;
  font-size: 16px;
  cursor: pointer;
  margin-left: 10px;
}

.button:hover {
  color: #0b6acc;
}

.aside {
  width:200px;
}

.vertical-menu {
  font-size: 1.3rem;
}

.main-content {
  flex: 1;
}

.button p {
  margin: 30px;
}
</style>
