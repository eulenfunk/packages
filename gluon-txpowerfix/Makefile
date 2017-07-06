include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-txpowerfix
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/gluon-txpowerfix
  SECTION:=admin
  CATEGORY:=Workaround
  DEPENDS:=+wireless-tools
  TITLE:=Fixes txpower on some wifi nodes under chaos calmer (gluon 2016.1)
endef

define Package/gluon-txpowerfix/description
  With chaoscalmer, wifi nodes seemed to be locked to less txpower than they could do.
  First suggestions are, that this is a mistake in the upstream OpenWrt-Code. Even the
  bugtrackers of OpenWrt are full of this. 
  The idea of this workaround is, to check if the txpower could be increased iff it is not
  already set to a special value. Unfortunately this can only be done by setting the 
  country code to 00/BO.
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
