#!/system/bin/sh

NEGALITE=negalite_blurom

if [ -e /sdcard/NegaBluerom/negalite-blurom_ ] || [ -e /sdcard/OASVNlite/negalite-blurom_ ]; then
	
	MYPATH=`realpath $0` 
	cd `dirname $MYPATH`	

	LINE="$(sed -n '4{p;q;}' .svn/entries)"

	echo "OASVN Detected! - Zipping"
	sleep 2
	echo "."
	echo "."
	echo "Current Revision is: r$LINE"
	sleep 2
	
	zip -5 negalite_blurom_r$LINE.zip -r applications_data applications_optional applications_required applications_stock applications_system \
		carrier_cricket carrier_sprint carrier_virgin_mobile graphics kernel META-INF rosie_mods senseless setup sound_optional superuser system -x "*.svn*"	
	
	if [ -e negalite_blurom_r$LINE.zip ]; then	
		echo "Done, Now Go Flash This Baby!" 
	else
		echo "Something went wrong... No Zip exists. Make sure your SVN is updated to the latest revision..." 
	fi	
else

	echo "Linux Detected - Zipping, Signing and Renaming"
	sleep 3
	
	NEGAZIP=./zzz-NegaZip-Linux
	
	zip -9 ./$NEGALITE.zip -r ./applications_data ./applications_optional ./applications_required ./applications_stock ./applications_system \
		./carrier_cricket ./carrier_sprint ./carrier_virgin_mobile ./graphics ./kernel ./META-INF ./rosie_mods ./senseless ./setup ./sound_optional ./superuser ./system -x "*.svn*"

	mv ./$NEGALITE.zip $NEGAZIP/$NEGALITE.zip

	REVISION="$(svn info https://subversion.assembla.com/svn/negalite-blurom/ | grep "^Revision:" | cut -c 11-)"

	chmod 775 $NEGAZIP/signapk.jar

	echo "."
	echo "."
	echo "Current Revision is: r$REVISION"
	echo "."
	echo "."
	sleep 2
	echo "Signing negalite_blurom_r$REVISION"
	echo "."
	echo "."

	java -jar $NEGAZIP/signapk.jar $NEGAZIP/certificate.pem $NEGAZIP/key.pk8 $NEGAZIP/$NEGALITE.zip $NEGAZIP/$NEGALITE.sig

	mv $NEGAZIP/$NEGALITE.sig ./negalite_blurom_r$REVISION.zip

	if [ -e $NEGAZIP/$NEGALITE.zip ]; then
		rm $NEGAZIP/$NEGALITE.zip
	fi

	if [ -e ./negalite_blurom_r$REVISION.zip ]; then	
		echo "Done, Now Go Flash This Baby!" 
	else
		echo "Something went wrong... No Zip exists. Make sure your SVN is updated to the latest revision..." 
	fi 
fi

