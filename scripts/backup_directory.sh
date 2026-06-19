#!/bin/bash

# בדיקה אם התקבלו הפרמטרים הדרושים
if [ "$#" -ne 2 ]; then
    echo "שגיאה: יש לספק נתיב לתיקייה לגיבוי ונתיב ליעד הגיבוי."
    echo "שימוש: $0 <source_directory> <destination_directory>"
    exit 1
fi

SOURCE_DIR=$1
DEST_DIR=$2

# בדיקה אם תיקיית המקור קיימת
if [ ! -d "$SOURCE_DIR" ]; then
    echo "שגיאה: תיקיית המקור אינה קיימת: $SOURCE_DIR"
    exit 1
fi

# יצירת תיקיית היעד אם היא לא קיימת
mkdir -p "$DEST_DIR"

# יצירת שם קובץ הגיבוי עם חותמת זמן
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="backup_$(basename "$SOURCE_DIR")_$TIMESTAMP.tar.gz"

echo "מתחיל בגיבוי התיקייה $SOURCE_DIR..."
tar -czf "$DEST_DIR/$BACKUP_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -eq 0 ]; then
    echo "הגיבוי הושלם בהצלחה!"
    echo "קובץ הגיבוי נשמר ב: $DEST_DIR/$BACKUP_NAME"
else
    echo "שגיאה: הגיבוי נכשל."
    exit 1
fi
