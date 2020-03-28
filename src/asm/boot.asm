;;;
;;; Simple bootloader!
;;;
	[org 0x7c00]

	;; READ FILE TABLE INTO MEMORY FIRST
	;; set up ES:BX memory address/segment:offset 
	mov bx, 0x1000				; loads sector to memory address 0x1000
	mov es, bx 					; ES = 0x1000
	mov bx, 0x0					; ES:BX = 0x1000:0

	;; set up DX register for disk loading
	mov dh, 0					; head 0
	mov dl, 0					; drive 0
	mov ch, 0					; cylinder 0
	mov cl, 0x02				; starting sector to read from disk

read_disk1:
	mov ah, 0x02
	mov al, 0x01
	int 0x13					; BIOS read from disk int

	jc read_disk1				; retry if disk read error (CF = 1)

	;; READ KERNEL INTO MEMORY SECOND

	;; set up ES:BX memory address/segment:offset 
	mov bx, 0x2000				; loads sector to memory address 0x2000
	mov es, bx 					; ES = 0x1000
	mov bx, 0x0					; ES:BX = 0x1000:0

	;; set up DX register for disk loading
	mov dh, 0					; head 0
	mov dl, 0					; drive 0
	mov ch, 0					; cylinder 0
	mov cl, 0x03				; starting sector to read from disk

read_disk2:
	mov ah, 0x02
	mov al, 0x01
	int 0x13					; BIOS read from disk int

	jc read_disk2				; retry if disk read error (CF = 1)


	;; reset segment registers for RAM
	mov ax, 0x2000
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp 0x2000:0x0 				; move instruction pointer to our kernel (fare jmp)


;;; Boot Sector Magic Mumber  
	times 510-($-$$) db 0
	
	dw 0xaa55		;;; BIOS magic number
