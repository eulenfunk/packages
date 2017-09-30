include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-vpnlimittimeclock
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Turn on/off the bandwitdth limit for vpn-usage by cron schedule
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
	./gluonShellDiet.sh $(1)/lib/gluon/vpnlimittimeclock/vpnlimittimeclock.sh
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
