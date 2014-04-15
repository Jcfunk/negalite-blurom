#!/sbin/sh
/tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "console=ttyHSL0 androidboot.hardware=shooter no_console_suspend=1 maxkhz=1674000 minkhz=192000 gov=interactive maxscroff=540000 3dgpu=320000000 2dgpu=266667000 s2w=0 s2w_start=HOME s2w_end=SEARCH scheduler=deadline" --base 48000000 --output /tmp/newboot.img
