# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gsettings-desktop-schemas
$(PKG)_WEBSITE  := https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas
$(PKG)_DESCR    := Collection of GSettings schemas for settings shared by various GNOME components
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 43.0
$(PKG)_CHECKSUM := 5d5568282ab38b95759d425401f7476e56f8cbf2629885587439f43bd0b84bbe
$(PKG)_SUBDIR   := gsettings-desktop-schemas-$($(PKG)_VERSION)
$(PKG)_FILE     := gsettings-desktop-schemas-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gsettings-desktop-schemas/43/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper glib

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dintrospection=false \
        '$(SOURCE_DIR)' '$(BUILD_DIR)'
    
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef

