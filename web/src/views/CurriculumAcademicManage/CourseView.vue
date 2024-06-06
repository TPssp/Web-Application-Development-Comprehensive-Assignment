以下是修改后的代码，包含课程名称可以包含汉字、数字、字母，不能超过30个字符的校验规则，以及课程容量和学分的字段限制。具体修改包括更新校验规则和输入事件处理函数。

```html
<template>
  <div class="mainBox">
    <ContentHeader content="课程管理"></ContentHeader>
    <div class="query">
      <el-form :inline="true" :model="queryForm" class="demo-form-inline">
        <el-form-item label="课程名称">
          <el-input v-model="queryForm.name" placeholder="请输入课程名称" style="width: 130px;" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmit">查询</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="padded-element">
      <el-button type="primary" @click="handleAdd">+ 添加课程</el-button>
      <el-button type="primary" @click="handleBatchDelete">- 批量删除</el-button>
    </div>
    <div class="info-table">
      <el-table :data="tableData" border style="width: 100%;" :fit="true" @selection-change="handleSelectionChange"
        :header-cell-style="{ background: '#f2f2f2', fontWeight: 'bold' }">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column property="courseId" label="课程编号" align="center" />
        <el-table-column property="name" label="课程名称" align="center" />
        <el-table-column property="attribute" label="课程性质" align="center" />
        <el-table-column property="totalTime" label="课程容量（学生人数）" align="center" />
        <el-table-column property="score" label="学分" align="center" />
        <el-table-column label="操作" align="center" width="250">
          <template #default="scope">
            <el-button size="small" type="primary" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div class="foot-pagination">
      <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" :page-sizes="[10, 20, 50, 100]"
        background layout="slot, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
        @current-change="handleCurrentChange">
        <template #default>
          <span class="el-pagination__total">共{{ total }}条数据</span>
        </template>
        <template #jumper>
          <span>前往{{ jumper }}页</span>
        </template>
      </el-pagination>
    </div>

    <el-dialog v-model="dialogBatchVisible" width="500">
      <ContentHeader content="批量删除课程"></ContentHeader>
      <div class="info-message">您确定要批量删除这些课程的信息吗 ?</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="confirmDelete(1)">
            确定
          </el-button>
          <el-button @click="dialogBatchVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="dialogVisible" width="500">
      <ContentHeader content="删除课程"></ContentHeader>
      <div class="info-message">您确定要删除该课程的信息吗？</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="confirmDelete(0)">
            确定
          </el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="dialogFormVisible" width="500">
      <ContentHeader :content="dialogContent"></ContentHeader>
      <el-form :model="form" style="margin-top: 15px;" ref="ruleFormRef" :rules="rules">
        <el-form-item label="课程编号" :label-width="formWidth" prop="courseId">
          <el-input v-model="form.courseId" placeholder="请输入课程代码" style="width: 280px;" />
        </el-form-item>
        <el-form-item label="课程名称" :label-width="formWidth" prop="name">
          <el-input v-model="form.name" placeholder="请输入课程名称" style="width: 280px;" />
        </el-form-item>
        <el-form-item label="课程性质" :label-width="formWidth" prop="attribute">
          <el-select v-model="form.attribute" filterable clearable placeholder="请选择" style="width: 280px;">
            <el-option v-for="item in attributeOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="学分" :label-width="formWidth" prop="score">
          <el-input v-model.number="form.score" placeholder="请输入课程学分" style="width: 280px;" @input="handleChange2" />
        </el-form-item>
        <el-form-item label="课程容量" :label-width="formWidth" prop="totalTime">
          <el-input v-model.number="form.totalTime" placeholder="请输入课程容量（学生人数）" style="width: 280px;" @input="handleChange1" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="handleSave(ruleFormRef)">
            保存
          </el-button>
          <el-button @click="dialogFormVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import ContentHeader from '../../components/ContentHeader.vue';
import apiAxios from '@/api/ApiAxios.js';
import { ElMessage } from 'element-plus';
import { reactive, ref } from 'vue';

// 处理输入改变事件，限制输入内容
const handleChange1 = (value) => {
  if (!/^[0-9]*$/.test(value)) {
    ElMessage.error("请输入数字！");
    form.totalTime = value.replace(/[^0-9]/g, '');
  } else {
    if (parseInt(value) > 300) {
      ElMessage.error("课程容量不能大于300！");
      form.totalTime = "300";
    }
  }
}

// 处理输入改变事件，限制输入内容
const handleChange2 = (value) => {
  if (!/^\d+(\.\d+)?$/.test(value) && value != '') {
    ElMessage.error('请输入小数或整数！');
    form.score = value.replace(/[^\d.]/g, '');
  } else {
    const floatValue = parseFloat(value);
    if (floatValue > 10) {
      ElMessage.error('学分不能大于10！');
      form.score = '10';
    }
  }
}

// 自定义校验规则：课程代码只能包含数字和字母
function validateId(rule, value) {
  const pattern = /^[A-Za-z0-9]+$/;
  if (!pattern.test(value)) {
    return Promise.reject('课程代码只能包含数字和字母');
  } else {
    return Promise.resolve();
  }
}

// 自定义校验规则：课程名称只能包含汉字、数字、字母，不能超过30个字符
function validateName(rule, value) {
  const pattern = /^[\u4e00-\u9fa5a-zA-Z0-9]+$/;
  if (!pattern.test(value) || value.length > 30) {
    return Promise.reject('课程名称只能包含汉字、数字、字母，且不超过30个字符');
  } else {
    return Promise.resolve();
  }
}

// 表单校验规则
const rules = reactive({
  courseId: [
    { required: true, message: '请输入课程代码', trigger: 'blur' },
    { min: 2, max: 20, message: '课程代码应为2-20位', trigger: 'blur' },
    { validator: validateId, trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入课程名称', trigger: 'blur' },
    { min: 1, max: 30, message: '课程名称应为1-30位', trigger: 'blur' },
    { validator: validateName, trigger: 'blur' }
  ],
  attribute: [
    { required: true, message: '请选择课程性质', trigger: 'change' },
  ],
  score: [
    { required: true, message: '请输入学分', trigger: 'blur' },
  ],
  totalTime: [
    { required: true, message: '请输入课程容量', trigger: 'blur' },
  ],
})

const ruleFormRef = reactive({
  id: '',
  courseId: '',
  name: '',
  attribute: '',
  score: '',
  totalTime: ''
})

// 初始化数据
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(1);
let attributeOptions = [
  {
    label: "考试课",
    value: 1,
  },
  {
    label: "考察课",
    value: 2,
  }
];
let attributeMap = {
  1: "考试课",
  2: "考察课"
};
const queryForm = reactive({
  name: "",
  attribute: null
})
const tableData = ref([]);

// 获取课程列表
function getCourseList() {
  let params = {
    page: currentPage.value,
    pageSize: pageSize.value,
    name: queryForm.name,
    attribute: queryForm.attribute
  }
  apiAxios({
    url: '/course',
    method: 'get',
    params
  }).then(res => {
    tableData.value = res.data.data.rows;
    tableData.value.forEach(x => {
      x.attribute = attributeMap[x.attribute];
    });
    total.value = res.data.data.total;
  }).catch(err => {
    console.log(err.message);
  })
}

// 查询按钮提交事件
function onSubmit() {
  currentPage.value = 1;
  getCourseList();
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val;
  getCourseList();
}

// 每页显示数改变
const handleSizeChange = (val) => {
  pageSize.value = val;
  getCourseList();
}

// 选中行变化
const handleSelectionChange = (val) => {
  multipleSelection.value = val;
}

// 添加课程
const handleAdd = () => {
  resetForm();
  dialogFormVisible.value = true;
  dialogContent.value = '添加课程';
}

// 编辑课程
const handleEdit = (index, row) => {

  Object.assign(form, row);
  form.id = row.id; // 添加这一行，确保编辑时绑定了正确的id
  // console.log(form.id)
  dialogFormVisible.value = true;
  dialogContent.value = '编辑课程';
}


// 保存课程
const handleSave = (formRef) => {
  
  formRef.validate((valid) => {
    
    if (valid) {
      
      let apiUrl = '/course';
      let method = 'post';
      if (form.id) {
        apiUrl = '/course';
        method = 'put';
      }
    
      apiAxios({
        url: apiUrl,
        method: method,
        data: form
      }).then(() => {
        
        dialogFormVisible.value = false;
        ElMessage.success('保存成功');
        getCourseList();
      }).catch(err => {
        console.log(err.message);
      })
    } else {
      return false;
    }
  })
}

// 删除课程
const handleDelete = (index, row) => {
  form.id = row.id;
  dialogVisible.value = true;
}

// 确认删除课程
const confirmDelete = (type) => {
  if (type === 0) {
    apiAxios({
      url: '/course/' + form.id,
      method: 'delete'
    }).then(() => {
      dialogVisible.value = false;
      ElMessage.success('删除成功');
      getCourseList();
    }).catch(err => {
      console.log(err.message);
    })
  } else {
    const ids = multipleSelection.value.map(item => item.id).join(',');
    apiAxios({
      url: '/course/batch',
      method: 'delete',
      data: { ids }
    }).then(() => {
      dialogBatchVisible.value = false;
      ElMessage.success('批量删除成功');
      getCourseList();
    }).catch(err => {
      console.log(err.message);
    })
  }
}

// 批量删除课程
const handleBatchDelete = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning('请选择要删除的课程');
    return;
  }
  dialogBatchVisible.value = true;
}

// 重置表单
const resetForm = () => {
  Object.assign(form, {
    id: null,
    courseId: '',
    name: '',
    attribute: null,
    score: '',
    totalTime: null
  });
}

const form = reactive({
  id: null,
  courseId: '',
  name: '',
  attribute: null,
  score: '',
  totalTime: null
})

const dialogFormVisible = ref(false);
const dialogVisible = ref(false);
const dialogBatchVisible = ref(false);
const dialogContent = ref('');
const formWidth = '90px';
const multipleSelection = ref([]);

getCourseList();

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
  padding-top: 1em;
  /* 上方空白 */
  padding-bottom: 1em;
  /* 下方空白 */
}
</style>
