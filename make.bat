@echo off
setlocal enabledelayedexpansion

REM ------------------------------------------------------------------
REM make.bat - A helper script for managing the Go application and Docker containers.
REM Default environment is set to development if not specified.
REM ------------------------------------------------------------------

REM Set default environment if not specified
if "%ENV%"=="" set "ENV=development"

REM Color codes for Windows console output
set "GREEN=92"
set "YELLOW=93"
set "WHITE=97"
set "RESET=0"

REM If no command-line argument is provided, show help
if "%~1"=="" goto :help

REM Attempt to jump to the specified command label.
REM If the label does not exist, fall through to help.
goto :%~1 2>nul
if ERRORLEVEL 1 goto :help

REM ------------------------------------------------------------------
:help
REM Display help text with available commands and descriptions.
echo.
echo Usage:
call :colorEcho %YELLOW% "  make.bat" %RESET% " " %GREEN% "<target>" %RESET%
echo.
echo Available Targets:
call :colorEcho %GREEN% "  run           - Run the Go application with interactive environment selection" 
call :colorEcho %GREEN% "  build         - Build the Go application binary" 
call :colorEcho %GREEN% "  docker-up     - Start a specific Docker container (Keycloak, Kong, Kafka, or Postgres)" 
call :colorEcho %GREEN% "  docker-restart- Restart a specific Docker container (Keycloak, Kong, Kafka, or Postgres)"
call :colorEcho %GREEN% "  docker-down   - Stop a specific Docker container (Keycloak, Kong, Kafka, or Postgres)" 
call :colorEcho %GREEN% "  docker-log    - View logs for a specific Docker container (Keycloak, Kong, Kafka, or Postgres)" 
call :colorEcho %GREEN% "  clean         - Remove build files and clean environment" 
call :colorEcho %GREEN% "  help          - Display this help message" 
echo.
goto :eof

REM ------------------------------------------------------------------
:docker-start
REM Stop any running containers (to clear orphan containers), then start them up.
echo Starting Docker containers...
docker-compose down --remove-orphans
docker-compose up -d --build
goto :eof

REM ------------------------------------------------------------------
:run
REM Prompt the user to select an environment and run accordingly.
call :colorEcho %YELLOW% "Please select environment:" %RESET%
echo.
echo 1) Development
echo 2) Production
echo 3) Docker
set /p choice="Enter choice [1-3]: "

if "%choice%"=="1" (
  set "ENV=development"
  goto :run-direct
) else if "%choice%"=="2" (
  set "ENV=production"
  goto :run-direct
) else if "%choice%"=="3" (
  set "ENV=docker"
  goto :run-docker
) else (
  call :colorEcho %YELLOW% "Invalid choice. Defaulting to development." %RESET%
  echo.
  set "ENV=development"
  goto :run-direct
)

REM ------------------------------------------------------------------
:run-direct
REM Run the Go application using the current ENV variable.
call :colorEcho %GREEN% "Running application in %ENV% environment..." %RESET%
echo.
go run ./cmd/api/main.go
goto :eof

REM ------------------------------------------------------------------
:run-docker
REM Stop orphan containers then run the application via docker-compose.
call :colorEcho %GREEN% "Running application in Docker environment..." %RESET%
echo.
docker-compose down --remove-orphans
docker-compose up --build -d
goto :eof

REM ------------------------------------------------------------------
:docker-up
REM Let the user choose which Docker container to start.
echo Choose a Docker container to start:
echo 1) Keycloak
echo 2) Kong
echo 3) Kafka
echo 4) Postgres
set /p choice="Enter choice [1-4]: "
if "%choice%"=="1" (
  goto :keycloak
) else if "%choice%"=="2" (
  goto :kong
) else if "%choice%"=="3" (
  goto :kafka
) else if "%choice%"=="4" (
  goto :postgres
) else (
  call :colorEcho %YELLOW% "Invalid choice. Exiting docker-up." %RESET%
  goto :eof
)

REM ------------------------------------------------------------------
:docker-restart
REM Let the user choose which Docker container to restart.
echo Restarting Docker container:
echo 1) Keycloak
echo 2) Kong
echo 3) Kafka
echo 4) Postgres
set /p choice="Enter choice [1-4]: "
if "%choice%"=="1" (
  goto :keycloak-restart
) else if "%choice%"=="2" (
  goto :kong-restart
) else if "%choice%"=="3" (
  goto :kafka-restart
) else if "%choice%"=="4" (
  goto :postgres-restart
) else (
  call :colorEcho %YELLOW% "Invalid choice. Exiting docker-restart." %RESET%
  goto :eof
)

REM ------------------------------------------------------------------
:docker-down
REM Let the user choose which Docker container to stop.
echo Stopping Docker container:
echo 1) Keycloak
echo 2) Kong
echo 3) Kafka
echo 4) Postgres
set /p choice="Enter choice [1-4]: "
if "%choice%"=="1" (
  docker-compose -f docker-compose.keycloak.yml down
  REM Uncomment the line below to remove the Keycloak image if needed:
  REM docker rmi -f quay.io/keycloak/keycloak:26.1.3
  goto :eof
) else if "%choice%"=="2" (
  docker-compose -f docker-compose.kong.yml down
  goto :eof
) else if "%choice%"=="3" (
  docker-compose -f docker-compose.kafka.yml down
  goto :eof
) else if "%choice%"=="4" (
  docker-compose -f docker-compose.postgres.yml down
  goto :eof
) else (
  call :colorEcho %YELLOW% "Invalid choice. Exiting docker-down." %RESET%
  goto :eof
)

REM ------------------------------------------------------------------
:docker-log
REM Let the user choose which container's logs to view.
echo Choose a Docker container for logs:
echo 1) Keycloak
echo 2) Kong
echo 3) Kafka
echo 4) Postgres
set /p choice="Enter choice [1-4]: "
if "%choice%"=="1" (
  docker-compose -f docker-compose.keycloak.yml logs -f
  goto :eof
) else if "%choice%"=="2" (
  docker-compose -f docker-compose.kong.yml logs -f
  goto :eof
) else if "%choice%"=="3" (
  docker-compose -f docker-compose.kafka.yml logs -f
  goto :eof
) else if "%choice%"=="4" (
  docker-compose -f docker-compose.postgres.yml logs -f
  goto :eof
) else (
  call :colorEcho %YELLOW% "Invalid choice. Exiting docker-log." %RESET%
  goto :eof
)

REM ------------------------------------------------------------------
:postgres
REM Build and start the Postgres Docker container.
echo Starting Postgres container...
docker-compose -f docker-compose.postgres.yml down
docker-compose -f docker-compose.postgres.yml up --build -d
goto :eof

REM ------------------------------------------------------------------
:keycloak
REM Build and start the Keycloak Docker container.
echo Starting Keycloak container...
docker-compose -f docker-compose.keycloak.yml down
docker-compose -f docker-compose.keycloak.yml up --build -d
goto :eof

REM ------------------------------------------------------------------
:kong
REM Build and start the Kong Docker container.
echo Starting Kong container...
docker-compose -f docker-compose.kong.yml down
docker-compose -f docker-compose.kong.yml up --build -d
goto :eof

REM ------------------------------------------------------------------
:kafka
REM Build and start the Kafka Docker container.
echo Starting Kafka container...
docker-compose -f docker-compose.kafka.yml down
docker-compose -f docker-compose.kafka.yml up --build -d
goto :eof

REM ------------------------------------------------------------------
:build
REM Create the bin directory (if it doesn't exist) and build the Go binary.
echo Building application...
if not exist bin mkdir bin
go build -o bin/app main.go
goto :eof

REM ------------------------------------------------------------------
:clean
REM Remove the bin directory and invoke go clean.
echo Cleaning build files...
if exist bin rmdir /s /q bin
go clean
goto :eof

REM ------------------------------------------------------------------
:colorEcho
REM A helper function to output colored text.
REM Parameters:
REM   %1 - Color code for the first part of the text.
REM   %2 - The text to display with the first color.
REM   %3 - (Optional) Additional color code or text.
<nul set /p "dummy=%~1" >nul
echo %~2
<nul set /p "dummy=%~3" >nul
goto :eof

REM ------------------------------------------------------------------
:keycloak-restart
REM Restart the Keycloak Docker container.
docker-compose -f docker-compose.keycloak.yml down
docker-compose -f docker-compose.keycloak.yml up -d
goto :eof

REM ------------------------------------------------------------------
:kong-restart
REM Restart the Kong Docker container.
docker-compose -f docker-compose.kong.yml down
docker-compose -f docker-compose.kong.yml up -d
goto :eof

REM ------------------------------------------------------------------
:kafka-restart
REM Restart the Kafka Docker container.
docker-compose -f docker-compose.kafka.yml down
docker-compose -f docker-compose.kafka.yml up -d
goto :eof

REM ------------------------------------------------------------------
:postgres-restart
REM Restart the Postgres Docker container.
docker-compose -f docker-compose.postgres.yml down
docker-compose -f docker-compose.postgres.yml up -d
goto :eof
