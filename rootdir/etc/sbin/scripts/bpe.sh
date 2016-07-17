#!/sbin/busybox sh
# bpe build.prop editor
# originally made by BHB27 fglfgl27@gmail.com
# This files is used to support multi model devices
# There is other workaround like init libs but some build.prop flags can't be set or may have no effect if set by kernel libs
# With this there is a kernel library that will set ro.boot.fsg-id dynamically
# This .sh can be place on the kernel or on the ROM zip
# On the kernel recommended place this on sbin, creat a service and start it under the last entre of a "on boot"
# the first time this script run it will set the values and reboot so they can take effect in next boot it will just skip
# To place this on the ROM zip do the below and remove the reboot on the end of it if
# Is need to modify build/tools/releasetools/ota_from_target_files.py and edify_generator.py 
# add the below code:
# edify_generator.py any were of the file
#
#  def bpe(self):
#    self.script.append('run_program("/tmp/install/bin/bpe.sh')
#
#ota_from_target_files.py add this line after the system have be unpack, today I do on the top of a unmount after the block_image_update process end
# my is under script.RunBackup("restore")
#
#    script.bpe()
#
# then place the sh on install folder use the code below on the device.mk
#
#PRODUCT_COPY_FILES += \
#    device/vendor/model/folder/bpe.sh:install/bin/bpe.sh \
#
# Mount root as RW to apply
mount -o remount,rw /;
mount -o rw,remount /system

if [ -e /tmp ]; then
	echo "tmp folder already exist"
else
mkdir /tmp;
fi

# Give permissions to execute
chmod -R 777 /tmp/;
chmod 6755 /sbin/*;
chmod 6755 /system/xbin/*;

# bpe start
#check if is the first run
MODIFIED=`cat /system/build.prop|grep "Multi Device support"`

if [ "$MODIFIED" ]; then 
	echo "Already done, no need to modify, boot initiated on $(date)" > /tmp/bootcheck;
else
	# Make a copy of build.prop before change
	cp /system/build.prop /system/build.prop-bak;
	#use a know and unique flags to enter the if's
	f=`getprop ro.boot.fsg-id`
	# To prevent from enter in sku if only set the variabel "t" if fsg-id is not valid
	if [[ "$f" != verizon_gsm ]] && [[ "$f" != lra_gsm ]]; then
		t=`getprop ro.boot.hardware.sku`
	fi
	if [[ "$t" == XT1254 ]]; then
	# XT1254 - Droid Turbo
		echo "

# Multi Device support
# Set as XT1254 - Droid Turbo
persist.cne.feature=1
persist.cne.logging.qxdm=3974
persist.data.iwlan.enable=true
persist.data.netmgrd.qos.hybrid=true
persist.eab.supported=1
persist.ims.enableADBLogs=1
persist.ims.enableDebugLogs=1
persist.radio.0x9e_not_callname=1
persist.radio.0x9e_not_callname=1
persist.radio.calls.on.ims=true
persist.radio.data_con_rprt=1
persist.radio.domain.ps=0
persist.radio.domain.ps=0
persist.radio.eri64_as_home=1
persist.radio.ignore_ims_wlan=1
persist.radio.ims.audio.output=0
persist.radio.jbims=1
persist.radio.mode_pref_nv10=1
persist.radio.mt_sms_ack=30
persist.radio.nw_mtu_enabled=true
persist.radio.plmn_name_cmp=1
persist.radio.RATE_ADAPT_ENABLE=1
persist.radio.REVERSE_QMI=0
persist.radio.ROTATION_ENABLE=1
persist.radio.sib16_support=1
persist.radio.videopause.mode=1
persist.radio.VT_ENABLE=1
persist.radio.VT_HYBRID_ENABLE=1
persist.rcs.presence.provision=0
persist.rcs.supported=1
persist.rmnet.mux=enabled
persist.sys.cnd.iwlan=1
persist.sys.media.use-awesome=false
persist.vt.supported=1
ro.build.description=quark_verizon-user 5.1 SU4TL-44 44 release-keys
ro.build.fingerprint=motorola/quark_verizon/quark:5.1/SU4TL-44/44:user/release-keys
ro.build.product=quark
ro.cdma.data_retry_config=max_retries=infinite,0,0,10000,10000,100000,10000,10000,10000,10000,140000,540000,960000
ro.cdma.disableVzwNbpcd=true
ro.cdma.home.operator.alpha=Verizon
ro.cdma.home.operator.isnan=1
ro.cdma.home.operator.numeric=311480
ro.cdma.homesystem=64,65,76,77,78,79,80,81,82,83
ro.cdma.nbpcd=1
ro.cdma.otaspnumschema=SELC,1,80,99
ro.com.android.dataroaming=true
ro.com.google.clientidbase.am=android-verizon
ro.com.google.clientidbase.gmm=android-motorola
ro.com.google.clientidbase.ms=android-verizon
ro.com.google.clientidbase.yt=android-verizon
ro.com.google.clientidbase=android-motorola
ro.mot.eri=1
ro.mot.ignore_csim_appid=true
ro.mot.phonemode.vzw4gphone=1
ro.product.device=quark
ro.product.model=DROID Turbo
ro.ril.force_eri_from_xml=true
ro.telephony.default_cdma_sub=0
ro.telephony.default_network=10
ro.telephony.get_imsi_from_sim=true
ro.telephony.gsm-routes-us-smsc=1
telephony.lteOnCdmaDevice=1" >> /system/build.prop
		mount -o remount,ro /system
		reboot
	elif [[ "$f" == verizon_gsm ]]; then
	# XT1254 as GSM device
		echo "

# Multi Device support
# Set as XT1254 GSM device
persist.cne.feature=1
persist.cne.logging.qxdm=3974
persist.data.iwlan.enable=true
persist.data.netmgrd.qos.hybrid=true
persist.eab.supported=1
persist.ims.enableADBLogs=1
persist.ims.enableDebugLogs=1
persist.radio.0x9e_not_callname=1
persist.radio.0x9e_not_callname=1
persist.radio.calls.on.ims=true
persist.radio.data_con_rprt=1
persist.radio.domain.ps=0
persist.radio.domain.ps=0
persist.radio.eri64_as_home=1
persist.radio.ignore_ims_wlan=1
persist.radio.ims.audio.output=0
persist.radio.jbims=1
persist.radio.mode_pref_nv10=1
persist.radio.mt_sms_ack=30
persist.radio.nw_mtu_enabled=true
persist.radio.plmn_name_cmp=1
persist.radio.RATE_ADAPT_ENABLE=1
persist.radio.REVERSE_QMI=0
persist.radio.ROTATION_ENABLE=1
persist.radio.sib16_support=1
persist.radio.videopause.mode=1
persist.radio.VT_ENABLE=1
persist.radio.VT_HYBRID_ENABLE=1
persist.rcs.presence.provision=0
persist.rcs.supported=1
persist.rmnet.mux=enabled
persist.sys.cnd.iwlan=1
persist.sys.media.use-awesome=false
persist.vt.supported=1
ro.build.description=quark_verizon-user 5.1 SU4TL-44 44 release-keys
ro.build.fingerprint=motorola/quark_verizon/quark:5.1/SU4TL-44/44:user/release-keys
ro.build.product=quark
ro.com.android.dataroaming=true
ro.com.google.clientidbase.am=android-verizon
ro.com.google.clientidbase.gmm=android-motorola
ro.com.google.clientidbase.ms=android-verizon
ro.com.google.clientidbase.yt=android-verizon
ro.com.google.clientidbase=android-motorola
ro.mot.eri=1
ro.mot.ignore_csim_appid=true
ro.mot.phonemode.vzw4gphone=1
ro.product.device=quark
ro.product.model=DROID Turbo
ro.telephony.default_network=10
telephony.lteOnGsmDevice=1" >> /system/build.prop
		mount -o remount,ro /system
		reboot
	elif [[ "$t" == XT1250 ]]; then
	# XT1250 - Moto MAXX
		echo "

# Multi Device support
# Set as XT1250 - Moto MAXX
persist.radio.0x9e_not_callname=1
persist.radio.apm_mdm_not_pwdn=1
persist.radio.mode_pref_nv10=1
persist.radio.redir_party_num=0
ro.build.description=quark_lra-user 4.4.4 KXG21.50-11 8 release-keys
ro.build.fingerprint=motorola/quark_lra/quark:4.4.4/KXG21.50-11/8:user/release-keys
ro.build.product=quark
ro.cdma.data_retry_config=max_retries=infinite,0,0,10000,10000,100000,10000,10000,10000,10000,140000,540000,960000
ro.cdma.disableVzwNbpcd=true
ro.cdma.home.operator.isnan=1
ro.cdma.home.operator.isnan=1
ro.cdma.homesystem=64,65,76,77,78,79,80,81,82,83
ro.cdma.nbpcd=1
ro.cdma.otaspnumschema=SELC,1,80,99
ro.mot.eri=1
ro.product.device=quark
ro.product.model=Moto MAXX
ro.ril.force_eri_from_xml=true
ro.telephony.default_cdma_sub=0
ro.telephony.default_network=10
ro.telephony.get_imsi_from_sim=true
telephony.lteOnCdmaDevice=1" >> /system/build.prop
		mount -o remount,ro /system
		reboot
	elif  [[ "$f" == lra_gsm ]]; then
	# XT1250 as GSM device
		echo "

# Multi Device support
# Set as XT1250 GSM device
ro.build.product=quark
ro.product.device=quark
ro.product.model=Moto MAXX
ro.telephony.default_network=9
telephony.lteOnGsmDevice=1
persist.radio.apm_mdm_not_pwdn=1
persist.radio.plmn_name_cmp=1
persist.radio.redir_party_num=0
persist.radio.0x9e_not_callname=1
persist.radio.apm_mdm_not_pwdn=1
persist.radio.mode_pref_nv10=1
persist.radio.redir_party_num=0
ro.mot.eri=1
ro.build.description=quark_lra-user 4.4.4 KXG21.50-11 8 release-keys
ro.build.fingerprint=motorola/quark_lra/quark:4.4.4/KXG21.50-11/8:user/release-keys" >> /system/build.prop
		mount -o remount,ro /system
		reboot
	elif  [[ "$t" == XT1225 ]] && [[ "$f" == emea ]]; then
		# XT1225 - Moto Turbo
		echo "

# Multi Device support
# Set as XT1225 - Moto Turbo
persist.radio.apm_mdm_not_pwdn=1
persist.radio.plmn_name_cmp=1
persist.radio.redir_party_num=0
ro.build.description=quark_reteu-user 5.0.2 LXG22.33-12.16 16 release-keys
ro.build.fingerprint=motorola/quark_reteu/quark_umts:5.0.2/LXG22.33-12.16/16:user/release-keys
ro.build.product=quark_umts
ro.product.device=quark_umts
ro.product.model=Moto Turbo
ro.telephony.default_network=9
telephony.lteOnGsmDevice=1" >> /system/build.prop
		mount -o remount,ro /system
		reboot
	else
	# XT1225 - Moto MAXX (default if any if is satisfied)
		echo "

# Multi Device support
# Set as XT1225 - Moto MAXX
persist.radio.apm_mdm_not_pwdn=1
persist.radio.plmn_name_cmp=1
persist.radio.redir_party_num=0
ro.build.description=quark_retla-user 5.0.2 LXG22.33-12.16 16 release-keys
ro.build.fingerprint=motorola/quark_retla/quark_umts:5.0.2/LXG22.33-12.16/16:user/release-keys
ro.build.product=quark_umts
ro.product.device=quark_umts
ro.product.model=Moto MAXX
ro.telephony.default_network=9
telephony.lteOnGsmDevice=1" >> /system/build.prop
		mount -o remount,ro /system
		reboot
	fi
fi
mount -o remount,ro /system
exit;
