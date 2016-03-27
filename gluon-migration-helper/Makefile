include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-migration-helper
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-migration-helper
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=migration-helper
  DEPENDS:=+gluon-core
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-migration-helper/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-migration-helper))
