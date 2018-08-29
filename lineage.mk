$(call inherit-product, device/motorola/quark/device.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage

PRODUCT_NAME := lineage_quark
