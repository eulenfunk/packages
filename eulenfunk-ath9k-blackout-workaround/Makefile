include $(TOPDIR)/rules.mk

PKG_NAME:=eulenfunk-ath9k-blackout-workaround
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/eulenfunk-ath9k-blackout-workaround
  SECTION:=eulenfunk
  CATEGORY:=Workarounds
  TITLE:=ATH9K-Blackout workaround
  DEPENDS:=+gluon-core +micrond
  MAINTAINER:=Freifunk Hochstift <kontakt@hochstift.freifunk.net>
endef

define Package/eulenfunk-ath9k-blackout-workaround/description
	Restartes the wifi if possible blckout is detected.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/eulenfunk-ath9k-blackout-workaround/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

define Package/eulenfunk-ath9k-blackout-workaround/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,eulenfunk-ath9k-blackout-workaround))
