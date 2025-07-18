#!/bin/bash

APP1="com.jakex7.test51"
APP2="com.jakex7.test53"
APP3="com.jakex7.test51splash"
APP4="com.jakex7.test53splash"
APP5="com.jakex7.test51splashdelayed"
APP6="com.jakex7.test53splashdelayed"
APPS=($APP1 $APP2 $APP3 $APP4 $APP5 $APP6)
    
AVD_NAME="bare-expo"
START_EMULATOR=true

if [ "$START_EMULATOR" = true ]; then
  emulator -avd "$AVD_NAME" -no-snapshot-load &
  adb wait-for-device

  BOOT_STATUS=""
  until [[ "$BOOT_STATUS" == "1" ]]; do
    BOOT_STATUS=$(adb shell getprop sys.boot_completed | tr -d '\r')
  done
  sleep 30
fi

for PACKAGE in "${APPS[@]}"; do
  echo "Running: $PACKAGE"

  adb shell am force-stop $PACKAGE
  adb shell pm clear $PACKAGE

  adb shell monkey -p $PACKAGE -c android.intent.category.LAUNCHER 1

  sleep 5
done

echo "Testing complete for all apps."