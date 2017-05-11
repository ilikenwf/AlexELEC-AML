################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="emulationstation"
PKG_VERSION="268e6c8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/RetroPie/EmulationStation"
PKG_URL="none"
PKG_SOURCE_DIR="EmulationStation*"
PKG_DEPENDS_TARGET="toolchain systemd SDL2 boost freetype curl cmake:host freeimage eigen libvlc"
PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Emulationstation emulator frontend"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# theme for Emulationstation
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-simple-dark"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-carbon"

unpack() {
  git clone --recursive https://github.com/RetroPie/EmulationStation $PKG_BUILD
  cd $PKG_BUILD
  git reset --hard $PKG_VERSION
  rm -rf .git
  cd $ROOT
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/emulationstation
    cp $PKG_DIR/config/* $INSTALL/usr/config/emulationstation
  mkdir -p $INSTALL/etc
    ln -sf /storage/.config/emulationstation $INSTALL/etc/emulationstation
}
