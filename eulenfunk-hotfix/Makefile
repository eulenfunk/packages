include $(TOPDIR)/rules.mk

PKG_NAME:=eulenfunk-hotfix
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Workaround
  TITLE:=Gluon Hotfix  Collection (Ruben Kelevra & Eulenfunk) (reinit Wifi or even reboot unter certain conditions)
  DEPENDS:=+gluon-core +micrond
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	./gluonShellDiet.sh $(1)/lib/gluon/eulenfunk-hotfix/rebootIfNoGw.sh 
	./gluonShellDiet.sh $(1)/lib/gluon/eulenfunk-hotfix/healthcheck.sh
	./gluonShellDiet.sh $(1)/lib/gluon/eulenfunk-hotfix/check_hostapd.sh
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
