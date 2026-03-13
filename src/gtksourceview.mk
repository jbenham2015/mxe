# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtksourceview
$(PKG)_WEBSITE  := https://projects.gnome.org/gtksourceview/
$(PKG)_DESCR    := GTKSourceView
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.24.11
$(PKG)_CHECKSUM := 691b074a37b2a307f7f48edc5b8c7afa7301709be56378ccf9cc9735909077fd
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib gtk3 libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/gtksourceview/refs/tags' | \
    $(SED) -n 's,.*>GTKSOURCEVIEW_\([0-9]\+_[0-9]*[02468]_[0-9_]\+\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v '^2\.9[0-9]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-gtk-doc \
	CFLAGS="-Wno-error=incompatible-pointer-types"
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

