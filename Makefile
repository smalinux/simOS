

# all:
# # 	./fasm/fasm boot.asm

# run:
# 	bochs
# # 	qemu-system-x86_64 ./bin/simOS.bin

# iso:
# 	sudo mkfs.vfat -I /dev/sdb
# 	sudo dd if=simOS.bin of=/dev/sdb

all:
	-cd bin && $(MAKE) clean
	cd bin && $(MAKE)
	cd bin && $(MAKE) run