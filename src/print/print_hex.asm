;;;
;;; Prints hexdecimal values using DX register and print_string.asm
;;;
;;; Ascii '0'-'9' == hex 0x30-0x39
;;; Ascii 'A'-'B' == hex 0x41-0x46
;;; Ascii 'a'-'b' == hex 0x61-0x66

print_hex:
	pusha
	mov CX, 0 				; init loop counter
	
	hex_loop:
		cmp cx, 4
		je end_hexloop
		;; convert DX hex values to ascii
		mov ax, dx
		and ax, 0x000F
		add al, 0x30
		cmp al, 0x39
		jle move_intoBX
		add al, 0x7
	
	move_intoBX:
		mov si, hexString + 5
		sub si, cx
		mov [si], al
		ror dx, 4
		add cx, 1
		jmp hex_loop

	end_hexloop:
		mov si, hexString
		call print_string

		popa
		ret

;;; Data
hexString: 		db '0x0000', 0
