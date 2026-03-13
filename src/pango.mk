# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pango
$(PKG)_WEBSITE  := http://www.pango.org/
$(PKG)_DESCR    := Pango
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.48.11
$(PKG)_CHECKSUM := 084fd0a74fad05b1b299d194a7366b6593063d370b40272a5d3a1888ceb9ac40
$(PKG)_SUBDIR   := pango-$($(PKG)_VERSION)
$(PKG)_FILE     := pango-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/pango/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo fontconfig freetype glib harfbuzz fribidi

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/pango/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

#define $(PKG)_BUILD
#    rm '$(1)'/docs/Makefile.am
#    cd '$(1)' && NOCONFIGURE=1 ./autogen.sh
#    cd '$(1)' && ./configure \
#        $(MXE_CONFIGURE_OPTS) \
#        --enable-explicit-deps \
#        --with-included-modules \
#        --without-dynamic-modules \
#        CXX='$(TARGET)-g++'
#    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
#endef


define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
       '$(SOURCE_DIR)' '$(BUILD_DIR)'
    
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
