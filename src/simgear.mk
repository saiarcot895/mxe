# This file is part of MXE.
# See index.html for further information.

PKG             := simgear
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 3021692be05ca1c983ffa7a4483a74934ec02dbb
$(PKG)_SUBDIR   := simgear-$($(PKG)_VERSION)
$(PKG)_FILE     := simgear-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://mirrors.ibiblio.org/simgear/ftp/Source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openscenegraph jpeg boost openal expat cmake freeglut

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://mirrors.ibiblio.org/simgear/ftp/Source/' | \
    $(SED) -n 's,.*simgear-\([0-9]*\.[0-9]*[02468]\.[^<]*\)\.tar.*,\1,p' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS='-D__STDC_CONSTANT_MACROS -D_USE_MATH_DEFINES -fpermissive -std=c++11' \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DSYSTEM_EXPAT=ON \
		 $(if $(BUILD_STATIC), \
		 -DSIMGEAR_SHARED=OFF , \
		 -DSIMGEAR_SHARED=ON )
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
