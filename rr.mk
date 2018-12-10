# Inherit some common stuff.
$(call inherit-product, vendor/rr/config/common_full_phone.mk)

$(call inherit-product, device/motorola/quark/device.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-rr

PRODUCT_NAME := rr_quark

# export the below before . build/envsetup.sh
# export ROM_VVV=$(grep PRODUCT_VERSION vendor/rr/config/common.mk | head -1 | awk '{print $3}');
#This will make TWRP backups name same as ROM zip name

QUARK_ROM_VERSION=RR-O-v$(ROM_VVV)-$(shell date -u +%Y%m%d)-quark-$(RR_BUILDTYPE)

PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_DISPLAY_ID=$(QUARK_ROM_VERSION)
    
# To make addon SU to work
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lineage.version=$(QUARK_ROM_VERSION)
