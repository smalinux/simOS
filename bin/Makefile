OS: boot.bin kernel.bin
	cat boot.bin kernel.bin > simOS.bin


boot.bin:
	nasm -f bin "../src/asm/boot.asm" -o "boot.bin"

kernel.bin:
	nasm -f bin "../src/asm/kernel.asm" -o "kernel.bin"

run:
	bochs

# That shows the code
show:
	xxd xxx.bin

clean:
	rm *.bin