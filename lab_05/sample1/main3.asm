;прямоугольная цифровая  
;переставить местами строки с наибольшим и
;наименьшим элементами

seg_stack SEGMENT PARA STACK 'STACK'
    DB 100 DUP (0)
seg_stack ENDS


seg_text SEGMENT PARA 'DATA'
    MSG_ROW DB 'Input number of rows: $'
	MSG_COL DB 'Input number of columns: $'
	MSG_MTR DB 'Input elements of matrix: $'
	MSG_RES DB 'The result: $'
	MSG_ERR DB 'Error!$'
seg_text ENDS


seg_data SEGMENT PARA 'DATA'
	ROW DB 0
	COL DB 0
	MTR DB 9 * 9 DUP (0)
	MAX_I DW 1 DUP (0)
	MIN_I DW 1 DUP (0)
seg_data ENDS	

seg_code_main SEGMENT PARA 'CODE'	
    ASSUME CS:seg_code_main, DS:seg_text, SS:seg_stack
		
	input_num:
		MOV AH, 01h
		INT 21h
		SUB AL, 30h ;делаем из строки число
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

	print_num:
		ADD DL, 30h ;делаем из числа строку
		MOV AH, 02h
		INT 21h
		RET

	print_text:
		MOV AH, 09h
		INT 21h
		RET

	main:
		MOV AX, seg_data
		MOV ES, AX
		
		MOV AX, seg_text
		MOV DS, AX

		MOV DX, OFFSET ES:MSG_ROW ;сообщение на ввод строки
		CALL print_text
		CALL input_num ;ввод числа строк
		MOV ES:ROW, AL 
		CMP ES:ROW, 0 ;проверка на ноль
		JE error_exit 
		CALL print_new_line
		
		MOV DX, OFFSET ES:MSG_COL ;то же, что и для row
		CALL print_text
		CALL input_num
		MOV ES:COL, AL
		CMP ES:COL, 0
		JE error_exit
		CALL print_new_line
		
		MOV DX, OFFSET ES:MSG_MTR ;сообщение на ввод матрицы
		CALL print_text
		CALL print_new_line
		
		input_mtr: ;ввод матрицы
			XOR CX, CX 
			MOV CL, ES:ROW ;переносим кол-во строк в cl
			XOR SI, SI
			input_row: ;начало цикла
				PUSH CX ;Сохраняем кол-во строк, которые еще нужно прочитать, отправляя его в стек
				MOV CL, ES:COL ;переносим кол-во столбцов в cl
				XOR BX, BX 
				input_col: ;начало цикла
					CALL input_num ;ввод элемента матрицы
					MOV ES:MTR[SI][BX], AL 
					
					INC BX
					CALL print_space
					LOOP input_col
					
				CALL print_new_line
				POP CX ;получаем из стека сохраненное значение кол-ва строк
				ADD SI, 9 ;переходим на новую строку
				LOOP input_row
				
				
		; find_max_min: 
			; MOV SI, 0 ;SI=0
			
			; XOR AX, AX
			; MOV AL, ES:COL ;AX=0-COL         ;Тут прикол как раз в том, что col занимает байт, а al - 2 байта, поэтому так
			
			; XOR DI, DI ;DI=0
			; MOV DI, AX ;DI=0-COL
			
			; XOR CX, CX
			; MOV CL, ES:ROW ;cl-кол-во строк
			
			; XOR AX, AX
			; XOR DX, DX
			; MOV AL, ES:MTR[SI] ;в ал - элемент 0;0
			; MOV DL, ES:MTR[SI] ;в дл - элемент 0;0
			
			; find_row_max_min: ;цикл - начало
				; PUSH CX ;финт, что и при вводе
				; MOV CL, ES:COL
				; MOV BX, 0
				; find_col_max_min: ;цикл - начало
					; CMP AL, ES:MTR[SI][BX] ;сравнение текущего максимума с текущим элементом
					; JLE next_max
					; CMP DL, ES:MTR[SI][BX] ;сравнение текущего минимума с текущим элементом
					; JGE next_min
					; JMP next
				; next_max:
					; MOV AL, ES:MTR[SI][BX] ;обновление текущего максимума
					; MOV ES:MAX_I, SI ;сохраняем новер строки с наибольшиим элементом
					; JMP next 
				; next_min:
					; MOV DL, ES:MTR[SI][BX] ;обновление текущего минимума
					; MOV ES:MIN_I, SI	

				; next:
					; INC BX
					; LOOP find_col_max_min ;цикл - конец
				; POP CX
				; ADD SI, DI ;по сути просто si+9 т.е. следующая строка
				; LOOP find_row_max_min ;цикл - конец
				
		; swap_lines:
			; XOR CX, CX
			; MOV CL, ES:COL
			; MOV SI, ES:MAX_I ;в si - индекс строки с максимальным элементом (типо 9*n + 0)
			; MOV BX, ES:MIN_I ;в bx - индекс строки с минимальным элемнетом
			; swap: ;цикл - начало   идем по столбцам
				; XCHG AL, ES:MTR[SI] ; стандратный обмент через tmp
				; XCHG AL, ES:MTR[BX] ;
				; XCHG AL, ES:MTR[SI] ;
				; INC SI
				; INC BX
				; LOOP swap ;цикл - конец
		
		print_mtr: ;вывод матрицы
			MOV DX, OFFSET ES:MSG_RES
			CALL print_text
			CALL print_new_line
			
			XOR CX, CX
			MOV CL, ES:ROW
			XOR SI, SI
			print_row:
				PUSH CX 
				MOV CL, ES:COL
				XOR BX, BX
				print_col: 
					MOV DL, ES:MTR[SI][BX]
					CALL print_num
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
	
seg_code_main ENDS
END main
