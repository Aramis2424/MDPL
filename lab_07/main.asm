.model tiny

seg_code segment
    assume cs:seg_code, ds:seg_code
    org 100h                    ; там хранится psp (делаем сдвиг)

main:
    jmp install_breaking         ; для установки прерывания
    old_8h dd ?                  ; сохранение старого веетора прерывания
    flag db 'T'                  ; для понятия, установлено ли прерывание или нет 
    ; для установки прерывания
    buf db 0

my_new_8h proc
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    push es
    push ds

    pushf
    

    call cs:old_8h

    cmp buf, 63
    je buf_again
    jne cancel

    buf_again:
        mov buf, 0
        jmp next_step

    cancel:
        inc buf

    next_step:
        ;xor ax, ax
        mov ah, 0f3h
        ;out 60h, ax
        mov al, 96
        add al, buf
        out 60h, ax
    ;cmp ah, 243 
    ; f3h === 243, так как на f3h ругается, считает ее за переменную.
    ; команда f3h отвечает за параметры режима
    ; автоповтора нажатой клавиши. её байт данных имеет следующее значение:
    ; 7 бит (старший) - всегда 0
    ; 5,6 биты - пауза перед началом автоповтора (250, 500, 750 или 1000 мс)
    ; 4-0 биты - скорость автоповтора (от 0000b (30 символов в секунду) до 11111b - 2 символа в секунду).
    ;jne exit_breaking ; если не эта команда, то выход из прерывания
    ;mov bl, al
    ;and bl, 31
    ;dec bl

    ;and al, 96 ; секунды
    ;or al, bl   
    ;mov     cx, 0fh
    ;mov     dx, 4240h
    ;mov     ah, 86h
    ;int     15h
    

    exit_breaking:
        pop ds
        pop es

        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax

        iret

my_new_8h endp

install_breaking:
    mov ax, 3508h  
    ; функуция 35 будет искать вектор прерывания 9
    ; возвращает значение вектора прерывания для int (al)
    ; то есть, загружает в bx 0000:[al*4], а в es - 0000:[(al*4)+2].
    int 21h

    cmp es:flag, 'T'
    je uninstall_breaking

    mov word ptr old_8h, bx      ; сохраняем адрес вектора прерывания старого
    mov word ptr old_8h + 2, es  ; после адреса пишем нашу память 

    mov ax, 2508h               
    ; устанавливаем наше прерывание 
    ; устанавливает значение элемента таблицы векторов прерываний для
    ; прерывания с номером al равным ds:dx. это равносильно записи
    ; 4-байтового адреса в 0000:(al*4), но, в отличие от прямой записи,
    ; dos здесь знает, что вы делаете, и гарантирует, что в момент
    ; записи прерывания будут заблокированы.
    mov dx, offset my_new_8h         
    ; помещаем в память метку с нашими командами, 
    ; для установки нашего прерывания
    int 21h                     ; устанавливаем

    mov dx, offset install_msg
    mov ah, 9
    int 21h

    mov dx, offset install_breaking
    int 27h                 
    ; возвращает управление dos, оставляя часть памяти распределенной, 
    ; так что последующие программы не будут перекрывать программный 
    ; код или данные в этой памяти.
    ; int 27h - это традиционный метод установки программ обслуживания
    ; прерываний и пользовательских таблиц данных. 

uninstall_breaking:
    push es
    push ds

    mov dx, word ptr es:old_8h          ; достаем наше старое прерывание
    mov ds, word ptr es:old_8h + 2      ; достаем все еще старое прерывание
    mov ax, 2508h                       ; установка прерывания
    int 21h

    pop ds
    pop es

    mov ah, 49h                         
    ; освобождает блок памяти, начинающийся с адреса es:0000.
    ; этот блок становится доступным для других запросов системы
    int 21h

    mov dx, offset uninstall_msg
    mov ah, 9h
    int 21h

    mov ax, 4c00h
    int 21h

    install_msg   db 'breaking my_new_8h!$'
    uninstall_msg db 'breaking old_8h!$'
    


seg_code ends
end main
