ARCHS = arm64
TARGET = appletv:clang
SYSROOT = $(THEOS)/sdks/AppleTVOS12.4.sdk
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.211

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Addilynne
Addilynne_FILES = $(wildcard *.mm)
Addilynne_INSTALL_PATH = /Library/PreferenceBundles
Addilynne_FRAMEWORKS = UIKit TVSettingKit 
Addilynne_PRIVATE_FRAMEWORKS = TVSettingKit
Addilynne_CFLAGS+= -I. -ITVSettings -ITVSettingsKit
Addilynne_LDFLAGS = -undefined dynamic_lookup


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Addilynne.plist$(ECHO_END)
