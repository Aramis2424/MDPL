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
    ASSUME CS:seg_code_main, DS:seg_text, ES:seg_data, SS:seg_stack
		
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
		
		error_exit:
			CALL print_new_line
			MOV DX, OFFSET MSG_ERR ;печатаем сообщение об ошибке
			CALL print_text
			MOV AH, 4Ch	;завершаем

			INT 21h
	
seg_code_main ENDS
END main
