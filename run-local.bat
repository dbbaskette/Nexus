@echo off
REM Run Nexus Gateway locally with the 'local' profile

echo Starting Nexus MCP Gateway (local profile)
echo.

REM Check if mvn is available
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Maven not found. Please install Maven first.
    exit /b 1
)

REM Run with local profile
mvn spring-boot:run -Dspring-boot.run.profiles=local
