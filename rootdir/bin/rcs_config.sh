#!/system/bin/sh

idle=`getprop sys.boot_completed`

echo "config volte: $1"

if [ "$1" = "on" ]; then
    if [ "$idle" = "1" ]; then
        pm enable com.qualcomm.qti.rcsbootstraputil
        pm enable com.qualcomm.qti.rcsimsbootstraputil
    fi
    /system/bin/log -t rcs_config_on -p i "rcs_config_on run"
elif [ "$1" = "off" ]; then
    if [ "$idle" = "1" ]; then
        pm disable com.qualcomm.qti.rcsbootstraputil
        pm disable com.qualcomm.qti.rcsimsbootstraputil
    fi
    /system/bin/log -t rcs_config_off -p i "rcs_config_off run"
fi
