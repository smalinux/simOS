OS: boot.bin fileTable.bin kernel.bin
	cat boot.bin fileTable.bin kernel.bin > simOS.bin


boot.bin:
	nasm -f bin ../src/asm/boot.asm -o boot.bin

kernel.bin:
	nasm -f bin ../src/asm/kernel.asm -o kernel.bin

# Create file table
fileTable.bin:
	nasm -f bin ../src/asm/fileTable.asm -o fileTable.bin

run:
	bochs

# That shows the code
show:
	xxd simOS.bin

clean:
	rm *.bin