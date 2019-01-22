# Inherit some common stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_NAME := lineage_quark
