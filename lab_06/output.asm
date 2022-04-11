public print_newline
public print_space
public print_num
public print_text
public print_hex
extrn hex_sign: byte
extrn hex_number: byte
extrn bin_to_hex: near
; public print_new_line
; public print_new_line
; public print_new_line

seg_data segment para public 'data'
    msg_hex_num db 'Signed hexadecimal number: $'
seg_data ends

seg_code segment para public 'code'	
	assume cs:seg_code, ds:seg_data

	print_newline proc
		mov ah, 02h
		mov dl, 13  ;lf line feed
		int 21h
		mov dl, 10  ;cr carriage return
		int 21h
		ret
	print_newline endp

	print_space proc
		mov ah, 02h
		mov dl, 20h
		int 21h
		ret
	print_space endp

	print_num proc
		add dl, 30h ;делаем из числа строку
		mov ah, 02h
		int 21h
		ret
	print_num endp

	print_text proc
		mov ah, 09h
		int 21h
		ret
	print_text  endp
	
	print_hex proc
		mov dx, OFFSET msg_hex_num
		call print_text
		
		call bin_to_hex
		
		mov cx, 4
		mov bx, 0          ;;;;;;;;;;;;;;;

		mov dl, hex_sign

		mov ah, 2
		int 21h

		loop_out: 
			mov ah, 2

			mov dl, hex_number[bx]

			inc bx

			int 21h
			
			loop loop_out
		call print_newline

		mov hex_sign, ' '

		ret
	print_hex endp
	
seg_code ends
end
