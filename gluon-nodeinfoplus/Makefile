include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-nodeinfoplus
PKG_VERSION:=2
PKG_RELEASE:=$(GLUON_VERSION).$(GLUON_SITE_CODE)-$(GLUON_RELEASE).$(GLUON_CONFIG_VERSION)

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS := respondd

include $(GLUONDIR)/include/package.mk

define Package/gluon-nodeinfoplus
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=transmits more respondd nodeinfo about wifi and meshes
  DEPENDS:=+gluon-core +libiwinfo-lua +iw
  MAINTAINER:=Eulenfunk  <http://www.eulenfunk.de>
  URL:=https://www.github.com/eulenfunk/packages
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/gluon-nodeinfoplus/install
	$(CP) ./files/* $(1)/

	$(INSTALL_DIR) $(1)/lib/gluon/respondd
	$(CP) $(PKG_BUILD_DIR)/respondd.so $(1)/lib/gluon/respondd/nodeinfoplus.so
endef

$(eval $(call BuildPackage,gluon-nodeinfoplus))
