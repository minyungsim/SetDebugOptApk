:: deodex tools
:: 
:: http://blog.naver.com/softdx
::
@echo off
if (%1)==() GOTO END
if not exist "place-odex-here-to-deodex\%~n1.odex" goto END
echo Deodexing %~n1.apk...
java -Xmx%heapy%m -jar "./other/baksmali-%smaliversion%.jar" -a %api% -d framework -d place-odex-here-to-deodex -c :%4 -x "place-odex-here-to-deodex/%~n1.odex" -o deodex 
if errorlevel 1 goto error
echo Copying "classes.dex" to %~n1.apk...
java -Xmx%heapy%m -jar "./other/smali-%smaliversion%.jar" -a %api% deodex -o classes.dex
if errorlevel 1 goto error
%~dp0\7za u -tzip "place-odex-here-to-deodex\%~n1.apk" classes.dex %2
:: cleanup
echo Cleaning up...
del /q "place-odex-here-to-deodex\%~n1.odex"
del /q "classes.dex"
rd /s /q deodex
goto END
:error
rd /s /q deodex
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
:END