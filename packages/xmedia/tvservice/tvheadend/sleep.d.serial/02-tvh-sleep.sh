#!/bin/sh
################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

SERVICE="tvheadend.service"
SERVICE_DIR="/storage/.cache/services"
AVL_MODULE_RUN="/usr/bin/avl-dvb.run"

case $1 in
  pre)
    if [ -f "$SERVICE_DIR/tvheadend.conf" ] ; then
      systemctl stop "$SERVICE"
      [ -x "$AVL_MODULE_RUN" ] && $AVL_MODULE_RUN del
    fi
    ;;
  post)
    if [ -f "$SERVICE_DIR/tvheadend.conf" ] ; then
      [ -x "$AVL_MODULE_RUN" ] && $AVL_MODULE_RUN
      systemctl start "$SERVICE"
    fi
    ;;
esac
