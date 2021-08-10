@ set ERRORLEVEL=&setlocal&echo off
@ set SENTINEL=NOT_ICON& set PROMPT=running -$G &set ECHO_ON=off

pushd %~dps0

:: Extract world.icn from example_stdin.cmd
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn

:: Delete any pre-existing executable
if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.bat" del "%~dp0world.bat"

echo.
echo -------  Here is the Icon program used for these examples ---------
type "%~dp0world.icn"

echo.
echo -------  Test one   - Translate with default options [1]  ---------
set PROMPT=running one -$G
@echo %ECHO_ON%
(call "%~dp0..\icont.cmd" "%~dp0world.icn") >NUL 2>&1

@echo %ECHO_ON%
call "%~dp0world.bat" one
@echo off

del "%~dp0world.bat"

echo.
echo -------  Test two   - Translate with custom options [2]  ---------
set PROMPT=running two -$G
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" -s -u -o "%~dp0mundo.exe" "%~dp0world.icn"
call "%~dp0..\bin\smudge.cmd" "%~dp0mundo.exe"
@echo %ECHO_ON%
call "%~dp0mundo.bat" one two
@echo off

:: prep for next test
if exist "%~dp0mundo.bat" del "%~dp0mundo.bat"
if exist "%~dp0world.icn" del "%~dp0world.icn"
echo.
echo -------  Test three - Translate from within a script and run [3]  ---------
set PROMPT=running three -$G
:: It is imperative that you use "call";
::   otherwise, the rest of the script is ignored.
@echo %ECHO_ON%
call example_stdin.cmd one two three
@echo off

:: Extract world.icn from example_stdin.cmd for next test
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
echo.
echo -------  Test four  - Explicity run the Icon Virtual Machine [4]  ---------
set PROMPT=running four -$G
@echo %ECHO_ON%
"%~dp0..\bin\nticont.exe" -s -u "%~dp0world.icn"
@echo %ECHO_ON%
"%~dp0..\bin\nticonx.exe" "%~dp0world.exe" one two three four
@echo off

@echo %ECHO_ON%
"%~dp0..\icont.exe" -s -u "%~dp0world.icn"
@echo %ECHO_ON%
"%~dp0..\iconx.exe" "%~dp0world.bat" won too three faure
@echo off

setlocal

echo.
echo -------  Test five  - Implicity run the Icon Virtual Machine using CMD [5]  ---------
call "%~dp0..\bin\smudge.cmd" "%~dp0world.exe"
set PROMPT=running five -$G
set OLD_PATH=%PATH%
set PATH=%~dp0..;%PATH%
@echo %ECHO_ON%
cmd /c ^""%~dp0world.bat" one two three four five^"
@echo off

echo.
echo -------  Test six  - Implicity run the Icon Virtual Machine in the background using START [6]  ---------
set PROMPT=running six -$G
@echo %ECHO_ON%
start "demo start" /b "%windir%\system32\cmd.exe" /c ""%~dp0world.bat" one two three four five six^"
>NUL ping -n 2 localhost
@echo off

if exist "%~dp0world.bat" del "%~dp0world.bat"
if exist "%~dp0world.exe" del "%~dp0world.exe"

endlocal

echo.
echo -------  Test seven  -  Do not include the Icon Virtual Machine in the output file [7]  ---------

set PROMPT=running seven -$G

set PATH=OLD_%PATH%
@echo %ECHO_ON%
call "%~dp0..\icont_nopath.cmd" -s -u "%~dp0world.icn"

@echo %ECHO_ON%
if exist "%~dp0world.exe" call "%~dp0..\bin\smudge.cmd" "%~dp0world.exe" >NUL
@echo %ECHO_ON%
if exist "%~dp0world.bat" call "%~dp0world.bat" uno deux drei tessera cinque seis seven
@echo off

if exist "%~dp0world.bat" del "%~dp0world.bat"
if exist "%~dp0world.bat" del "%~dp0world.bat"

echo.
echo -------  Test eight  -  Shebang example [8]  ---------

set PROMPT=running eight -$G


:: the shebang line in this case is NOT emitted because echo is OFF
call "%~dp0example_shebang.cmd" ten nine eight seven six five four three two one zero "blast off"
@echo off

echo.
echo -------  Test nine  -  icon invokes icont and iconx [9]  ---------

set PROMPT=running nine -$G

@echo %ECHO_ON%
:: invoke with the icon script with and without quotes
call %~dps0..\icon.cmd %~dps0world.icn nine "with quoted path"
echo.
call %~dps0..\icon.cmd %~dps0world.icn nine "without quoted path"
echo.
type %~dp0world.icn | %~dps0..\icon.cmd - "nine with stdin"
@echo off

echo.
echo -------  "Where there's smoke, there's fire." -Anonymous ---------

popd
endlocal
