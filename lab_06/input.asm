public input_choice
public input_dig
public number
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
				
				mov ax, 2
				mul bx
				mov bx, ax

				add bx, cx	; к числу прибавляю введенную цифру

			jmp input_num_loop	;продолжаем ввод
		
		end_input:		;если ввели enter 
			cmp di, 0
			je wrong
			cmp di, 17
			jge wrong

			mov number, bx

		ret
	input_unbin endp

seg_code ends
end



;DIGIT:
;		MOV AH, 1	; для ввода числа по цифрам
;		INT 21h		;
;		CMP AL, 13 	; 13 - это нажатый энтер, если нажат энтер, то выход из подпрограммы
;		JE EXITINPUT	; если нажат энтер, то есть ZF == 1
;		MOV CL, AL	; в CL помещаю код считанный цифры
;		SUB CL, '0'	; отнимаю 30 из CL
		; SAL BX, 1
		; MOV AX, BX
		; SAL BX, 1
		; SAL BX, 1
		; ADD BX, AX

		; ADD BX, CX	; к числу прибавляю введенную цифру
		; JMP DIGIT	; ввожу цифру до энтер
	; EXITINPUT:		; если ввели энтер 
	; MOV NUMBER, BX	; помещаю число в отведенную память
	; RET
	
	
	
	
; PUBLIC INPUT

; DSEG	SEGMENT PARA PUBLIC 'DATA'
	; ENT		DB	'>> $'
	; NLINE	DB	10, 13, '$'
; DSEG	ENDS

; CSEG	SEGMENT PARA PUBLIC 'CODE'
	; ASSUME CS:CSEG
		
; INPUT PROC NEAR
	; MOV  AH, 9
	; MOV  DX, OFFSET ENT
	; INT  21H
	
	; XOR  BX, BX
	; XOR  CX, CX
	

; INPUT_LOOP:
	; MOV  AH, 8 ;ввод без эха
	; INT  21H
	
	; CMP  AL, 13       ;enter
	; JE   INPUT_END		
		
	; CMP  AL, 45		минус
	; JE   NEG_NUM
		
	; CMP  AL, '0' ;0
	; JB   INPUT_LOOP
	
	; CMP  AL, '9' ;9
	; JA   INPUT_LOOP
		
	; MOV  AH, 2 ;ввод с эхом
	; MOV  DL, AL
	; INT  21H
		
	; MOV  CL, AL
	; MOV  AX, BX
		
	; SHL  AX, 1
	; SHL  AX, 1
	; ADD  AX, BX
	; SHL  AX, 1
		
	; MOV  BL, CL
	; SUB  BL, '0'
	; XOR  BH, BH
	; ADD  BX, AX
		
	; JMP  INPUT_LOOP
		
; NEG_NUM:
	; MOV  AH, 2
	; MOV  DL, AL
	; INT  21H
		
	; MOV  CH, 1
		
	; JMP  INPUT_LOOP
		
; INPUT_END:
	; MOV  AH, 9
	; MOV  DX, OFFSET NLINE
	; INT  21H
		
	; CMP  CH, 1
	; JNE  SCAN_END
		
	; NEG  BX
		
; SCAN_END:
	; XOR  DH, DH
	; MOV  DL, CH
	; MOV  AX, BX
		
	; RET
		
; INPUT ENDP

; CSEG	ENDS
; END