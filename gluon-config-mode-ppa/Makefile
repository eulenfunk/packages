include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-config-mode-ppa
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)

define Package/gluon-config-mode-ppa
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Add a checkbox to accept the PPA
  DEPENDS:=gluon-config-mode-core-virtual +gluon-node-info
endef

define Package/gluon-config-mode-ppa/description
	Add a checkbox to accept the PPA
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,gluon-config-mode-ppa,i18n)
endef

define Package/gluon-config-mode-ppa/install
	$(CP) ./files/* $(1)/
	$(call GluonInstallI18N,gluon-config-mode-ppa,$(1))
endef

define Package/gluon-config-mode-ppa/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,gluon-config-mode-ppa))
