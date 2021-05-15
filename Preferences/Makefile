ARCHS = arm64 arm64e
TARGET = iphone:clang:13.3:13.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NotiMaskPreferences
NotiMaskPreferences_FILES = $(wildcard *.m)
NotiMaskPreferences_INSTALL_PATH = /Library/PreferenceBundles
NotiMaskPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotiMaskPreferences.plist$(ECHO_END)