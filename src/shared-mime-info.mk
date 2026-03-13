# This file is *NOT* part of MXE.
# See index.html for further information.

PKG             := shared-mime-info
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 531291d0387eb94e16e775d7e73788d06d2b2fdd8cd2ac6b6b15287593b6a2de
$(PKG)_VERSION  := 2.4
$(PKG)_SUBDIR   := shared-mime-info-$($(PKG)_VERSION)
$(PKG)_FILE     := shared-mime-info-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 

define $(PKG)_UPDATE
$(WGET) -q -O- 'https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/' | \
    grep 'evince-' | \
    $(SED) -n 's,.*evince-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef

#define $(PKG)_BUILD
#    cd '$(1)/' && ./configure \
#        $(MXE_CONFIGURE_OPTS) \
#	--disable-doxygen \
#	--without-gspell \	
#	--without-libgnome \
#	--without-gconf \
#	--without-keyring \
#	--with-platform=win32 \
#	--with-smclient-backend=win32 \
#	--disable-help \
#	--disable-thumbnailer \
#	--disable-nautilus \
#	--disable-dbus \
#	--disable-gtk-doc \
#	--disable-previewer \
#	--disable-nls \
#	--without-gtk-unix-print \
#	--disable-comics \
#	--disable-browser-plugin \
#        CONFIG_SHELL=$(SHELL)
#    $(MAKE) -C '$(1)/' -j '$(JOBS)' install
#endef
