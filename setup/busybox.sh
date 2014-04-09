#!/sbin/sh

BB=/system/xbin/busybox

SYS_BB="`$BB find /system -type f -iname busybox`"
SYS_TB="`$BB find /system -type f -iname toolbox`"

if [ ! -z "$SYS_BB" ] && [ ! -z "$SYS_TB" ]; then
	TB_BIN="watchprops wipe vmstat date uptime reboot getevent getprop setprop id iftop ioctl ionice log lsof nandread newfs_msdos notify ps r schedtop sendevent setconsole setprop sleep smd start stop top umount touch sync route rmmod rmdir rm renice printenv netstat mv mount mkdir lsmod ls ln kill insmod ifconfig grep dmesg df dd cmp chown chmod cat"
	BB_BIN="`$SYS_BB --list`"
fi	

if $BB [ "$1" = "check" ]; then
    for i in $BB_BIN; do
        whichCmd=$($BB which $i)

        if [ ! -z "$whichCmd" ]; then
            x=$($BB readlink $whichCmd)

            if $BB [ ! -z "$x" ] && ( $BB [ "$i" = "[" ] || $BB [ "$i" = "[[" ] || $BB [ -z "`$BB echo $TB_BIN | $BB grep -e " $i\|$i "`" ] ) && $BB [ "`$BB basename $x`" == "toolbox" ]; then
                exit 1
            fi

        else
            exit 1
        fi
    done

    exit 0

elif $BB [ "$1" = "configure" ]; then
    if $BB [ ! -z "$SYS_BB" ] && $BB [ ! -z "$SYS_TB" ]; then
	    for i in $BB_BIN; do
		    # Replace toolbox link if it exists in /system/bin
		    if $BB [ -L /system/bin/$i ]; then
			    if $BB [ "`$BB basename $($BB readlink -f /system/bin/$i)`" = "toolbox" ]; then
				    $BB rm -f /system/bin/$i
				    $BB ln -s $SYS_BB /system/bin/$i

				    # Make sure that we don't have two links
				    if $BB [ -L /system/xbin/$i ]; then
					    $BB rm -f /system/xbin/$i
				    fi
			    fi

		    # Otherwise replace it if it exists in /system/xbin
		    elif $BB [ -L /system/xbin/$i ]; then
			    if $BB  [ "`$BB basename $($BB readlink -f /system/xbin/$i)`" = "toolbox" ]; then
				    $BB rm -f /system/xbin/$i
				    $BB ln -s $SYS_BB /system/xbin/$i
			    fi

		    # If no toolbox link exists, make sure that we do no replace a real binary
		    elif $BB [ ! -f /system/bin/$i ] && $BB [ ! -f /system/xbin/$i ]; then
			    $BB ln -s $SYS_BB /system/bin/$i
		    fi
	    done

	    for i in $TB_BIN; do
		    if $BB [ -L /system/bin/$i ]; then
			    $BB rm -f /system/bin/$i
			    $BB ln -s $SYS_TB /system/bin/$i

			    if $BB [ -e /system/xbin/$i ]; then
				    $BB rm -f /system/xbin/$i
			    fi

		    elif $BB [ -L /system/xbin/$i ]; then
			    $BB rm -f /system/xbin/$i
			    $BB ln -s $SYS_TB /system/xbin/$i

		    elif $BB [ ! -e /system/bin/$i ] && $BB [ ! -e /system/xbin/$i ]; then
			    $BB ln -s $SYS_TB /system/bin/$i
		    fi
	    done
    fi
fi
