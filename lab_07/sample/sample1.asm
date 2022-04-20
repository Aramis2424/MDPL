; Написать резидентную программу под DOS, которая будет каждую секунду менять
; скорость автоповтора ввода символов в циклическом режиме, от самой медленной до
; самой быстрой.

.model tiny
.code
.186
org 100h   

MAIN:
    OLDPTR: ; дальше комманда в 2 байта, перезапишем ее
            ; И выделем еще два байта под дальний указатель
    JMP start_resident
    DW ?

    CUR_TIME DB 0
    SPEED DB 1fh  ; начальная скорость 11111 
    INSTALL_MARKER DB 'S' ; Маркер резидента (флаг "работает ли резидентная программа")
    

TIMER_HANDLER:
    pusha ; Сохранение регистров общего назначения (AX, CX, DX, BX, исходный SP, BP, SI и DI)
    pushf ; Сохранение регистров флагов
    push es
    push ds

    mov ah, 02h
    int 1ah         ; get current time from bios 
    ;02H ¦AT¦ читать время из "постоянных" (CMOS) часов реального времени
    ; выход: CH = часы в коде BCD   (пример: CX = 1243H = 12:43)
    ;        CL = минуты в коде BCD
    ;        DH = секунды в коде BCD

    cmp dh, CUR_TIME
    mov CUR_TIME, dh 
    je end_loop ; время не изменилось


	; Порт 60h доступен для записи и обычно принимает пары байтов последовательно:
	; Первый - код команды, второй - данные
    mov al, 0f3h ; 0f3h - командаЮ отвечающая за пармаметры авоповтора
    out 60h, al
    mov al, SPEED
    out 60h, al

    dec SPEED ; уменьшая значение увеличиваем скорость (соглсно заданию)
    test SPEED, 0fh ; 0000 1111 - маска только для скорости
    jz reset ; если speed == 0001 0000
    jmp end_loop
    reset:
        mov SPEED, 0fh

    end_loop:
        pop ds
        pop es

        popf
        popa

        jmp DWORD ptr CS:OLDPTR ; возвращаемся назад

STOP_MESSAGE db "Resident stopped", 10, 13 , '$'
START_MESSAGE db "Resident started", 10, 13 , '$'

start_resident:
    MOV AX, 351ch ; получить из вектора прерывание 1c (таймер) в ES, BX
    INT 21H
    
    ; check if resident started
    cmp ES:INSTALL_MARKER, 'S'
    JE stop_resident

    ; save old ptr
    MOV WORD PTR OLDPTR, BX
    MOV WORD PTR OLDPTR + 2, ES

	; Печатаем сообщение
    MOV DX, offset START_MESSAGE
    MOV AH, 09h
    int 21h
    

    ; Устанавливаем обрабочик
    MOV AX, 251ch
    MOV DX, OFFSET TIMER_HANDLER
    INT 21H
    
    ; stop programm residently
    MOV DX, OFFSET start_resident
    INT 27H

stop_resident:
    MOV DX, offset STOP_MESSAGE
    MOV AH, 09h
    int 21h

    ; restore ptr
    mov dx, word ptr es:OLDPTR
    mov ds, word ptr es:OLDPTR + 2
    mov ax, 251ch
    int 21H
    
    ; free memory 
    mov ah, 49h
    int 21h
    
    ; end program
    mov ah, 4Ch
    int 21h

END MAIN
