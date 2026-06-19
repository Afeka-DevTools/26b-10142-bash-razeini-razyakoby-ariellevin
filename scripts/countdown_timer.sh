#!/bin/bash

# בדיקה אם התקבל פורמט הזמן הנכון
if [ "$#" -ne 1 ] || [[ ! "$1" =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]; then
    echo "שגיאה: יש לספק זמן בפורמט HH:MM:SS"
    echo "שימוש: $0 HH:MM:SS"
    exit 1
fi

TIME_INPUT=$1

# פירוק הקלט לשעות, דקות ושניות
IFS=':' read -r hours minutes seconds <<< "$TIME_INPUT"

# המרה של כל הזמן לשניות סך הכל
TOTAL_SECONDS=$((hours * 3600 + minutes * 60 + seconds))

echo "הטיימר הופעל למשך $TIME_INPUT ($TOTAL_SECONDS שניות)"

while [ $TOTAL_SECONDS -gt 0 ]; do
    # חישוב מחדש של הזמן שנותר להצגה
    H=$((TOTAL_SECONDS / 3600))
    M=$(((TOTAL_SECONDS % 3600) / 60))
    S=$((TOTAL_SECONDS % 60))
    
    # הדפסת הזמן שנותר באותה שורה באופן דינמי
    printf "\rהזמן שנותר: %02d:%02d:%02d" $H $M $S
    
    sleep 1
    TOTAL_SECONDS=$((TOTAL_SECONDS - 1))
done

echo -e "\n\a!!! הזמן עבר !!!"
