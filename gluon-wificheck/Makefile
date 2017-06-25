include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-wificheck
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-wificheck
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=WIFI-Neighborcheck
  DEPENDS:=+gluon-core +micrond
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-wificheck/install
        $(CP) ./files/* $(1)/
        ./gluonShellDiet.sh $(1)/lib/gluon/weeklyreboot/weeklyreboot.sh
endef

$(eval $(call BuildPackage,gluon-wificheck))

