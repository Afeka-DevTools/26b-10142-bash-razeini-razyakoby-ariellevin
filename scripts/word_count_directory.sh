#!/bin/bash

# בדיקה אם התקבל נתיב לתיקייה
if [ "$#" -ne 1 ]; then
    echo "שימוש: $0 <directory_path>"
    exit 1
fi

TARGET_DIR=$1

# בדיקה אם התיקייה קיימת
if [ ! -d "$TARGET_DIR" ]; then
    echo "שגיאה: התיקייה אינה קיימת: $TARGET_DIR"
    exit 1
fi

echo "מנתח קבצים בתיקייה: $TARGET_DIR"
echo "--------------------------------------------------"
echo -e "Lines\tWords\tBytes\tFile Name"
echo "--------------------------------------------------"

# לולאה על כל הקבצים בתיקייה (לא כולל תתי-תיקיות)
find "$TARGET_DIR" -maxdepth 1 -type f | while read -r file; do
    # שימוש ב-wc לקבלת הנתונים
    wc "$file" | awk '{print $1 "\t" $2 "\t" $3 "\t" "'$(basename "$file")'"}'
done
echo "--------------------------------------------------"
