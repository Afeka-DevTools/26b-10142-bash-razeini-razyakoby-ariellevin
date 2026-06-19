#!/bin/bash

# בדיקה אם התקבל נתיב לפרויקט
if [ "$#" -ne 1 ]; then
    echo "שימוש: $0 <project_directory_path>"
    exit 1
fi

PROJECT_DIR=$1

# בדיקה אם התיקייה קיימת
if [ ! -d "$PROJECT_DIR" ]; then
    echo "שגיאה: התיקייה אינה קיימת: $PROJECT_DIR"
    exit 1
fi

echo "מתחיל בניקוי קבצים זמניים ותיקיות בנתיב: $PROJECT_DIR"
echo "--------------------------------------------------------"

# הגדרת האלמנטים למחיקה (קבצים ותיקיות נפוצים)
# ניתן להוסיף סיומות נוספות לפי הצורך
echo "מוחק תיקיות node_modules..."
find "$PROJECT_DIR" -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null

echo "מוחק תיקיות __pycache__ וקבצי .pyc..."
find "$PROJECT_DIR" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null
find "$PROJECT_DIR" -name "*.pyc" -type f -delete 2>/dev/null

echo "מוחק קבצי קומפילציה של Java (.class)..."
find "$PROJECT_DIR" -name "*.class" -type f -delete 2>/dev/null

echo "מוחק תיקיות build זמניות..."
find "$PROJECT_DIR" -name "build" -type d -exec rm -rf {} + 2>/dev/null

echo "--------------------------------------------------------"
echo "ניקוי הפרויקט הושלם בהצלחה!"
