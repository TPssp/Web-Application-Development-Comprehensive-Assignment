# Web Application Development Comprehensive Assignment

This repository contains the frontend and backend files for a web application developed as a comprehensive assignment for the Web Application Development Technology course. The application includes various management and statistical functionalities.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Introduction
This web application is developed as part of the course requirements for the Web Application Development Technology course at Harbin Institute of Technology, Weihai. The project aims to enhance students' skills in developing web applications independently, including system analysis and design.

## Features
The application includes the following functionalities:
1. **Department Management**
   - Query departments
   - Add new department
   - Edit department details
   - Delete department

2. **Employee Management**
   - Query employees
   - View employee details
   - Add new employee
   - Edit employee details
   - Delete employee
   - Upload employee image

3. **Class Management**
   - Query classes
   - View class details
   - Add new class
   - Edit class details
   - Delete class

4. **Student Management**
   - Query students
   - View student details
   - Add new student
   - Edit student details
   - Delete student
   - Handle student disciplinary actions

5. **Course Management**
   - Query courses
   - View course details
   - Add new course
   - Edit course details
   - Delete course

6. **Course Scheduling**
   - Query course schedules
   - View course schedule details
   - Edit course schedule

7. **Statistics**
   - Employee statistics by gender and position
   - Student statistics by gender and education background

8. **Authentication**
   - User login with JWT

## Technologies Used
The project uses the following technologies:
- **Frontend:** HTML, CSS, JavaScript, Vue
- **Backend:** Java, Spring Boot
- **Database:** MySQL
- **Authentication:** JWT (JSON Web Tokens)

## Installation
Follow these steps to set up the project locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/yourrepository.git
   cd yourrepository
   ```

2. **Backend Setup:**
   - Ensure you have Java and Maven installed.
   - Configure the `application.properties` file with your MySQL database details.
   - Build and run the Spring Boot application:
     ```bash
     mvn clean install
     mvn spring-boot:run
     ```

3. **Frontend Setup:**
   - Open the frontend directory.
   - Serve the frontend files using a web server or directly open `index.html` in a browser.

## Usage
1. Access the application via your browser.
2. Log in using the credentials provided (or register a new account if registration is implemented).
3. Navigate through the different sections (Department Management, Employee Management, etc.) to use the respective functionalities.

## License
This project is for educational purposes only. Please do not distribute it without permission.

---

Feel free to modify this README to better suit your needs or add more specific instructions if necessary.
