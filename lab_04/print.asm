public print
extrn number : byte

CODE_SEG_2 SEGMENT PARA 'CODE'
	ASSUME CS:CODE_SEG_2
	print:
		sub number, 5		;уменьшение числа на 5
		
		mov AH, 02h
		mov DL, 20h		;пробел
		int 21h
		mov DL, number
		int 21h
		
		mov AH, 4Ch
		int 21h
		
CODE_SEG_2 ENDS
END
