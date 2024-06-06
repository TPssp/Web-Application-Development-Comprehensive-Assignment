/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80037
 Source Host           : localhost:3306
 Source Schema         : web

 Target Server Type    : MySQL
 Target Server Version : 80037
 File Encoding         : 65001

 Date: 20/05/2024 22:22:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班级名称',
  `classroom` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班级教室',
  `start_time` date NOT NULL COMMENT '开课时间',
  `end_time` date NOT NULL COMMENT '结课时间',
  `teacher_id` int UNSIGNED NOT NULL COMMENT '班主任',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  INDEX `class_emp_id_fk`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `class_emp_id_fk` FOREIGN KEY (`teacher_id`) REFERENCES `emp` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '班级表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `course_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程代码',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程名称',
  `attribute` tinyint UNSIGNED NOT NULL COMMENT '课程性质，1为必修，2为选修',
  `class_room` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上课教室',
  `score` float UNSIGNED NOT NULL COMMENT '学分',
  `total_time` int UNSIGNED NOT NULL COMMENT '学时',
  `teacher` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已有教师，0表示无，1表示又',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `course_id`(`course_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for course_arrange
-- ----------------------------
DROP TABLE IF EXISTS `course_arrange`;
CREATE TABLE `course_arrange`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` int UNSIGNED NOT NULL COMMENT '对应的课程的id',
  `teacher_id` int UNSIGNED NOT NULL COMMENT '授课教师的id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `course_arrange_course_id_fk`(`course_id` ASC) USING BTREE,
  INDEX `course_arrange_emp_id_fk`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `course_arrange_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `course_arrange_emp_id_fk` FOREIGN KEY (`teacher_id`) REFERENCES `emp` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程安排表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for emp
-- ----------------------------
DROP TABLE IF EXISTS `emp`;
CREATE TABLE `emp`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '123456' COMMENT '密码',
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `gender` tinyint UNSIGNED NOT NULL COMMENT '性别, 说明: 1 男, 2 女',
  `image` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'http://localhost:8080/upload/init.jpg' COMMENT '图像',
  `job` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '职位, 说明: 1 班主任,2 讲师, 3 学工主管, 4 教研主管, 5 咨询师',
  `entry_date` date NULL DEFAULT NULL COMMENT '入职时间',
  `dept_id` int UNSIGNED NULL DEFAULT NULL COMMENT '部门ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `emp_dept_id_fk`(`dept_id` ASC) USING BTREE,
  CONSTRAINT `emp_dept_id_fk` FOREIGN KEY (`dept_id`) REFERENCES `dept` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '员工表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `stu_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `class_id` int UNSIGNED NOT NULL COMMENT '所属班级',
  `gender` tinyint UNSIGNED NOT NULL COMMENT '性别, 说明: 1 男, 2 女',
  `telephone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `education` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最高学历，说明：1 初中, 2 高中, 3 大专, 4 本科, 5 硕士, 6 博士',
  `discipline_num` int UNSIGNED NULL DEFAULT 0 COMMENT '违纪次数',
  `discipline_score` int UNSIGNED NULL DEFAULT 0 COMMENT '违纪扣分',
  `update_time` datetime NOT NULL COMMENT '最后操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `stu_id`(`stu_id` ASC) USING BTREE,
  INDEX `student_class_id_fk`(`class_id` ASC) USING BTREE,
  CONSTRAINT `student_class_id_fk` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学员表' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
