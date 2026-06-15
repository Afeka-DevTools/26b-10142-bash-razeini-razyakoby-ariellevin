#!/bin/bash

echo -e "\n--- בדיקת סטטוס Git לתת-תיקיות ---"
read -p "הכנס את נתיב תיקיית האב (ברירת מחדל - .): " parent_dir
parent_dir=${parent_dir:-.}

# בדיקה אם התיקייה קיימת
if [ ! -d "$parent_dir" ]; then
    echo "שגיאה: התיקייה לא קיימת!"
    exit 1
fi

echo -e "\nסורק מאגרי Git בתוך: $parent_dir\n"
found_any=0

# מעבר על כל תת-התיקיות בתוך תיקיית האב
for dir in "$parent_dir"/*/; do
    # מניעת שגיאה במקרה שהתיקייה ריקה והתו * נשאר כתוטרל
    [ -e "$dir" ] || continue

    # בדיקה האם קיימת תת-תיקיית .git בפנים
    if [ -d "${dir}.git" ]; then
        found_any=1
        repo_name=$(basename "$dir")
        echo "========================================"
        echo "📌 מאגר: $repo_name"
        echo "========================================"
        
        # הרצת הסטטוס בצורה קומפקטית מבלי לשנות את תיקיית העבודה הנוכחית של הסקריפט
        git -C "$dir" status -s
        
        # אם הסטטוס נקי לחלוטין (אין פלט), נדפיס הודעה ידידותית
        if [ $? -eq 0 ] && [ -z "$(git -C "$dir" status -s)" ]; then
            echo "Working directory clean ✨"
        fi
        echo ""
    fi
done

if [ $found_any -eq 0 ]; then
    echo "לא נמצאו תת-תיקיות שהן מאגרי Git בנתיב שצוין."
fi
