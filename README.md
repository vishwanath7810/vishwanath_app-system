# 🎓 Vishwanath App – College ERP System

A production-level College ERP System built using **Flutter, Riverpod, Firebase & Firestore**.

This application supports multi-role authentication, department-based access control, employee management, and real-time student activity tracking.

---

## 🚀 Features

### 🔐 Multi-Role Authentication
- Admin
- Teacher (Sub Admin)
- Student
- Canteen Staff
- Librarian
- General Staff

Role-based routing using Riverpod and Firebase Auth.

---

### 🏢 Department Management
- Admin can create, update, delete departments
- Teachers are assigned to specific departments
- Students register under departments
- Department-based access control enforced via Firestore security rules

---

### 👨‍🏫 Teacher Dashboard
- View active students in real-time
- Department-specific filtering
- Secure access to only assigned department students
- Live login status tracking (`isActive`)

---

### 👑 Admin Panel
- Department CRUD operations
- Employee registration & management
- Assign roles and departments
- Full system-level control

---

### 👨‍🎓 Student Module
- Department-based registration
- Secure authentication
- Real-time active status tracking

---

### 🔐 Security
- Firestore role-based access rules
- Department-level read permissions
- Secret scanning enabled
- Dependabot alerts enabled
- Secure authentication flow

---

## 🛠 Tech Stack

| Technology | Usage |
|------------|--------|
| Flutter | Frontend Framework |
| Riverpod | State Management |
| Firebase Auth | Authentication |
| Cloud Firestore | Database |
| Git & GitHub | Version Control |
| GitHub Releases | Versioning |

---

## 🏗 Architecture Overview
lib/
├── models/
├── services/
├── providers/
├── presentation/
│ ├── admin/
│ ├── teacher/
│ ├── student/
│ └── auth/



- Clean modular structure
- Service-based Firebase integration
- Role-based router system
- Secure Firestore rule architecture

---

## 📈 Version History

### 🔖 v1.1 – Multi Role ERP Update
- Implemented multi-role authentication
- Department-based teacher filtering
- Active student real-time tracking
- Employee management module
- Firestore security improvements

---

## 🎯 Future Improvements

- Attendance Management System
- Student Analytics Dashboard
- File Upload System
- Notification Module
- Deployment to Play Store

---

## 👨‍💻 Developer

**Vishwanath Todkar**  
Application Developer | MCA Student  

GitHub: https://github.com/vishwanath7810  

---

## 📜 License

This project is built for educational and portfolio purposes.
