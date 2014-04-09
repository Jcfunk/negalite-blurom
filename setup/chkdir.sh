#!/sbin/sh

if [ -e /sdcard/Negalite/aroma.tgz ]; then
	echo -n "yes" > /tmp/chkdir.txt
else
	echo -n "no" > /tmp/chkdir.txt
	echo -n "selected.0=3" /tmp/aroma/restore.prop
fi
