include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ebtables-limit-arp
PKG_VERSION:=2
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Ebtables limiter for ARP packets
  DEPENDS:=+gluon-core +gluon-ebtables
endef

define Package/$(PKG_NAME)/description
  Gluon community wifi mesh firmware framework: Ebtables rules to
  rate-limit ARP packets.

  These filters limit the amount of ARP Requests devices are allowed
  to send into the mesh from a particular node to 1 per second on
  average.

  A burst of up to 50 ARP Requests is allowed until the rate-limiting
  takes effect (see --limit-burst in the ebtables manpage).

  Furthermore, ARP Requests with a target IP already present in the
  batman-adv DAT Cache are excluded from the rate-limiting,
  both regarding counting and filtering, as batman-adv will respond
  locally with no burden for the mesh. Therefore, this limiter
  should not affect popular target IPs, like gateways.

  However it should mitigate the problem of curious people or
  smart devices scanning the whole IP range. Which could create
  a significant amount of overhead for all participants so far.
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
