#!/bin/bash

echo -e "\n--- סריקת פורטים פתוחים ---"
read -p "הכנס כתובת IP או Hostname לסריקה: " ip_addr
read -p "הכנס פורט התחלה: " start_port
read -p "הכנס פורט סיום: " end_port

echo "סורק את $ip_addr מפורט $start_port עד $end_port..."
for ((port=$start_port; port<=$end_port; port++)); do
    timeout 1 bash -c "cat < /dev/null > /dev/tcp/$ip_addr/$port" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "[+] Port $port is OPEN"
    fi
done
