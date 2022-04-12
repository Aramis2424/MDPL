public bin_to_undec
public undec_number
extrn number: word

seg_data segment para public 'data'
    undec_number db 5 dup(' '), '$'
seg_data ends

seg_code segment para public 'code'
	assume cs:seg_code, ds:seg_data

	bin_to_undec proc
		mov ax, number

		mov bx, 4
		mov cx, 10
		undec_loop:
			xor	dx, dx  
			div	cx             ;Делим DX:AX на CX (10),
							   ;Получаем в AX частное, в DX остаток
			xchg ax, dx        ;Меняем их местами (нас интересует остаток)
			add	al, 30h        ;Получаем в AL символ десятичной цифры

			mov undec_number[bx], al
			dec bx
			
			xchg	ax,dx      ;Восстанавливаем в AX частное
			CMP AX, 0          ;Сравниваем AX с 0
			jne	undec_loop     ;Если не ноль, то повторяем
		ret
	bin_to_undec endp

seg_code ends
end
