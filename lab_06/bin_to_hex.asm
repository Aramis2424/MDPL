public bin_to_hex
extrn number: word

seg_data segment para public 'data'
    out_msg db 'Converted number: $'
    hexnum db 4 dup('0'), '$'
    sign db ' '

    mask16 dw 15
seg_data ends

seg_code segment para public 'code'
assume cs:seg_code, ds:seg_data

to_shex:
    mov ax, number

    cmp ax, 32767
    jbe nosign

    mov sign, '-'

    sub ax, 1
    not ax

    nosign:

    mov bx, 3

    trans_shex:
        mov dx, ax

        and dx, mask16

        cmp dl, 10
        jb digit

        add dl, 7

        digit:

        add dl, '0'

        mov hexnum[bx], dl

        mov cl, 4
        sar ax, cl

        dec bx

        cmp bx, -1
        jne trans_shex

    ret


print_shex:

    mov cx, 4
    mov bx, 0

    mov dl, sign

    mov ah, 2
    int 21h

    loop_out: 
        mov ah, 2

        mov dl, hexnum[bx]

        inc bx

        int 21h
        
        loop loop_out

    mov sign, ' '

    ret

; Var 2 end




bin_to_hex proc near
    mov dx, OFFSET out_msg
    mov ah, 9
    int 21h

    call to_shex

    call print_shex

    ret

bin_to_hex endp

seg_code ends
end









; public convert_shex
; extrn num: word



; DATASEG SEGMENT PARA PUBLIC 'DATA'
    ; out_msg db 'Converted number: $'
    ; hexnum db 4 dup('0'), '$'
    ; sign db ' '

    ; mask16 dw 15
; DATASEG ENDS


; CODESEG SEGMENT PARA PUBLIC 'CODE'
    ; assume CS:CODESEG, DS:DATASEG

; to_shex:
   ; Var2
    ; mov ax, num

    ; cmp ax, 32767
    ; jbe nosign

    ; mov sign, '-'

    ; sub ax, 1 ;из обратного кода делаем прямой
    ; not ax

    ; nosign:

    ; mov bx, 3

    ; trans_shex:
        ; mov dx, ax

        ; and dx, mask16

        ; cmp dl, 10
        ; jb digit

        ; add dl, 7

        ; digit:

        ; add dl, '0'

        ; mov hexnum[bx], dl

        ; mov cl, 4
        ; sar ax, cl

        ; dec bx

        ; cmp bx, -1
        ; jne trans_shex

    ; ret

; print_shex:

    ; mov cx, 4
    ; mov bx, 0

    ; mov dl, sign

    ; mov ah, 2
    ; int 21h

    ; loop_out: 
        ; mov ah, 2

        ; mov dl, hexnum[bx]

        ; inc bx

        ; int 21h
        
        ; loop loop_out

    ; mov sign, ' '

    ; ret
; Var 2 end

; convert_shex proc near
    ; mov dx, OFFSET out_msg
    ; mov ah, 9
    ; int 21h

    ; call to_shex

    ; call print_shex

    ; ret

; convert_shex endp

; CODESEG ENDS
; END