################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="tvheadend"
PKG_VERSION="a9dffb7"
PKG_REV="3"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvheadend.org"
PKG_URL="none"
PKG_DEPENDS_TARGET="toolchain curl libdvbcsa libiconv openssl pngquant:host Python:host yasm jq"
PKG_SECTION="xmedia/tvservice"
PKG_SHORTDESC="Tvheadend: a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources."
PKG_LONGDESC="Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources. It also comes with a powerful and easy to use web interface both used for configuration and day-to-day operations, such as searching the EPG and scheduling recordings. Even so, the most notable feature of Tvheadend is how easy it is to set up: Install it, navigate to the web user interface, drill into the TV adapters tab, select your current location and Tvheadend will start scanning channels and present them to you in just a few minutes. If installing as an Addon a reboot is needed"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_LOCALE_INSTALL="yes"

unpack() {
  git clone -b 'master' https://github.com/tvheadend/tvheadend.git $PKG_BUILD
  cd $PKG_BUILD
  git reset --hard $PKG_VERSION
  PKG_VERSION_NUMBER=`git describe --match "v*" | sed 's/-g.*$//'`
  echo "****** version: $PKG_VERSION_NUMBER ******"
  sed -e 's/VER="0.0.0~unknown"/VER="'$PKG_VERSION_NUMBER' ~ Alex@ELEC"/g' -i support/version
  sed -e 's|'/usr/bin/pngquant'|'$ROOT/$TOOLCHAIN/bin/pngquant'|g' -i support/mkbundle
  rm -rf .git
  cd $ROOT
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                           --arch=$TARGET_ARCH \
                           --cpu=$TARGET_CPU \
                           --cc=$CC \
                           --disable-avahi \
                           --disable-dbus_1 \
                           --disable-uriparser \
                           --disable-dvbscan \
                           --disable-hdhomerun_client \
                           --disable-hdhomerun_static \
                           --disable-nvenc \
                           --disable-ffmpeg_static \
                           --disable-libav \
                           --disable-bintray_cache \
                           --enable-dvbcsa \
                           --enable-tvhcsa \
                           --enable-dvben50221 \
                           --enable-bundle \
                           --enable-trace \
                           --enable-timeshift \
                           --enable-epoll \
                           --enable-inotify \
                           --enable-pngquant \
                           --nowerror \
                           --python=$ROOT/$TOOLCHAIN/bin/python"

pre_configure_target() {
# fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME

  export CROSS_COMPILE=$TARGET_PREFIX
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/iconv -L$SYSROOT_PREFIX/usr/lib/iconv"
}

post_make_target() {
  $CC -O -fbuiltin -fomit-frame-pointer -fPIC -shared -o capmt_ca.so src/extra/capmt_ca.c -ldl
  $STRIP $ROOT/$PKG_BUILD/build.linux/tvheadend
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P capmt_ca.so $INSTALL/usr/lib

  mkdir -p $INSTALL/usr/bin
    cp -P $PKG_DIR/scripts/* $INSTALL/usr/bin
    cp -P support/sat_xml_scan.py $INSTALL/usr/bin/sat_xml_scan

  #sat files
  mkdir -p $INSTALL/usr/config/tvheadend
  mkdir -p $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/atsc $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-c $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-s $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-t $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/isdb-t $INSTALL/usr/config/tvheadend/dvb-scan
  #config
    rm -f $INSTALL/usr/config/tvheadend/dvb-scan/dvb-t/ua-Kyiv
    rm -f $INSTALL/usr/config/tvheadend/dvb-scan/dvb-s/Amos-*
    rm -f $INSTALL/usr/config/tvheadend/dvb-scan/dvb-s/Sirius-*
    cp -a $PKG_DIR/config/* $INSTALL/usr/config/tvheadend
}

post_install() {
  enable_service tvheadend.service
}
