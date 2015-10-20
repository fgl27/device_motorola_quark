#!/system/bin/sh
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

mode=`getprop ro.bootmode`
case "$mode" in
	"charger")

	echo 4 > /sys/module/lpm_levels/enable_low_power/l2
	echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu3/retention/idle_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu0/retention/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu1/retention/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu2/retention/suspend_enabled
	echo 1 > /sys/module/msm_pm/modes/cpu3/retention/suspend_enabled
	echo 1 > /sys/module/msm_thermal/core_control/enabled
	echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo "interactive" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	echo "interactive" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
	echo "interactive" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 0 > /sys/devices/system/cpu/cpu2/online
	echo 0 > /sys/devices/system/cpu/cpu3/online

	/system/bin/charge_only_mode

	echo 0 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
	echo 1 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu2/online
	echo 1 > /sys/devices/system/cpu/cpu3/online
	;;
esac
