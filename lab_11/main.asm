format PE GUI 4.0
entry start

include 'win32a.inc'

ID_FIRSTDIG          = 101
ID_SECONDDIG         = 102
ID_RES               = 103 

section '.text' code readable executable

  start:
        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
		invoke  ExitProcess,0

proc DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
        cmp     [msg],WM_COMMAND
        je      .wmcommand
        cmp     [msg],WM_CLOSE
        je      .wmclose
        xor     eax,eax
        jmp     .finish
  .wmcommand:
        cmp     [wparam],BN_CLICKED shl 16 + IDCANCEL
        je      .wmclose
        cmp     [wparam],BN_CLICKED shl 16 + IDOK
        jne     .processed
        invoke  GetDlgItemText,[hwnddlg],ID_FIRSTDIG,firstDigit,4h
        invoke  GetDlgItemText,[hwnddlg],ID_SECONDDIG,secondDigit,4h
        mov     [flags],MB_OK
		
		mov 	edx, firstDigit
		mov 	edx, [edx]
		sub 	edx, '0'
		mov 	eax, secondDigit
		mov 	eax, [eax]
		sub 	eax, '0'
		add 	eax, edx
		
		cmp 	al, 10
		jae 	.twoDigOut
		;вывод 1 цифры
		add 	eax, '0'
		mov 	[res], al
		mov 	[res + 1], ' '
		invoke SetDlgItemText,[hwnddlg],ID_RES,res
		jmp 	.processed
  .twoDigOut:
		;вывод 2 цифр
		mov 	dl, 31h
		mov 	[res], dl
		sub 	eax, 10
		add 	eax, '0'
		mov 	[res + 1], al 
		invoke SetDlgItemText,[hwnddlg],ID_RES,res
		jmp 	.processed
  .wmclose:
        invoke  EndDialog,[hwnddlg],0
  .processed:
        mov     eax,1
  .finish:
        pop     edi esi ebx
        ret
endp

section '.bss' readable writeable

  flags dd ?
  firstDigit db 4h
  secondDigit db 4h
  res db 4h

section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL'

  import kernel,\
         GetModuleHandle,'GetModuleHandleA',\
         ExitProcess,'ExitProcess'

  import user,\
         DialogBoxParam,'DialogBoxParamA',\
         GetDlgItemText,'GetDlgItemTextA',\
		 SetDlgItemText, 'SetDlgItemTextA',\
         IsDlgButtonChecked,'IsDlgButtonChecked',\
         MessageBox,'MessageBoxA',\
         EndDialog,'EndDialog'

section '.rsrc' resource data readable

  directory RT_DIALOG,dialogs

  resource dialogs,\
           37,LANG_ENGLISH+SUBLANG_DEFAULT,demonstration

  dialog demonstration,'Calculate digit sum',70,70,190,175,WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME
    dialogitem 'STATIC','&First digit:',-1,10,10,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_FIRSTDIG,10,20,170,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP
    dialogitem 'STATIC','&Second digit:',-1,10,40,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_SECONDDIG,10,50,170,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP
	dialogitem 'STATIC','&Result of digit sum:',-1,10,70,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_RES,10,80,170,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP
    dialogitem 'BUTTON','OK',IDOK,135,150,45,15,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
  enddialog