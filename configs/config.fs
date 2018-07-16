[AID_RFS]
value:2951

[AID_RFS_SHARED]
value:2952

[vendor/bin/qmuxd]
mode: 0755
user: AID_RADIO
group: AID_SHELL
caps: BLOCK_SUSPEND

[vendor/bin/mm-qcamera-daemon]
mode: 0755
user: AID_CAMERA
group: AID_SHELL
caps: SYS_NICE

[vendor/bin/wcnss_filter]
mode: 0755
user: AID_BLUETOOTH
group: AID_BLUETOOTH
caps: BLOCK_SUSPEND

[vendor/etc/hdrhax]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[/vendor/app/Adaway/lib/arm/libblank_webserver_exec.so]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[/vendor/app/Adaway/lib/arm/libtcpdump_exec.so]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0
