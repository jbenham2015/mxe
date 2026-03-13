# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := at-spi2-atk
$(PKG)_WEBSITE  := 
$(PKG)_DESCR    := part of the GNOME Accessibility Project
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.38.0
$(PKG)_CHECKSUM := cfa008a5af822b36ae6287f18182c40c91dd699c55faa38605881ed175ca464f
$(PKG)_SUBDIR   := at-spi2-atk-$($(PKG)_VERSION)
$(PKG)_FILE     := at-spi2-atk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/at-spi2-atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper glib atk at-spi2-core

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/at-spi2-atk/tags' | \
    $(SED) -n "s,.*<a [^>]\+>ATK_\([0-9]\+_[0-9_]\+\)<.*,\1,p" | \
    $(SED) "s,_,.,g;" | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' \
        -Dtests=false \
        '$(BUILD_DIR)' \
        '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
