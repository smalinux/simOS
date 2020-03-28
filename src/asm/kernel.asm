;;;
;;; Basic 'kernel' loaded from out bootsector
;;;

;;; General Setings
	;;; Set Video Mode ;;;
	mov ah, 0
	mov al, 0x03
	int 0x10

	;;; Set Color Palette
	mov ah, 0x0B
	mov bh, 0
	mov bl, 0x02
	int 0x10

;;; Write Text in Teletype Mode
	mov si, welcome
	call print_string
	mov si, Msg
	call print_string

;;; Write Hex in Teletype 
	mov si, 0x12cB 			;; Sample hex number
	call print_hex

;;; THE END OS - jump forever
	hlt 				; halt the cpu

;;; Functions
	%include "../src/print/print_string.asm"
	%include "../src/print/print_hex.asm"


;;; Vars 
welcome: db 	'welcome to 54545simOS', 0xA, 0xD, 0
Msg: db 		'My name is Sohaib (smalinux)', 0xA, 0xD, 0

;;; Sector Padding magic
	times 510-($-$$) db 0