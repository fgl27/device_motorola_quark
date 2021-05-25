#!/vendor/bin/sh
echo 'init.qcom.post_boot run' > /dev/kmsg;

if [ "$1" -eq 1 ]; then
    echo 'init.qcom.post_boot charger mode' > /dev/kmsg;

    for i in 0 1 2 3
    do
        echo 1 > /sys/devices/system/cpu/cpu"$i"/online
        chown -h root.system /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_max_freq
        chmod -h 664 /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_max_freq
        echo 1497600 > /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_max_freq
    done

    echo 0 > /sys/devices/system/cpu/cpu2/online
    echo 0 > /sys/devices/system/cpu/cpu3/online
else
    echo 'init.qcom.post_boot init mode' > /dev/kmsg;

    for i in 0 1 2 3
    do
        echo 1 > /sys/devices/system/cpu/cpu"$i"/online
        chown -h root.system /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_governor
        chmod -h 664 /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_governor
        echo "interactive" > /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_governor
        chown -h root.system /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_max_freq
        chmod -h 664 /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_max_freq
    done
fi;

echo 'init.qcom.post_boot exit' > /dev/kmsg;

exit;
