:: boot oat deodex tools
:: 
:: http://blog.naver.com/softdx
::
@echo off
if (%1)==() GOTO END
if not exist "place-boot-oat-here-to-extracting" (mkdir "place-boot-oat-here-to-extracting")
if not exist "place-boot-oat-here-to-extracting\%~n1.oat" goto notoat
echo BOOT.OAT File Type - %~n1.oat Extracting...
cd place-boot-oat-here-to-extracting
mkdir "%~n1_odex"
copy ".\%~n1.oat" ".\%~n1_odex\%~n1.oat"
cd "%~n1_odex"
if errorlevel 1 goto error
java -Xmx%heapy%m -jar "%~dp0oat2dex.jar" odex "%~n1.oat"
:: cleanup
cd ..
cd ..
echo Cleaning up...
del /q "place-boot-oat-here-to-extracting\%~n1_odex\%~n1.oat"
goto END
:error
echo "An Error Occured, Please Check The Log (option 21)"
cd ..
cd ..
PAUSE
goto END
:notoat
echo "Not %~n1.oat File!"
:END