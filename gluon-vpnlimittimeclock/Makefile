include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-vpnlimittimeclock
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-vpnlimittimeclock
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

define Package/gluon-vpnlimittimeclock/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-vpnlimittimeclock))

