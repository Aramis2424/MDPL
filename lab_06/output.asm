public print_newline
public print_num
public print_text
public print_hex
public print_undec
extrn hex_sign: byte
extrn hex_number: byte
extrn bin_to_hex: near
extrn undec_number: byte
extrn bin_to_undec: near

seg_data segment para public 'data'
    msg_hex_num db 'Signed hexadecimal number: $'
	msg_undec_num db 'Unsigned decimal number: $'
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
		xor bx, bx

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
	
	print_undec proc
		mov dx, OFFSET msg_undec_num
		call print_text
		call bin_to_undec
		mov cx, 5
		xor bx, bx
		loop_out: 
			mov ah, 2
			mov dl, undec_number[bx]
			inc bx
			int 21h
			loop loop_out
		call print_newline
		ret
	print_undec endp
	
seg_code ends
end
