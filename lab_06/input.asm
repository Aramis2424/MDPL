public input_choice
public input_num
extrn error_menu: near
; public input_choice
; public input_choice
; public input_choice

seg_code segment para public 'code'	
	assume cs:seg_code

	input_num proc
			mov ah, 01h
			int 21h
			sub al, 30h ;делаем из строки число
			ret
	input_num endp
	
	input_choice proc
			call input_num
			
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
				MOV CL, 2  	; так как размер элемента в массиве действий DW то есть 2 байта 
				MUL CL		; умножаем на 2, так как у нас команды DW 
				MOV SI, AX	; в индексовый регистр кладем индекс нужной нам команды
			ret
	input_choice endp

seg_code ends
end
