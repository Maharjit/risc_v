ROSS = aarch64-none-elf
AS = $(CROSS)-as
LD = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy

all: kernel8.img

main.o: main.S
	$(AS) -o main.o main.S

kernel.elf: main.o linker.ld
	$(LD) -T linker.ld -o kernel.elf main.o

kernel8.img: kernel.elf
	$(OBJCOPY) -O binary kernel.elf kernel8.img

clean:
	rm -f *.o *.elf *.img