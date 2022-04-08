PUBLIC INPUTCOM ; Описывает идентификатор, как доступный из других модулей
PUBLIC INPUTDECNUM

PUBLIC NUMBER

; Сегмент данных
DATAS SEGMENT PARA PUBLIC 'DATA'
	INPUTMSG DB 'Input unsigned decimal number (0 - 65535): $'
	NUMBER DW 0
DATAS ENDS	

; Сегмент кода
CODES SEGMENT PARA PUBLIC 'CODE'	
    ASSUME CS:CODES, DS:DATAS
	
INPUTCOM PROC NEAR
	MOV AH, 1	; для ввода команды (так как там только одна цифра)
	INT 21h	
	SUB AL, '0'	; чтобы получить код == цифре (т е 31 ==> 1)
	MOV CL, 2  	; так как размер элемента в массиве действий DW то есть 2 байта 
	MUL CL		; умножаем на 2, так как у нас команды DW 
	MOV SI, AX	; в индексовый регистр кладем индекс нужной нам команды
	RET
INPUTCOM ENDP

; так как надо представить мне число как число я суммирую до записи в память
INPUTDECNUM PROC NEAR
	MOV AH, 9
	MOV DX, OFFSET INPUTMSG
	INT 21h
	MOV BX, 0 		; сюда записываю число
	
	DIGIT:
		MOV AH, 1	; для ввода числа по цифрам
		INT 21h		;
		CMP AL, 13 	; 13 - это нажатый энтер, если нажат энтер, то выход из подпрограммы
		JE EXITINPUT	; если нажат энтер, то есть ZF == 1
		MOV CL, AL	; в CL помещаю код считанный цифры
		SUB CL, '0'	; отнимаю 30 из CL
		SAL BX, 1
		MOV AX, BX
		SAL BX, 1
		SAL BX, 1
		ADD BX, AX
		;MOV AX, 10 	; умножить на 10, чтобы потом число было как число
		;MUL BX 		; умножила число на 10, число записано в BX, результат умньжения в AX
		;MOV BX, AX	; переносим из AX в BX 
		ADD BX, CX	; к числу прибавляю введенную цифру
		JMP DIGIT	; ввожу цифру до энтер
	EXITINPUT:		; если ввели энтер 
	MOV NUMBER, BX	; помещаю число в отведенную память
	RET
INPUTDECNUM ENDP

CODES ENDS
END