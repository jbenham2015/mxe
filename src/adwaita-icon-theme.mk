# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := adwaita-icon-theme
$(PKG)_WEBSITE  := https://gitlab.gnome.org/GNOME/adwaita-icon-theme
$(PKG)_DESCR    := GNOME default icon theme
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 42.0
$(PKG)_CHECKSUM := 5e85b5adc8dee666900fcaf271ba717f7dcb9d0a03d96dae08f9cbd27e18b1e0
$(PKG)_SUBDIR   := adwaita-icon-theme-$($(PKG)_VERSION)
$(PKG)_FILE     := adwaita-icon-theme-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/adwaita-icon-theme/42/$($(PKG)_FILE)
$(PKG)_DEPS     := cc librsvg gtk3

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
