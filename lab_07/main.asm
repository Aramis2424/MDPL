; Написать резидентную программу под dos, которая будет каждую секунду менять
; скорость автоповтора ввода символов в циклическом режиме, от самой медленной до
; самой быстрой.

.model tiny

.data
	msg_stop db "Resident stopped", 10, 13 , '$'
	msg_start db "Resident started", 10, 13 , '$'

.code
org 100h   

main:
    oldptr: 
		jmp start_resident
		dw ?
 
		cur_time db 0
		speed db 1fh  ; начальная скорость 11111 
		flag_resid db 'T' ; флаг резидента

	change_time:
		push ax
		push dx
		push es
		push ds

		mov ah, 02h
		int 1ah         ; текущее время
						; выход: ch = часы
						; cl = минуты в коде bcd
						; dh = секунды в коде bcd

		cmp dh, cur_time
		mov cur_time, dh 
		je end_loop ; время не изменилось

		; порт 60h доступен для записи и обычно принимает пары байтов последовательно:
		; первый - код команды, второй - данные
		mov al, 0f3h ; 0f3h - команда отвечающая за пармаметры авоповтора
		out 60h, al
		mov al, speed
		out 60h, al

		dec speed ; уменьшая значение, увеличиваем скорость (соглсно заданию)
		test speed, 1fh ;
		jz reset ; если speed == 0010 0000
		jmp end_loop

		reset:
			mov speed, 1fh

		end_loop:
			pop ds
			pop es
			pop dx
			pop ax

			jmp dword ptr cs:oldptr ; возвращаемся назад

	start_resident:
		mov ax, 351ch ; получить из вектора прерывание 1c (таймер) в es, bx
		int 21h
		
		cmp es:flag_resid, 'T'
		je stop_resident ; если резидентная программа уже запущена

		; сохраняем старый указатель
		mov word ptr oldptr, bx
		mov word ptr oldptr + 2, es

		; печатаем сообщение
		mov dx, offset msg_start
		mov ah, 09h
		int 21h
		
		; устанавливаем обрабочик
		mov ax, 251ch
		mov dx, offset change_time
		int 21h
		
		mov dx, offset start_resident
		int 27h

	; останавливаем резидентную программу
	stop_resident:
		mov dx, offset msg_stop
		mov ah, 09h
		int 21h

		; удаляем указатели
		mov dx, word ptr es:oldptr
		mov ds, word ptr es:oldptr + 2
		mov ax, 251ch
		int 21h
		
		; освобождаем память
		mov ah, 49h
		int 21h
		
		; завершаем программу
		mov ah, 4ch
		int 21h

end main
