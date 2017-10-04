include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-hotfix
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
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

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	./gluonShellDiet.sh $(1)/lib/gluon/hotfix/rebootIfNoWifiClients.sh
	./gluonShellDiet.sh $(1)/lib/gluon/hotfix/rebootIfNoGw.sh
	./gluonShellDiet.sh $(1)/lib/gluon/hotfix/fixbat0br.sh
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
