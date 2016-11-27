:: boot oat deodex tools
:: 
:: http://blog.naver.com/softdx
::
@echo off
if (%1)==() GOTO END
if not exist "place-boot-oat-here-to-extracting" (mkdir "place-boot-oat-here-to-extracting")
if not exist "place-boot-oat-here-to-extracting\%~n1.odex" goto notoat
echo OAT ODEX File Type - %~n1.dex Extracting...
cd place-boot-oat-here-to-extracting
if errorlevel 1 goto error
java -Xmx%heapy%m -jar "%~dp0oat2dex.jar" odex "%~n1.odex"
:: cleanup
cd ..
echo Cleaning up...
del /q "place-boot-oat-here-to-extracting\%~n1.odex"
goto END
:error
echo "An Error Occured, Please Check The Log (option 21)"
cd ..
cd ..
PAUSE
goto END
:notoat
echo "Not %~n1.odex File!"
:END