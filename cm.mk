$(call inherit-product, device/motorola/quark/full_quark.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Enhanced NFC
$(call inherit-product, vendor/cm/config/nfc_enhanced.mk)

PRODUCT_RELEASE_NAME := Moto MAXX
PRODUCT_NAME := cm_quark

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=quark \
    BUILD_FINGERPRINT=motorola/quark_retla/quark_umts:4.4.4/KXG21.50-9/6:user/release-keys \
    PRIVATE_BUILD_DESC="quark_retla-user 4.4.4 KXG21.50-9 6 release-keys"
