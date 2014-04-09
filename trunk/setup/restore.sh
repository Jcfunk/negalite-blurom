#!/sbin/sh

if [ -e /sdcard/Negalite/aroma ]; then
	rm -rf /sdcard/Negalite/aroma
fi	

tar -pxzf /sdcard/Negalite/aroma.tgz
