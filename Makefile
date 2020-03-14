#export PATH=../arm-tools/_build/_toolchain/bin:${PATH}

NAME=blinky
INC=-Iexternal/CMSIS_5/CMSIS/Core/Include -Iexternal/cmsis_device_f0/Include -Iexternal/CMSIS_5/Device/ARM/ARMCM0/Include
CCFLAGS=-O0 -g -mcpu=cortex-m0 -march=armv6-m -fno-asynchronous-unwind-tables $(INC) \
		--specs=nosys.specs -nostdlib

#	   	-nostartfiles -nostdlib -nodefaultlibs -nolibc

CPPFLAGS=-std=c++14 -fno-exceptions $(CCFLAGS)
CFLAGS=$(CCFLAGS)
CPPC=arm-none-eabi-g++ $(CPPFLAGS) -c
CC=arm-none-eabi-gcc $(CFLAGS) -c
AS=arm-none-eabi-as -mcpu=cortex-m0 -mthumb --gdwarf2 
LINK=arm-none-eabi-gcc $(CCFLAGS)
SRCS:=$(wildcard src/*.cpp) $(wildcard src/*.c) $(wildcard src/*.h) $(wildcard src/*.S)
OBJS:=$(patsubst %.c, %.o, $(patsubst %.cpp, %.o, $(patsubst %.S, %.o, $(SRCS))))
OBJS:=$(filter %.o, $(OBJS))
OBJS:=$(OBJS:src/%=derived/%)

# this is local machine dependent

#LDSCRIPT=external/CMSIS_5/Device/ARM/ARMCM0/Source/GCC/gcc_arm.ld
LDSCRIPT=stm32f030.ld
#STARTUP=external/cmsis_device_f0/Source/Templates/gcc/startup_stm32f030x6.s
#external/CMSIS_5/Device/ARM/ARMCM0/Source/GCC/startup_ARMCM0.S 
#STARTUP=external/CMSIS_5/Device/ARM/ARMCM0/Source/startup_ARMCM0.c external/CMSIS_5/Device/ARM/ARMCM0/Source/system_ARMCM0.c
#STARTUP=src/startup.S

derived/$(NAME).bin: derived/$(NAME).elf
	arm-none-eabi-objcopy -S -O binary $< $@
	
derived/$(NAME).ihex: derived/$(NAME).elf
	arm-none-eabi-objcopy -O ihex $< $@

derived/$(NAME).elf: $(OBJS) $(LDSCRIPT)
	$(LINK) $(filter %.o, $^) $(STARTUP) -T $(filter %.ld, $^) -Xlinker -Map=derived/$(NAME).map -o $@ 
	#arm-none-eabi-size $@

derived/%.o : src/%.cpp | derived
	$(CPPC) $< -o $@

derived/%.o : src/%.c | derived
	$(CC) $< -o $@

derived/%.o : src/%.S | derived
	$(AS) $< -o $@

derived:
	mkdir -p derived

.PHONY: clean
clean:
	rm -rf derived/*.o derived/*.bin derived/*.elf derived/*.map derived/*.ihex
	rm -f derived/$(NAME)
	rmdir derived

flash: all
	./launch_openocd.sh flash

ocd: flash
	./launch_openocd.sh openocd


all: derived/$(NAME).bin derived/$(NAME).ihex
