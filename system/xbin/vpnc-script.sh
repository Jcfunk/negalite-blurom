#!/system/bin/sh 
#* reason                       -- why this script was called, one of: pre-init connect disconnect
#* VPNGATEWAY                   -- vpn gateway address (always present)
#* TUNDEV                       -- tunnel device (always present)
#* INTERNAL_IP4_ADDRESS         -- address (always present)
#* INTERNAL_IP4_NETMASK         -- netmask (often unset)
#* INTERNAL_IP4_NETMASKLEN      -- netmask length (often unset)
#* INTERNAL_IP4_NETADDR         -- address of network (only present if netmask is set)
#* INTERNAL_IP4_DNS             -- list of dns serverss
#* INTERNAL_IP4_NBNS            -- list of wins servers
#* CISCO_DEF_DOMAIN             -- default domain name
#* CISCO_BANNER                 -- banner from server
#* CISCO_SPLIT_INC              -- number of networks in split-network-list
#* CISCO_SPLIT_INC_%d_ADDR      -- network address
#* CISCO_SPLIT_INC_%d_MASK      -- subnet mask (for example: 255.255.255.0)
#* CISCO_SPLIT_INC_%d_MASKLEN   -- subnet masklen (for example: 24)
#* CISCO_SPLIT_INC_%d_PROTOCOL  -- protocol (often just 0)
#* CISCO_SPLIT_INC_%d_SPORT     -- source port (often just 0)
#* CISCO_SPLIT_INC_%d_DPORT     -- destination port (often just 0)

# FIXMEs:

# Section A: route handling

# 1) The 3 values CISCO_SPLIT_INC_%d_PROTOCOL/SPORT/DPORT are currently being ignored
#   In order to use them, we'll probably need os specific solutions
#   * Linux: iptables -t mangle -I PREROUTING <conditions> -j ROUTE --oif $TUNDEV
#       This would be an *alternative* to changing the routes (and thus 2) and 3)
#       shouldn't be relevant at all)
# 2) There are two different functions to set routes: generic routes and the
#   default route. Why isn't the defaultroute handled via the generic route case?
# 3) In the split tunnel case, all routes but the default route might get replaced
#   without getting restored later. We should explicitely check and save them just
#   like the defaultroute
# 4) Replies to a dhcp-server should never be sent into the tunnel

# Section B: Split DNS handling

# 1) Maybe dnsmasq can do something like that
# 2) Parse dns packets going out via tunnel and redirect them to original dns-server

# env | sort
# set -x 

# =========== script (variable) setup ====================================

PATH=/sbin:/usr/sbin:$PATH

OS="`uname -s`"
#FULL_SCRIPTNAME=/system/bin/vpnc
FULL_SCRIPTNAME=/data/data/org.codeandroid.vpnc_frontend/files/vpnc
SCRIPTPATH=/data/data/org.codeandroid.vpnc_frontend/files
SCRIPTNAME=`basename $FULL_SCRIPTNAME`

# stupid SunOS: no blubber in /usr/local/bin ... (on stdout)
IPROUTE="`which ip | grep '^/' 2> /dev/null`"
IFCONFIG="`which ifconfig | grep '^/' 2> /dev/null`"
ROUTE="`which route | grep '^/' 2> /dev/null`"

ifconfig_syntax_ptp="pointopoint"
route_syntax_gw="gw"
route_syntax_del="del"
route_syntax_netmask="netmask"

MODIFYRESOLVCONF=modify_resolvconf_android
RESTORERESOLVCONF=restore_resolvconf_android

# =========== tunnel interface handling ====================================
do_ifconfig() {
	if [ -n "$INTERNAL_IP4_MTU" ]; then
		MTU=$INTERNAL_IP4_MTU
	elif [ -n "$IPROUTE" ]; then
		DEV=$($IPROUTE route | grep ^default | sed 's/^.* dev \([[:alnum:]-]\+\).*$/\1/')
		MTU=$(($($IPROUTE link show "$DEV" | grep mtu | sed 's/^.* mtu \([[:digit:]]\+\).*$/\1/') - 88))
	else
		MTU=1412
	fi

	# Point to point interface require a netmask of 255.255.255.255 on some systems
	"$IFCONFIG" "$TUNDEV" inet "$INTERNAL_IP4_ADDRESS" $ifconfig_syntax_ptp "$INTERNAL_IP4_ADDRESS" netmask 255.255.255.255  up

	if [ -n "$INTERNAL_IP4_NETMASK" ]; then
		set_network_route $INTERNAL_IP4_NETADDR $INTERNAL_IP4_NETMASK $INTERNAL_IP4_NETMASKLEN
	fi
}

destroy_tun_device() {
	echo "Destroying tun device" 
}

# =========== route handling ====================================
fix_ip_get_output () {
	sed 's/cache//;s/metric \?[0-9]\+ [0-9]\+//g;s/hoplimit [0-9]\+//g'
}

set_vpngateway_route() {
	$IPROUTE route add `$IPROUTE route get "$VPNGATEWAY" | fix_ip_get_output`
	# blue led on, when vpn connection is on
	echo 1 > /sys/devices/platform/leds-microp/leds/blue/brightness
	# deleting routing rules, since the traffic must go through the tunnel
	$IPROUTE rule del table wifi
	$IPROUTE rule del table gprs
	$IPROUTE route flush cache
}

del_vpngateway_route() {
	$IPROUTE route $route_syntax_del "$VPNGATEWAY"
	# blue led off when disconnected
	echo 0 > /sys/devices/platform/leds-microp/leds/blue/brightness
	# now adding back deleted routing rules
	$IPROUTE rule add table wifi
	$IPROUTE rule add table gprs
	$IPROUTE route flush cache
}

set_default_route() {
	DEFAULT_ROUTE_FILE=`dirname $0`/def_route.txt
	$IPROUTE route | grep '^default' | fix_ip_get_output > "$DEFAULT_ROUTE_FILE"
	$IPROUTE route replace default dev "$TUNDEV"
	$IPROUTE route flush cache
}

set_network_route() {
	NETWORK="$1"
	NETMASK="$2"
	NETMASKLEN="$3"
	$IPROUTE route replace "$NETWORK/$NETMASKLEN" dev "$TUNDEV"
	$IPROUTE route flush cache
}

reset_default_route() {
	DEFAULT_ROUTE_FILE=`dirname $0`/def_route.txt
	if [ -s "$DEFAULT_ROUTE_FILE" ]; then
		$IPROUTE route replace `cat "$DEFAULT_ROUTE_FILE"`
		$IPROUTE route flush cache
		rm -f -- "$DEFAULT_ROUTE_FILE"
	fi
}

del_network_route() {
	NETWORK="$1"
	NETMASK="$2"
	NETMASKLEN="$3"
	$IPROUTE route $route_syntax_del "$NETWORK/$NETMASKLEN" dev "$TUNDEV"
	$IPROUTE route flush cache
}


# =========== resolv.conf handling for any OS =========================

modify_resolvconf_android() {
	echo "backing up dns settings"
	INTERNAL_IP4_DNS_TEMP="$INTERNAL_IP4_DNS"

	PREVIOUS_DNS1=`getprop net.dns1`
	PREVIOUS_DNS2=`getprop net.dns2`
	
	echo $PREVIOUS_DNS1 > `dirname $0`/dns1.txt
	echo $PREVIOUS_DNS2 > `dirname $0`/dns2.txt
	
	N=1

	for i in $INTERNAL_IP4_DNS; do
		setprop net.dns$N $i	
		N=`expr $N + 1`
	done

}

restore_resolvconf_android() {
	echo "restore dns settings"
	INTERNAL_IP4_DNS_TEMP="$INTERNAL_IP4_DNS"
	# put an eye on the $SCRIPTPATH variable, this is a special one
	setprop net.dns1 `cat $SCRIPTPATH/dns1.txt`
	setprop net.dns2 `cat $SCRIPTPATH/dns2.txt`

}

# === resolv.conf handling via /sbin/resolvconf (Debian, Ubuntu, Gentoo)) =========

modify_resolvconf_manager() {
	NEW_RESOLVCONF=""
	for i in $INTERNAL_IP4_DNS; do
		NEW_RESOLVCONF="$NEW_RESOLVCONF
nameserver $i"
	done
	if [ -n "$CISCO_DEF_DOMAIN" ]; then
		NEW_RESOLVCONF="$NEW_RESOLVCONF
domain $CISCO_DEF_DOMAIN"
	fi
	echo "$NEW_RESOLVCONF" | /sbin/resolvconf -a $TUNDEV
}


# ========= Toplevel state handling  =======================================

kernel_is_2_6_or_above() {
	case `uname -r` in
		1.*|2.[012345]*)
			return 1
			;;
		*)
			return 0
			;;
	esac
}

do_pre_init() {
	if [ "`readlink /dev/net/tun`" = misc/net/tun \
		-a ! -e /dev/net/misc/net/tun -a -e /dev/misc/net/tun ] ; then
		ln -sf /dev/misc/net/tun /dev/net/tun
	fi
	# make sure tun device exists
	if [ ! -e /dev/net/tun ]; then
		# mknod doesn't exist on base android, use prebuild binary.
		/system/bin/make-tun-device	
	fi
}

do_connect() {
	if [ -n "$CISCO_BANNER" ]; then
		echo "Connect Banner:"
		echo "$CISCO_BANNER" | while read LINE ; do echo "|" "$LINE" ; done
		echo
	fi
	
	do_ifconfig
	set_vpngateway_route
	if [ -n "$CISCO_SPLIT_INC" ]; then
		i=0
		while [ $i -lt $CISCO_SPLIT_INC ] ; do
			eval NETWORK="\${CISCO_SPLIT_INC_${i}_ADDR}"
			eval NETMASK="\${CISCO_SPLIT_INC_${i}_MASK}"
			eval NETMASKLEN="\${CISCO_SPLIT_INC_${i}_MASKLEN}"
			if [ $NETWORK != "0.0.0.0" ]; then
				set_network_route "$NETWORK" "$NETMASK" "$NETMASKLEN"
			else
				set_default_route
			fi
			i=`expr $i + 1`
		done
		for i in $INTERNAL_IP4_DNS ; do
			set_network_route "$i" "255.255.255.255" "32"
		done
	else
		set_default_route
	fi
	
	if [ -n "$INTERNAL_IP4_DNS" ]; then
		$MODIFYRESOLVCONF
	fi
	echo "vpnc-script ran to completion"
}

do_disconnect() {
	if [ -n "$CISCO_SPLIT_INC" ]; then
		i=0
		while [ $i -lt $CISCO_SPLIT_INC ] ; do
			eval NETWORK="\${CISCO_SPLIT_INC_${i}_ADDR}"
			eval NETMASK="\${CISCO_SPLIT_INC_${i}_MASK}"
			eval NETMASKLEN="\${CISCO_SPLIT_INC_${i}_MASKLEN}"
			if [ $NETWORK != "0.0.0.0" ]; then
				# FIXME: This doesn't restore previously overwritten
				#        routes.
				del_network_route "$NETWORK" "$NETMASK" "$NETMASKLEN"
			else
				reset_default_route
			fi
			i=`expr $i + 1`
		done
		for i in $INTERNAL_IP4_DNS ; do
			del_network_route "$i" "255.255.255.255" "32"
		done
	else
		reset_default_route
	fi
	
	del_vpngateway_route
	
	if [ -n "$INTERNAL_IP4_DNS" ]; then
		$RESTORERESOLVCONF
	fi
	destroy_tun_device
}

#### Main

if [ -z "$reason" ]; then
	echo "this script must be called from vpnc" 1>&2
	exit 1
fi

case "$reason" in
	pre-init)
		do_pre_init
		;;
	connect)
		do_connect
		;;
	disconnect)
		do_disconnect
		;;
	*)
		echo "unknown reason '$reason'. Maybe vpnc-script is out of date" 1>&2
		exit 1
		;;
esac

exit 0
