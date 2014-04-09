#!/sbin/sh
val=$(cat /tmp/aroma-data/reboot.prop | cut -d"=" -f2)
case $val 
	in  "1")
		sleep 2
		reboot
    ;;
esac
case $val 
	in  "2")
		sleep 2
		reboot recovery	
    ;;	
esac
	
