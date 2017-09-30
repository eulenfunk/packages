include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-aptimeclock
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/gluon-aptimeclock
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Turn on/off client AP by cron
  DEPENDS:=+gluon-core +micrond
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-aptimeclock/install
	$(CP) ./files/* $(1)/
	./gluonShellDiet.sh $(1)/lib/gluon/aptimeclock/aptimeclock.sh
endef

$(eval $(call BuildPackage,gluon-aptimeclock))
