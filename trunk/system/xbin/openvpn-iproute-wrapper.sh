#!/system/bin/sh

# ip route wrapper, add 'table vpn' to all commands

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
#export PATH

IPROUTE=/system/bin/ip

has_vpn_table=$("$IPROUTE" rule show | grep ' vpn')
case "$@" in
    *'route add'*|*'route del'*)
        if [ -z "$has_vpn_table" ]; then
            "$IPROUTE" rule add from all table vpn
        fi
        exec "$IPROUTE" "$@" table vpn
        ;;
    *)
        exec "$IPROUTE" "$@"
        ;;
esac

# EOF
