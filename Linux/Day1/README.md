df
# Day 1: Linux Fundamentals (CLI, Filesystem, Users, Processes)

**Student:** Nihar  
**Date:** 24 February 2026  
**Course:** CloudMalven Linux Mastery  

---

## 📋 Overview
Completed all **4 mandatory Hands-On Labs** from the Day 1 PDF.

---

## ✅ Labs Completed

| Lab | Task | Status | Screenshot |
|-----|------|--------|------------|
| Lab 1 | User Management (create, switch, verify) | ✅ Done | [Lab1_CreateUser.jpg](Lab1_CreateUser.jpg)<br>[Lab1_SwitchUser.jpg](Lab1_SwitchUser.jpg) |
| Lab 2 | File Permissions & Ownership (chmod, chown, test access) | ✅ Done | [Lab1_Permission.jpg](Lab1_Permission.jpg) |
| Lab 3 | Process Control (background + kill) | ✅ Done | [Lab1_BackgroundProcess+Killprocess.jpg](Lab1_BackgroundProcess+Killprocess.jpg) |
| Lab 4 | Text Editor (vim) | ✅ Done | [Lab1_Vim.jpg](Lab1_Vim.jpg)<br>[Lab1_Cat.jpg](Lab1_Cat.jpg) |

---

## 📁 Files Created

```bash
Linux/Day1/
├── myfile.txt
├── practice.txt
├── README.md
├── Lab1_CreateUser.jpg
├── Lab1_SwitchUser.jpg
├── Lab1_Permission.jpg
├── Lab1_Cat.jpg
├── Lab1_BackgroundProcess+Killprocess.jpg
└── Lab1_Vim.jpg
```
---

## 🛠 Key Commands Demonstrated

```bash
# Lab 1 - User Management
sudo adduser testuser
su - testuser
whoami

# Lab 2 - Permissions
touch myfile.txt
chmod 644 myfile.txt
sudo chown testuser:testuser myfile.txt
su - testuser && cat myfile.txt

# Lab 3 - Processes
sleep 300 &
ps
kill <>

# Lab 4 - vim
vim practice.txt
# (i → insert text → Esc → :wxx))
cat practice.txt
