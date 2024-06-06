<template>
  <div class="mainBox">
    <!-- 内容头部组件 -->
    <ContentHeader content="学员管理"></ContentHeader>

    <!-- 查询条件表单 -->
    <div class="query">
      <el-form :inline="true" :model="formQuery" class="demo-form-inline">
        <el-form-item label="学员姓名">
          <el-input v-model="formQuery.name" placeholder="请输入学员姓名" style="width: 120px;" clearable/>
        </el-form-item>
        <el-form-item label="学号">
          <el-input v-model="formQuery.stuId" placeholder="请输入学号" style="width: 120px;" clearable/>
        </el-form-item>
        <el-form-item label="最高学历">
          <el-select
              v-model="formQuery.education"
              filterable
              clearable
              placeholder="请选择"
              style="width: 100px;">
            <el-option
                v-for="item in educationOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"/>
          </el-select>
        </el-form-item>
        <el-form-item label="所属班级">
          <el-select
              v-model="formQuery.classId"
              filterable
              clearable
              placeholder="请选择"
              style="width: 100px;">
            <el-option
                v-for="item in classOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"/>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmit">查询</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 添加学员按钮 -->
    <div class="padded-element">
      <el-button type="primary" @click="handleAdd" >+ 添加学员</el-button>

      <!-- 批量删除学员按钮 -->
      <el-button type="primary" @click="handleBatchDelete" >- 批量删除</el-button>
    </div>
    <!-- 学员信息表格 -->
    <div class="tableInfo">
      <el-table :data="tableData" border style="width: 100%;height: calc(100vh - 300px);" :fit="true"
                @selection-change="handleSelectionChange" :header-cell-style="{ background: '#f2f2f2', fontWeight: 'bold' }">
        <!-- 多选框列 -->
        <el-table-column type="selection" width="55" align="center"/>
        <el-table-column property="name" label="姓名" align="center"/>
        <el-table-column property="stuId" width="110" label="学号" align="center"/>
        <el-table-column property="class" width="150" label="班级" align="center"/>
        <el-table-column property="genderName" width="80" label="性别" align="center"/>
        <el-table-column property="telephone" width="140" label="手机号" align="center"/>
        <el-table-column property="educationName" label="最高学历" align="center"/>
        <el-table-column property="disciplineNum" label="违纪次数" align="center"/>
        <el-table-column property="disciplineScore" label="违纪扣分" align="center"/>
        <el-table-column property="updateTime" label="最后操作时间" :formatter="dateFormatter" align="center"/>
        <!-- 操作列 -->
        <el-table-column label="操作" align="center" width="200">
          <template #default="scope">
            <!-- 编辑按钮 -->
            <el-button size="small" type="primary" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
            <!-- 违纪按钮 -->
            <el-button size="small" type="warning" @click="handleIndiscipline(scope.$index, scope.row)">违纪</el-button>
            <!-- 删除按钮 -->
            <el-button size="small" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页组件 -->
    <div class="foot-pagination">
      <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="slot, sizes, prev, pager, next, jumper"
          background
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange">
        <!-- 自定义显示总条数 -->
        <template #default>
          <span class="el-pagination__total">共{{ total }}条数据</span>
        </template>
        <!-- 自定义跳转输入框文字 -->
        <template #jumper>
          <span>前往{{ jumper }}页</span>
        </template>
      </el-pagination>
    </div>

    <!-- 学员违纪处理对话框 -->
    <el-dialog
        v-model="disciplineVisible"
        width="500">
      <ContentHeader content="学员违纪处理"></ContentHeader>
      <div>
        <el-form style="margin-top: 15px;">
          <el-form-item label="违纪扣分" :label-width="formWidth">
            <el-input v-model="points" style="width: 280px;" @input="handleChange"/>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="handlePoints">
            确定
          </el-button>
          <el-button @click="disciplineVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 批量删除学员对话框 -->
    <el-dialog
        v-model="dialogDelVisible"
        width="500">
      <ContentHeader content="批量删除学员"></ContentHeader>
      <div class="info-message">您确定要批量删除这些学员的信息吗 ?</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="confirmDelete(1)">
            确定
          </el-button>
          <el-button @click="dialogDelVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 删除学员对话框 -->
    <el-dialog v-model="dialogVisible" width="500">
      <ContentHeader content="删除学员"></ContentHeader>
      <div class="info-message">您确定要删除该学员的信息吗？</div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="confirmDelete(0)">
            确定
          </el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 添加/编辑学员对话框 -->
    <el-dialog v-model="dialogFormVisible" width="500">
      <ContentHeader :content="dialogContent"></ContentHeader>
      <el-form :model="form" style="margin-top: 15px;" :rules="rules" :ref="ruleFormRef">
        <el-form-item label="姓名" :label-width="formWidth" prop="name">
          <el-input v-model="form.name" placeholder="请输入姓名" style="width: 280px;"/>
        </el-form-item>
        <el-form-item label="学号" :label-width="formWidth" prop="stuId">
          <el-input v-model="form.stuId" placeholder="请输入学号" style="width: 280px;"/>
        </el-form-item>
        <el-form-item label="性别" :label-width="formWidth" prop="gender">
          <el-select
              v-model="form.gender"
              filterable
              clearable
              placeholder="请选择"
              style="width: 280px;">
            <el-option
                v-for="item in genderOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"/>
          </el-select>
        </el-form-item>
        <el-form-item label="手机号" :label-width="formWidth" prop="telephone" >
          <el-input v-model="form.telephone" placeholder="请输入手机号" style="width: 280px;"/>
        </el-form-item>
        <el-form-item label="最高学历" :label-width="formWidth" >
          <el-select
              v-model="form.education"
              filterable
              clearable
              placeholder="请选择"
              style="width: 280px;">
            <el-option
                v-for="item in educationOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"/>
          </el-select>
        </el-form-item>
        <el-form-item label="所属班级" :label-width="formWidth" prop="classId">
          <el-select
              v-model="form.classId"
              filterable
              clearable
              placeholder="请选择"
              style="width: 280px;">
            <el-option
                v-for="item in classOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"/>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="handleSave">
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
import {ElMessage} from 'element-plus';
import {ref, reactive} from 'vue';
import moment from 'moment';

// 验证函数：用户名只能包含数字和字母
function validateId(rule, value) {
  const pattern = /^[A-Za-z0-9]+$/;
  return pattern.test(value) ? Promise.resolve() : Promise.reject('用户名只能包含数字和字母');
}

// 验证函数：姓名只能包含汉字
function validateName(rule, value) {
  const pattern = /^[\u4e00-\u9fa5]+$/;
  return pattern.test(value) ? Promise.resolve() : Promise.reject('姓名只能包含汉字');
}

// 验证函数：输入只能包含数字
function validateInput(rule, value) {
  const pattern = /^[0-9]+$/;
  return pattern.test(value) ? Promise.resolve() : Promise.reject('输入只能包含数字');
}

// 表单验证规则
const rules = reactive({
  name: [
    {required: true, message: '请输入学员姓名', trigger: 'blur'},
    {min: 2, max: 10, message: '姓名长度应为2-10', trigger: 'blur'},
    {validator: validateName, trigger: 'blur'}
  ],
  stuId: [
    {required: true, message: '请输入学号', trigger: 'blur'},
    {min: 10, max: 10, message: '学号应为10位', trigger: 'blur'},
    {validator: validateId, trigger: 'blur'}
  ],
  gender: [
    {required: true, message: '请选择性别', trigger: 'change'},
  ],
  telephone: [
    {required: true, message: '请输入手机号', trigger: 'blur'},
    {min: 11, max: 11, message: '手机号非法，应为11位', trigger: 'blur'},
    {validator: validateInput, trigger: 'blur'}
  ],
  classId: [
    {required: true, message: '请选择所属班级', trigger: 'change'},
  ],
});

// 日期格式化函数
const dateFormatter = (row) => {
  const updateTime = row.updateTime;
  const date = moment(updateTime);
  return date.format("YYYY-MM-DD HH:mm:ss");
}

// 当前页码、每页显示数量、总记录数
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(1);

// 性别选项和映射关系
const genderOptions = [
  {label: "男", value: 1},
  {label: "女", value: 2}
];
const genderMap = {1: "男", 2: "女"};

// 学历选项
const educationOptions = [
    {label: "初中", value: 1},
    {label: "高中", value: 2},
    {label: "大专", value: 3},
    {label: "本科", value: 4},
    {label: "硕士", value: 5},
    {label: "博士", value: 6},
  ];
  const educationMap = {
    1: "初中",
    2: "高中",
    3: "大专",
    4: "本科",
    5: "硕士",
    6: "博士"
  };
// 是否显示处分对话框、处分值和学员ID
const disciplineVisible = ref(false);
const points = ref(0);
const points_id = ref(null);

// 处理处分
function handlePoints() {
  apiAxios({
    url: '/student/points',
    method: 'put',
    data: {id: points_id.value, points: points.value}
  }).then(res => {
    if (res.data.code === 200) {
      ElMessage({message: "处理成功", type: "success"});
      disciplineVisible.value = false;
      getStudentList();
    }
  });
}

// 处理输入变化
const handleChange = (value) => {
  if (!/^[0-9]*$/.test(value)) {
    ElMessage.error("请输入数字！");
    points.value = value.replace(/[^0-9]/g, '');
  } else {
    if (parseInt(value) > 100) {
      ElMessage.error("处分不能大于100！");
      points.value = "100";
    }
  }
}

// 班级选项和映射关系
const classOptions = ref([]);
const classMap = {};

// 获取班级列表
function getClassList() {
  apiAxios({
    url: '/class/list',
    method: 'get',
  }).then(res => {
    const temp_data = res.data.data;
    temp_data.forEach(x => {
      classOptions.value.push({label: x.name, value: x.id});
      classMap[x.id] = x.name;
    });
  }).catch(err => {
    console.log(err.message);
  });
}

getClassList();

// 表单查询条件
const formQuery = reactive({
  name: "",
  stuId: "",
  education: null,
  classId: null,
});

// 表格数据
const tableData = ref([]);

// 获取学员列表
function getStudentList() {
  const params = {
    page: currentPage.value,
    pageSize: pageSize.value,
    name: formQuery.name,
    stuId: formQuery.stuId,
    education: formQuery.education,
    classId: formQuery.classId
  };
  apiAxios({
    url: '/student',
    method: 'get',
    params
  }).then(res => {
    tableData.value = res.data.data.rows;
    tableData.value.forEach(x => {
      x.class = classMap[x.classId];
      x.genderName = genderMap[x.gender];
      x.educationName = educationMap[x.education];
    });
    total.value = res.data.data.total;
  }).catch(err => {
    console.log(err.message);
  });
}

getStudentList();

// 删除对话框可见性
const dialogDelVisible = ref(false);

// 对话框可见性、对话框内容、表单数据、表单可见性、表单标签宽度
const dialogVisible = ref(false);
const dialogContent = ref("添加学员");
const form = ref({});
const dialogFormVisible = ref(false);
const formWidth = '140px';

// 保存表单
function handleSave() {
      // 根据对话框内容判断请求方法
      let method = dialogContent.value === "添加学员" ? 'post' : 'put';
      
      // 调用接口保存数据
      apiAxios({
        url: "/student", // 接口地址
        method: method, // 请求方法
        data: form.value, // 表单数据
      })
      .then(res => {
        if (res.data.code === 200) { 
          ElMessage({
        message: dialogContent.value === '新增学员' ? '新增成功！' : '修改成功！',
        type: 'success',
      });
          getStudentList(); // 刷新学员列表
          dialogFormVisible.value = false;
        } else {
          // 保存失败
          ElMessage.error(res.data.msg); // 显示错误消息
        }
      })
    }


// 表格选择和操作处理函数
const multipleSelection = ref([]);
const handleSelectionChange = (val) => {
  multipleSelection.value = val;
};
const handleEdit = (index, row) => {
  apiAxios({
    url: "/student/" + row.id,
    method: 'get',
  }).then(res => {
    form.value = {
      ...res.data.data, // 将 API 返回的数据复制到 form 中
      education: educationMap[res.data.data.education] // 转换 education 为 educationName
    };
  }).catch(err => {
    console.log(err.message);
  });
  dialogContent.value = "编辑学员";
  dialogFormVisible.value = true;
};
const temp_id = ref(0);
const handleDelete = (index, row) => {
  temp_id.value = row.id;
  dialogVisible.value = true;
};

// 确认删除
function confirmDelete(type) {
  let ids = "";
  if (type) {
    multipleSelection.value.forEach(x => {
      if (ids === "") ids = x.id;
      else ids += "," + x.id;
    });
  } else {
    ids = temp_id.value;
  }
  apiAxios({
    url: "/student/" + ids,
    method: "delete",
  }).then(res => {
    if (res.data.code === 200) {
      ElMessage({message: '删除成功！', type: 'success'});
      getStudentList();
      dialogVisible.value = false;
      dialogDelVisible.value = false;
    }
  });
}

// 处理违纪
const handleIndiscipline = (index, row) => {
  points.value = 0;
  points_id.value = row.id;
  disciplineVisible.value = true;
};

// 分页大小变化和当前页码变化处理函数
const handleSizeChange = (val) => {
  getStudentList();
};
const handleCurrentChange = (val) => {
  getStudentList();
};

// 添加学员
function handleAdd() {
  // 重置表单，并添加 id 属性
  form.value = {
    id: null, // 添加 id 属性，设置为 null
    name: '', 
    stuId: '', 
    gender: null,
    telephone: '', 
    education: null, 
    classId: null 
  };
  // 设置对话框内容
  dialogContent.value = "添加学员";
  // 显示对话框
  dialogFormVisible.value = true;
}

// 批量删除
function handleBatchDelete() {
  // 显示批量删除对话框
  dialogDelVisible.value = true;
}

// 查询
const onSubmit = () => {
  getStudentList();
};

const ruleFormRef = ref(null);

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