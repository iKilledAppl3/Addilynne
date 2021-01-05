ARCHS = arm64
TARGET = appletv:clang
SYSROOT = $(THEOS)/sdks/AppleTVOS12.4.sdk
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Addilynne
Addilynne_FILES = Tweak.xm
Addilynne_FRAMEWORKS = UIKit CoreGraphics QuartzCore AVFoundation AudioToolbox
Addilynne_LIBRARIES = substrate


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += addilynne
include $(THEOS_MAKE_PATH)/aggregate.mk
