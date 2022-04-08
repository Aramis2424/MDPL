EXTRN INPUTCOM: NEAR    		; Ближний (near) - в пределах того же сегмента (2 байта).
EXTRN INPUTDECNUM: NEAR			; Ближний (near) - в пределах того же сегмента (2 байта).
EXTRN OUTPUTUNSIGNHEX: NEAR		; Ближний (near) - в пределах того же сегмента (2 байта).
EXTRN OUTPUTSIGNBIN: NEAR		; Ближний (near) - в пределах того же сегмента (2 байта).
EXTRN NEWSTR: NEAR				; Ближний (near) - в пределах того же сегмента (2 байта).

STKS SEGMENT PARA STACK 'STACK'		; сегмент стека
    DB 200 DUP (0)					;  
STKS ENDS

; Сегмент данных
DATAS SEGMENT PARA PUBLIC'DATA'	
	EXITMSG DB 'Finally program $'
    MENUMSG DB '1 - Input unsigned decimal number.', 13, 10
		DB '2 - Convent to unsigned hexadecimal.', 13, 10				
		DB '3 - Convent to signed binary.', 13, 10				
		DB '0 - EXIT!', 13, 10, 10		
		DB 'INPUT COMMAND: $'
	ACT DW EXIT, INPUTDECNUM, OUTPUTUNSIGNHEX, OUTPUTSIGNBIN
DATAS ENDS	

; Сегмент кода
CODES SEGMENT PARA PUBLIC 'CODE'	
    ASSUME CS:CODES, DS:DATAS, SS:STKS

EXIT PROC NEAR
	MOV DX, OFFSET EXITMSG
	MOV AH, 9h
	INT 21h
	MOV AH,4Ch						
	INT 21h
EXIT ENDP

OUTPUTMENU PROC NEAR
	MOV DX, OFFSET MENUMSG
	MOV AH, 9
	INT 21h
	RET
OUTPUTMENU ENDP

MAIN:
	MOV AX, DATAS			;
    MOV DS, AX				;
		
	MENULOOP:
		CALL OUTPUTMENU		;
		CALL INPUTCOM		;
		CALL NEWSTR			;
		CALL ACT[SI]		;
		JMP MENULOOP		;
CODES ENDS
END MAIN

	