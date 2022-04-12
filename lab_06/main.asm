;ввод беззнаковое в 2 с/с
;1-е выводимое беззнаковое в 10 с/с
;2-е выводимое знаковое в 16 с/с

public error_menu
public print_menu_loop
extrn print_text: near
extrn print_newline: near
extrn input_choice: near
extrn input_unbin: near
extrn print_hex: near
extrn print_undec: near

seg_stack segment para stack 'stack'
    db 100 dup (?)
seg_stack ends

seg_data segment para public 'data'
    msg_menu db 'Menu:', 13, 10
			 db ' 1 - Input unsigned binary number', 13, 10
			 db ' 2 - Print unsigned decimal number', 13, 10 
			 db ' 3 - Print signed hexadecimal number', 13, 10
			 db ' 0 - Exit ', 13, 10, 10
			 db 'Input command: $'
	msg_error db 'There is not such menu item!', 13, 10, 'Please try again!', '$'
	msg_exit db 'End program!', 13, 10, '$'
	choice dw exit, input_unbin, print_undec, print_hex
seg_data ends

seg_code segment para public 'code'	
    assume cs:seg_code, ds:seg_data, ss:seg_stack

	exit proc
		mov dx, offset msg_exit
		call print_text
		mov ah, 4ch						
		int 21h
	exit endp

	error_menu proc
		call print_newline
		mov dx, offset msg_error ;сообщение об ошибке
		call print_text
		call print_newline
		jmp print_menu_loop
	error_menu endp

	print_menu proc
		mov dx, offset msg_menu
		call print_text
		ret
	print_menu endp

	main:
		mov ax, seg_data
		mov ds, ax
			
		print_menu_loop:
			call print_menu
			call input_choice
			call print_newline
			call choice[si]
			jmp print_menu_loop
	
seg_code ends
end main
