# This file is part of MXE.
# See index.html for further information.

PKG             := flightgear
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := b5645d05b50728a89f091292bc557f440d8f8719dd9cebf7f5bf3fa8ea795780
$(PKG)_SUBDIR   := flightgear-$($(PKG)_VERSION)
$(PKG)_FILE     := flightgear-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.flightgear.org/flightgear/Source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cmake simgear openscenegraph jpeg libpng plib boost openal freeglut sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.flightgear.org/flightgear/Source/' | \
    $(SED) -n 's,.*flightgear-\([0-9]*\.[0-9]*[02468]\.[^<]*\)\.tar.*,\1,p' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS='-D__STDC_CONSTANT_MACROS -D_USE_MATH_DEFINES -fpermissive' \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
		 $(if $(BUILD_STATIC), \
		 -DSIMGEAR_SHARED=OFF, \
		 -DSIMGEAR_SHARED=ON) \
		-DSYSTEM_SQLITE=ON \
		-DENABLE_FGCOM=OFF \
		-DENABLE_IAX=OFF
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
