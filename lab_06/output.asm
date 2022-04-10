public print_newline
public print_space
public print_num
public print_text
; public print_new_line
; public print_new_line
; public print_new_line
; public print_new_line

seg_code segment para public 'code'	
	assume cs:seg_code

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
	
seg_code ends
end
