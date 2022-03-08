public number
extrn print : far

STACK_SEG1 SEGMENT PARA STACK 'STACK'
	db 200h dup(?)
STACK_SEG1 ENDS

DATA_SEG_1 SEGMENT PARA 'DATA'
	number db 0
DATA_SEG_1 ENDS

CODE_SEG_1 SEGMENT PARA 'CODE'
	ASSUME CS:CODE_SEG_1, DS:DATA_SEG_1, SS:STACK_SEG1
	main:
		mov AX, DATA_SEG_1
		mov DS, AX
		
		mov AH, 01h
		int 21h		;введеное число в AL
		mov number, Al		;переместить в number
		
		jmp print
		
CODE_SEG_1 ENDS
END main
