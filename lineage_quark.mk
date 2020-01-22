# Inherit some common stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_NAME := lineage_quark

#This will make TWRP backups name same as ROM zip name
QUARK_LOS_ROM_VERSION=lineage-16.0-$(shell date -u +%Y%m%d)-MOD-quark

PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=$(QUARK_LOS_ROM_VERSION)
