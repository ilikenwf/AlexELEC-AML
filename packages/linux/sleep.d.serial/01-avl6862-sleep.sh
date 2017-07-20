#!/bin/sh
################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

AVL_MODULE_RUN="/usr/bin/avl-dvb.run"

case $1 in
  pre)
    if [ -x "$AVL_MODULE_RUN" ] ; then
      $AVL_MODULE_RUN del
    fi
    ;;
  post)
    if [ -x "$AVL_MODULE_RUN" ] ; then
      $AVL_MODULE_RUN
    fi
    ;;
esac
