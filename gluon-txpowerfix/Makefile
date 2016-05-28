include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-txpowerfix
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/gluon-txpowerfix
  SECTION:=admin
  CATEGORY:=Workaround
  DEPENDS:=+wireless-tools
  TITLE:=Fixes txpower under Chaos Calmer (Gluon 2016.1+)
endef

define Package/gluon-txpowerfix/description
	In Chaos Calmer (Gluon v2016.1+) the limitations of the DE regulatory domain 
	have changed to an unrealistically low value. This script removes the 
        excessive limitations of the DE regulatory domain from the 2.4 GHz iface by 
        setting the country code to BO.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-txpowerfix/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-txpowerfix))
