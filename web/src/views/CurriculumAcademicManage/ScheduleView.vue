<template>
  <div class="mainBox">
    <!-- 内容标题 -->
    <ContentHeader content="课程安排"></ContentHeader>

    <!-- 查询表单 -->
    <div class="query">
      <el-form :inline="true" :model="queryForm" class="demo-form-inline" style="margin-bottom: 10px">
        <el-form-item label="课程名称">
          <el-input v-model="queryForm.name" placeholder="请输入课程名称" style="width: 130px;" clearable />
        </el-form-item>
        <el-form-item label="授课教师">
          <el-select v-model="queryForm.teacher" filterable clearable placeholder="请选择" style="width: 120px;">
            <el-option v-for="item in empList" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmit">查询</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="padded-element">
      <!-- 批量删除按钮 -->
      <el-button type="primary" @click="handleAdd">+&nbsp;添加安排</el-button>
      <el-button type="primary" @click="handleBatchDelete">-&nbsp;批量删除</el-button>
    </div>
    <!-- 课程信息表格 -->
    <div class="info-table">
      <el-table :data="tableData" border style="width: 100%;" :fit="true" @selection-change="handleSelectionChange" :header-cell-style="{ background: '#f2f2f2', fontWeight: 'bold' }">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column property="courseNo" label="课程代码" align="center" />
        <el-table-column property="courseName" label="课程名称" align="center" />
        <el-table-column property="teachers" label="授课教师" align="center" />
        <el-table-column label="操作" align="center" width="250">
          <template #default="scope">
            <el-button size="small" type="primary" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页器 -->
    <div class="foot-pagination">
      <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" background :page-sizes="[10, 20, 50, 100]" layout="slot, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange" @current-change="handleCurrentChange">
        <template #default>
          <span class="el-pagination__total">共{{ total }}条数据</span>
        </template>
        <template #jumper>
          <span>前往{{ jumper }}页</span>
        </template>
      </el-pagination>
    </div>

    <!-- 批量删除对话框 -->
    <el-dialog v-model="dialogBatchVisible" width="500">
      <ContentHeader content="批量删除课程"></ContentHeader>
      <div class="info-message">您确定要批量删除这些课程安排吗？</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="confirmDelete(1)">确定</el-button>
          <el-button @click="dialogBatchVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 删除课程对话框 -->
    <el-dialog v-model="dialogVisible" width="500">
      <ContentHeader content="删除课程"></ContentHeader>
      <div class="info-message">您确定要删除该课程安排吗?</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="confirmDelete(0)">确定</el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 编辑课程对话框 -->
    <el-dialog v-model="dialogFormVisible" width="500">
      <ContentHeader content="编辑"></ContentHeader>
      <el-form :model="form" style="margin-top: 15px;" ref="ruleFormRef" :rules="rules">
        <el-form-item label="课程代码" :label-width="formWidth" :required="true">
          <el-input v-model="form.courseNo" placeholder="请输入课程代码" :disabled="true" style="width: 280px;" />
        </el-form-item>
        <el-form-item label="课程名称" :label-width="formWidth" :required="true">
          <el-input v-model="form.courseName" placeholder="请输入课程名称" :disabled="true" style="width: 280px;" />
        </el-form-item>
        <el-form-item label="授课教师" :label-width="formWidth" :required="true">
          <el-select v-model="form.teachersId" filterable clearable multiple placeholder="请选择" style="width: 280px;" @change="test()">
            <el-option v-for="item in empList" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="handleSave">保存</el-button>
          <el-button @click="dialogFormVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 添加课程对话框 -->
    <el-dialog v-model="dialogAddVisible" width="500">
      <ContentHeader content="添加安排"></ContentHeader>
      <el-form :model="form" style="margin-top: 15px;" ref="addFormRef" :rules="rules">
        <el-form-item label="课程代码" :label-width="formWidth" :required="true">
          <el-input v-model="form.courseNo" placeholder="请输入课程代码" style="width: 280px;" />
        </el-form-item>
        <el-form-item label="课程名称" :label-width="formWidth" :required="true">
          <el-input v-model="form.courseName" placeholder="请输入课程名称" style="width: 280px;" />
        </el-form-item>
        <el-form-item label="授课教师" :label-width="formWidth" :required="true">
          <el-select v-model="form.teachersId" filterable clearable multiple placeholder="请选择" style="width: 280px;">
            <el-option v-for="item in empList" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="handleAddSave">保存</el-button>
          <el-button @click="dialogAddVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue';
import ContentHeader from '../../components/ContentHeader.vue';
import apiAxios from '@/api/ApiAxios.js';
import { ElMessage } from 'element-plus';

// 翻页器变量
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(1);

// 授课教师下拉框选项
const empList = ref([]);
const empMap = {};

// 获取授课教师列表
async function getEmpList() {
  try {
    const res = await apiAxios({
      url: '/emp/list',
      method: 'get',
    });
    empList.value = res.data.data.map(item => {
      empMap[item.id] = item.name;
      return { label: item.name, value: item.id };
    });
  } catch (err) {
    console.log(err.message);
  }
}

// 查询表单数据
const queryForm = reactive({
  name: '',
  arranged: null,
  teacher: null,
});

// 课程信息表格数据
const tableData = ref([]);

// 获取课程列表
async function getCourseList() {
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      name: queryForm.name,
      arranged: queryForm.arranged,
      teacher: queryForm.teacher,
    };
    const res = await apiAxios({
      url: '/courseTeachers',
      method: 'get',
      params,
    });
    if (res.data.code === 200) {
      tableData.value = res.data.data.rows.map(row => {
        if (row.teacherIds) {
          row.teachersId = row.teacherIds.split(',').map(Number);
          row.teachers = row.teachersId.map(id => empMap[id]);
        } else {
          row.teachers = [];
        }
        return row;
      });
      total.value = res.data.data.total;
    } else {
      ElMessage.error(res.data.msg);
    }
  } catch (err) {
    console.log(err.message);
  }
}

// 批量删除对话框可见性
const dialogBatchVisible = ref(false);

// 删除课程对话框可见性
const dialogVisible = ref(false);

// 编辑课程对话框可见性
const dialogFormVisible = ref(false);

// 新增课程对话框可见性
const dialogAddVisible = ref(false);

// 编辑课程表单数据
const form = ref({});

// 保存编辑的课程信息
function handleSave() {
  apiAxios({
    url: '/courseTeachers',
    method: 'put',  // 修改为 PUT 方法
    data: {
      courseId: form.value.courseId,
      teachersId: form.value.teachersId,
    },
  })
  .then(res => {
    if (res.data.code === 200) {
      dialogFormVisible.value = false;
      ElMessage({
        message: '保存成功！',
        type: 'success',
      });
      getCourseList();
    } else {
      ElMessage.error(res.data.msg);
    }
  })
  .catch(err => {
    console.log(err.message);
  });
}

// 保存新增的课程信息
function handleAddSave() {
  apiAxios({
    url: '/courseTeachers',
    method: 'post',
    data: {
      courseNo: form.value.courseNo,
      courseName: form.value.courseName,
      teachersId: form.value.teachersId,
    },
  })
  .then(res => {
    if (res.data.code === 200) {
      dialogAddVisible.value = false;
      ElMessage({
        message: '添加成功！',
        type: 'success',
      });
      getCourseList();
    } else {
      ElMessage.error(res.data.msg);
    }
  })
  .catch(err => {
    console.log(err.message);
  });
}

// 查询课程列表
const onSubmit = () => {
  getCourseList();
};

// 批量删除课程
function handleBatchDelete() {
  dialogBatchVisible.value = true;
}

// 处理选中课程的变化
const multipleSelection = ref([]);
const handleSelectionChange = val => {
  multipleSelection.value = val;
};

// 处理编辑课程
const handleEdit = (index, row) => {
  form.value = row;
  dialogFormVisible.value = true;
};

// 添加安排按钮点击事件
function handleAdd() {
  form.value = {
    courseNo: '',
    courseName: '',
    teachersId: [],
  };
  dialogAddVisible.value = true;
}

// 删除课程
const temp_id = ref(0);
const handleDelete = (index, row) => {
  temp_id.value = row.id;
  dialogVisible.value = true;
};

// 确认删除课程
function confirmDelete(type) {
  let ids = type ? multipleSelection.value.map(x => x.courseId).join(',') : temp_id.value;
  apiAxios({
    url: '/course/' + ids,
    method: 'delete',
  }).then(res => {
    if (res.data.code === 200) {
      ElMessage({
        message: '删除成功！',
        type: 'success',
      });
      getCourseList();
      dialogVisible.value = false;
      dialogBatchVisible.value = false;
    }
  });
}

// 处理分页大小变化
const handleSizeChange = val => {
  getCourseList();
};

// 处理当前页码变化
const handleCurrentChange = val => {
  getCourseList();
};

// 编辑课程对话框中的测试函数
function test() {
  console.log(form.value.teachersId);
}

// 确保在组件挂载时获取教师列表
onMounted(async () => {
  await getEmpList();
  getCourseList();
});
</script>

<style scoped>
.mainBox {
  position: relative;
  width: 100%;
  height: 100%;
}

.info-message {
  font-size: 18px;
  margin: 20px 20px 10px;
}

.query {
  height: 60px;
}

.demo-form-inline {
  display: flex;
  padding-top: 20px;
}

.demo-form-inline {
  --el-input-width: 100px;
}

.demo-form-inline {
  --el-select-width: 100px;
}

.tableInfo {
  margin-top: 20px;
}

.foot-pagination {
  position: absolute;
  bottom: 0px;
  right: 0px;
}

.padded-element {
  padding-top: 1em; /* 上方空白 */
  padding-bottom: 1em; /* 下方空白 */
}
</style>
