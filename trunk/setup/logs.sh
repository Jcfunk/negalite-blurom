#!/sbin/sh

if [ ! -e /sdcard/Negalite ]; then
	mkdir /sdcard/Negalite
fi

if [ -e /sdcard/Negalite/aroma.log ]; then
	cp -f /tmp/aroma/.install.log /sdcard/Negalite/aroma.log
else	
	mv /tmp/aroma/.install.log /sdcard/Negalite/aroma.log
fi

if [ -e /sdcard/Negalite/recovery.log ]; then
	cp -f /tmp/recovery.log /sdcard/Negalite/recovery.log
else
	mv /tmp/recovery.log /sdcard/Negalite/recovery.log	
fi
