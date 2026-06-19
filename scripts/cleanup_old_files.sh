#!/bin/bash

# בדיקה אם התקבלו כל הפרמטרים
if [ "$#" -ne 2 ]; then
    echo "שימוש: $0 <directory_path> <days>"
    exit 1
fi

TARGET_DIR=$1
DAYS=$2

# בדיקה אם התיקייה קיימת
if [ ! -d "$TARGET_DIR" ]; then
    echo "שגיאה: התיקייה אינה קיימת: $TARGET_DIR"
    exit 1
fi

# בדיקה שהפרמטר של הימים הוא מספר חיובי
if [[ ! "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "שגיאה: מספר הימים חייב להיות מספר שלם חיובי."
    exit 1
fi

echo "מחפש קבצים ישנים מ-$DAYS ימים בתיקייה $TARGET_DIR..."

# מציאת הקבצים והצגתם לפני מחיקה
FILES_TO_DELETE=$(find "$TARGET_DIR" -type f -mtime +"$DAYS")

if [ -z "$FILES_TO_DELETE" ]; then
    echo "לא נמצאו קבצים התואמים לקריטריון החיפוש."
    exit 0
fi

echo "הקבצים הבאים יימחקו:"
echo "$FILES_TO_DELETE"
echo "----------------------------------"

# ביצוע המחיקה בפועל
find "$TARGET_DIR" -type f -mtime +"$DAYS" -delete

echo "המחיקה הושלמה בהצלחה."
