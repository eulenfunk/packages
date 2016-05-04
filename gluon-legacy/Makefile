include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-legacy-https-stats
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-legacy-https-stats
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Legacy https stats
  DEPENDS:=+curl +@CONFIG_LIBCURL_NOSSL
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-legacy-https-stats/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-legacy-https-stats))
