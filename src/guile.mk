PKG             := guile
$(PKG)_WEBSITE  := https://www.gnu.org/software/guile/
$(PKG)_DESCR    := GNU Guile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.7
$(PKG)_CHECKSUM := cdf776ea5f29430b1258209630555beea6d2be5481f9da4d64986b077ff37504
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gc gettext gmp libffi libgnurx libiconv libltdl libunistring readline glib
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/gitweb/?p=guile.git;a=tags' | \
    grep '<a [^>]*class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>[^0-9>]*\([0-9][^< ]*\)\.<.*,\1,p' | \
    grep -v 2.* | \
    $(SORT) -Vr | \
    head -1
endef
define $(PKG)_BUILD
    cd '$(SOURCE_DIR)/libguile' && \
    echo '#ifdef __MINGW32__' >> filesys.h && \
    echo '#define open64 open' >> filesys.h && \
    echo '#define lstat64 lstat' >> filesys.h && \
    echo '#define readdir64 readdir' >> filesys.h && \
    echo '#endif' >> filesys.h
    
    cd '$(BUILD_DIR)' && CC_FOR_BUILD=$(BUILD_CC) \
    CFLAGS='-O2 -Wno-unused-but-set-variable -Wno-unused-value -fvisibility=default' \
    CXXFLAGS='-O2' \
    LDFLAGS='' \
    LIBS='-lunistring -lintl -liconv -lssp -lws2_32' \
    ac_cv_func_open64=no \
    ac_cv_func_lstat64=no \
    ac_cv_func_readdir64=no \
    ac_cv_func_mmap=no \
    scm_cv_struct_timespec=no \
    gl_cv_func_poll=yes \
    ac_cv_func_poll=yes \
    gl_cv_header_sys_socket_h_shut_wr_defined=yes \
    gl_cv_header_sys_socket_h_socklen_t_typedef=yes \
    gl_cv_header_sys_select_h_self_contained=yes \
    ac_cv_header_sys_select_h=no \
    $(SOURCE_DIR)/configure \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
	--enable-static \
	--disable-jit \
        --disable-dependency-tracking \
        --disable-largefile \
	--disable-networking \
	--disable-mmap-api \
	--disable-posix 
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' CFLAGS='-O2 -Wno-unused-but-set-variable -Wno-unused-value -fvisibility=default -Dopen64=open -Dlstat64=lstat -Dreaddir64=readdir' $(MXE_DISABLE_CRUFT) schemelib_DATA=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) schemelib_DATA=
endef
