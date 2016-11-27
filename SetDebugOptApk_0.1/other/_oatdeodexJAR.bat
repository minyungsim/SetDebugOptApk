:: deodex tools
:: 
:: http://blog.naver.com/softdx
::
@echo off
if (%1)==() GOTO END
if not exist "place-odex-here-to-deodex\%~n1.odex.xz" goto notoat
echo OAT Deodexing %~n1.jar...
%~dp0\7za x -y "place-odex-here-to-deodex\%~n1.odex.xz" -o"place-odex-here-to-deodex"
:odexstart
if not exist "place-odex-here-to-deodex\%~n1.odex" goto notodex
java -Xmx%heapy%m -jar "./other/oat2dex.jar" odex "place-odex-here-to-deodex\%~n1.odex"
if errorlevel 1 goto error
copy ".\%~n1.dex" "place-odex-here-to-deodex\classes.dex"
del /q ".\%~n1.dex"
cd place-odex-here-to-deodex
%~dp0\7za u -tzip "%~n1.jar" "classes.dex" %2
cd ..
%~dp0\zipalign -f 4 "place-odex-here-to-deodex\%~n1.jar" "place-odex-here-to-deodex\algin_%~n1.jar"
del /q "place-odex-here-to-deodex\%~n1.jar"
rename ".\place-odex-here-to-deodex\algin_%~n1.jar" "%~n1.jar"
:: cleanup
echo Cleaning up...
del /q "place-odex-here-to-deodex\%~n1.odex"
del /q "place-odex-here-to-deodex\classes.dex"
if exist "place-odex-here-to-deodex\%~n1.odex.xz" (del /q "place-odex-here-to-deodex\%~n1.odex.xz")
goto END
:error
rd /s /q deodex
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
goto END
:notoat
echo "No \%~n1.odex.xz File"
goto odexstart
:notodex
echo "No \%~n1.odex File"
:END