# This file is part of MXE.
# See index.html for further information.

PKG             := simgear
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2016.2.1
$(PKG)_CHECKSUM := 601d4ef75a7f9e7012f85d6f63219f3e2ef90f98249eaa5d16cc6b1a3c737a0a
$(PKG)_SUBDIR   := simgear-$($(PKG)_VERSION)
$(PKG)_FILE     := simgear-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/flightgear/release-$(word 1,$(subst ., ,$($(PKG)_VERSION))).$(word 2,$(subst ., ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openscenegraph jpeg boost openal expat cmake freeglut

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/flightgear/files/' | \
    $(SED) -n 's,.*/flightgear-\([0-9][^:]*\):.*,\1,p' | \
    cut -d'.' -f 1-3
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS='-D__STDC_CONSTANT_MACROS -D_USE_MATH_DEFINES -fpermissive -std=c++11' \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
		 $(if $(BUILD_STATIC), \
		 -DSIMGEAR_SHARED=OFF \
		 -DSYSTEM_EXPAT=OFF \
		 -DBoost_USE_STATIC_LIBS=ON, \
		 -DSIMGEAR_SHARED=ON \
		 -DSYSTEM_EXPAT=ON)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
