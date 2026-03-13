# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := at-spi2-core
$(PKG)_WEBSITE  := 
$(PKG)_DESCR    := part of the GNOME Accessibility Project
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.40.0
$(PKG)_CHECKSUM := 4196a7d30a0051e52a67b8ce4283fe79ae5e4e14a725719934565adf1d333429
$(PKG)_SUBDIR   := at-spi2-core-$($(PKG)_VERSION)
$(PKG)_FILE     := at-spi2-core-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/at-spi2-core/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/at-spi2-core/tags' | \
    $(SED) -n "s,.*<a [^>]\+>ATK_\([0-9]\+_[0-9_]\+\)<.*,\1,p" | \
    $(SED) "s,_,.,g;" | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' \
        -Dintrospection=no \
        -Dx11=no \
        -Ddocs=false \
        '$(BUILD_DIR)' \
        '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
