include $(TOPDIR)/rules.mk

PKG_NAME:=eulenfunk-dns-cache
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Use Node as DNS cache, configure using site.conf from ffffm
  DEPENDS:=+gluon-core
endef

define Package/gluon-legacy/description
  Use Node as DNS cache, configure using site.conf
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
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
