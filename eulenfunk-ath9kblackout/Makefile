include $(TOPDIR)/rules.mk

PKG_NAME:=eulenfunk-ath9kblackout
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/eulenfunk-ath9kblackout
  SECTION:=eulenfunk
  CATEGORY:=Workarounds
  TITLE:=ATH9K-Blackout workaround (Eulenfunk)
  DEPENDS:=+gluon-core +micrond
  MAINTAINER:=Eulenfunk <git://github.com/eulenfunk/packages>
endef

define Package/eulenfunk-ath9kblackout/description
	Restartes the wifi if possible blackout is detected.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/eulenfunk-ath9kblackout/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

define Package/eulenfunk-ath9kblackout/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,eulenfunk-ath9kblackout))
