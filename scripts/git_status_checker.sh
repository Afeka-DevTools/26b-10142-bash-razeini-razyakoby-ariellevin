#!/bin/bash

echo -e "\n--- בדיקת סטטוס Git לתת-תיקיות ---"
read -p "הכנס את נתיב תיקיית האב (ברירת מחדל - .): " parent_dir
parent_dir=${parent_dir:-.}

if [ ! -d "$parent_dir" ]; then
    echo "שגיאה: התיקייה לא קיימת!"
    exit 1
