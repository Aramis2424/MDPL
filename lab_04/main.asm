public number
extrn print : far

STACK_SEG1 SEGMENT PARA STACK 'STACK'
	db 200h dup(?)
STACK_SEG1 ENDS

DATA_SEG_1 SEGMENT WORD 'DATA'
	number db 0
DATA_SEG_1 ENDS

CODE_SEG_1 SEGMENT PARA 'CODE'
	ASSUME CS:CODE_SEG_1, DS:DATA_SEG_1, SS:STACK_SEG1
	main:
		mov AX, DATA_SEG_1
		mov DS, AX
		
		mov AH, 01h
		int 21h
		mov number, Al
		
		jmp print
		
		mov AH, 4Ch
		int 21h
		
CODE_SEG_1 ENDS
END main
