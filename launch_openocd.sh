#/bin/bash

# based on this helpful guide
# https://github.com/mystorm-org/BlackIce-II/wiki/Using-an-STLink-Dongle-and-GDB-with-your-BlackIce-II

export PATH=../arm-tools/_build/_toolchain/bin:${PATH}

case $1 in
	flash)
		st-flash write derived/blinky.bin 0x08000000
		;;
	openocd) openocd -f /usr/local/Cellar/open-ocd/0.10.0/share/openocd/scripts/interface/stlink-v2.cfg -f /usr/local/Cellar/open-ocd/0.10.0/share/openocd/scripts/target/stm32f0x_stlink.cfg
		exit
		;;
	telnet)
		telnet localhost 4444
		exit
		;;
	gdb)
		arm-none-eabi-gdb -ex "target remote localhost:3333" ./derived/blinky.elf
		exit
		;;
	*)
		echo "launch flash|openocd|telnet|gdb"
		echo "To actually debug you want to launch 'opendocd' then launch 'gdb' in another terminal window"
		exit
		;;
esac

