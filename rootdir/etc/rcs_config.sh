#!/system/bin/sh

idle=`getprop sys.boot_completed`

echo "config volte: $1"

if [ "$1" = "on" ]; then
    setprop persist.radio.calls.on.ims true
    setprop persist.radio.jbims 1
    setprop persist.radio.domain.ps 0
    setprop persist.radio.VT_ENABLE 1
    setprop persist.radio.VT_HYBRID_ENABLE 1
    setprop persist.radio.ROTATION_ENABLE 1
    setprop persist.radio.REVERSE_QMI 0
    setprop persist.radio.RATE_ADAPT_ENABLE 1
    setprop persist.rcs.supported 1
    setprop persist.ims.enableADBLogs 1
    setprop persist.ims.enableDebugLogs 1
    setprop persist.rmnet.mux enabled
    # epdg configuration
    setprop persist.cne.feature 1
    setprop persist.data.netmgrd.qos.enable true
    setprop persist.data.iwlan.enable true
    setprop persist.sys.cnd.iwlan 1
    setprop persist.cne.logging.qxdm 3974
    if [ "$idle" = "1" ]; then
        pm enable com.qualcomm.qti.rcsbootstraputil
        pm enable com.qualcomm.qti.rcsimsbootstraputil
    fi
    /system/bin/log -t rcs_config_on -p i "rcs_config_on run"
elif [ "$1" = "off" ]; then
    setprop persist.radio.calls.on.ims false
    setprop persist.radio.jbims 0
    setprop persist.radio.domain.ps 0
    setprop persist.radio.VT_ENABLE 0
    setprop persist.radio.VT_HYBRID_ENABLE 0
    setprop persist.radio.ROTATION_ENABLE 0
    setprop persist.radio.REVERSE_QMI 0
    setprop persist.radio.RATE_ADAPT_ENABLE 0
    setprop persist.rcs.supported 0
    setprop persist.ims.enableADBLogs 0
    setprop persist.ims.enableDebugLogs 0
    setprop persist.rmnet.mux disabled
    # epdg configuration
    setprop persist.cne.feature 0
    #setprop persist.data.netmgrd.qos.enable false
    setprop persist.data.iwlan.enable false
    setprop persist.sys.cnd.iwlan 0
    setprop persist.cne.logging.qxdm 0
    if [ "$idle" = "1" ]; then
        pm disable com.qualcomm.qti.rcsbootstraputil
        pm disable com.qualcomm.qti.rcsimsbootstraputil
    fi
    /system/bin/log -t rcs_config_off -p i "rcs_config_off run"
fi
