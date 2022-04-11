public bin_to_hex
extrn number: word
public hex_number
public hex_sign

seg_data segment para public 'data'
    hex_number db 4 dup('0'), '$'
    hex_sign db ' '

    mask16 dw 15
seg_data ends

seg_code segment para public 'code'
assume cs:seg_code, ds:seg_data

bin_to_hex proc
    mov ax, number

    cmp ax, 32767
    jbe nosign

    mov hex_sign, '-'

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

        mov hex_number[bx], dl

        mov cl, 4
        sar ax, cl

        dec bx

        cmp bx, -1
        jne trans_shex

    ret
bin_to_hex endp

seg_code ends
end
