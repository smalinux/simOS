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
	mov bl, 0x01
	int 0x10

;;; Write Text in Teletype Mode
	mov si, welcome
	call print_string

	; mov si, endl
	; call print_string
	
	mov si, line
	call print_string

	; Print Menu heading
	mov si, fileTable
	call print_string

	; mov si, doller
	; 	call print_string

;;; Write Hex in Teletype 
	; mov si, 0x12cB 			;; Sample hex number
	; call print_hex


	;; Get user input, print to screen & choose menu option or run command
get_input:
	mov di, cmdString			; now di pointer to cmdString memory location	
keyloop:
	mov ah, 0x00				; int 16/ah=0
	int 0x16					; BIOS int get keystroke

	mov ah, 0x0e

	cmp al, 0xD					; did user press 'enter' key?
	je run_cmd
	int 0x10					; print input char to screen
	mov [di], al
	inc di
	jmp keyloop 				; loop for next char input


run_cmd:
	mov byte [di], 0			; null terminate cmdString from di
	mov al, [cmdString]
	cmp al, 'f'					; file table command/ menu option
	jne not_found
	cmp al, 'n'					; e(n)d our current program
	je end_os
	mov si, success 			; command found!
	call print_string
	jmp get_input

not_found:
	mov si, failure 			; command not found
	call print_string
	jmp get_input



;;; THE END OS - jump forever
end_os:
	cli 				; clear interrupts
	hlt 				; halt the cpu

;;; Functions
	%include "../src/print/print_string.asm"
	%include "../src/print/print_hex.asm"


;;; welcome Message
welcome: 		db 'welcome to simOS - Made my Sohaib (smalinux)', 0xA, 0xD,\
					'     https://github.com/smalinux/simOS', 0xA, 0xD, 0xA, 0xD, 0
fileTable: 		db 'F) File Browser', 0xA, 0xD, 0

line: times 80 	db '-'

success: 		db	0xA, 0xD, 'Okey! command found', 0xA, 0xD, 0
failure: 		db	0xA, 0xD, 'Ooops! Something went wrong :(', 0xA, 0xD, 0


cmdString: 		db ''


;;; utilities
; endl: db 0xA, 0xD, 0
;;; $
doller: db '$ '

;;; Sector Padding magic
	times 510-($-$$) db 0