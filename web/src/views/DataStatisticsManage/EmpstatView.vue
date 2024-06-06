<template>
  <div class="page-wrapper">
    <div class="header">
      员工信息统计
    </div>
    <div class="emp-data-wrapper">
      <div id="genderCount"></div>
      <div id="jobCount"></div>
    </div>
  </div>
</template>

<script setup>
import * as echarts from 'echarts'; // 导入echarts库
import apiAxios from '@/api/ApiAxios.js'; // 导入接口请求函数
import { onMounted } from 'vue'; // 导入Vue的onMounted钩子函数

let echart = echarts; // 定义echart变量

// 初始化性别统计图表
async function initGenderChart() {
  let label = [];
  let data = [];
  try {
    const res = await apiAxios({
      url: "/emp/genderCount",
      method: 'get'
    });
    for (let key in res.data.data) {
      label.push(key);
      data.push({
        value: res.data.data[key],
        name: key
      });
    }
  } catch (err) {
    console.log(err);
  }

  let genderChart = echart.init(document.getElementById("genderCount"));

  let option = {
    title: {
      text: '员工性别统计',
      x: 'center',
      textStyle: {
        fontSize: 20, // 调整字体大小
        fontFamily: 'Arial, sans-serif' // 更改字体
      }
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      top: '5%',
      left: 'center'
    },
    series: [
      {
        name: '性别',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: false,
          position: 'center'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: 20,
            fontWeight: 'bold'
          }
        },
        labelLine: {
          show: false
        },
        data: data
      }
    ]
  };
  genderChart.setOption(option);
  window.onresize = function () {
    genderChart.resize();
  };
}

// 初始化职位统计图表
async function initJobChart() {
  let label = [];
  let data = [];
  try {
    const res = await apiAxios({
      url: "/emp/jobCount",
      method: 'get'
    });
    for (let key in res.data.data) {
      label.push(key);
      data.push(res.data.data[key]);
    }
  } catch (err) {
    console.log(err);
  }
  let jobChart = echart.init(document.getElementById("jobCount"));
  let option = {
    title: {
      text: '员工职位统计',
      x: 'center',
      textStyle: {
        fontSize: 20, // 调整字体大小
        fontFamily: 'Arial, sans-serif' // 更改字体
      }
    },
    tooltip: {
      trigger: 'item'
    },
    xAxis: {
      data: label,
      axisLabel: {
        color: '#000', // 设置横坐标标签颜色
        rotate: 0, // 如果标签太长，可以旋转以避免重叠
        fontFamily: 'Arial, sans-serif' // 更改字体
      },
      axisLine: {
        show: true,
        lineStyle: {
          color: '#000' // 设置横坐标线条颜色
        }
      },
      axisTick: {
        show: false
      }
    },
    yAxis: {
      axisLine: {
        show: false
      },
      axisTick: {
        show: false
      },
      axisLabel: {
        color: '#999',
        fontFamily: 'Arial, sans-serif' // 更改字体
      }
    },
    dataZoom: [
      {
        type: 'inside'
      }
    ],
    series: [
      {
        type: 'bar',
        itemStyle: {
          color: '#5470C6', // 设定柱状颜色
          borderRadius: [10, 10, 0, 0] // 圆角
        },
        emphasis: {
          itemStyle: {
            color: '#5470C6' // 强调时的颜色
          }
        },
        data: data
      }
    ]
  };
  jobChart.setOption(option);
  window.onresize = function () {
    jobChart.resize();
  };
}

// 在组件挂载后调用初始化函数
onMounted(() => {
  initGenderChart();
  initJobChart();
});
</script>

<style scoped>
.page-wrapper {
  position: relative;
}

.header {
  position: absolute;
  top: 10px;
  left: 20px;
  font-size: 24px;
  font-weight: bold;
  color: #007BFF;
}

.emp-data-wrapper {
  display: flex;
  margin-top: 10px; /* 调整以避免遮挡标题 */
}

#genderCount {
  margin-top: 150px;
  width: 400px; /* 调整宽度 */
  height: 400px; /* 调整高度 */
}

#jobCount {
  margin-top: 150px;
  width: 500px; /* 调整宽度 */
  height: 400px; /* 调整高度 */
  margin-left: 150px;
}
</style>
