CROSS_COMPILE=aarch64-linux-gnu-

all: kernel8.img

OBJS = start.o vectors.o main.o uart.o user.o svc_handler.o

%.o: %.c
	$(CROSS_COMPILE)gcc -c $< -o $@ -nostdlib -nostartfiles -ffreestanding

%.o: %.S
	$(CROSS_COMPILE)as $< -o $@

kernel8.img: $(OBJS)
	$(CROSS_COMPILE)ld -T linker.ld -o kernel.elf $(OBJS)
	$(CROSS_COMPILE)objcopy kernel.elf -O binary kernel8.img

clean:
	rm -f *.o kernel.elf kernel8.img
