#!/system/bin/sh

# ip route wrapper, add 'table vpn' to add/del commands

IPROUTE=/system/bin/ip

case "$@" in

    *'route add'*|*'route del'*)
        exec "$IPROUTE" "$@" table local
        ;;
    *)
        exec "$IPROUTE" "$@"
        ;;

esac
