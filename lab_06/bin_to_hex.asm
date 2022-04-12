public bin_to_hex
public hex_number
public hex_sign
extrn number: word

seg_data segment para public 'data'
    hex_number db 4 dup('0'), '$'
    hex_sign db ' '
    four_bit dw 15
seg_data ends

seg_code segment para public 'code'
	assume cs:seg_code, ds:seg_data

	bin_to_hex proc
		mov cx, 4
		mov bx, 3
		to_zero_loop:
			mov hex_number[bx], '0'
			dec bx
			loop to_zero_loop
		mov hex_sign, ' '
		mov ax, number

		cmp ax, 32767
		jbe less

		mov hex_sign, '-'
		sub ax, 1
		not ax

		less:
		mov bx, 3
		hex_loop:
			mov dx, ax
			and dx, four_bit

			cmp dl, 10
			jb digit
			add dl, 7 ;корректируем номер для буквы

			digit:
			add dl, '0'
			mov hex_number[bx], dl
			mov cl, 4
			sar ax, cl

			dec bx
			cmp bx, -1
			jne hex_loop
		ret
	bin_to_hex endp

seg_code ends
end
