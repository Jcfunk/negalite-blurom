#!/system/bin/sh
##################################################
#  ______                   _       _            #
# |  ___ \                 | |     (_)_          #
# | |   | | ____ ____  ____| |      _| |_  ____  #
# | |   | |/ _  ) _  |/ _  | |     | |  _)/ _  ) #
# | |   | ( (/ ( ( | ( ( | | |_____| | |_( (/ /  #
# |_|   |_|\____)_|| |\_||_|_______)_|\___)____) #
#              (_____|                           #
##################################################
#                                                #
#   Created By Negamann303 for NegaLite-BluRom   #
#                                                #
##################################################
#                                                #
#     Any changes made will require a Reboot     #
#      Don't forget to re-set permissions        #
#                                                #
##################################################

#===============================================================

##############################
# User Customizable Settings #
##############################

#===============================================================

PERFORMANCE_CONTROL="On"  #choices [On, off]
COLOR_RES_CONTROL="On"  #choices [On, off]
VOLTAGE_CONTROL="On"  #choices [On, off]
SD_MEMORY_CONTROL="On"  #choices [On, off]
MEMORY_CONTROL="On"  #choices [On, off]
WIMAX_HACK_CONTROL="On"  #choices [On, off]
DEFRAG_DB_CONTROL="On"  #choices [On, off]
ZIPALIGN_CONTROL="On"  #choices [On, off] 
DISABLE_LOGCAT_CONTROL="On"  #choices [On, off] (Turning 'On' will disable logcat)
SLEEP_CONTROL="On"  #choices [On, off] 

#===============================================================

# Misc Settings
FAST_CHARGE="On"  #choices: [On, Off]
CAPACITIVE_LED="2"  #choices: [2 - dim, 10 - normal, 20 - bright]

#===============================================================

# UnderVolt Options( If VOLTAGE_CONTROL is set to "On" )
UNDER_VOLT="Semi_Low"  #Choices: [Extra_Low, Low, Semi_Low, Medium]

#===============================================================

# Color Resolution ( If COLOR_RES_CONTROL is set to "On" )
COLOR_RES="32"  #choices[16, 24, 32]

# LED Notification Duration
LED_NOTIF_DUR="0" #[0 = Forever]

#===============================================================

# Memory Settings ( If MEMORY_CONTROL is set to "On" )
MEM_MINFREE="1536,3072,19200,25600,32000,38400"
MEM_KILL="0,3,5,7,14,15"
MEM_COST="32"
MEM_DEBUG_LEVEL="0"

#===============================================================

# SD Cache Settings ( If SD_MEMORY_CONTROL is set to "On" )
READ_AHEAD_KB="3024"
VIR_READ_AHEAD_KB="128"
MTD_READ_AHEAD_KB="16"
MAX_RATIO="100"
SCHEDULER="deadline"  #choices: [noop, deadline, cfq, sio, row]

#####################################
# End Of User Customizable Settings #
#####################################

#===============================================================

####################################
#                                  #
# Script specific - DO NOT TOUCH   #
TARGET=`getprop ro.board.platform`
EMMC_BOOT=`getprop ro.emmc`  
#                                  #
####################################
####################################
#Boot Animation End                #
echo "0" > /sys/devices/platform/panel_3d/3D_mode      
#                                  #
####################################

#Remounts with noatime and nodiratime.
busybox mount -o remount,ro /
busybox mount -o remount,ro rootfs
busybox mount -o remount,ro /system 2>/dev/null
busybox mount -o remount,noatime,barrier=0,nobh /system
busybox mount -o remount,noatime,barrier=0,nobh /data
busybox mount -o remount,noatime,barrier=0,nobh /cache
busybox mount -t debugfs debugfs /sys/kernel/debug

if [ $PERFORMANCE_CONTROL = "On" ]; then
	#Kernel
	echo "NO_NORMALIZED_SLEEPER" > /proc/sys/kernel/debug/sched_features
	echo "100000" > /proc/sys/kernel/sched_rt_period_us
	echo "95000" > /proc/sys/kernel/sched_rt_runtime_us
	echo "0" > /proc/sys/kernel/sched_child_runs_first
	echo "0" > /proc/sys/kernel/tainted
	echo "5" > /proc/sys/kernel/panic
	echo "0" > /proc/sys/kernel/panic_on_oops
	echo "1333" > /proc/sys/kernel/random/read_wakeup_threshold
	echo "4096" > /proc/sys/kernel/random/write_wakeup_threshold
	echo "524288" > /proc/sys/kernel/threads-max
	echo "268435456" > /proc/sys/kernel/shmmax
	echo "16777216" > /proc/sys/kernel/shmall
	echo "5000000" > /proc/sys/kernel/sched_latency_ns
	echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns
	echo "1000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

	#FileSystem
	echo "524288" > /proc/sys/fs/file-max
	echo "32000" > /proc/sys/fs/inotify/max_queued_events
	echo "256" > /proc/sys/fs/inotify/max_user_instances
	echo "10240" > /proc/sys/fs/inotify/max_user_watches
	echo "10" > /proc/sys/fs/lease-break-time
	echo "1048576" > /proc/sys/fs/nr_open

	#Sysctl
	echo "0" > /proc/sys/vm/block_dump
	echo "1" > /proc/sys/vm/oom_dump_tasks
	echo "3" > /proc/sys/vm/drop_caches
	echo "1" > /proc/sys/vm/overcommit_memory
	echo "100" > /proc/sys/vm/overcommit_ratio
	echo "0" > /proc/sys/vm/swappiness
	
	swapoff nullswap
	
	echo "80" > /proc/sys/vm/dirty_ratio
	echo "60" > /proc/sys/vm/dirty_background_ratio
	echo "25" > /proc/sys/vm/vfs_cache_pressure
	echo "0" > /proc/sys/vm/oom_kill_allocating_task
	echo "4096" > /proc/sys/vm/min_free_kbytes
	echo "0" > /proc/sys/vm/panic_on_oom
	echo "3" > /proc/sys/vm/page-cluster
	echo "0" > /proc/sys/vm/laptop_mode
	echo "4" > /proc/sys/vm/min_free_order_shift
	echo "1000" > /proc/sys/vm/dirty_expire_centisecs
	echo "2000" > /proc/sys/vm/dirty_writeback_centisecs

	#Net
	echo "1048576" > /proc/sys/net/core/wmem_max
	echo "1048576" > /proc/sys/net/core/rmem_max
	echo "524288" > /proc/sys/net/core/rmem_default
	echo "524288" > /proc/sys/net/core/wmem_default

	echo "0" > /proc/sys/net/ipv4/tcp_ecn
	echo "1" > /proc/sys/net/ipv4/route/flush
	echo "1" > /proc/sys/net/ipv4/tcp_rfc1337
	echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc
	echo "1" > /proc/sys/net/ipv4/tcp_sack
	echo "1" > /proc/sys/net/ipv4/tcp_fack
	echo "1" > /proc/sys/net/ipv4/tcp_window_scaling
	echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
	echo "0" > /proc/sys/net/ipv4/conf/all/secure_redirects
	echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
	echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
	echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
	echo "0" > /proc/sys/net/ipv4/conf/default/secure_redirects
	echo "0" > /proc/sys/net/ipv4/conf/default/accept_source_route
	echo "1" > /proc/sys/net/ipv4/conf/default/rp_filter
	echo "cubic" > /proc/sys/net/ipv4/tcp_congestion_control
	echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
	echo "2" > /proc/sys/net/ipv4/tcp_syn_retries
	echo "1024" > /proc/sys/net/ipv4/tcp_max_syn_backlog
	echo "16384" > /proc/sys/net/ipv4/tcp_max_tw_buckets
	echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
	echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
	echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
	echo "1" > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
	echo "1800" > /proc/sys/net/ipv4/tcp_keepalive_time
	echo "0" > /proc/sys/net/ipv4/ip_forward
	echo "1" > /proc/sys/net/ipv4/tcp_timestamps
	echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
	echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle
	echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
	echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl
	echo "15" > /proc/sys/net/ipv4/tcp_fin_timeout
	echo "1" > /proc/sys/net/ipv4/tcp_workaround_signed_windows
	echo "1" > /proc/sys/net/ipv4/tcp_low_latency
	echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc
	echo "1" > /proc/sys/net/ipv4/tcp_mtu_probing
	echo "2" > /proc/sys/net/ipv4/tcp_frto
	echo "2" > /proc/sys/net/ipv4/tcp_frto_response
fi
	
# CPU Settings
case $TARGET
    in "msm8660")
	    echo "1" > /sys/module/rpm_resources/enable_low_power/L2_cache
	    echo "1" > /sys/module/rpm_resources/enable_low_power/pxo
	    echo "2" > /sys/module/rpm_resources/enable_low_power/vdd_dig
	    echo "2" > /sys/module/rpm_resources/enable_low_power/vdd_mem
	    echo "1" > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu1/power_collapse/idle_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/idle_enabled
	    echo "1" > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/idle_enabled
		echo "0" > /sys/devices/system/cpu/sched_mc_power_savings
	    chown root.system /sys/devices/system/cpu/mfreq
	    chmod 220 /sys/devices/system/cpu/mfreq
    ;;
esac

case $EMMC_BOOT
	in "1")
		chown system /sys/devices/platform/rs300000a7.65536/force_sync
		chown system /sys/devices/platform/rs300000a7.65536/sync_sts
	;;
esac

# MPDecision Options
echo $SLEEP_MIN > /sys/kernel/msm_mpdecision/conf/idle_freq

if [ $COLOR_RES_CONTROL = "On" ]; then
    echo $COLOR_RES > /sys/kernel/debug/msm_fb/0/bpp	
fi
	
# Voltages
if [ $VOLTAGE_CONTROL = "On" ]; then
	if [ -e /sys/devices/system/cpu/cpu0/cpufreq/vdd_levels ]; then			
		vdd_levels=/sys/devices/system/cpu/cpu0/cpufreq/vdd_levels
			
	elif [ -e /sys/devices/system/cpu/cpu1/cpufreq/vdd_levels ]; then			
		vdd_levels=/sys/devices/system/cpu/cpu0/cpufreq/vdd_levels	
			
	elif [ -e /sys/devices/system/cpu/cpufreq/vdd_table/vdd_levels ]; then
		vdd_levels=/sys/devices/system/cpu/cpufreq/vdd_table/vdd_levels
	fi
	
	if [ $UNDER_VOLT = "Extra_Low" ]; then	
		echo "192000 787500" > $vdd_levels
		echo "310500 787500" > $vdd_levels
		echo "384000 800000" > $vdd_levels
		echo "432000 800000" > $vdd_levels
		echo "486000 800000" > $vdd_levels
		echo "540000 800000" > $vdd_levels
		echo "594000 800000" > $vdd_levels
		echo "648000 812500" > $vdd_levels
		echo "702000 837500" > $vdd_levels
		echo "756000 850000" > $vdd_levels
		echo "810000 862500" > $vdd_levels
		echo "864000 875000" > $vdd_levels
		echo "918000 887500" > $vdd_levels
		echo "972000 912500" > $vdd_levels
		echo "1026000 925000" > $vdd_levels
		echo "1080000 950000" > $vdd_levels
		echo "1134000 962500" > $vdd_levels
		echo "1188000 987500" > $vdd_levels
		echo "1242000 1012500" > $vdd_levels
		echo "1296000 1025000" > $vdd_levels
		echo "1350000 1050000" > $vdd_levels
		echo "1404000 1062500" > $vdd_levels
		echo "1458000 1087500" > $vdd_levels
		echo "1512000 1125000" > $vdd_levels
		echo "1536000 1150000" > $vdd_levels
		echo "1566000 1175000" > $vdd_levels
		echo "1620000 1200000" > $vdd_levels
		echo "1674000 1237500" > $vdd_levels
		echo "1728000 1337500" > $vdd_levels
		echo "1782000 1375000" > $vdd_levels
		echo "1836000 1400000" > $vdd_levels
		echo "1944000 1475000" > $vdd_levels
		echo "2052000 1500000" > $vdd_levels
	fi
	
	if [ $UNDER_VOLT = "Low" ]; then	
		echo "192000 800000" > $vdd_levels
		echo "310500 812500" > $vdd_levels
		echo "384000 825000" > $vdd_levels
		echo "432000 837500" > $vdd_levels
		echo "486000 850000" > $vdd_levels
		echo "540000 875000" > $vdd_levels
		echo "594000 875000" > $vdd_levels
		echo "648000 887500" > $vdd_levels
		echo "702000 912500" > $vdd_levels
		echo "756000 925000" > $vdd_levels
		echo "810000 937500" > $vdd_levels
		echo "864000 950000" > $vdd_levels
		echo "918000 962500" > $vdd_levels
		echo "972000 987500" > $vdd_levels
		echo "1026000 1000000" > $vdd_levels
		echo "1080000 1025000" > $vdd_levels
		echo "1134000 1037500" > $vdd_levels
		echo "1188000 1062500" > $vdd_levels
		echo "1242000 1087500" > $vdd_levels
		echo "1296000 1100000" > $vdd_levels
		echo "1350000 1125000" > $vdd_levels
		echo "1404000 1137500" > $vdd_levels
		echo "1458000 1162500" > $vdd_levels
		echo "1512000 1200000" > $vdd_levels
		echo "1536000 1225000" > $vdd_levels
		echo "1566000 1250000" > $vdd_levels
		echo "1620000 1275000" > $vdd_levels
		echo "1674000 1312500" > $vdd_levels
		echo "1728000 1337500" > $vdd_levels
		echo "1782000 1375000" > $vdd_levels
		echo "1836000 1400000" > $vdd_levels
		echo "1944000 1475000" > $vdd_levels
		echo "2052000 1500000" > $vdd_levels
	fi
	
	if [ $UNDER_VOLT = "Semi_Low" ]; then	
		echo "192000 812500" > $vdd_levels
		echo "310500 812500" > $vdd_levels
		echo "384000 825000" > $vdd_levels
		echo "432000 825000" > $vdd_levels
		echo "486000 825000" > $vdd_levels
		echo "540000 825000" > $vdd_levels
		echo "594000 825000" > $vdd_levels
		echo "648000 837500" > $vdd_levels
		echo "702000 862500" > $vdd_levels
		echo "756000 875000" > $vdd_levels
		echo "810000 887500" > $vdd_levels
		echo "864000 900000" > $vdd_levels
		echo "918000 912500" > $vdd_levels
		echo "972000 937500" > $vdd_levels
		echo "1026000 950000" > $vdd_levels
		echo "1080000 975000" > $vdd_levels
		echo "1134000 987500" > $vdd_levels
		echo "1188000 1012500" > $vdd_levels
		echo "1242000 1037500" > $vdd_levels
		echo "1296000 1050000" > $vdd_levels
		echo "1350000 1075000" > $vdd_levels
		echo "1404000 1087500" > $vdd_levels
		echo "1458000 1112500" > $vdd_levels
		echo "1512000 1150000" > $vdd_levels
		echo "1536000 1175000" > $vdd_levels
		echo "1566000 1200000" > $vdd_levels
		echo "1620000 1225000" > $vdd_levels
		echo "1674000 1262500" > $vdd_levels
		echo "1728000 1287500" > $vdd_levels
		echo "1782000 1325000" > $vdd_levels
		echo "1836000 1350000" > $vdd_levels
		echo "1944000 1425000" > $vdd_levels
		echo "2052000 1500000" > $vdd_levels
	fi

	if [ $UNDER_VOLT = "Medium" ]; then	
		echo "192000 825000" > $vdd_levels
		echo "310500 825000" > $vdd_levels
		echo "384000 837500" > $vdd_levels
		echo "432000 837500" > $vdd_levels
		echo "486000 837500" > $vdd_levels
		echo "540000 837500" > $vdd_levels
		echo "594000 837500" > $vdd_levels
		echo "648000 850000" > $vdd_levels
		echo "702000 875000" > $vdd_levels
		echo "756000 887500" > $vdd_levels
		echo "810000 900000" > $vdd_levels
		echo "864000 912500" > $vdd_levels
		echo "918000 925000" > $vdd_levels
		echo "972000 950000" > $vdd_levels
		echo "1026000 962500" > $vdd_levels
		echo "1080000 987500" > $vdd_levels
		echo "1134000 1000000" > $vdd_levels
		echo "1188000 1025000" > $vdd_levels
		echo "1242000 1050000" > $vdd_levels
		echo "1296000 1062500" > $vdd_levels
		echo "1350000 1087500" > $vdd_levels
		echo "1404000 1100000" > $vdd_levels
		echo "1458000 1125000" > $vdd_levels
		echo "1512000 1162500" > $vdd_levels
		echo "1536000 1187500" > $vdd_levels
		echo "1566000 1212500" > $vdd_levels
		echo "1620000 1237500" > $vdd_levels
		echo "1674000 1275000" > $vdd_levels
		echo "1728000 1287500" > $vdd_levels
		echo "1782000 1325000" > $vdd_levels
		echo "1836000 1350000" > $vdd_levels
		echo "1944000 1425000" > $vdd_levels
		echo "2052000 1500000" > $vdd_levels
	fi
fi

# Fast charge
if [ $FAST_CHARGE = "On" ]; then
    echo "1" > /sys/kernel/fast_charge/force_fast_charge
else
 	echo "0" > /sys/kernel/fast_charge/force_fast_charge
fi

# Capacitive LED's
if [ -e /sys/devices/platform/leds-pm8058/leds/button-backlight/currents ]; then
    echo $CAPACITIVE_LED > /sys/devices/platform/leds-pm8058/leds/button-backlight/currents
fi

# LED Notification
if [ -e /sys/kernel/notification_leds/off_timer_multiplier ]; then
	echo $LED_NOTIF_DUR > /sys/kernel/notification_leds/off_timer_multiplier
fi	

# SD Card Tweaks
if [ $SD_MEMORY_CONTROL = "On" ]; then
	echo "8" > /sys/block/mtdblock0/bdi/read_ahead_kb
	echo "8" > /sys/block/mtdblock1/bdi/read_ahead_kb
	echo "8" > /sys/block/mtdblock2/bdi/read_ahead_kb
	echo "8" > /sys/block/mtdblock3/bdi/read_ahead_kb
	echo $SCHEDULER > /sys/block/stl10/queue/scheduler
	echo $SCHEDULER > /sys/block/stl11/queue/scheduler
	echo $SCHEDULER > /sys/block/stl9/queue/scheduler
	echo $SCHEDULER > /sys/block/mmcblk0/queue/scheduler
	echo $SCHEDULER > /sys/block/mmcblk1/queue/scheduler
	echo $READ_AHEAD_KB > /sys/block/stl10/bdi/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/stl11/bdi/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/stl9/bdi/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/mmcblk0/queue/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/mmcblk1/queue/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/devices/virtual/bdi/179:0/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/devices/virtual/bdi/179:64/read_ahead_kb
	echo $MAX_RATIO > /sys/devices/virtual/bdi/179:0/max_ratio
	echo $MAX_RATIO > /sys/devices/virtual/bdi/default/max_ratio
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:0/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:1/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:2/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:3/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:4/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:5/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:6/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:7/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/default/read_ahead_kb
fi
	
# Memory Management
if [ $MEMORY_CONTROL = "On" ]; then
	chmod 664 /sys/module/lowmemorykiller/parameters/minfile
	chmod 664 /sys/module/lowmemorykiller/parameters/minfree
	echo $MEM_MINFREE > /sys/module/lowmemorykiller/parameters/minfree
	echo $MEM_COST > /sys/module/lowmemorykiller/parameters/cost
	echo $MEM_DEBUG_LEVEL > /sys/module/lowmemorykiller/parameters/debug_level
	echo $MEM_KILL > /sys/module/lowmemorykiller/parameters/adj

	# Flags blocks as non-rotational and increases cache size
	LOOP=`ls -d /sys/block/loop*`
	RAM=`ls -d /sys/block/ram*`
	MMC=`ls -d /sys/block/mmc*`

	for r in $LOOP $RAM; do
        echo "0" > $r/queue/rotational
		echo "1" > $r/queue/iosched/back_seek_penalty
		echo "1" > $r/queue/iosched/low_latency
		echo "1" > $r/queue/iosched/slice_idle
		echo "4" > $r/queue/iosched/fifo_batch
		echo "1" > $r/queue/iosched/writes_starved
		echo "8" > $r/queue/iosched/quantum
		echo "1" > $r/queue/iosched/rev_penalty
		echo "1" > $r/queue/rq_affinity
		echo "0" > $r/queue/iostats
		echo "2" > $r/queue/iosched/writes_starved		
	done

	for m in $LOOP $MMC; do
		echo "1024" > $m/queue/nr_requests
	done
fi	
	
# Kill old garbage market doesnt clean
busybox rm -f /cache/*.apk
busybox rm -f /cache/*.tmp
busybox rm -f /cache/recovery/*
busybox rm -f /data/dalvik-cache/*.apk
busybox rm -f /data/dalvik-cache/*.tmp
busybox rm -f /data/system/userbehavior.db
busybox chmod 400 /data/system/usagestats/
busybox chmod 400 /data/system/appusagestats/

# Disable GSF Check In
if [ -e /data/data/com.google.android.gsf/databases/gservices.db ]; then
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 'false' where name = 'perform_market_checkin' and value = 'true'"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 'false' where name = 'checkin_dropbox_upload:system_update' and value = 'true'"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 0 where name = 'market_force_checkin' and value = 1"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 0 where name = 'checkin_interval'"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 0 where name = 'secure:bandwidth_checkin_stat_interval'"
fi

if [ $WIMAX_HACK_CONTROL = "On" ]; then
	start wimax_baud_hack
fi

# Disable Logcat
if [ $DISABLE_LOGCAT_CONTROL = "On" ]; then
	if [ -e /dev/log/main ]; then
		busybox rm /dev/log/main
	fi
fi

# Defrag Databases
if [ $DEFRAG_DB_CONTROL = "On" ]; then
	for i in \
	`busybox find /data -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done

	if [ -d "/dbdata" ]; then
		for i in \
		`busybox find /dbdata -iname "*.db"` 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'
			/system/xbin/sqlite3 $i 'REINDEX;'
		done
	fi


	if [ -d "/datadata" ]; then
		for i in \
		`busybox find /datadata -iname "*.db"`
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'
			/system/xbin/sqlite3 $i 'REINDEX;'
		done
	fi


	for i in \
	`busybox find /sdcard -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done
fi

# Zipalign
if [ $ZIPALIGN_CONTROL = "On" ]; then
	for apk in /system/app/*.apk /system/framework/*.apk; do
		zipalign -c 4 $apk
		ZIPCHECK=$?
		if [ $ZIPCHECK -eq 1 ]; then
			echo ZipAligning $(basename $apk)
			zipalign -f 4 $apk /cache/$(basename $apk)
			if [ -e /cache/$(basename $apk) ]; then
				cp -f -p /cache/$(basename $apk) $apk
				rm /cache/$(basename $apk)
			else
				echo ZipAligning $(basename $apk)
			fi
		else
			echo ZipAlign already completed on $apk
		fi
	done
	
	for apk in /data/app/*.apk; do
		zipalign -c 4 $apk
		ZIPCHECK=$?
		if [ $ZIPCHECK -eq 1 ]; then
			echo ZipAligning $(basename $apk)
			zipalign -f 4 $apk /cache/$(basename $apk)
			if [ -e /cache/$(basename $apk) ]; then
				cp -f -p /cache/$(basename $apk) $apk
				rm /cache/$(basename $apk)
			else
				echo ZipAligning $(basename $apk) Failed
			fi
		else
			echo ZipAlign already completed on $apk
		fi
	done
fi

# Fix Permissions
for file in /system/app/* /system/framework/* /data/app/*; do
	chmod 644 $file
done

if [ -e /data/data/com.android.providers.contacts/files ]; then
	chmod -R 777 /data/data/com.android.providers.contacts/files
fi

# Enable Writeback

case $TARGET
    in "msm8660")
		tune2fs -o journal_data_writeback /dev/block/mmcblk0p23
		tune2fs -o journal_data_writeback /dev/block/mmcblk0p24
		tune2fs -o journal_data_writeback /dev/block/mmcblk0p25
	;;
esac

# Unmount debug filesystem
busybox unmount /sys/kernel/debug

# Run Init.d Scripts
if [ -e /system/etc/init.d ]; then
    busybox run-parts /system/etc/init.d
fi
