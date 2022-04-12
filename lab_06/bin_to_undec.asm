public bin_to_undec
public undec_number
extrn number: word

seg_data segment para public 'data'
    undec_number db 5 dup(' '), '$'
seg_data ends

seg_code segment para public 'code'
	assume cs:seg_code, ds:seg_data

	bin_to_undec proc
		mov cx, 5
		mov bx, 4
		to_zero_loop:
			mov undec_number[bx], ' '
			dec bx
			loop to_zero_loop
		mov ax, number

		mov bx, 4
		mov cx, 10
		undec_loop:
			xor	dx, dx  
			div	cx             ;Делим DX:AX на CX (10),
							   ;Получаем в AX частное, в DX остаток
			xchg ax, dx     
			add	al, 30h       

			mov undec_number[bx], al
			dec bx
			
			xchg	ax,dx      ;Восстанавливаем в AX частное
			CMP AX, 0         
			jne	undec_loop     ;Если не ноль, то повторяем
		ret
	bin_to_undec endp

seg_code ends
end
