#!/system/bin/sh

idle=`getprop sys.boot_completed`

echo "config volte: $1"

if [ "$1" = "on" ]; then
    if [ "$idle" = "1" ]; then
        pm enable com.qualcomm.qti.rcsbootstraputil
        pm enable com.qualcomm.qti.rcsimsbootstraputil
    fi
elif [ "$1" = "off" ]; then
    if [ "$idle" = "1" ]; then
        pm disable com.qualcomm.qti.rcsbootstraputil
        pm disable com.qualcomm.qti.rcsimsbootstraputil
    fi
fi
