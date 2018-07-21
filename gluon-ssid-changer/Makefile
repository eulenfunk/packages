include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ssid-changer
PKG_VERSION:=5

	include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=changes the SSID to an Offline-SSID so clients don't connect to an offline WiFi
  DEPENDS:=+gluon-core +micrond
endef

define Package/$(PKG_NAME)/description
  Script to change the SSID to an Offline-SSID when there is no connection to
  any gateway. This SSID can be generated from the nodes hostname with the first
  and last part of the nodename or the mac address, to allow observers to 
  recognise which node is down. The script is called once a minute by micron.d
  and it will change from online to offline-SSID maximum once every (definable)
  timeframe.
endef

define Package/$(PKG_NAME)/install
	./gluonShellDiet.sh $(1)/lib/gluon/ssid-changer/ssid-changer.sh
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
