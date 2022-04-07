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
	
input_num:
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

print_num:
	MOV AH, 02h
	INT 21h
	RET

print_text:
	MOV AH, 09h
	INT 21h
	RET

main:
	MOV AX, DataSeg
    MOV ES, AX
	
	MOV AX, TextSeg
	MOV DS, AX

	MOV DX, OFFSET ES:MSG_ROW
	CALL print_text
	CALL input_num
	
	MOV ES:ROW, AL
	SUB ES:ROW, 30h
	MOV AL, ES:ROW
	;CALL print_new_line ;;
	CMP AL, 0
	JE error_exit ;;
	CALL print_new_line ;;
	
	MOV DX, OFFSET ES:MSG_COL
	CALL print_text
	CALL input_num
	MOV ES:COL, AL
	SUB ES:COL, 30h
	MOV AL, ES:COL
	CALL print_new_line
	CMP AL, 0
	JE error_exit
	
	
	MOV DX, OFFSET ES:MSG_MTR
	CALL print_text
	CALL print_new_line
	
	input_mtr:
		XOR BX, BX ;обнуление
		XOR CX, CX
		MOV CL, ES:ROW
		XOR SI, SI
		input_row:
			PUSH CX
			MOV CL, ES:COL
			XOR BX, BX
			input_col:
				CALL input_num
				SUB AL, 30h
				MOV ES:MTR[BX + SI], AL
				
				INC BX
				CALL print_space
				LOOP input_col			
			CALL print_new_line
			POP CX
			ADD SI, 9
			LOOP input_row
		
		
	find_max_min: 
		MOV SI, 0
		
		XOR AX, AX
		MOV AL, ES:COL
		XOR DI, DI
		MOV DI, AX
		
		XOR CX, CX
		MOV CL, ES:ROW
		
		XOR AX, AX
		XOR DX, DX
		MOV AL, ES:MTR[SI]
		MOV DL, ES:MTR[SI]
		
		find_row_max_min:
			PUSH CX
			MOV CL, ES:COL
			MOV BX, 0
			find_col_max_min:
				CMP AL, ES:MTR[SI][BX]
				JLE next_max
				CMP DL, ES:MTR[SI][BX]
				JGE next_min
				JMP next
			next_max:
				MOV AL, ES:MTR[SI][BX]
				MOV ES:MAX_I, SI
				JMP next 
			next_min:
				MOV DL, ES:MTR[SI][BX]
				MOV ES:MIN_I, SI	

			next:
				INC BX
				LOOP find_col_max_min
			POP CX
			ADD SI, DI
			LOOP find_row_max_min
			
	swap_lines:
		XOR CX, CX
		MOV CL, ES:COL
		MOV SI, ES:MAX_I
		MOV BX, ES:MIN_I
		swap:
			XCHG AL, ES:MTR[SI]
			XCHG AL, ES:MTR[BX]
			XCHG AL, ES:MTR[SI]
			INC SI
			INC BX
			LOOP swap
	
	print_mtr:
		MOV DX, OFFSET ES:MSG_RES
		CALL print_text
		CALL print_new_line
		XOR BX, BX
		XOR CX, CX
		MOV CL, ES:ROW
		print_row:
			XOR BX, BX
			PUSH CX 
			MOV CL, ES:COL
			print_col:
				MOV DL, ES:MTR[BX + SI]
				ADD DL, 30h
				CALL print_num
				INC BX
				CALL print_space
				LOOP print_col
			CALL print_new_line
			POP CX
			ADD SI, 9
			LOOP print_row
			

	MOV AH, 4Ch						
    INT 21h
	
	error_exit:
		CALL print_new_line
		MOV DX, OFFSET ES:MSG_ERR
		CALL print_text
		MOV AH, 4Ch		

		INT 21h
	
CodeSeg ENDS
END main

;SI - str
;BX - col