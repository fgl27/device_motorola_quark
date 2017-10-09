/*
 * This file contains device specific hooks.
 * Always enclose hooks to #if MR_DEVICE_HOOKS >= ver
 * with corresponding hook version!
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdint.h>
#include <time.h>
#include <string.h>

#include <log.h>
#include <util.h>

#if MR_DEVICE_HOOKS >= 1
int mrom_hook_after_android_mounts(const char *busybox_path, const char *base_path, int type)
{
    return 0;
}
#endif /* MR_DEVICE_HOOKS >= 1 */


#if MR_DEVICE_HOOKS >= 2
// Screen gets cleared immediatelly after closing the framebuffer on this device,
// give user a while to read the message box until it dissapears.
void mrom_hook_before_fb_close(void)
{
    usleep(800000);
}
#endif /* MR_DEVICE_HOOKS >= 2 */


#if MR_DEVICE_HOOKS >= 3
static int read_file(const char *path, char *dest, int dest_size)
{
    int res = 0;
    FILE *f = fopen(path, "re");
    if(!f)
        return res;

    res = fgets(dest, dest_size, f) != NULL;
    fclose(f);
    return res;
}

static void set_cpu_governor(void)
{
    size_t i;
    char buff[256];
    static const char *governors[] = { "interactive", "ondemand" };

    if(!read_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", buff, sizeof(buff)))
        return;

    if(strncmp(buff, "performance", 11) != 0)
        return;

    if(!read_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors", buff, sizeof(buff)))
        return;

    write_file("/sys/module/msm_thermal/core_control/enabled", "0");
    write_file("/sys/devices/system/cpu/cpu1/online", "1");
    write_file("/sys/devices/system/cpu/cpu2/online", "1");
    write_file("/sys/devices/system/cpu/cpu3/online", "1");

    for(i = 0; i < sizeof(governors)/sizeof(governors[0]); ++i)
    {
        if(strstr(buff, governors[i]))
        {
            write_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", governors[i]);
            write_file("/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor", governors[i]);
            write_file("/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor", governors[i]);
            write_file("/sys/devices/system/cpu/cpu3/cpufreq/scaling_governor", governors[i]);
            break;
        }
    }

    write_file("/sys/module/lpm_levels/enable_low_power/l2", "4");
    write_file("/sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu1/power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu2/power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu3/power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu0/retention/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu1/retention/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu2/retention/idle_enabled", "1");
    write_file("/sys/module/msm_pm/modes/cpu3/retention/idle_enabled", "1");
    write_file("/sys/module/msm_thermal/core_control/enabled", "1");
    write_file("/sys/devices/system/cpu/cpufreq/interactive/io_is_busy", "1");

    write_file("/sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay", "20000 1400000:40000 1700000:20000");
    write_file("/sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load", "90");
    write_file("/sys/devices/system/cpu/cpufreq/interactive/hispeed_freq", "1497600");
    write_file("/sys/devices/system/cpu/cpufreq/interactive/target_loads", "85 1500000:90 1800000:70");
    write_file("/sys/devices/system/cpu/cpufreq/interactive/min_sample_time", "40000");
    write_file("/sys/module/cpu_boost/parameters/boost_ms", "20");
    write_file("/sys/module/cpu_boost/parameters/sync_threshold", "1728000");
    write_file("/sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor", "100000");
    write_file("/sys/module/cpu_boost/parameters/input_boost_freq", "1497600");
    write_file("/sys/module/cpu_boost/parameters/input_boost_ms", "40");
}

static void wait_for_mmc(void)
{
    static const char *filename = "/sys/devices/msm_sdcc.1/mmc_host/mmc0/mmc0:0001/block/mmcblk0/mmcblk0p40/uevent";
    if(access(filename, R_OK) < 0)
    {
        INFO("Waiting for %s\n", filename);
        if(wait_for_file(filename, 5) < 0)
        {
            ERROR("Waiting too long for dev %s\n", filename);
            return;
        }
    }

    // 64gb shamu has some kind of race condition in its kernel emmc drivers,
    // if we start mounting things too soon, the commands will timeout.
    // We can't really tell when were the drivers initialized, so just wait a flat 1.5s.
    INFO("Sleeping for 1.5s to give emmc drivers some time to initialize...\n");
    usleep(1500000);
}

void tramp_hook_before_device_init(void)
{
    // shamu's kernel has "performance" as default
    set_cpu_governor();

    wait_for_mmc();
}
#endif /* MR_DEVICE_HOOKS >= 3 */

#if MR_DEVICE_HOOKS >= 4
int mrom_hook_allow_incomplete_fstab(void)
{
    return 0;
}
#endif

#if MR_DEVICE_HOOKS >= 5

static void replace_tag(char *cmdline, size_t cap, const char *tag, const char *what)
{
    char *start, *end;
    char *str = cmdline;
    char *str_end = str + strlen(str);
    size_t replace_len = strlen(what);

    while((start = strstr(str, tag)))
    {
        end = strstr(start, " ");
        if(!end)
            end = str_end;
        else if(replace_len == 0)
            ++end;

        if(end != start)
        {

            size_t len = str_end - end;
            if((start - cmdline)+replace_len+len > cap)
                len = cap - replace_len - (start - cmdline);
            memmove(start+replace_len, end, len+1); // with \0
            memcpy(start, what, replace_len);
        }

        str = start+replace_len;
    }
}

void mrom_hook_fixup_bootimg_cmdline(char *bootimg_cmdline, size_t bootimg_cmdline_cap)
{
    // Shamu's bootloader replaces all occurences of console=... with console=null, because fuck you.
    replace_tag(bootimg_cmdline, bootimg_cmdline_cap, "androidboot.console=", "");
    replace_tag(bootimg_cmdline, bootimg_cmdline_cap, "console=", "console=null");
}

int mrom_hook_has_kexec(void)
{
    // shamu kernels don't have /proc/config.gz, but they
    // have CONFIG_PROC_DEVICETREE enabled by default, so check
    // for /proc/device-tree/soc/kexec_hardboot-hole instead
    // (the DTB node that reserves memory for kexec-hardboot page).

    static const char *checkfile = "/proc/device-tree/soc/kexec_hardboot-hole";
    if(access(checkfile, R_OK) < 0)
    {
        ERROR("%s was not found!\n", checkfile);
        return 0;
    }
    return 1;
}
#endif
