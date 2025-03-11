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
call :colorEcho %GREEN% "  run           - Run the Go application with interactive environment selection"
call :colorEcho %GREEN% "  run-direct    - Run directly with ENV variable"
call :colorEcho %GREEN% "  build         - Build the Go application"
call :colorEcho %GREEN% "  docker-start  - Start Docker containers"
call :colorEcho %GREEN% "  docker        - Choose a Docker command (Keycloak or Kong)"
call :colorEcho %GREEN% "  clean         - Remove binary files"
call :colorEcho %GREEN% "  help          - Show this help message"
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
echo 3) Docker
set /p choice="Enter choice [1-3]: "

if "%choice%"=="1" (
  set ENV=development
  goto :run-direct
) else if "%choice%"=="2" (
  set ENV=production
  goto :run-direct
) else if "%choice%"=="3" (
  set ENV=docker
  goto :run-docker
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

:run-docker
call :colorEcho %GREEN% "Running application in Docker environment..." %RESET%
echo.
docker-compose down --remove-orphans
docker-compose up --build -d
goto :eof

:docker
echo Choose a Docker command:
echo 1) Keycloak
echo 2) Kong
set /p choice="Enter choice [1-2]: "
if "%choice%"=="1" (
  goto :keycloak
) else if "%choice%"=="2" (
  goto :kong
) else (
  call :colorEcho %YELLOW% "Invalid choice" %RESET%
  goto :eof
)

:keycloak
echo Starting Keycloak...
docker-compose -f docker-compose.keycloak.yml down
docker-compose -f docker-compose.keycloak.yml up --build -d
goto :eof

:kong
echo Starting Kong...
docker-compose -f docker-compose.kong.yml down
docker-compose -f docker-compose.kong.yml up --build -d
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

:colorEcho
<nul set /p ".=%1" > nul
echo %2
<nul set /p ".=%3" > nul
goto :eof
