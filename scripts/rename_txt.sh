#!/bin/bash

echo -e "\n--- הוספת תחילית לקבצי TXT ---"
read -p "הכנס את הנתיב המלא לתיקייה: " target_dir

if [ ! -d "$target_dir" ]; then
    echo "שגיאה: התיקייה לא קיימת!"
    exit 1
fi

read -p "הכנס את התחילית הרצויה: " prefix
count=0

for file in "$target_dir"/*.txt; do
    if [ ! -f "$file" ]; then
        echo "לא נמצאו קבצי .txt בתיקייה זו."
        break
    fi
    filename=$(basename "$file")
    mv "$file" "$target_dir/${prefix}${filename}"
    ((count++))
done
echo "הפעולה הושלמה. שונו שמות של $count קבצים."
