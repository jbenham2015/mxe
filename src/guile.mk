PKG             := guile
$(PKG)_WEBSITE  := https://www.gnu.org/software/guile/
$(PKG)_DESCR    := GNU Guile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.10
$(PKG)_CHECKSUM := bd7168517fd526333446d4f7ab816527925634094fbd37322e17e2b8d8e76388
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
    # Patch to avoid 64-bit file functions on Windows
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
    LIBS='-lunistring -lintl -liconv -ldl -lssp -lmman' \
    ac_cv_func_open64=no \
    ac_cv_func_lstat64=no \
    ac_cv_func_readdir64=no \
    scm_cv_struct_timespec=no \
    ac_cv_func_mmap=no \
    cv_func_readdir64=no \
    cv_func_mmap=no \
    _cv_struct_timespec=no \
    cv_func_poll=yes \
    cv_header_sys_select_h=no \
    $(SOURCE_DIR)/configure \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static \
	--disable-mmap-api \
        --disable-dependency-tracking \
	--disable-posix \
        --disable-largefile
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' CFLAGS='-O2 -Wno-unused-but-set-variable -Wno-unused-value -fvisibility=default -Dopen64=open -Dlstat64=lstat -Dreaddir64=readdir' $(MXE_DISABLE_CRUFT) schemelib_DATA=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) schemelib_DATA=
    $(SED) -i \
        's,#elif defined _WIN32 || defined __CYGWIN__,#elif defined SCM_STATIC_BUILD\n# define SCM_API extern\n#elif defined _WIN32 || defined __CYGWIN__,' \
        '$(PREFIX)/$(TARGET)/include/guile/3.0/libguile/scm.h'
    echo 'guile build complete, skipping link test'
endef
