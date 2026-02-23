@echo off
echo =========================================
echo Event Planner Backend - Java/Spring Boot
echo =========================================
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo X Java is not installed. Please install Java 17 or higher.
    exit /b 1
)

echo [OK] Java is installed
java -version

REM Check if Maven is installed
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo X Maven is not installed. Please install Maven 3.6 or higher.
    exit /b 1
)

echo [OK] Maven is installed
mvn -version | findstr "Apache Maven"
echo.

REM Check if .env file exists
if not exist ".env" (
    echo [WARNING] No .env file found. Using default configuration from application.properties
    echo           Copy .env.example to .env and update with your settings.
    echo.
)

echo Starting Spring Boot application...
echo.

REM Run the application
mvn spring-boot:run
