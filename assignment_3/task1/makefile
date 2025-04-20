CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

CFLAGS = -O2 -nostdlib -nostartfiles -ffreestanding
LDFLAGS = -T linker.ld

all: kernel.img

kernel.img: start.o main.o
	$(LD) $(LDFLAGS) -o kernel.elf start.o main.o
	$(OBJCOPY) kernel.elf -O binary kernel.img

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o *.elf *.img
