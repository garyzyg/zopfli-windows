PUSHD .
FOR %%I IN (C:\WinDDK\7600.16385.1) DO CALL %%I\bin\setenv.bat %%I fre %Platform% WIN7 no_oacr
POPD

IF %_BUILDARCH%==x86 SET Lib=%Lib%\Crt\i386;%DDK_LIB_DEST%\i386;%Lib%
IF %_BUILDARCH%==AMD64 SET Lib=%Lib%\Crt\amd64;%DDK_LIB_DEST%\amd64;%Lib%

FOR /F %%I IN ('DIR /B /S src\zopfli\*.c') DO CALL :cl %%I
CALL :link zopfli.exe

FOR %%I IN (
zopfli_bin.obj
) DO IF EXIST %%I DEL /Q %%I

FOR /F %%I IN ('DIR /B /S src\zopflipng\*.c*') DO CALL :cl /I%INCLUDE%\crt\stl60 /EHsc %%I
CALL :link zopflipng.exe

GOTO :EOF

:cl
cl.exe -nologo -O1 /GL /GS- /I%CRT_INC_PATH% /I. -c /MD /DNDEBUG %*
GOTO :EOF

:link
link.exe -nologo						^
	/LTCG							^
	/OUT:%1							^
	*.obj							^
	user32.lib advapi32.lib					^
	kernel32.lib						^
