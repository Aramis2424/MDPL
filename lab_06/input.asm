public input_choice
public input_dig
extrn error_menu: near
extrn print_text: near
extrn print_newline: near
extrn print_menu_loop: near
; public input_choice
; public input_choice
; public input_choice

seg_data segment para public 'data'
	msg_input db 'Input unsigned binary number [0; 1111111111111111]: $'
	msg_error_input db 'Input error', 13, 10, 'Please try again!', 13, 10, '$'
	number dw 0
seg_data ends

seg_code segment para public 'code'	
	assume cs:seg_code, ds:seg_data

	input_dig proc
			mov ah, 01h
			int 21h
			sub al, 30h ;делаем из строки число
			ret
	input_dig endp
	
	input_sym proc
			mov ah, 01h
			int 21h
			ret
	input_sym endp
	
	input_choice proc
			call input_dig
			
			cmp al, 0
			je right
			cmp al, 1
			je right
			cmp al, 2
			je right
			cmp al, 3
			je right
			wrong:
				call error_menu
			right:
				mov cl, 2  	;т.к. каждый элемент массива - 2 байта, значит, чтобы правильно посчитать смещение, нужно умножить на 2
				mul cl
				xor bx, bx
				mov bl, al
				mov si, bx
			ret
	input_choice endp

	input_unbin proc
		call print_newline
		mov dx, offset msg_input
		call print_text
		xor bx, bx
		xor dx, dx
		xor di, di
		
		input_num_loop:
			call input_sym	;ввод числа по цифрам
			
			cmp al, 13 	;13 - символ enter - конец ввода
			je end_input
			
			inc di
			
			sub al, 30h	;делаем число
			
			cmp al, 0
			je right
			cmp al, 1
			je right
			
			wrong:
				call print_newline
				mov dx, offset msg_error_input
				call print_text
				call print_newline
				jmp print_menu_loop
			
			right:
				xor cx, cx
				mov cl, al ;записали в cx
				
				shl bx, 1
				add bx, cx

			jmp input_num_loop	;продолжаем ввод
		
		end_input:		;если ввели enter 
			cmp di, 0
			je wrong
			cmp di, 17
			jge wrong

			mov number, bx
		
		
		; call print_newline
		; mov dx, offset number
		; call print_text
		
		
		ret
	input_unbin endp

seg_code ends
end


INPUT_LOOP:
	MOV  AH, 8
	INT  21H
	
	CMP  AL, 13
	JE   INPUT_END
		
	CMP  AL, 45
	JE   NEG_NUM
		
	CMP  AL, '0'
	JB   INPUT_LOOP
	CMP  AL, '9'
	JA   INPUT_LOOP
		
	MOV  AH, 2
	MOV  DL, AL
	INT  21H
		
	MOV  CL, AL
	MOV  AX, BX
		
	SHL  AX, 1
	SHL  AX, 1
	ADD  AX, BX
	SHL  AX, 1
		
	MOV  BL, CL
	SUB  BL, '0'
	XOR  BH, BH
	ADD  BX, AX
		
	JMP  INPUT_LOOP
