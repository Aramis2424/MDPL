public bin_to_undec
public undec_number
extrn number: word

seg_data segment para public 'data'
    undec_number db 5 dup('0'), '$'

    mask10 dw 15
seg_data ends

seg_code segment para public 'code'
assume cs:seg_code, ds:seg_data

bin_to_undec proc
    mov ax, number

    mov bx, 4
	mov cx, 10
    trans_shex:
		xor	dx,dx          ; Обнуляем DX (для деления)
		div	cx             ; Делим DX:AX на CX (10),
                                       ; Получаем в AX частное, в DX остаток
		xchg	ax,dx          ; Меняем их местами (нас интересует остаток)
		add	al,'0'         ; Получаем в AL символ десятичной цифры
		
		mov undec_number[bx], al
		dec bx
		
		xchg	ax,dx          ; Восстанавливаем AX (частное)
		or	ax,ax          ; Сравниваем AX с 0
		jne	trans_shex         ; Если не ноль, то повторяем
		;xor dx, dx
		;div cx
        ;mov dx, ax

        ;and dx, mask10

        ;add dl, '0'

        ;mov undec_number[bx], dl

        ;mov cl, 4
        ;sar ax, cl

        ;dec bx

        ;cmp bx, -1
        ;jne trans_shex

    ret
bin_to_undec endp

seg_code ends
end
