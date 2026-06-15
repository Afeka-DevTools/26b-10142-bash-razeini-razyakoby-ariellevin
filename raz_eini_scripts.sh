#!/bin/bash

# ==============================================================================
# סקריפט 1: יצירת סיסמה רנדומלית מאובטחת בת 10 תווים
# המכילה לפחות: אות גדולה, אות קטנה, ספרה וסימן מיוחד
# ==============================================================================
generate_password() {
    echo -e "\n--- יצירת סיסמה רנדומלית מאובטחת ---"
    
    # הגדרת קבוצות התווים
    lower="a-z"
    upper="A-Z"
    digits="0-9"
    special="!@#$%^&*"
    all_chars="${lower}${upper}${digits}${special}"
    
    # ייצור תו אחד מכל סוג כדי להבטיח עמידה בתנאי הסף
    char1=$(LC_ALL=C tr -dc "$lower" < /dev/urandom | head -c 1)
    char2=$(LC_ALL=C tr -dc "$upper" < /dev/urandom | head -c 1)
    char3=$(LC_ALL=C tr -dc "$digits" < /dev/urandom | head -c 1)
    char4=$(LC_ALL=C tr -dc "$special" < /dev/urandom | head -c 1)
    
    # השלמת עוד 6 תווים רנדומליים מכל הקבוצות יחד (סך הכל 10)
    rest=$(LC_ALL=C tr -dc "$all_chars" < /dev/urandom | head -c 6)
    
    # ערבוב של כל התווים יחד כדי שלא יהיה מבנה קבוע מראש
    final_password=$(echo "${char1}${char2}${char3}${char4}${rest}" | fold -w1 | shuf | tr -d '\n')
    
    echo "הסיסמה שנוצרה: $final_password"
}

# ==============================================================================
# סקריפט 2: סריקת פורטים פתוחים בכתובת IP (Port Scanner בסיסי ב-Bash)
# ==============================================================================
scan_ports() {
    echo -e "\n--- סריקת פורטים פתוחים ---"
    read -p "הכנס כתובת IP או Hostname לסריקה: " ip_addr
    read -p "הכנס פורט התחלה (למשל 20): " start_port
    read -p "הכנס פורט סיום (למשל 90): " end_port
    
    echo "סורק את $ip_addr מפורט $start_port עד $end_port..."
    
    for ((port=$start_port; port<=$end_port; port++)); do
        # שימוש בפיצ'ר המובנה של Bash לבדיקת חיבורי TCP (במקום להסתמך על כלי חיצוני כמו nc)
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/$ip_addr/$port" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "[+] Port $port is OPEN"
        fi
    done
    echo "הסריקה הסתיימה."
}

# ==============================================================================
# סקריפט 3: הוספת תחילית (Prefix) לשם של כל קבצי ה-txt בתיקייה מסוימת
# ==============================================================================
rename_txt_files() {
    echo -e "\n--- הוספת תחילית לקבצי TXT ---"
    read -p "הכנס את הנתיב המלא לתיקייה: " target_dir
    
    # בדיקה האם התיקייה קיימת
    if [ ! -d "$target_dir" ]; then
        echo "שגיאה: התיקייה לא קיימת!"
        return 1
    fi
    
    read -p "הכנס את התחילית הרצויה (למשל, backup_): " prefix
    
    count=0
    # לולאה שעוברת רק על קבצי txt באותה תיקייה
    for file in "$target_dir"/*.txt; do
        # הגנה מפני מצב שבו אין קבצי txt בתיקייה
        if [ ! -f "$file" ]; then
            echo "לא נמצאו קבצי .txt בתיקייה זו."
            break
        fi
        
        # חילוץ שם הקובץ בלבד ללא הנתיב
        filename=$(basename "$file")
        # ביצוע שינוי השם
        mv "$file" "$target_dir/${prefix}${filename}"
        ((count++))
    done
    
    echo "הפעולה הושלמה בהצלחה. שונו השמות של $count קבצים."
}

# ==============================================================================
# סקריפט 4: הצגת סטטוס git (Git Status) לכל תת-תיקייה בתיקייה נתונה
# ==============================================================================
check_subdirs_git_status() {
    echo -e "\n--- בדיקת סטטוס Git לתת-תיקיות ---"
    read -p "הכנס את נתיב תיקיית האב (ברירת מחדל - התיקייה הנוכחית .): " parent_dir
    parent_dir=${parent_dir:-.} # אם המשתמש לחץ אנטר, ישתמש בתיקייה הנוכחית
    
    if [ ! -d "$parent_dir" ]; then
        echo "שגיאה: התיקייה לא קיימת!"
        return 1
    fi
    
    # מעבר על כל תת-התיקיות ברמה הראשונה
    for dir in "$parent_dir"/*/; do
        # הגנה מפני מצב שהתיקייה ריקה
        [ -d "$dir" ] || continue
        
        echo -e "\n----------------------------------------"
        echo "בודק את: $dir"
        echo "----------------------------------------"
        
        # בדיקה האם מדובר בריפוזיטורי של גיט
        if [ -d "${dir}.git" ]; then
            # הרצת git status בתוך התיקייה הספציפית הזו
            git -C "$dir" status -s
            if [ $? -eq 0 ] && [ -z "$(git -C "$dir" status -s)" ]; then
                echo "✅ הכל נקי ומעודכן (Clean)."
            fi
        else
            echo "❌ תיקייה זו אינה מנוהלת על ידי Git."
        fi
    done
}

# ==============================================================================
# SCRIPT 5: בדיקת תקינות גישה (HTTP Status) לרשימת אתרים
# ==============================================================================
check_websites_status() {
    echo -e "\n--- בדיקת תקינות גישה לאתרים ---"
    echo "נא להזין את כתובות האתרים (מופרדים ברווחים), למשל: google.com github.com"
    read -p "כתובות: " -a websites
    
    if [ ${#websites[@]} -eq 0 ]; then
        echo "לא הוכנסו כתובות לבדיקה."
        return 1
    fi
    
    echo -e "\nמתחיל בבדיקה..."
    for url in "${websites[@]}"; do
        # הוספת http:// אם המשתמש לא הזין פרוטוקול
        if [[ ! "$url" =~ ^http:// && ! "$url" =~ ^https:// ]]; then
            check_url="https://$url"
        else
            check_url="$url"
        fi
        
        # שימוש ב-curl כדי לקבל רק את קוד הסטטוס (HTTP Code)
        # --silent מונע הדפסת פרוגרס, --output שולח את התוכן לפח, ו--write-out מחזיר רק את הקוד
        status_code=$(curl -o /dev/null --silent --head --write-out "%{http_code}" --max-time 5 "$check_url")
        
        if [ "$status_code" -eq 200 ] || [ "$status_code" -eq 301 ] || [ "$status_code" -eq 302 ]; then
            echo "✅ [HTTP $status_code] האתר $url זמין ותקין!"
        else
            echo "❌ [HTTP $status_code / שגיאת חיבור] האתר $url אינו זמין או החזיר שגיאה."
        fi
    done
}

# ==============================================================================
# תפריט ראשי אינטראקטיבי (Menu Loop)
# ==============================================================================
while true; do
    echo -e "\n========================================"
    echo "          תפריט סקריפטים ב-Bash         "
    echo "========================================"
    echo "1) יצירת סיסמה רנדומלית מאובטחת"
    echo "2) סריקת פורטים בכתובת IP"
    echo "3) הוספת תחילית לקבצי TXT בתיקייה"
    echo "4) הצגת סטטוס Git לכל תת-תיקייה"
    echo "5) בדיקת סטטוס ותקינות אתרי אינטרנט"
    echo "6) יציאה מהתוכנית"
    echo "========================================"
    read -p "אנא בחר אפשרות (1-6): " choice
    
    case $choice in
        1) generate_password ;;
        2) scan_ports ;;
        3) rename_txt_files ;;
        4) check_subdirs_git_status ;;
        5) check_websites_status ;;
        6) echo "להתראות!"; exit 0 ;;
        *) echo "בחירה לא חוקית, נסה שוב." ;;
    esac
done
