


all:
	nasm boot.asm -f bin -o boot.bin
	sudo dd if=boot.bin bs=512 of=/dev/fd0

run:
	qemu-system-x86_64 boot.bin

clean:
	@rm -rf *.o kernel.elf os.iso