.MODEL TINY

CODES SEGMENT
    ASSUME CS:CODES, DS:CODES
    ORG 100H                    ; Там хранится PSP (делаем сдвиг)

MAIN:
    JMP INSTALL_BREAKING         ; Для установки прерывания
    OLD_8H DD ?                  ; Сохранение старого веетора прерывания
    FLAG DB 'E'                  ; Для понятия, установлено ли прерывание или нет 
    ; Для установки прерывания
    BUF DB 0

MY_NEW_8H PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI

    PUSH ES
    PUSH DS

    PUSHF
    

    CALL CS:OLD_8H

    CMP BUF, 63
    JE BUF_AGAIN
    JNE CANCEL

    BUF_AGAIN:
        MOV BUF, 0
        JMP NEXT_STEP

    CANCEL:
        INC BUF

    NEXT_STEP:
        ;XOR AX, AX
        MOV AH, 0F3h
        ;OUT 60H, AX
        MOV AL, 96
        ADD AL, BUF
        OUT 60H, AX
    ;CMP AH, 243 
    ; F3H === 243, так как на F3H ругается, считает ее за переменную.
    ; команда F3h отвечает за параметры режима
    ; автоповтора нажатой клавиши. Её байт данных имеет следующее значение:
    ; 7 бит (старший) - всегда 0
    ; 5,6 биты - пауза перед началом автоповтора (250, 500, 750 или 1000 мс)
    ; 4-0 биты - скорость автоповтора (от 0000b (30 символов в секунду) до 11111b - 2 символа в секунду).
    ;JNE EXIT_BREAKING ; Если не эта команда, то выход из прерывания
    ;MOV BL, AL
    ;AND BL, 31
    ;DEC BL

    ;AND AL, 96 ; секунды
    ;OR Al, BL   
    ;MOV     CX, 0FH
    ;MOV     DX, 4240H
    ;MOV     AH, 86H
    ;INT     15H
    

    EXIT_BREAKING:
        POP DS
        POP ES

        POP SI
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX

        IRET

MY_NEW_8H ENDP

INSTALL_BREAKING:
    MOV AX, 3508H  
    ; функуция 35 будет искать вектор прерывания 9
    ; возвращает значение вектора прерывания для INT (AL)
    ; то есть, загружает в BX 0000:[AL*4], а в ES - 0000:[(AL*4)+2].
    INT 21H

    CMP ES:FLAG, 'E'
    JE UNINSTALL_BREAKING

    MOV WORD PTR OLD_8H, BX      ; Сохраняем адрес вектора прерывания старого
    MOV WORD PTR OLD_8H + 2, ES  ; После адреса пишем нашу память 

    MOV AX, 2508H               
    ; УСтанавливаем наше прерывание 
    ; устанавливает значение элемента таблицы векторов прерываний для
    ; прерывания с номером AL равным DS:DX. это равносильно записи
    ; 4-байтового адреса в 0000:(AL*4), но, в отличие от прямой записи,
    ; DOS здесь знает, что вы делаете, и гарантирует, что в момент
    ; записи прерывания будут заблокированы.
    MOV DX, OFFSET MY_NEW_8H         
    ; Помещаем в память метку с нашими командами, 
    ; Для установки нашего прерывания
    INT 21H                     ; Устанавливаем

    MOV DX, OFFSET INSTALL_MSG
    MOV AH, 9
    INT 21H

    MOV DX, OFFSET INSTALL_BREAKING
    INT 27H                 
    ; Возвращает управление DOS, оставляя часть памяти распределенной, 
    ; так что последующие программы не будут перекрывать программный 
    ; код или данные в этой памяти.
    ; INT 27H - это традиционный метод установки программ обслуживания
    ; прерываний и пользовательских таблиц данных. 

UNINSTALL_BREAKING:
    PUSH ES
    PUSH DS

    MOV DX, WORD PTR ES:OLD_8H          ; Достаем наше старое прерывание
    MOV DS, WORD PTR ES:OLD_8H + 2      ; ДОстаем все еще старое прерывание
    MOV AX, 2508H                       ; Установка прерывания
    INT 21H

    POP DS
    POP ES

    MOV AH, 49H                         
    ; Освобождает блок памяти, начинающийся с адреса ES:0000.
    ; этот блок становится доступным для других запросов системы
    INT 21H

    MOV DX, OFFSET UNINSTALL_MSG
    MOV AH, 9H
    INT 21H

    MOV AX, 4C00H
    INT 21H

    INSTALL_MSG   DB 'Breaking my_new_8h!$'
    UNINSTALL_MSG DB 'Breaking old_8h!$'
    


CODES ENDS
END MAIN