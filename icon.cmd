  @echo off
  setlocal
  set ARGS=
  set ICONT_ARGS=
  set ARG0=%~dps0
  set ARG=%1
  set ICN_FILE=
  if not defined ARG goto usage_ERROR

  :: shift till last arg is %1
  set ARG=%1

:more_args

  if /I ""%ARG%"" == ""--help"" goto usage
  if    ""%ARG%"" == ""/?""     goto usage
  if /I ""%ARG%"" == ""-H""     goto usage
  set ARG2=%2
  if defined ICN_FILE goto next_arg
    set ICONT_ARGS=%ARGS%
    if exist "%~dpns1.icn" set ICN_FILE=%~dpns1.icn& set ICNSRCdpnsx=%~dpnxs1& set ICNSRCdpns=%~dpns1& set ICNSRCdps=%~dps1& set ICNSRCns=%~ns1& set ARGS=
    if "%~ns1" == "-" set ICN_FILE=-& set ICNSRCns=%~ns1& set ARGS=
  :next_arg
  if not "%~ns1" == "-" if not exist "%~dpns1.icn" set ARGS=%ARGS% %ARG%
  shift
  set ARG=%1
  :: if not "%~ns1" == "-" set ARGS=%ARGS% %ARG%
  if not defined ARG2 goto got_args
  goto more_args

:got_args

  set EXIT_ERROR=0
  if "%ICN_FILE%" == "-" goto have_pipe

:not_pipe
  set ICX=%ICNSRCdps%%ICNSRCns%.exe
  if not exist "%ICNSRCdpnsx%" if not exist "%ICNSRCdpns%.icn" (
    echo.icon.cmd: No .icn file find among args:
    echo.    %*
    goto usage_ERROR
  )
  if /I not "%ICNSRCdpnsx:~-4%" == ".icn" set ICNSRCdpnsx=%ICNSRCdpns%.icn
  if not exist "%ICNSRCdpnsx%" (
    echo.icon.cmd: No file ending in '.icn' find among args:
    echo.    %*
    goto usage_ERROR
  )
  set ICNSRCdpnsx="%ICNSRCdpnsx%"
  set ICX="%ICX%"
  (type %ICNSRCdpnsx% | call %ARG0%icont.cmd -o %ICX% -u -v0 %ICONT_ARGS% - )& if exist %ICX% ( %ARG0%bin\nticonx.exe %ICX% %ARGS% & del %ICX% ) else (echo %ARG0%: translation of %ICNSRCdpnsx% FAILED)
  @echo off
  goto post_pipe

:have_pipe
  set ICX=%ICNSRCdps%pipe%RANDOM%.exe
  set ICX="%ICX%"
  (call %ARG0%icont.cmd -o %ICX% -u -v0 %ICONT_ARGS% - )& if exist %ICX% ( %ARG0%bin\nticonx.exe %ICX% %ARGS% & del %ICX% ) else (echo %ARG0%: translation of standard input FAILED)

:post_pipe
  set EXIT_ERROR=%ERRORLEVEL%
  if %EXIT_ERROR% == 0 exit /b 0
  echo exit code %EXIT_ERROR% 1>&2
  endlocal&exit /b %EXIT_ERROR%

:usage_ERROR
  set EXIT_ERROR=1

:usage
  echo usage: icon [options for icont] [program.icn or -] [args for program]
  endlocal&exit /b %EXIT_ERROR%
