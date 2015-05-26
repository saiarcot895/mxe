# This file is part of MXE.
# See index.html for further information.

PKG             := dcmtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.1_20150217
$(PKG)_CHECKSUM := 87ad15e13850f0db7139ad4395f2d4f1502ca288
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://dicom.offis.de/pub/dicom/offis/software/$(PKG)/snapshot/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl tiff libpng libxml2 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://dicom.offis.de/dcmtk.php.en' | \
    $(SED) -n 's,.*/dcmtk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake '$(1)' \
	-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
	-DCMAKE_PREFIX_PATH:PATH='$(PREFIX)/$(TARGET)' \
	-DDCMTK_WITH_OPENSSL=ON \
	-DDCMTK_WITH_TIFF=ON \
	-DDCMTK_WITH_PNG=ON \
	-DDCMTK_WITH_XML=ON \
	-DDCMTK_WITH_ZLIB=ON \
	-DDCMTK_WITH_WRAP=OFF \
	$(if $(BUILD_SHARED),-DBUILD_SHARED_LIBS=ON -DDCMTK_SHARED_LIBRARIES=ON)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
