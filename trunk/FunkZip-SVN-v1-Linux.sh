#!sh

NEGALITE=negalite_blurom

MECH="$(uname -m)"
echo "Detecting System"
sleep 2
echo $MECH
echo $MECH
echo $MECH

if  [ $MECH != "armv7l" ]; then
	
	MYPATH=`readlink -f $0`
	cd `dirname $MYPATH`	

	LINE="$(sed  '4{p;q;}' .svn/entries)"

	echo " Android Detected! - Zipping"
	sleep 2
	echo "."
	echo "."
	echo "Current MOD Revision is: v$LINE"
	sleep 2
	
	zip -5 negalite-funk_mod_v$LINE.zip -r applications_data applications_optional applications_required applications_stock applications_system \
		carrier_cricket carrier_sprint carrier_virgin_mobile graphics kernel META-INF rosie_mods senseless setup sound_optional superuser system -x "*.svn*"	
	
	if [ -e negalite-funk_mod_vLINE.zip ]; then	
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

	REVISION="$(svn info http://negalite-blurom.googlecode.com/svn/trunk/ | grep "^Revision:" | cut -c 11-)"
	REV="$(($REVISION - 1))"
	
	chmod 775 $NEGAZIP/signapk.jar

	echo "."
	echo "."
	echo "Current MOD Revision is: v$REV"
	echo "."
	echo "."
	sleep 2
	echo "Signing negalite-funk_mod_v$REV"
	echo "."
	echo "."

	java -jar $NEGAZIP/signapk.jar $NEGAZIP/certificate.pem $NEGAZIP/key.pk8 $NEGAZIP/$NEGALITE.zip $NEGAZIP/$NEGALITE.sig

	mv $NEGAZIP/$NEGALITE.sig ./negalite-funk_mod_v$REV.zip

	if [ -e $NEGAZIP/$NEGALITE.zip ]; then
		rm $NEGAZIP/$NEGALITE.zip
	fi

	if [ -e ./negalite-funk_mod_v$REV.zip ]; then	
		echo "Done, Now Go Flash This Baby!" 
	else
		echo "Something went wrong... No Zip exists. Make sure your SVN is updated to the latest revision..." 
	fi 
fi

