################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="libretro-picodrive"
PKG_VERSION="f5de3ba"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/picodrive"
PKG_URL="https://github.com/libretro/picodrive/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="picodrive-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain $PKG_NAME:host"
PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Libretro implementation of PicoDrive. (Sega Megadrive/Genesis/Sega Master System/Sega GameGear/Sega CD/32X)"
PKG_LONGDESC="This is yet another Megadrive / Genesis / Sega CD / Mega CD / 32X / SMS emulator, which was written having ARM-based handheld devices in mind (such as smartphones and handheld consoles like GP2X and Pandora), but also runs on non-ARM little-endian hardware too."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cd $PKG_BUILD
  git clone https://github.com/notaz/cyclone68000.git cpu/cyclone
  git clone https://github.com/notaz/libpicofe.git platform/libpicofe
  rm -rf cpu/cyclone/.git
  rm -rf platform/libpicofe/.git
  rm -rf .git
  cd $ROOT
}

pre_configure_host() {
  # fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$HOST_NAME
}

configure_host() {
  : none
}

make_host() {
  make -C cpu/cyclone CONFIG_FILE=../cyclone_config.h
}

makeinstall_host() {
  : none
}

pre_configure_target() {
  # fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME
}

configure_target() {
  strip_gold
}

make_target() {
  case $PROJECT in
    S805)
       make -f Makefile.libretro platform=armv-aml805
      ;;
    S812)
      make -f Makefile.libretro platform=armv-aml812
      ;;
    S905)
      make -f Makefile.libretro platform=armv-aml905
      ;;
  esac
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
    cp `find . -name "*.so" | xargs echo` $INSTALL/usr/lib/libretro/
}
