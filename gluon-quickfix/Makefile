include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-quickfix
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/gluon-quickfix
  SECTION:=gluon
  CATEGORY:=Workaround
  TITLE:=Reboot under certain conditions (loss of mesh neighbours, broken client wifi, unsuccessful anycast ping)
  DEPENDS:=+gluon-core +micrond
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-quickfix/install
	$(CP) ./files/* $(1)/
	./gluonShellDiet.sh $(1)/lib/gluon/quickfix/quickfix.sh
endef

$(eval $(call BuildPackage,gluon-quickfix))
