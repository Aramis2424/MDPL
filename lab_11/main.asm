format PE GUI 4.0 ; говорим компилятору FASM какой файл делать
entry start ; говорим windows-у, где начало программы

include 'win32a.inc' ; подключаем библиотеку FASM-а 

ID_FIRSTDIG          = 101
ID_SECONDDIG         = 102
ID_RES               = 103 

section '.text' code readable executable ; секция данных+кода
; invoke - макрос, макро команда, т.е. fasm вместо invoke
; подставит нужный набор команд
  start:  ;метка старта
        invoke  GetModuleHandle,0
		; Переход в основную процедуры программы
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
		; Как только вышли из процедуры, заканчиваем программу
		invoke  ExitProcess,0

proc DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
		; Анализируем полученную команду
        cmp     [msg],WM_COMMAND 
        je      .wmcommand ; Выполнение сложения
        cmp     [msg],WM_CLOSE
        je      .wmclose ; Завершение процедуры
        xor     eax,eax
        jmp     .finish
  .wmcommand:
        cmp     [wparam],BN_CLICKED shl 16 + IDCANCEL
        je      .wmclose
        cmp     [wparam],BN_CLICKED shl 16 + IDOK ; Нажата кнопка для суммирования
        jne     .processed
		
		; Считывание первого числа из поля ввода в переменную
        invoke  GetDlgItemText,[hwnddlg],ID_FIRSTDIG,firstDigit,4h 
        invoke  GetDlgItemText,[hwnddlg],ID_SECONDDIG,secondDigit,4h
        mov     [flags],MB_OK
		
		mov 	edx, firstDigit ; Считывание в dx первого числа
		mov 	edx, [edx]
		sub 	edx, '0' ; Превращение первого числа из строки в, собственно, число
		
		mov 	eax, secondDigit ; Считывание в dx второго числа
		mov 	eax, [eax]
		sub 	eax, '0' ; Превращение второго числа из строки в, собственно, число
		
		add 	eax, edx ; Сложение двух цифр
		
		cmp 	al, 10 ; Проверка полученного числа: больше ли оно 10 или нет
		
		jae 	.twoDigOut ; Если полученное число меньше 10
		;вывод одной цифры
		add 	eax, '0' ; Делаем из цифры строку
		mov 	[res], al
		mov 	[res + 1], ' ' ; Формируем результат
		invoke SetDlgItemText,[hwnddlg],ID_RES,res ; Собственно вывод результата
		jmp 	.processed
		
  .twoDigOut: ; То же, но в том случае, если результат больше или равен 10
		;вывод двух цифр
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

section '.idata' import data readable writeable ; секция импорта

  library kernel,'KERNEL32.DLL',\ ; library как invoke - макро команда
          user,'USER32.DLL' ; загрузка библиотеки

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

  ; Размещение главного окна и объектов на нем
  ; Формат определения размеров объектов: X1,Y1, X2,<Высота>
  dialog demonstration,'Sum of digits',70,70,190,175,WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME ; Окно программы
  
    dialogitem 'STATIC','&First digit:',-1,10,10,70,8,WS_VISIBLE ; Надпись
    dialogitem 'EDIT','',ID_FIRSTDIG,10,20,170,15,WS_VISIBLE+WS_BORDER+WS_TABSTOP ; Окно ввода
	
    dialogitem 'STATIC','&Second digit:',-1,10,40,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_SECONDDIG,10,50,170,15,WS_VISIBLE+WS_BORDER+WS_TABSTOP
	
	dialogitem 'BUTTON','Sum digits!',IDOK,10,80,170,15,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON ; Кнопка
	
	dialogitem 'STATIC','&Result:',-1,10,110,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_RES,10,120,170,15,WS_VISIBLE+WS_BORDER+WS_TABSTOP
  enddialog
