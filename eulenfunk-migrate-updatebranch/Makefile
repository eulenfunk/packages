include $(TOPDIR)/rules.mk

PKG_NAME:=eulenfunk-migrate-updatebranch
PKG_VERSION:=v2018.1
PKG_RELEASE:=4

include $(TOPDIR)/../package/gluon.mk


define Package/$(PKG_NAME)
  TITLE:=Migrate autoupdater branches and settings
  DEPENDS:=+gluon-core
endef

define Package/$(PKG_NAME)/description
	Migrate autoupdater branches and settings away from outdated branches
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	./gluonShellDiet.sh $(1)/lib/gluon/upgrade/910-eulenfunk-migrate-updatebranch
endef

$(eval $(call BuildPackageGluon,$(PKG_NAME)))
