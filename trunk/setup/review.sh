#!/sbin/sh

if [ ! -e /sdcard/Negalite ]; then
	mkdir /sdcard/Negalite
fi

WIPE=/tmp/aroma/wipe.prop
ROSIE=/tmp/aroma/rosie.prop
GRAPHICS=/tmp/aroma/graphics.prop
VSYNC=/tmp/aroma/vsync.prop
CARRIER=/tmp/aroma/carrier.prop
ADDSTOCK=/tmp/aroma/addstock.prop
ROMTYPE=/tmp/aroma/romtype.prop
APPS=/tmp/aroma/apps.prop
STOCK=/tmp/aroma/stock.prop
OPTIONAL=/tmp/aroma/optional.prop
SUPERUSER=/tmp/aroma/superuser.prop
FRIENDSTREAM=/tmp/aroma/friendstream.prop
KERNEL=/tmp/aroma/kernel.prop
WIDGET=/tmp/aroma/widget.prop

S1="selected.0=1"
S2="selected.0=2"
S3="selected.0=3"
S4="selected.0=4"
S5="selected.0=5"
S6="selected.0=6"

I1="item.0.1=1"
I2="item.0.2=1"
I3="item.0.3=1"
I4="item.0.4=1"
I5="item.0.5=1"
I6="item.0.6=1"
I7="item.0.7=1"
I8="item.0.8=1"
I9="item.0.9=1"
I10="item.0.10=1"
I11="item.0.11=1"
I12="item.0.12=1"
I13="item.0.13=1"
I14="item.0.14=1"
I15="item.0.15=1"
I16="item.0.16=1"
I17="item.0.17=1"
I18="item.0.18=1"
I19="item.0.19=1"
I20="item.0.20=1"
I21="item.0.21=1"
I22="item.0.22=1"
I23="item.0.23=1"
I24="item.0.24=1"
I25="item.0.25=1"
I26="item.0.26=1"
I27="item.0.27=1"
I28="item.0.28=1"
I29="item.0.29=1"
I30="item.0.30=1"
I31="item.0.31=1"

CHECK=/tmp/chkoptions.txt
REVIEW=/tmp/review.txt
SUMMARY=/tmp/summary.txt

touch $CHECK
chmod 777 $CHECK
echo "Backed-up options:" > $CHECK
echo "" >> $CHECK

################
# Wipe Options
################

echo "Wipe Options:" >> $CHECK

if [ -e $WIPE ]; then
	if fgrep $I1 $WIPE; then
		echo "Format Boot Partition" >> $CHECK
	fi

	if fgrep $I2 $WIPE; then
		echo "Format Ext4 Data Partition" >> $CHECK
	fi

	if fgrep $I3 $WIPE; then
		echo "FormatExt4 SD-Ext Partitions" >> $CHECK
	fi

	if fgrep $I4 $WIPE; then
		echo "Remove Old System Files From SD Card" >> $CHECK
	fi
else
	echo "None Selected" >> $CHECK
fi

echo "" >> $CHECK

################
# Rosie Options
################

echo "Rosie Selection:" >> $CHECK

if fgrep $S1 $ROSIE; then
	echo "4x4 Rosie Mod" >> $CHECK
fi

if fgrep $S2 $ROSIE; then
	echo "4x5 Rosie Mod" >> $CHECK
fi

if fgrep $S3 $ROSIE; then
	echo "4x6 Rosie Mod" >> $CHECK
fi

if fgrep $S4 $ROSIE; then
	echo "5x5 Rosie Mod" >> $CHECK
fi

echo "" >> $CHECK

################
# Graphics Options
################

echo "Graphics Selection:" >> $CHECK

if fgrep $S1 $GRAPHICS; then
	echo "Quality Graphics Settings" >> $CHECK
fi

if fgrep $S2 $GRAPHICS; then
	echo "Performance Graphics Settings" >> $CHECK
fi

echo "" >> $CHECK

################
# Vsync Options
################

echo "Vsync Selection:" >> $CHECK

if fgrep $S1 $VSYNC; then
	echo "VSync On" >> $CHECK
fi

if fgrep $S2 $VSYNC; then
	echo "VSync Off" >> $CHECK
fi

echo "" >> $CHECK

################
# Carrier Options
################

echo "Carrier Selection:" >> $CHECK

if fgrep $S1 $CARRIER; then
	echo "Cricket Carrier Files" >> $CHECK
fi

if fgrep $S2 $CARRIER; then
	echo "Sprint Carrier Files" >> $CHECK
fi

if fgrep $S3 $CARRIER; then
	echo "Virgin Mobile Carrier Files" >> $CHECK
fi

echo "" >> $CHECK

################
# RomType Options
################

echo "Launcher Selection:" >> $CHECK

if fgrep $S1 $ROMTYPE; then
	echo "Sense Launcher" >> $CHECK
fi

if fgrep $S2 $ROMTYPE; then
	echo "Apex Launcher With Extras" >> $CHECK
fi

if fgrep $S3 $ROMTYPE; then
	echo "Go Launcher With Extras" >> $CHECK
fi

if fgrep $S4 $ROMTYPE; then
	echo "Nova Launcher With Extras" >> $CHECK
fi

if fgrep $S5 $ROMTYPE; then
	echo "Blank Rom Setup" >> $CHECK
fi

if fgrep $S6 $ROMTYPE; then
	echo "Tablet Mode" >> $CHECK
fi

echo "" >> $CHECK

################
# Apps Options
################

echo "App Options:" >> $CHECK

if [ -e $APPS ]; then
	if fgrep $I1 $APPS; then
		echo "Ad-Away" >> $CHECK
	fi

	if fgrep $I2 $APPS; then
		echo "Adobe Reader" >> $CHECK
	fi

	if fgrep $I3 $APPS; then
		echo "Android Terminal" >> $CHECK
	fi

	if fgrep $I4 $APPS; then
		echo "Cache Cleaner NG" >> $CHECK
	fi

	if fgrep $I5 $APPS; then
		echo "Dolby Mobile" >> $CHECK
	fi

	if fgrep $I6 $APPS; then
		echo "Root Browser" >> $CHECK
	fi

	if fgrep $I7 $APPS; then
		echo "Facebook" >> $CHECK
	fi	
	
	if fgrep $I8 $APPS; then
		echo "Facebook Home" >> $CHECK
	fi

	if fgrep $I9 $APPS; then
		echo "Flashplayer" >> $CHECK
	fi

	if fgrep $I10 $APPS; then
		echo "Google Chrome" >> $CHECK
	fi	
	
	if fgrep $I11 $APPS; then
		echo "Google+" >> $CHECK
	fi

	if fgrep $I12 $APPS; then
		echo "Google Mail" >> $CHECK
	fi

	if fgrep $I13 $APPS; then
		echo "Google Maps" >> $CHECK
	fi

	if fgrep $I14 $APPS; then
		echo "Google Mobile Services" >> $CHECK
	fi

	if fgrep $I15 $APPS; then
		echo "Google Play Music" >> $CHECK
	fi

	if fgrep $I16 $APPS; then
		echo "Google Videos" >> $CHECK
	fi

	if fgrep $I17 $APPS; then
		echo "Google Voice" >> $CHECK
	fi	
	
	if fgrep $I18 $APPS; then
		echo "Kernel Tuner" >> $CHECK
	fi

	if fgrep $I19 $APPS; then
		echo "MX Player" >> $CHECK
	fi

	if fgrep $I20 $APPS; then
		echo "Mobile SVN" >> $CHECK
	fi

	if fgrep $I21 $APPS; then
		echo "NoozXoid EIZO Rewire Pro" >> $CHECK
	fi

	if fgrep $I22 $APPS; then
		echo "Playstation Mobile" >> $CHECK
	fi

	if fgrep $I23 $APPS; then
		echo "Script-Manager" >> $CHECK
	fi
	
	if fgrep $I24 $APPS; then
		echo "StickMount OTG" >> $CHECK
	fi

	if fgrep $I25 $APPS; then
		echo "System Tuner" >> $CHECK
	fi

	if fgrep $I26 $APPS; then
		echo "Titanium Backup" >> $CHECK
	fi

	if fgrep $I27 $APPS; then
		echo "Ultimate Backup" >> $CHECK
	fi

	if fgrep $I28 $APPS; then
		echo "USB OTG Helper" >> $CHECK
	fi

	if fgrep $I29 $APPS; then
		echo "Volume Sync" >> $CHECK
	fi

	if fgrep $I30 $APPS; then
		echo "Wifi Tether" >> $CHECK
	fi

	if fgrep $I31 $APPS; then
		echo "YouTube" >> $CHECK
	fi
else
	echo "None Selected" >> $CHECK
fi
echo "" >> $CHECK

################
# Stock Options
################

echo "Stock Options:" >> $CHECK

if [ -e $STOCK ]; then
	if fgrep $S1 $STOCK; then
		echo "All Optional Stock Files" >> $CHECK
	fi

	if fgrep $S2 $STOCK; then
		echo "Hand-Picked Optional Stock File Selections" >> $CHECK
	fi

	if fgrep $S3 $STOCK; then
		echo "None Selected" >> $CHECK
	fi
fi

echo "" >> $CHECK

################
# AddStock Options
################

echo "Extra Stock Options:" >> $CHECK

if [ -e $ADDSTOCK ]; then
	if fgrep $I1 $ADDSTOCK; then
		echo "Connections Optimizer" >> $CHECK
	fi

	if fgrep $I2 $ADDSTOCK; then
		echo "HTC Screenshot" >> $CHECK
	fi

	if fgrep $I3 $ADDSTOCK; then
		echo "HTC Facebook" >> $CHECK
	fi

	if fgrep $I4 $ADDSTOCK; then
		echo "Internet Browser" >> $CHECK
	fi
else
	echo "None Selected" >> $CHECK
fi

echo "" >> $CHECK

################
# Optional Options
################

echo "Stock App Options:" >> $CHECK

if [ -e $OPTIONAL ]; then
	if fgrep $I1 $OPTIONAL; then
		echo "All Sounds" >> $CHECK
	fi

	if fgrep $I2 $OPTIONAL; then
		echo "All Wallpapers" >> $CHECK
	fi

	if fgrep $I3 $OPTIONAL; then
		echo "Amazon MP3" >> $CHECK
	fi

	if fgrep $I4 $OPTIONAL; then
		echo "Blockbuster" >> $CHECK
	fi

	if fgrep $I5 $OPTIONAL; then
		echo "DockMode" >> $CHECK
	fi

	if fgrep $I6 $OPTIONAL; then
		echo "EReader" >> $CHECK
	fi

	if fgrep $I7 $OPTIONAL; then
		echo "FaceLock" >> $CHECK
	fi

	if fgrep $I8 $OPTIONAL; then
		echo "Flickr" >> $CHECK
	fi

	if fgrep $I9 $OPTIONAL; then
		echo "HTC Car Panel" >> $CHECK
	fi

	if fgrep $I10 $OPTIONAL; then
		echo "HTC Caompress Viewer" >> $CHECK
	fi

	if fgrep $I11 $OPTIONAL; then
		echo "HTC Data Roaming Widget" >> $CHECK
	fi

	if fgrep $I12 $OPTIONAL; then
		echo "HTC Data Strip Widget" >> $CHECK
	fi

	if fgrep $I13 $OPTIONAL; then
		echo "HTC Footprints" >> $CHECK
	fi
	
	if fgrep $I14 $OPTIONAL; then
		echo "HTC Footprints" >> $CHECK
	fi

	if fgrep $I15 $OPTIONAL; then
		echo "HTC Notes" >> $CHECK
	fi

	if fgrep $I16 $OPTIONAL; then
		echo "HTC Watch" >> $CHECK
	fi

	if fgrep $I17 $OPTIONAL; then
		echo "JetCet Print" >> $CHECK
	fi

	if fgrep $I18 $OPTIONAL; then
		echo "MyShelf Widget" >> $CHECK
	fi

	if fgrep $I19 $OPTIONAL; then
		echo "News" >> $CHECK
	fi

	if fgrep $I20 $OPTIONAL; then
		echo "Nascar Sprint" >> $CHECK
	fi

	if fgrep $I21 $OPTIONAL; then
		echo "Picasa" >> $CHECK
	fi

	if fgrep $I22 $OPTIONAL; then
		echo "Polaris Ofce" >> $CHECK
	fi

	if fgrep $I23 $OPTIONAL; then
		echo "Sprint Mobile Wallet" >> $CHECK
	fi

	if fgrep $I24 $OPTIONAL; then
		echo "Sprint TV" >> $CHECK
	fi

	if fgrep $I25 $OPTIONAL; then
		echo "Sprint Zone" >> $CHECK
	fi

	if fgrep $I26 $OPTIONAL; then
		echo "Stocks" >> $CHECK
	fi

	if fgrep $I27 $OPTIONAL; then
		echo "Swype Keyboard" >> $CHECK
	fi

	if fgrep $I28 $OPTIONAL; then
		echo "Talkback" >> $CHECK
	fi

	if fgrep $I29 $OPTIONAL; then
		echo "Transfer Rider" >> $CHECK
	fi

	if fgrep $I30 $OPTIONAL; then
		echo "Trends Widget" >> $CHECK
	fi

	if fgrep $I31 $OPTIONAL; then
		echo "Trends Widget" >> $CHECK
	fi
	echo "" >> $CHECK
else
	echo "None Selected" >> $CHECK
fi

################
# FriendStream Option
################

if [ -e $FRIENDSTREAM ]; then
	if fgrep $S1 $FRIENDSTREAM; then
		echo "Removing FriendStream" >> $CHECK
		echo "" >> $CHECK
	fi
else
	echo "" >> $CHECK
fi

################
# RomType Options
################


if [ -e $WIDGET ]; then
	if fgrep $S1 $WIDGET; then
		echo "Including Fancy Sense Widgets" >> $CHECK
		echo "" >> $CHECK
	fi
fi

################
# SuperUser Options
################

echo "SuperUser Selection:" >> $CHECK

if fgrep $S1 $SUPERUSER; then
	echo "CWM Superuser Support" >> $CHECK
fi

if fgrep $S2 $SUPERUSER; then
	echo "MIUI Security Support" >> $CHECK
fi

if fgrep $S3 $SUPERUSER; then
	echo "SuperSU Support" >> $CHECK
fi

if fgrep $S4 $SUPERUSER; then
	echo "Superuser Support" >> $CHECK
fi

echo "" >> $CHECK

################
# Kernel Options
################

echo "Kernel Selection:" >> $CHECK

if fgrep $S1 $KERNEL; then
	echo "Kernel Maxed Settings" >> $CHECK
fi

if fgrep $S2 $KERNEL; then
	echo "Kernel Extreme Settings" >> $CHECK
fi

if fgrep $S3 $KERNEL; then
	echo "Kernel Over-Clock Settings" >> $CHECK
fi

if fgrep $S4 $KERNEL; then
	echo "Kernel Relaxed Settings" >> $CHECK
fi

if fgrep $S5 $KERNEL; then
	echo "Kernel Under-Clock Settings" >> $CHECK
fi

################
# File Settings
################

if [ -e /tmp/aroma/restore.prop ]; then
	if [ ! -e $REVIEW ]; then
		mv $CHECK $REVIEW
		chmod 777 $REVIEW
	fi
else	
	if [ ! -e $SUMMARY ]; then
		mv $CHECK $SUMMARY
		chmod 777 $SUMMARY
	fi	
fi

if [ -e /sdcard/Negalite/summary.txt ]; then
	cp -f $SUMMARY /sdcard/Negalite/summary.txt
else
	mv $SUMMARY /sdcard/Negalite/summary.txt
fi

if [ -e /sdcard/Negalite/review.txt ]; then
	cp -f $REVIEW /sdcard/Negalite/review.txt
else
	mv $REVIEW /sdcard/Negalite/review.txt
fi

sleep 3
