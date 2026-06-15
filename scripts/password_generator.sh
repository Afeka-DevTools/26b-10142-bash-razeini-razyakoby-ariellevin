#!/bin/bash

echo -e "\n--- יצירת סיסמה רנדומלית מאובטחת ---"
lower="a-z"
upper="A-Z"
digits="0-9"
special="!@#$%^&*"
all_chars="${lower}${upper}${digits}${special}"

char1=$(LC_ALL=C tr -dc "$lower" < /dev/urandom | head -c 1)
char2=$(LC_ALL=C tr -dc "$upper" < /dev/urandom | head -c 1)
char3=$(LC_ALL=C tr -dc "$digits" < /dev/urandom | head -c 1)
char4=$(LC_ALL=C tr -dc "$special" < /dev/urandom | head -c 1)
rest=$(LC_ALL=C tr -dc "$all_chars" < /dev/urandom | head -c 6)

final_password=$(echo "${char1}${char2}${char3}${char4}${rest}" | fold -w1 | shuf | tr -d '\n')
echo "הסיסמה שנוצרה: $final_password"
