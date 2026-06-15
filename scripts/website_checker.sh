#!/bin/bash

echo -e "\n--- בדיקת תקינות גישה לאתרים ---"

# בדיקה האם curl מותקן - במידה ולא, מנסה להתקין אותו
if ! command -v curl &> /dev/null; then
    echo "התוכנה curl אינה מותקנת. מנסה להתקין כעת..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y curl
    elif command -v yum &> /dev/null; then
        sudo yum install -y curl
    else
        echo "שגיאה: לא ניתן להתקין את curl אוטומטית. אנא התקן אותו ידנית."
        exit 1
    fi
fi

read -p "הכנס כתובות אתרים (מופרדים ברווחים), למשל (google.com github.com): " -a websites

if [ ${#websites[@]} -eq 0 ]; then
    echo "לא הוכנסו כתובות לבדיקה."
    exit 1
fi

for url in "${websites[@]}"; do
    if [[ ! "$url" =~ ^http:// && ! "$url" =~ ^https:// ]]; then
        check_url="https://$url"
    else
        check_url="$url"
    fi
    
    status_code=$(curl -o /dev/null --silent --head --write-out "%{http_code}" --max-time 5 "$check_url")
    
    if [ "$status_code" -eq 200 ] || [ "$status_code" -eq 301 ] || [ "$status_code" -eq 302 ]; then
        echo "✅ [HTTP $status_code] האתר $url זמין!"
    else
        echo "❌ [שגיאה / HTTP $status_code] האתר $url אינו זמין."
    fi
done
