include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-hotfix
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-hotfix
  SECTION:=gluon
  CATEGORY:=Workaround
  TITLE:=Hotfix-collection_VFN
  DEPENDS:=+gluon-core +micrond
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-hotfix/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-hotfix))

