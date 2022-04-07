;прямоугольная цифровая  
;переставить местами строки с наибольшим и
;наименьшим элементами

StackSeg SEGMENT PARA STACK 'STACK'
    DB 100 DUP (0)
StackSeg ENDS


TextSeg SEGMENT PARA 'DATA'
    MSG_ROW DB 'Input rows: $'
	MSG_COL DB 'Input columns: $'
	MSG_MTR DB 'Input matrix: $'
	MSG_RES DB 'Result:$'
	MSG_ERR DB 'ERR$'
TextSeg ENDS


DataSeg SEGMENT PARA 'DATA'
	ROW DB 0
	COL DB 0
	MTR DB 9 * 9 DUP (0)
	MAX_I DW 1 DUP (0)
	MIN_I DW 1 DUP (0)
DataSeg ENDS	

CodeSeg SEGMENT PARA 'CODE'	
    ASSUME CS:CodeSeg, DS:TextSeg, SS:StackSeg
	
input_sym:
	MOV AH, 01h
	INT 21h
	RET

print_new_line:
	MOV AH, 02h
	MOV DL, 0Dh  ;LF Line Feed
	INT 21h
	MOV DL, 0Ah  ;CR Carriage Return
	INT 21h
	RET

print_space:
	MOV AH, 02h
	MOV DL, 20h
	INT 21h
	RET

print_sym:
	MOV AH, 02h
	INT 21h
	RET

print_text:
	MOV AH, 09h
	INT 21h
	RET

main:
	MOV AX, DataSeg ;записывание data
    MOV ES, AX
	
	MOV AX, TextSeg ;записывание text
	MOV DS, AX

	MOV DX, OFFSET ES:MSG_ROW ;сообщение на ввод строки
	CALL print_text
	CALL input_sym ;ввод числа строк
	
	MOV ES:ROW, AL ;перенос из al в row количества строк
	SUB ES:ROW, 30h ;делаем из '<число>' <число>
	MOV AL, ES:ROW ;переносим для проверки кол-во строк в al
	;CALL print_new_line ;
	CMP AL, 0
	JE error_exit ;
	CALL print_new_line ;новая строка
	
	MOV DX, OFFSET ES:MSG_COL ;то же, что и для row
	CALL print_text
	CALL input_sym
	MOV ES:COL, AL
	SUB ES:COL, 30h
	MOV AL, ES:COL
	CALL print_new_line
	CMP AL, 0
	JE error_exit
	
	
	MOV DX, OFFSET ES:MSG_MTR ;приглашение на ввод матрицы
	CALL print_text
	CALL print_new_line
	
	input_mtr: ;ввод матрицы
		XOR BX, BX ;обнуление (скорее всего делать не обязательно)
		XOR CX, CX 
		MOV CL, ES:ROW ;переносим кол-во строк в cl
		XOR SI, SI
		input_row: ;начало цикла
			PUSH CX ;Сохраняем кол-во строк, которые еще нужно прочитать, отправляя его в стек
			MOV CL, ES:COL ;переносим кол-во столбцов в cl
			XOR BX, BX ;на новой строке начнем заполнять с начала
			input_col: ;начало цикла
				CALL input_sym ;ввод элемента матрицы
				SUB AL, 30h ;делаем из него число
				MOV ES:MTR[BX + SI], AL ;запись элемента матрицы в  ячейку матрицы (bx = 0, 1, ..., 8 - текущий столбец ## si = 0, 9, 18, ..., 72 - текущая строка)
				
				INC BX ;следующая ячейка в этой же строке
				CALL print_space
				LOOP input_col ;конец цикла (здесь на один уменьшается кол-во столбцов, которые еще нужно прочитать)
				
			CALL print_new_line
			POP CX ;получаем из стека сохраненное значение кол-ва строк
			ADD SI, 9 ;переходим на новую строку
			LOOP input_row ;конец цикла (здесь на один уменьшается кол-во строк, которые еще нужно прочитать)
			
	; find_max_min: 
		; MOV SI, 0
		
		; XOR AX, AX
		; MOV AL, ES:COL
		; XOR DI, DI
		; MOV DI, AX
		
		; XOR CX, CX
		; MOV CL, ES:ROW
		
		; XOR AX, AX
		; XOR DX, DX
		; MOV AL, ES:MTR[SI]
		; MOV DL, ES:MTR[SI]
		
		; find_row_max_min:
			; PUSH CX
			; MOV CL, ES:COL
			; MOV BX, 0
			; find_col_max_min:
				; CMP AL, ES:MTR[SI][BX]
				; JLE next_max
				; CMP DL, ES:MTR[SI][BX]
				; JGE next_min
				; JMP next
			; next_max:
				; MOV AL, ES:MTR[SI][BX]
				; MOV ES:MAX_I, SI
				; JMP next 
			; next_min:
				; MOV DL, ES:MTR[SI][BX]
				; MOV ES:MIN_I, SI	

			; next:
				; INC BX
				; LOOP find_col_max_min
			; POP CX
			; ADD SI, DI
			; LOOP find_row_max_min
			
	; swap_lines:
		; XOR CX, CX
		; MOV CL, ES:COL
		; MOV SI, ES:MAX_I
		; MOV BX, ES:MIN_I
		; swap:
			; XCHG AL, ES:MTR[SI]
			; XCHG AL, ES:MTR[BX]
			; XCHG AL, ES:MTR[SI]
			; INC SI
			; INC BX
			; LOOP swap
	
	print_mtr: ;вывод матрицы
		MOV DX, OFFSET ES:MSG_RES ;print('result')
		CALL print_text
		CALL print_new_line
		
		;XOR BX, BX
		XOR CX, CX
		MOV CL, ES:ROW ;для вывода -- кол-во строк
		XOR SI, SI
		print_row:
			PUSH CX ;тот же финт, что и при вводе
			MOV CL, ES:COL
			XOR BX, BX
			print_col: ;для вывода -- кол-во столбцов
				MOV DL, ES:MTR[BX + SI]
				ADD DL, 30h ;делаем из числа строку
				CALL print_sym
				INC BX
				CALL print_space
				LOOP print_col
			CALL print_new_line
			
			POP CX
			ADD SI, 9
			LOOP print_row
			
	MOV AH, 4Ch	;завершаем				
    INT 21h
	
	error_exit:
		CALL print_new_line
		MOV DX, OFFSET ES:MSG_ERR ;печатаем сообщение об ошибке
		CALL print_text
		MOV AH, 4Ch	;завершаем

		INT 21h
	
CodeSeg ENDS
END main

;SI - str
;BX - col