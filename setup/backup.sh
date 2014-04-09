#!/sbin/sh

if [ -e /sdcard/Negalite/aroma.tgz ]; then
	rm /sdcard/Negalite/aroma.tgz
	mv /tmp/aroma/restore.prop /tmp/aroma/restore.bak.prop
	tar -pczf /sdcard/Negalite/aroma.tgz /tmp/aroma/*.prop
else
	if [ ! -e /sdcard/Negalite ]; then
		mkdir /sdcard/Negalite
	fi
	mv /tmp/aroma/restore.prop /tmp/aroma/restore.bak.prop
	tar -pczf /sdcard/Negalite/aroma.tgz /tmp/aroma/*.prop	
fi	
