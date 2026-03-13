# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := evince
$(PKG)_WEBSITE  := https://wiki.gnome.org/Apps/Evince
$(PKG)_DESCR    := Document viewer for multiple document formats
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 43.1
$(PKG)_CHECKSUM := 6d75ca62b73bfbb600f718a098103dc6b813f9050b9594be929e29b4589d2335
$(PKG)_SUBDIR   := evince-$($(PKG)_VERSION)
$(PKG)_FILE     := evince-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/evince/43/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper gtk3 poppler glib libxml2 gsettings-desktop-schemas adwaita-icon-theme libhandy

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dnautilus=false \
        -Dgtk_doc=false \
        -Dintrospection=false \
        -Dps=disabled \
        -Ddvi=disabled \
        -Ddjvu=disabled \
        -Dcomics=disabled \
        -Dthumbnail_cache=disabled \
        -Dmultimedia=disabled \
        -Dgspell=disabled \
        '$(SOURCE_DIR)' '$(BUILD_DIR)'
    
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
