;;
;; Basic 'kernel' loaded from out bootsector
;;

	;; ------------------------------------------------------------------
	;; General Setings
	;; ------------------------------------------------------------------
reset_screen:
	; Set Video Mode
	mov ah, 0
	mov al, 0x03
	int 0x10

	; Set Color Palette
	mov ah, 0x0B
	mov bh, 0
	mov bl, 0x01
	int 0x10

	; Write Text in Teletype Mode
	mov si, welcome
	call print_string

main_menu:
	; Print Menu heading
	mov si, fileTable
	call print_string

	;; -------------------------------------------------------------------
	;; Get user input, print to screen & choose menu option or run command
	;; -------------------------------------------------------------------
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
	cmp al, 'F'					; file table command/ menu option
	je filebrowser
	cmp al, 'R'					; Warm reboot
	je reboot
	cmp al, 'P'					; print regs values
	je print_regs
	cmp al, 'N'					; e(n)d our current program
	je end_os
	mov si, failure 			; command not found
	call print_string
	jmp main_menu



	;; -------------------------------------------------------------------
	;; F) File Browser
	;; -------------------------------------------------------------------
	;; Load File Table string from its memory location (0x1000:0000), print file
	;;  and program names & sector numbers to screen, for user to choose

filebrowser:
	;; Reset scrren state - Warning: this code is dublicated!
	;; ------------------
	
	; ; Set Video Mode
	; mov ah, 0
	; mov al, 0x03
	; int 0x10

	; ; Set Color Palette
	; mov ah, 0x0B
	; mov bh, 0
	; mov bl, 0x01
	; int 0x10

	; Print 'File table Header'
	mov si, fileTableHeading
	call print_string

	mov cx, cx					; reset counter for # chars in file/pgm name
	mov ax, 0x1000				; file table location
	mov es, ax					; ES = 0x1000
	xor bx, bx					; ES:BX = 0x1000:0
	mov ah, 0x0e				; get ready to print to screen


filetable_loop:
	inc bx
	mov al, [ES:BX]
	cmp al, '}'					; at end of fileTable?
	je stop
	cmp al, '-'					; at sector num of element?
	je sectorNumber_loop
	cmp al, ','					; between table elements?
	je next_element
	inc cx						; increment counter
	int 0x10
	jmp filetable_loop

sectorNumber_loop:
	cmp cx, 21					; Warning: hard coded
	je filetable_loop
	mov al, ' '
	int 0x10
	inc cx
	jmp sectorNumber_loop


next_element:
	mov al, 0xD
	int 0x10
	mov al, 0xA
	int 0x10
	xor cx, cx
	jmp filetable_loop

stop:
	mov si, goBackMsg
	call print_string
	mov ah, 0x0					; pause screen
	int 0x16
	jmp main_menu


	;; -------------------------------------------------------------------
	;; End file table
	;; -------------------------------------------------------------------









	;; -------------------------------------------------------------------
	;; Menu R) 'warm' reboot - far jump to reset vector
	;; -------------------------------------------------------------------
reboot:
	jmp 0xffff:0x0000

	;; -------------------------------------------------------------------
	;; Menu P) Print Registers
	;; -------------------------------------------------------------------
print_regs:
	; Reset the screen - Warn: hard code
	mov ah, 0
	mov al, 0x03
	int 0x10

	; Set Color Palette
	mov ah, 0x0B
	mov bh, 0
	mov bl, 0x01
	int 0x10

	call printRegs
	mov si, goBackMsg
	call print_string
	mov ah, 0x00				; pause screen :)
	int 0x16
	jmp reset_screen				; go back to main menu

	;; -------------------------------------------------------------------
	;; Menu N) THE END OS - jump forever
	;; -------------------------------------------------------------------
end_os:
	cli 						; clear interrupts
	hlt 						; halt the cpu


	;; ===================================================================
	;; End Main logic
	;; ===================================================================


	;; -------------------------------------------------------------------
	;; Include files
	;; -------------------------------------------------------------------
	%include "../src/print/print_string.asm"
	%include "../src/print/print_hex.asm"
	%include "../src/print/print_registers.asm"




	;; ------------------------------------------------------------------
	;; Vars
	;; ------------------------------------------------------------------
welcome: 		db 	'welcome to simOS - Made by Sohaib (smalinux)', 0xA, 0xD,\
					'     https://github.com/smalinux/simOS', 0xA, 0xD, 0xA, 0xD, 0
fileTable: 		db 	' F) File Browser', 0xA, 0xD,\
					' R) Reboot', 0xA, 0xD,\
					' P) Print Register Values', 0xA, 0xD, 0
; line: times 80 	db 	'-'
success: 		db	0xA, 0xD, 'Okey! command found', 0xA, 0xD, 0
failure: 		db	0xA, 0xD, 0xA, 0xD, ' Ooops! Something went wrong :(', 0xA, 0xD,0xA, 0xD, 0

;; File Table Heading
fileTableHeading: 			db 	0xA, 0xD,'File/Program         Sector', 0xA, 0xD,\
								'------------         ------', 0xA, 0xD, 0
goBackMsg		db 0xA, 0xD, 0xA, 0xD, '     Press any key to go back....', 0xA, 0xD, 0
cmdString: 		db 	''
;; utilities
; endl: db 0xA, 0xD, 0
;; $

; doller: db '$ '

	;; -------------------------------------------------------------------
	;; Sector Padding magic
	;; -------------------------------------------------------------------
	times 1024-($-$$) db 0
