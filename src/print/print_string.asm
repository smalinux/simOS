;;;
;;; print_string function - Print string in SI register
;;;

	; if (al == 0)
	; 	break
	; else
	; 	continue

print_string:
	pusha
	mov ah, 0x0e
	mov bh, 0x0						; page number
	mov bl, 0x07					; color
	.print_char:
		mov al, [si]
		cmp al, 0
		je .ret
		int 0x10
		add si, 1
		jmp .print_char

	.ret:
		popa 
		ret 						; retrun 0


