echo Run this file from "VS20xx <arch> Native Tools Command Prompt"

FOR /F %%I IN ('DIR /B /S src\zopfli\*.c') DO CALL :cl %%I
CALL :link zopfli.exe

FOR %%I IN (
zopfli_bin.obj
) DO IF EXIST %%I DEL /Q %%I

FOR /F %%I IN ('DIR /B /S src\zopflipng\*.c*') DO CALL :cl /I"%INCLUDE%\crt\stl60" /EHsc %%I
CALL :link zopflipng.exe

GOTO :EOF

:cl
cl.exe -nologo -O1 /GL /GS- /I"%CRT_INC_PATH%" /I. -c /MD /DNDEBUG %*
GOTO :EOF

:link
link.exe -nologo						^
	/LTCG							^
	/OUT:%1							^
	*.obj							^
	user32.lib advapi32.lib					^
	kernel32.lib						^
