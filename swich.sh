#! /bin/bash

PORT_NUM=$1
if [ $2. == 'on.' ]; then
  NEW_VALUE=1
else
  if [ $2. == 'off.' ]; then
NEW_VALUE=0
  else
echo 'Usage: $0 PORT_NUM on|off'
exit
  fi
fi

# Настраиваем порт GPIO на вывод
if [ ! -e /sys/class/gpio/gpio$PORT_NUM ]
  then echo $PORT_NUM > /sys/class/gpio/export
fi

# Читаем старое состояние
OLD_VALUE=$(cat /sys/class/gpio/gpio$PORT_NUM/value)

if [ $OLD_VALUE == 1 ]; then
  OLD_VALUE_TEXT='on'
else
  OLD_VALUE_TEXT='off'
fi

echo "out" > /sys/class/gpio/gpio$PORT_NUM/direction

echo -ne 'Switching GPIO '$PORT_NUM' from '$OLD_VALUE_TEXT' to '$2'...'
echo $NEW_VALUE > /sys/class/gpio/gpio$PORT_NUM/value
echo ' done.'
