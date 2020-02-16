LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE       := animation
LOCAL_MODULE_SUFFIX := .txt
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PRODUCT_MODULE := true
LOCAL_SRC_FILES    := animation.txt
LOCAL_MODULE_PATH  := $(TARGET_OUT_PRODUCT)/etc/res/values/charger
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := battery_fail
LOCAL_MODULE_SUFFIX := .png
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PRODUCT_MODULE := true
LOCAL_SRC_FILES    := images/battery_fail.png
LOCAL_MODULE_PATH  := $(TARGET_OUT_PRODUCT)/etc/res/images/charger
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := battery_scale
LOCAL_MODULE_SUFFIX := .png
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PRODUCT_MODULE := true
LOCAL_SRC_FILES    := images/battery_scale.png
LOCAL_MODULE_PATH  := $(TARGET_OUT_PRODUCT)/etc/res/images/charger
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := font_log
LOCAL_MODULE_SUFFIX := .png
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_PRODUCT_MODULE := true
LOCAL_SRC_FILES    := images/font_log.png
LOCAL_MODULE_PATH  := $(TARGET_OUT_PRODUCT)/etc/res/images/charger
include $(BUILD_PREBUILT)
