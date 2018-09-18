#
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

[vendor/app/Adaway/lib/arm/libblank_webserver_exec.so]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[vendor/app/Adaway/lib/arm/libtcpdump_exec.so]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[vendor/bin/time_daemon]
mode: 0755
user: AID_SYSTEM
group: AID_NET_RAW
caps: SYS_TIME

[vendor/bin/btnvtool]
mode: 0755
user: AID_BLUETOOTH
group: AID_BLUETOOTH
caps: 0
