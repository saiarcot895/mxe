# This file is part of MXE.
# See index.html for further information.

PKG             := flightgear
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2016.2.1
$(PKG)_CHECKSUM := b554170ca6b5943fd90496759b055fb60f362ea96f6c46dfff89e3d12c940a94
$(PKG)_SUBDIR   := flightgear-$($(PKG)_VERSION)
$(PKG)_FILE     := flightgear-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/flightgear/release-$(word 1,$(subst ., ,$($(PKG)_VERSION))).$(word 2,$(subst ., ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc simgear openscenegraph jpeg libpng plib boost openal freeglut sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/flightgear/files/' | \
    $(SED) -n 's,.*/flightgear-\([0-9][^:]*\):.*,\1,p' | \
    cut -d'.' -f 1-3
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
