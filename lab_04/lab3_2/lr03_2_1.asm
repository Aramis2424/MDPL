STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

SD1 SEGMENT para common 'DATA'
	W dw 3444h ;34 == 4, 44 == d
SD1 ENDS
END
