@echo off
setlocal enabledelayedexpansion
COLOR 0A
mode con:cols=95 lines=40

set heapy=512
set capp=None

:restart
cd "%~dp0"
set menunr=GARBAGE
cls
echo  =============================================================================================
echo  ^| Compression-Level: %usrc% ^| Heap Size: %heapy%mb ^| Current-App: %capp% ^|
echo  ---------------------------------------------------------------------------------------------
echo  0    Set current project
echo  1    Decompile apk
echo  2    Set AndroidManifest Debuggable Options
echo  3    Set smali OnCreate Debug Options
echo  4    Compile apk     
echo  5    Sign apk
echo  6    Install apk
echo  7    Compile apk / Sign apk / Install apk
echo  8    Convert dex to jar
echo  =============================================================================================
SET /P menunr=Please make your decision:
IF %menunr%==0 (goto filesel)
IF %menunr%==1 (goto de)
IF %menunr%==2 (goto manifestset)
IF %menunr%==3 (goto smaliset)
IF %menunr%==4 (goto co)
IF %menunr%==5 (goto si)
IF %menunr%==6 (goto ins)
IF %menunr%==7 (goto all)
IF %menunr%==8 (goto dex2jar)

rem filesel : 파일 선택
:filesel
cls
Set "Pattern= "
Set "Replace=_"
cd "place-apk-here-for-modding"
For %%a in (*.apk) Do (
    Set "File=%%~a"
    Ren "%%a" "!File:%Pattern%=%Replace%!"
)
cd ..
set /A count=0
FOR %%F IN (place-apk-here-for-modding/*.apk) DO (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 (echo ^- !count!  - %%F )
if /I !count! EQU 10 (echo ^- !count! - %%F )
if /I !count! GTR 10 (echo ^- !count! - %%F )
)
echo.
echo Choose the app to be set as current project (0=cancel)?
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto chc)
if /I %INPUT% LSS 1 (goto chc)
if /I %INPUT% EQU 0 (goto chc)
set capp=!a%INPUT%!
goto restart

rem de : 디컴파일
:de
echo.
cd other
IF EXIST "../projects/%capp%" (goto deredeco)
goto decomstart
:deredeco
echo Delete the Project folder and Decompile ^(y/n^)
set /P INPU=Type input: %=%
if %INPU%==n (goto dereq)
echo Project Decompile %capp% folder Deleting..
rmdir /S /Q "../projects/%capp%"
:decomstart
echo.
IF EXIST "%~dp0place-apk-here-for-modding\signed%capp%" (del /Q "%~dp0place-apk-here-for-modding\signed%capp%")
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
echo Decompiling Apk
java -Xmx%heapy%m -jar apktool.jar d -f "../place-apk-here-for-modding/%capp%" -o "../projects/%capp%" 
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
:dereq
cd ..
goto restart


rem manifestset : 매니페스트에 android:debuggable="true" 를 추가함. 만약 해당 옵션이 false 로 되어있으면 true로 바꿔줌
:manifestset
other\setApk.exe -m "./projects/%capp%/AndroidManifest.xml"
move ".\projects\%capp%\AndroidManifest.xml.new" ".\projects\%capp%\AndroidManifest.xml"
PAUSE
goto restart

rem smaliset : smali OnCreate 부분에 "invoke-static {}, Landroid/os/Debug;->waitForDebugger()V"를 추가해줌
:smaliset
set /P psmali=Input Smali Path (ex. com.example.MainActivity): %=%
other\setApk.exe -s ".\\projects\\%capp%\\smali\\" "%psmali%"
PAUSE
goto restart

rem 
:co
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
echo.
cd other
echo Is this a system apk ^(y/n^)
set /P INPU=Type input: %=%
if not %INPU% == y (goto conqq)
if %INPU%==y (goto q1)

rem 
:conqq
echo.
echo Normal Apk Building
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
java -Xmx%heapy%m -jar apktool.jar b "../projects/%capp%" -o "%~dp0place-apk-here-for-modding\unsigned%capp%"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
goto restart

:q1
echo.
echo System Apk Building
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
java -Xmx%heapy%m -jar apktool.jar b -c "../projects/%capp%" -o "%~dp0place-apk-here-for-modding\unsigned%capp%"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
goto restart

:si
cd other
echo Signing Apk
java -Xmx%heapy%m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../place-apk-here-for-modding/unsigned%capp% ../place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)

DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
cd ..
goto restart

:ins
echo Waiting for device
other\adb wait-for-device
echo Installing Apk
other\adb install -r place-apk-here-for-modding/signed%capp%
PAUSE
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
goto restart

:all
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cd other
echo Building Apk
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
java -Xmx%heapy%m -jar apktool.jar b "../projects/%capp%" -o "%~dp0place-apk-here-for-modding\unsigned%capp%"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
goto restart
)
echo Signing Apk
java -Xmx%heapy%m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../place-apk-here-for-modding/unsigned%capp% ../place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
cd ..
echo Waiting for device
other\adb wait-for-device
echo Installing Apk
other\adb install -r place-apk-here-for-modding/signed%capp%
PAUSE
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
goto restart

:dex2jar
cd other
cd dex2jar-2.0
IF EXIST "%~dp0place-apk-here-for-modding\%ccapp%\output.jar" (del /Q "%~dp0place-apk-here-for-modding\%ccapp%\output.jar")
echo Convert dex to jar
set "ccapp=%capp:~0,-4%"
start d2j-dex2jar.bat --force "%~dp0place-apk-here-for-modding\%ccapp%\classes.dex" -o "%~dp0place-apk-here-for-modding\%ccapp%\output.jar"
PAUSE
cd ..
cd ..
goto restart
