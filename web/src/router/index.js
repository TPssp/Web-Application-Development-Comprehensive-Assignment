import {createRouter, createWebHistory} from 'vue-router';
import SignUpView from '@/views/SignUpView.vue';
import HomePage from '@/views/HomePage.vue';
import ClassManage from '@/views/ClassStudentManage/ClassView.vue';
import StudentManage from '@/views/ClassStudentManage/StudView.vue';
import DepartmentManage from '@/views/SysInfoManage/DeptView.vue';
import EmployeeManage from '@/views/SysInfoManage/EmpView.vue';
import EmpInfoManage from '@/views/DataStatisticsManage/EmpstatView.vue';
import StuInfoManage from '@/views/DataStatisticsManage/StudstatView.vue';
import CurriculumManage from '@/views/CurriculumAcademicManage/CourseView.vue';
import CurriculumArrange from '@/views/CurriculumAcademicManage/ScheduleView.vue';

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: SignUpView
        },
        {
            path: '/homePage',
            name: 'homePage',
            component: HomePage,
            children: [
                {
                    path: '/class',
                    component: ClassManage,
                },
                {
                    path: '/stud',
                    component: StudentManage,
                },
                {
                    path: '/dept',
                    component: DepartmentManage,
                },
                {
                    path: '/emp',
                    component:EmployeeManage,
                },
                {
                    path: '/empstat',
                    component: EmpInfoManage,
                },
                {
                    path: '/studstat',
                    component: StuInfoManage,
                },
                {
                    path: '/course',
                    component: CurriculumManage,
                },
                {
                    path: '/schedule',
                    component: CurriculumArrange,
                }
            ]
        },
    ]
})

export default router
