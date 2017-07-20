#
#	AVL6862 DVB-Sx/Tx/C frontend driver
#

obj-$(CONFIG_AM_DVB) += aml.o aml_fe.o avl6862.o r848.o
aml-objs=aml_dvb.o aml_dmx.o 

EXTRA_CFLAGS += -I.
EXTRA_CFLAGS += -Idrivers/media/dvb-core -Idrivers/media/usb/dvb-usb -Idrivers/media/dvb-frontends -Idrivers/media/tuners
