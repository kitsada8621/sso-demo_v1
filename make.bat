@echo off
setlocal enabledelayedexpansion

REM Default environment is development
if "%ENV%"=="" set ENV=development

REM Color codes for Windows console
set GREEN=92
set YELLOW=93
set WHITE=97
set RESET=0

REM Check if a command was provided
if "%1"=="" goto :help

REM Jump to the specified command
goto :%1
if ERRORLEVEL 1 goto :help

:help
echo.
echo Usage:
call :colorEcho %YELLOW% "  make.bat" %RESET% " " %GREEN% "^<target^>" %RESET%
echo.
echo Targets:
call :colorEcho %GREEN% "  run" %RESET% "           - Run the Go application with interactive environment selection"
call :colorEcho %GREEN% "  run-direct" %RESET% "    - Run directly with ENV variable"
call :colorEcho %GREEN% "  build" %RESET% "         - Build the Go application"
call :colorEcho %GREEN% "  docker-start" %RESET% "  - Start Docker containers"
call :colorEcho %GREEN% "  clean" %RESET% "         - Remove binary files"
call :colorEcho %GREEN% "  help" %RESET% "          - Show this help message"
echo.
goto :eof

:docker-start
echo Starting Docker containers...
docker-compose down --remove-orphans
docker-compose up -d --build
goto :eof

:run
call :colorEcho %YELLOW% "Please select environment:" %RESET%
echo.
echo 1) Development
echo 2) Production
set /p choice="Enter choice [1-2]: "

if "%choice%"=="1" (
    set ENV=development
    goto :run-direct
) else if "%choice%"=="2" (
    set ENV=production
    goto :run-direct
) else (
    call :colorEcho %YELLOW% "Invalid choice. Using default (development)" %RESET%
    echo.
    set ENV=development
    goto :run-direct
)

:run-direct
call :colorEcho %GREEN% "Running application in %ENV% environment..." %RESET%
echo.
go run ./cmd/api/main.go
goto :eof

:build
echo Building application...
if not exist bin mkdir bin
go build -o bin/app main.go
goto :eof

:clean
echo Cleaning build files...
if exist bin rmdir /s /q bin
go clean
goto :eof

:default
goto :help

:colorEcho
for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

set "param=%~1"
set "string=%~2"
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%param% /R "^$" "%~2" nul
del "%~2" > nul 2>&1

if "%~3"=="" goto :eof
<nul set /p "=%~3"

set "param=%~4"
set "string=%~5"
if not "%param%"=="" (
  <nul set /p ".=%DEL%" > "%~5"
  findstr /v /a:%param% /R "^$" "%~5" nul
  del "%~5" > nul 2>&1
)

if "%~6"=="" goto :eof
<nul set /p "=%~6"

set "param=%~7"
set "string=%~8"
if not "%param%"=="" (
  <nul set /p ".=%DEL%" > "%~8"
  findstr /v /a:%param% /R "^$" "%~8" nul
  del "%~8" > nul 2>&1
)

goto :eof