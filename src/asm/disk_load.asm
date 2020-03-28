;;;
;;; Disk Load: 
;;;
disk_load:
	push dx				; Store DX on stack to check number of sectors actual read.
	mov ah, 0x02 		; int 13/ah=02h, BIOS read disk sectors into memory
	
	mov al, dh			; number of sectors we want to read ex, 1
	mov ch, 0x00		; cylinder 0
	mov cl, 0x02		; start reading at CL sector (sector 2 in this case, right after our bootsector)

	int 0x13			; BIOS interrupts for disk functions

	jc disk_error		; jump if disk read error (CF = 1)

	pop dx				; restore DX
	cmp dh, al			; if AL(# sectors actually read) != DH (# sectors we want to read)
	jne disk_error 		; error,
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	hlt				; cop! catch this area 

DISK_ERROR_MSG: db 'Disk read error!11!!!', 0xA, 0xD, 0