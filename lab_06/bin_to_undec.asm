public bin_to_undec
public undec_number
extrn number: word

seg_data segment para public 'data'
    undec_number db 4 dup('0'), '$'

    mask16 dw 9
seg_data ends

seg_code segment para public 'code'
assume cs:seg_code, ds:seg_data

bin_to_undec proc
    mov ax, number
	;mov undec_number, al
	;ret

    mov bx, 4
    trans_shex:
        mov dx, ax

        and dx, mask16

        add dl, '0'

        mov undec_number[bx], dl

        mov cl, 5
        sar ax, cl

        dec bx

        cmp bx, -1
        jne trans_shex

    ret
bin_to_undec endp

seg_code ends
end
