;прямоугольная цифровая  
;удалить строку с наибольшей суммой элементов

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
	STR_INDEX DB 0 ;номер строки, в которой находится наибольшая сумма элементов
	ELEM_INDEX DB 0 ;номер первого элемента в такой строке
	STR_SUM DB 0
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
		
		MOV CL, ES:ROW
		CMP CL, 1
		JE one_line
				
		find_max_str_sum: 
			XOR AX, AX
			XOR DX, DX

			XOR CX, CX
			MOV CL, ES:ROW ;cl-кол-во строк
			
			XOR SI, SI
			XOR DI, DI
			find_max_str_sum_str: ;начало цикла
				PUSH CX 
				MOV CL, ES:COL
				XOR BX, BX
				INC DI
				find_max_str_sum_col: ;цикл - начало
					ADD DL, ES:MTR[SI][BX] ;накапливаем сумму
					INC BX
					LOOP find_max_str_sum_col
					
				CMP DL, ES:STR_SUM
				JLE next
				JG upgrade_str_sum ;обновляем максимумальную сумму
				upgrade_str_sum:
					MOV ES:STR_SUM, DL ;сумма
					MOV AX, SI
					MOV ES:ELEM_INDEX, AL ;;номер первого элемента в  строке с макс суммой
					MOV AX, DI
					MOV ES:STR_INDEX, AL ;индекс строки с максимальной суммой
				next:
				POP CX
				XOR DX, DX
				ADD SI, 9 
				LOOP find_max_str_sum_str

		del_str:
			XOR CX, CX
			XOR BX, BX
			
			MOV CL, ES:ROW
			SUB CL, ES:STR_INDEX ;сколько строк под строкой, которую нужно удаоить
			
			CMP CL, 0
			JE last_line
			
			MOV BL, ES:ELEM_INDEX
			MOV SI, BX
			
			del_str_str: ;начало цикла
				PUSH CX 
				MOV CL, ES:COL
				XOR BX, BX
				del_str_col: ;начало цикла
					MOV DL, ES:MTR[SI+9][BX]
					MOV ES:MTR[SI][BX], DL
					INC BX
					LOOP del_str_col
				POP CX
				ADD SI, 9
				LOOP del_str_str
				
		last_line: ;если нужно удалить последнюю строку
			SUB ES:ROW, 1
			JMP print_mtr
		one_line: ;если в матрице только одна строка
			XOR SI, SI
			XOR BX, BX
			MOV CL, ES:COL
			zero_line:
				MOV ES:MTR[SI][BX], 0
				INC BX
				LOOP zero_line
		
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
