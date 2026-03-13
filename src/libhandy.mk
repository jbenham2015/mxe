# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libhandy
$(PKG)_WEBSITE  := https://gitlab.gnome.org/GNOME/libhandy
$(PKG)_DESCR    := Building blocks for modern GNOME applications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.3
$(PKG)_CHECKSUM := 05b497229073ff557f10b326e074c5066f8743a302d4820ab97bcb5cd2dab087
$(PKG)_SUBDIR   := libhandy-$($(PKG)_VERSION)
$(PKG)_FILE     := libhandy-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libhandy/1.8/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper gtk3 glib

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dexamples=false \
        -Dtests=false \
        -Dglade_catalog=disabled \
        -Dintrospection=disabled \
        -Dvapi=false \
        -Dgtk_doc=false \
        '$(SOURCE_DIR)' '$(BUILD_DIR)'
    
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
