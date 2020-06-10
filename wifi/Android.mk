LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
SEC_WIFI_FILES := \
	WCNSS_cfg.dat WCNSS_qcom_cfg.ini WCNSS_qcom_wlan_nv.bin

SEC_WIFI_SYMLINKS := $(addprefix $(TARGET_OUT)/etc/firmware/wlan/qca_cld/,$(notdir $(SEC_WIFI_FILES)))
$(SEC_WIFI_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "WIFI symlink: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /system/vendor/firmware/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SEC_WIFI_SYMLINKS)

include $(CLEAR_VARS)
SEC_PERSIST_FILES := \
	wlan_mac.bin wlan_mac_serial.bin

SEC_PERSIST_SYMLINKS := $(addprefix $(TARGET_OUT)/etc/firmware/wlan/qca_cld/,$(notdir $(SEC_PERSIST_FILES)))
$(SEC_PERSIST_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "WIFI PERSIST symlink: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /persist/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SEC_PERSIST_SYMLINKS)
