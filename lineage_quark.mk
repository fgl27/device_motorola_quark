# Inherit some common stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

$(call inherit-product, $(LOCAL_PATH)/device.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage

PRODUCT_NAME := lineage_quark
