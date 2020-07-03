include $(TOPDIR)/rules.mk

PKG_NAME:=eulenfunk-ch13to9
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=admin
  CATEGORY:=Workaround
  DEPENDS:=+wireless-tools
  TITLE:=pushes ch13 to ch9 on 2.4GHz once
endef

define Package/$(PKG_NAME)/description
  due to compatiblity issues with certain clients (apple, microsoft) struggeling to connect to 2.4-ch13 APs,
  push those nodes to ch9, even if keepradiochannels is set. 
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
	./gluonShellDiet.sh $(1)/etc/init.d/ch13to9
	./gluonShellDiet.sh $(1)/lib/gluon/upgrade/209-eulenfunk-ch13to9
	./gluonShellDiet.sh $(1)/lib/gluon/ch13to9/ch13to9.lua
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
