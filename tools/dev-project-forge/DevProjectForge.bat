@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV PROJECT FORGE
REM Project Scaffolding & Environment Initialization Tool
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV PROJECT FORGE
mode con cols=100 lines=42 >nul 2>&1

REM --- ANSI Terminal Colors
for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "C_RESET=!ESC![0m"
set "C_CYAN=!ESC![96m"
set "C_BLUE=!ESC![94m"
set "C_GREEN=!ESC![92m"
set "C_YELLOW=!ESC![93m"
set "C_RED=!ESC![91m"
set "C_MAGENTA=!ESC![95m"
set "C_WHITE=!ESC![97m"
set "C_GRAY=!ESC![90m"
set "C_BOLD=!ESC![1m"

set "APP_NAME=DEV Project Forge"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

REM Default workspace configuration
if not defined DEFAULT_PROJECTS_DIR (
    set "DEFAULT_PROJECTS_DIR=%USERPROFILE%\Projects"
)
set "LAST_CREATED_PATH="

goto :MAIN_MENU

REM ------------------------------------------------------------
REM HEADER
REM ------------------------------------------------------------
:HEADER
cls
echo.
echo !C_CYAN!  +==============================================================================+!C_RESET!
echo !C_CYAN!  ^|    ____  _______     __   ______            __        _____       _ __       ^|!C_RESET!
echo !C_CYAN!  ^|   / __ \/ ____/ ^|   / /  /_  __/___  ____  / /____   / ___/__  __(_) /____   ^|!C_RESET!
echo !C_CYAN!  ^|  / / / / __/  ^| ^|  / /    / / / __ \/ __ \/ / ___/   \__ \/ / / / / __/ _ \  ^|!C_RESET!
echo !C_CYAN!  ^| / /_/ / /___  ^| ^| / /    / / / /_/ / /_/ / (__  )   ___/ / /_/ / / /_/  __/  ^|!C_RESET!
echo !C_CYAN!  ^|/_____/_____/  ^|___/     /_/  \____/\____/_/____/   /____/\__,_/_/\__/\___/   ^|!C_RESET!
echo !C_CYAN!  +==============================================================================+!C_RESET!
echo   !C_CYAN!::!C_RESET! !C_WHITE!!C_BOLD!%APP_NAME%!C_RESET!          !C_GRAY![ Provider: !C_WHITE!AnoS!C_GRAY! :: Version: !C_GREEN!v%APP_VERSION%!C_GRAY! :: Platform: !C_CYAN!Windows!C_GRAY! ]!C_RESET!
echo !C_CYAN!  --------------------------------------------------------------------------------!C_RESET!
echo.
exit /b

REM ------------------------------------------------------------
REM MAIN MENU
REM ------------------------------------------------------------
:MAIN_MENU
cls
call :HEADER

echo  !C_WHITE!WORKSPACE OVERVIEW!C_RESET!
echo  Default Directory: !C_CYAN!%DEFAULT_PROJECTS_DIR%!C_RESET!
if defined LAST_CREATED_PATH (
    echo  Last Active Project: !C_GREEN!%LAST_CREATED_PATH%!C_RESET!
)
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET! Create Project               !C_CYAN![6]!C_RESET! Create Virtual Environment
echo    !C_CYAN![2]!C_RESET! Project Templates            !C_CYAN![7]!C_RESET! Open Project
echo    !C_CYAN![3]!C_RESET! Initialize Git               !C_CYAN![8]!C_RESET! Project Information
echo    !C_CYAN![4]!C_RESET! Create README                !C_CYAN![9]!C_RESET! Settings
echo    !C_CYAN![5]!C_RESET! Create .gitignore            !C_RED![0]!C_RESET! Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-9]: "
if "!CHOICE!"=="1" goto :CREATE_PROJECT
if "!CHOICE!"=="2" goto :VIEW_TEMPLATES
if "!CHOICE!"=="3" goto :INIT_GIT_MENU
if "!CHOICE!"=="4" goto :CREATE_README_MENU
if "!CHOICE!"=="5" goto :CREATE_GITIGNORE_MENU
if "!CHOICE!"=="6" goto :CREATE_VENV_MENU
if "!CHOICE!"=="7" goto :OPEN_PROJECT_MENU
if "!CHOICE!"=="8" goto :PROJECT_INFO_MENU
if "!CHOICE!"=="9" goto :SETTINGS_MENU
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 9.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] CREATE PROJECT
REM ------------------------------------------------------------
:CREATE_PROJECT
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CREATE NEW PROJECT!C_RESET!
echo  ----------------------------------------------------------------------
echo.
echo  Choose a project template:
echo    !C_CYAN![1]!C_RESET! Python (Standard Console)
echo    !C_CYAN![2]!C_RESET! Python FastAPI (Modern REST API)
echo    !C_CYAN![3]!C_RESET! Python Flask (Web Application)
echo    !C_CYAN![4]!C_RESET! Node.js (Standard ESM/CommonJS)
echo    !C_CYAN![5]!C_RESET! Node.js Express (REST API)
echo    !C_CYAN![6]!C_RESET! React (Vite + React JSX)
echo    !C_CYAN![7]!C_RESET! Vite (Modern Frontend Tooling)
echo    !C_CYAN![8]!C_RESET! C++ (Native Executable)
echo    !C_CYAN![9]!C_RESET! CMake C++ (Cross-Platform)
echo    !C_CYAN![10]!C_RESET! Java (Standard Application)
echo    !C_CYAN![11]!C_RESET! Java Maven (Standard Architecture)
echo    !C_CYAN![12]!C_RESET! Java Gradle (Modern Build)
echo    !C_CYAN![13]!C_RESET! Static HTML/CSS/JavaScript
echo    !C_CYAN![14]!C_RESET! Generic Git Project
echo    !C_RED![0]!C_RESET! Cancel
echo.

set "TPL="
set /p "TPL=Select template [0-14]: "
if "!TPL!"=="0" goto :MAIN_MENU
if "!TPL!"=="" goto :MAIN_MENU

set "TPL_NAME="
if "!TPL!"=="1"  set "TPL_NAME=Python"
if "!TPL!"=="2"  set "TPL_NAME=Python FastAPI"
if "!TPL!"=="3"  set "TPL_NAME=Python Flask"
if "!TPL!"=="4"  set "TPL_NAME=Node.js"
if "!TPL!"=="5"  set "TPL_NAME=Node.js Express"
if "!TPL!"=="6"  set "TPL_NAME=React"
if "!TPL!"=="7"  set "TPL_NAME=Vite"
if "!TPL!"=="8"  set "TPL_NAME=C++"
if "!TPL!"=="9"  set "TPL_NAME=CMake C++"
if "!TPL!"=="10" set "TPL_NAME=Java"
if "!TPL!"=="11" set "TPL_NAME=Java Maven"
if "!TPL!"=="12" set "TPL_NAME=Java Gradle"
if "!TPL!"=="13" set "TPL_NAME=Static Web"
if "!TPL!"=="14" set "TPL_NAME=Generic Git"

if not defined TPL_NAME (
    echo !C_RED!Invalid template selection.!C_RESET!
    timeout /t 2 /nobreak >nul 2>&1
    goto :CREATE_PROJECT
)

:PROMPT_NAME
echo.
set "PROJ_NAME="
set /p "PROJ_NAME=Enter project name: "
if not defined PROJ_NAME (
    echo !C_RED!Project name cannot be empty.!C_RESET!
    goto :PROMPT_NAME
)

REM Validate invalid Windows filename characters: < > : " / \ | ? *
for %%C in ("<" ">" ":" "/" "\" "|" "?" "*") do (
    set "CHECK_CHAR=%%~C"
    echo !PROJ_NAME! | findstr /C:"!CHECK_CHAR!" >nul 2>&1
    if not errorlevel 1 (
        echo !C_RED!Invalid characters detected. Do not use: ^< ^> : " / \ ^| ? *!C_RESET!
        goto :PROMPT_NAME
    )
)

:PROMPT_FOLDER
echo.
echo  Target parent directory [Press Enter for default: %DEFAULT_PROJECTS_DIR%]:
set "TARGET_PARENT="
set /p "TARGET_PARENT=Directory: "
if not defined TARGET_PARENT set "TARGET_PARENT=%DEFAULT_PROJECTS_DIR%"

set "TARGET_PARENT=%TARGET_PARENT:"=%"
set "FULL_PATH=%TARGET_PARENT%\%PROJ_NAME%"

REM Check if target already exists
if exist "%FULL_PATH%" (
    echo.
    echo !C_YELLOW![WARN] Destination folder already exists:!C_RESET!
    echo %FULL_PATH%
    set "OVERWRITE="
    set /p "OVERWRITE=Continue and write inside existing folder? [Y/N]: "
    if /I not "!OVERWRITE!"=="Y" (
        echo !C_CYAN!Project creation cancelled.!C_RESET!
        pause
        goto :MAIN_MENU
    )
) else (
    md "%FULL_PATH%" >nul 2>&1
    if errorlevel 1 (
        echo !C_RED![ERROR] Could not create directory: %FULL_PATH%!C_RESET!
        pause
        goto :MAIN_MENU
    )
)

set "LAST_CREATED_PATH=%FULL_PATH%"

echo.
echo  Creating !TPL_NAME! project in:
echo  !C_CYAN!%FULL_PATH%!C_RESET!
echo.

call :GENERATE_TEMPLATE "!TPL!" "%FULL_PATH%" "%PROJ_NAME%"

echo.
echo  !C_GREEN![OK] Project successfully forged: %PROJ_NAME%!C_RESET!
echo.
set "ASK_GIT="
set /p "ASK_GIT=Initialize Git repository now? [Y/N]: "
if /I "!ASK_GIT!"=="Y" (
    call :INIT_GIT_DIR "%FULL_PATH%"
)

set "ASK_OPEN="
set /p "ASK_OPEN=Open project in Visual Studio Code? [Y/N]: "
if /I "!ASK_OPEN!"=="Y" (
    where code >nul 2>&1
    if not errorlevel 1 (
        code "%FULL_PATH%"
    ) else (
        echo [INFO] VS Code (code) command not found in PATH. Opening Explorer...
        explorer "%FULL_PATH%"
    )
)

pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM TEMPLATE CODE GENERATOR
REM ------------------------------------------------------------
:GENERATE_TEMPLATE
set "T_ID=%~1"
set "T_DIR=%~2"
set "T_NAME=%~3"

if not exist "%T_DIR%" md "%T_DIR%" >nul 2>&1

REM 1. Standard Python
if "%T_ID%"=="1" (
    md "%T_DIR%\src" >nul 2>&1
    md "%T_DIR%\tests" >nul 2>&1
    > "%T_DIR%\src\main.py" (
        echo def main^(^):
        echo     print^("Hello from %T_NAME%!"^)
        echo.
        echo if __name__ == "__main__":
        echo     main^(^)
    )
    > "%T_DIR%\tests\test_main.py" (
        echo def test_placeholder^(^):
        echo     assert True
    )
    > "%T_DIR%\requirements.txt" (
        echo # Dependencies for %T_NAME%
        echo pytest^>=8.0.0
    )
    call :WRITE_GITIGNORE_PYTHON "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Standard Python application with src/ layout."
)

REM 2. Python FastAPI
if "%T_ID%"=="2" (
    md "%T_DIR%\app" >nul 2>&1
    md "%T_DIR%\app\routers" >nul 2>&1
    > "%T_DIR%\app\main.py" (
        echo from fastapi import FastAPI
        echo.
        echo app = FastAPI^(title="%T_NAME%", version="1.0.0"^)
        echo.
        echo @app.get^("/"^)
        echo def read_root^(^):
        echo     return {"status": "online", "app": "%T_NAME%"}
        echo.
        echo @app.get^("/health"^)
        echo def health_check^(^):
        echo     return {"status": "ok"}
    )
    > "%T_DIR%\requirements.txt" (
        echo fastapi^>=0.110.0
        echo uvicorn[standard]^>=0.28.0
        echo pydantic^>=2.6.0
    )
    call :WRITE_GITIGNORE_PYTHON "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "FastAPI modern asynchronous REST API service."
)

REM 3. Python Flask
if "%T_ID%"=="3" (
    md "%T_DIR%\templates" >nul 2>&1
    md "%T_DIR%\static" >nul 2>&1
    > "%T_DIR%\app.py" (
        echo from flask import Flask, render_template, jsonify
        echo.
        echo app = Flask^(__name__^)
        echo.
        echo @app.route^("/"^)
        echo def index^(^):
        echo     return jsonify^({"message": "Welcome to %T_NAME%!"}^)
        echo.
        echo if __name__ == "__main__":
        echo     app.run^(debug=True, port=5000^)
    )
    > "%T_DIR%\requirements.txt" (
        echo flask^>=3.0.0
    )
    call :WRITE_GITIGNORE_PYTHON "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Flask web application backend."
)

REM 4. Node.js Standard
if "%T_ID%"=="4" (
    md "%T_DIR%\src" >nul 2>&1
    > "%T_DIR%\package.json" (
        echo {
        echo   "name": "%T_NAME%",
        echo   "version": "1.0.0",
        echo   "description": "Node.js application forged with DEV",
        echo   "main": "src/index.js",
        echo   "type": "module",
        echo   "scripts": {
        echo     "start": "node src/index.js",
        echo     "dev": "node --watch src/index.js"
        echo   },
        echo   "keywords": [],
        echo   "author": "AnoS",
        echo   "license": "MIT"
        echo }
    )
    > "%T_DIR%\src\index.js" (
        echo console.log^("Welcome to %T_NAME%!"^);
    )
    call :WRITE_GITIGNORE_NODE "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Node.js application scaffolding."
)

REM 5. Node.js Express
if "%T_ID%"=="5" (
    md "%T_DIR%\src" >nul 2>&1
    md "%T_DIR%\src\routes" >nul 2>&1
    > "%T_DIR%\package.json" (
        echo {
        echo   "name": "%T_NAME%",
        echo   "version": "1.0.0",
        echo   "description": "Express API server forged with DEV",
        echo   "main": "src/server.js",
        echo   "type": "module",
        echo   "scripts": {
        echo     "start": "node src/server.js",
        echo     "dev": "node --watch src/server.js"
        echo   },
        echo   "dependencies": {
        echo     "express": "^^4.19.2",
        echo     "cors": "^^2.8.5"
        echo   }
        echo }
    )
    > "%T_DIR%\src\server.js" (
        echo import express from 'express';
        echo import cors from 'cors';
        echo.
        echo const app = express^(^);
        echo const PORT = process.env.PORT ^|^| 3000;
        echo.
        echo app.use^(cors^(^)^);
        echo app.use^(express.json^(^)^);
        echo.
        echo app.get^('/', ^(req, res^) =^> {
        echo   res.json^({ status: 'online', service: '%T_NAME%' }^);
        echo }^);
        echo.
        echo app.listen^(PORT, ^(^)=^> {
        echo   console.log^(`Server running at http://localhost:${PORT}`^);
        echo }^);
    )
    call :WRITE_GITIGNORE_NODE "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Express.js RESTful API service."
)

REM 6. React (Vite Template)
if "%T_ID%"=="6" (
    md "%T_DIR%\src" >nul 2>&1
    md "%T_DIR%\public" >nul 2>&1
    > "%T_DIR%\package.json" (
        echo {
        echo   "name": "%T_NAME%",
        echo   "private": true,
        echo   "version": "0.1.0",
        echo   "type": "module",
        echo   "scripts": {
        echo     "dev": "vite",
        echo     "build": "vite build",
        echo     "preview": "vite preview"
        echo   },
        echo   "dependencies": {
        echo     "react": "^^18.2.0",
        echo     "react-dom": "^^18.2.0"
        echo   },
        echo   "devDependencies": {
        echo     "@vitejs/plugin-react": "^^4.2.1",
        echo     "vite": "^^5.2.0"
        echo   }
        echo }
    )
    > "%T_DIR%\index.html" (
        echo ^<!DOCTYPE html^>
        echo ^<html lang="en"^>
        echo   ^<head^>
        echo     ^<meta charset="UTF-8" /^>
        echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0" /^>
        echo     ^<title^>%T_NAME%^</title^>
        echo   ^</head^>
        echo   ^<body^>
        echo     ^<div id="root"^>^</div^>
        echo     ^<script type="module" src="/src/main.jsx"^>^</script^>
        echo   ^</body^>
        echo ^</html^>
    )
    > "%T_DIR%\src\main.jsx" (
        echo import React from 'react';
        echo import ReactDOM from 'react-dom/client';
        echo import App from './App.jsx';
        echo.
        echo ReactDOM.createRoot^(document.getElementById^('root'^)^).render^(
        echo   ^<React.StrictMode^>
        echo     ^<App /^>
        echo   ^</React.StrictMode^>
        echo ^);
    )
    > "%T_DIR%\src\App.jsx" (
        echo export default function App^(^) {
        echo   return ^(
        echo     ^<main style={{ padding: '2rem', fontFamily: 'sans-serif' }}^>
        echo       ^<h1^>%T_NAME%^</h1^>
        echo       ^<p^>Forged with DEV Tools Suite^</p^>
        echo     ^</main^>
        echo   ^);
        echo }
    )
    call :WRITE_GITIGNORE_NODE "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "React frontend application powered by Vite."
)

REM 7. Vite Vanilla
if "%T_ID%"=="7" (
    md "%T_DIR%\src" >nul 2>&1
    > "%T_DIR%\package.json" (
        echo {
        echo   "name": "%T_NAME%",
        echo   "private": true,
        echo   "version": "0.1.0",
        echo   "type": "module",
        echo   "scripts": {
        echo     "dev": "vite",
        echo     "build": "vite build",
        echo     "preview": "vite preview"
        echo   },
        echo   "devDependencies": {
        echo     "vite": "^^5.2.0"
        echo   }
        echo }
    )
    > "%T_DIR%\index.html" (
        echo ^<!DOCTYPE html^>
        echo ^<html lang="en"^>
        echo   ^<head^>
        echo     ^<meta charset="UTF-8" /^>
        echo     ^<title^>%T_NAME%^</title^>
        echo   ^</head^>
        echo   ^<body^>
        echo     ^<div id="app"^>^</div^>
        echo     ^<script type="module" src="/src/main.js"^>^</script^>
        echo   ^</body^>
        echo ^</html^>
    )
    > "%T_DIR%\src\main.js" (
        echo document.querySelector^('#app'^).innerHTML = `^<h1^>%T_NAME%^</h1^>^<p^>Vite Application^</p^>`;
    )
    call :WRITE_GITIGNORE_NODE "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Vanilla Vite web application."
)

REM 8. C++
if "%T_ID%"=="8" (
    md "%T_DIR%\src" >nul 2>&1
    md "%T_DIR%\include" >nul 2>&1
    > "%T_DIR%\src\main.cpp" (
        echo #include ^<iostream^>
        echo.
        echo int main^(^) {
        echo     std::cout ^<^< "Hello from %T_NAME%!" ^<^< std::endl;
        echo     return 0;
        echo }
    )
    > "%T_DIR%\build.bat" (
        echo @echo off
        echo if not exist bin md bin
        echo cl /EHsc /Fe:bin\%T_NAME%.exe src\main.cpp
    )
    call :WRITE_GITIGNORE_CPP "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Standard C++ native project."
)

REM 9. CMake C++
if "%T_ID%"=="9" (
    md "%T_DIR%\src" >nul 2>&1
    md "%T_DIR%\include" >nul 2>&1
    > "%T_DIR%\CMakeLists.txt" (
        echo cmake_minimum_required^(VERSION 3.20^)
        echo project^(%T_NAME% VERSION 1.0.0 LANGUAGES CXX^)
        echo.
        echo set^(CMAKE_CXX_STANDARD 20^)
        echo set^(CMAKE_CXX_STANDARD_REQUIRED ON^)
        echo.
        echo add_executable^(%T_NAME% src/main.cpp^)
        echo target_include_directories^(%T_NAME% PRIVATE include^)
    )
    > "%T_DIR%\src\main.cpp" (
        echo #include ^<iostream^>
        echo.
        echo int main^(^) {
        echo     std::cout ^<^< "Hello from CMake C++: %T_NAME%" ^<^< std::endl;
        echo     return 0;
        echo }
    )
    call :WRITE_GITIGNORE_CPP "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Cross-platform C++ project configured with CMake."
)

REM 10. Java
if "%T_ID%"=="10" (
    md "%T_DIR%\src\com\dev" >nul 2>&1
    > "%T_DIR%\src\com\dev\Main.java" (
        echo package com.dev;
        echo.
        echo public class Main {
        echo     public static void main^(String[] args^) {
        echo         System.out.println^("Hello from %T_NAME%!"^);
        echo     }
        echo }
    )
    > "%T_DIR%\run.bat" (
        echo @echo off
        echo javac -d bin src\com\dev\Main.java
        echo java -cp bin com.dev.Main
    )
    call :WRITE_GITIGNORE_JAVA "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Native Java application."
)

REM 11. Java Maven
if "%T_ID%"=="11" (
    md "%T_DIR%\src\main\java\com\dev" >nul 2>&1
    md "%T_DIR%\src\test\java\com\dev" >nul 2>&1
    > "%T_DIR%\pom.xml" (
        echo ^<project xmlns="http://maven.apache.org/POM/4.0.0"^>
        echo   ^<modelVersion^>4.0.0^</modelVersion^>
        echo   ^<groupId^>com.dev^</groupId^>
        echo   ^<artifactId^>%T_NAME%^</artifactId^>
        echo   ^<version^>1.0.0-SNAPSHOT^</version^>
        echo   ^<properties^>
        echo     ^<maven.compiler.source^>21^</maven.compiler.source^>
        echo     ^<maven.compiler.target^>21^</maven.compiler.target^>
        echo   ^</properties^>
        echo ^</project^>
    )
    > "%T_DIR%\src\main\java\com\dev\App.java" (
        echo package com.dev;
        echo.
        echo public class App {
        echo     public static void main^(String[] args^) {
        echo         System.out.println^("Hello Maven: %T_NAME%"^);
        echo     }
        echo }
    )
    call :WRITE_GITIGNORE_JAVA "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Standard Java Maven structured project."
)

REM 12. Java Gradle
if "%T_ID%"=="12" (
    md "%T_DIR%\src\main\java\com\dev" >nul 2>&1
    > "%T_DIR%\build.gradle" (
        echo plugins {
        echo     id 'application'
        echo }
        echo.
        echo java {
        echo     toolchain {
        echo         languageVersion = JavaLanguageVersion.of^(21^)
        echo     }
        echo }
        echo.
        echo application {
        echo     mainClass = 'com.dev.App'
        echo }
    )
    > "%T_DIR%\settings.gradle" (
        echo rootProject.name = '%T_NAME%'
    )
    > "%T_DIR%\src\main\java\com\dev\App.java" (
        echo package com.dev;
        echo.
        echo public class App {
        echo     public static void main^(String[] args^) {
        echo         System.out.println^("Hello Gradle: %T_NAME%"^);
        echo     }
        echo }
    )
    call :WRITE_GITIGNORE_JAVA "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Java Gradle application."
)

REM 13. Static HTML/CSS/JS
if "%T_ID%"=="13" (
    md "%T_DIR%\css" >nul 2>&1
    md "%T_DIR%\js" >nul 2>&1
    md "%T_DIR%\assets" >nul 2>&1
    > "%T_DIR%\index.html" (
        echo ^<!DOCTYPE html^>
        echo ^<html lang="en"^>
        echo ^<head^>
        echo   ^<meta charset="UTF-8"^>
        echo   ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
        echo   ^<title^>%T_NAME%^</title^>
        echo   ^<link rel="stylesheet" href="css/style.css"^>
        echo ^</head^>
        echo ^<body^>
        echo   ^<main^>
        echo     ^<h1^>%T_NAME%^</h1^>
        echo     ^<p^>Created with DEV Project Forge^</p^>
        echo   ^</main^>
        echo   ^<script src="js/app.js"^>^</script^>
        echo ^</body^>
        echo ^</html^>
    )
    > "%T_DIR%\css\style.css" (
        echo * { box-sizing: border-box; margin: 0; padding: 0; }
        echo body { font-family: system-ui, sans-serif; background: #0f172a; color: #f8fafc; padding: 2rem; }
        echo h1 { color: #38bdf8; margin-bottom: 0.5rem; }
    )
    > "%T_DIR%\js\app.js" (
        echo console.log^('%T_NAME% loaded successfully.'^);
    )
    call :WRITE_GITIGNORE_UNIVERSAL "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Clean static HTML5, CSS3, and JavaScript project."
)

REM 14. Generic Git Project
if "%T_ID%"=="14" (
    md "%T_DIR%\src" >nul 2>&1
    md "%T_DIR%\docs" >nul 2>&1
    call :WRITE_GITIGNORE_UNIVERSAL "%T_DIR%"
    call :WRITE_README "%T_DIR%" "%T_NAME%" "Generic developer repository."
)

exit /b

REM ------------------------------------------------------------
REM HELPER WRITERS
REM ------------------------------------------------------------
:WRITE_README
set "R_DIR=%~1"
set "R_NAME=%~2"
set "R_DESC=%~3"
> "%R_DIR%\README.md" (
    echo # %R_NAME%
    echo.
    echo %R_DESC%
    echo.
    echo ## Overview
    echo Initialized with **DEV Project Forge** (Provider: AnoS^).
    echo.
    echo ## Quick Start
    echo Follow standard workflows for this project type.
    echo.
    echo ## License
    echo MIT License
)
exit /b

:WRITE_GITIGNORE_PYTHON
set "G_DIR=%~1"
> "%G_DIR%\.gitignore" (
    echo __pycache__/
    echo *.py[cod]
    echo *$py.class
    echo .venv/
    echo venv/
    echo env/
    echo .pytest_cache/
    echo .coverage
    echo .env
    echo .vscode/
    echo .idea/
)
exit /b

:WRITE_GITIGNORE_NODE
set "G_DIR=%~1"
> "%G_DIR%\.gitignore" (
    echo node_modules/
    echo npm-debug.log*
    echo yarn-debug.log*
    echo yarn-error.log*
    echo dist/
    echo build/
    echo .env
    echo .env.local
    echo .vscode/
    echo .idea/
)
exit /b

:WRITE_GITIGNORE_CPP
set "G_DIR=%~1"
> "%G_DIR%\.gitignore" (
    echo bin/
    echo obj/
    echo build/
    echo *.obj
    echo *.o
    echo *.exe
    echo *.dll
    echo *.pdb
    echo .vscode/
    echo .vs/
)
exit /b

:WRITE_GITIGNORE_JAVA
set "G_DIR=%~1"
> "%G_DIR%\.gitignore" (
    echo *.class
    echo *.jar
    echo *.war
    echo target/
    echo build/
    echo .gradle/
    echo bin/
    echo .vscode/
    echo .idea/
    echo *.iml
)
exit /b

:WRITE_GITIGNORE_UNIVERSAL
set "G_DIR=%~1"
> "%G_DIR%\.gitignore" (
    echo .DS_Store
    echo Thumbs.db
    echo .vscode/
    echo .idea/
    echo *.log
    echo .env
    echo .env.local
)
exit /b

REM ------------------------------------------------------------
REM [2] PROJECT TEMPLATES
REM ------------------------------------------------------------
:VIEW_TEMPLATES
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SUPPORTED PROJECT TEMPLATES (14)!C_RESET!
echo  ----------------------------------------------------------------------
echo  1. Python Standard     : src/ layout, virtualenv ready, pytest
echo  2. Python FastAPI      : Asynchronous API, OpenAPI documentation, uvicorn
echo  3. Python Flask        : Lightweight web framework, templates, routes
echo  4. Node.js Standard    : ESM modules, package.json, watch runner
echo  5. Node.js Express     : REST API service, JSON middleware, CORS
echo  6. React (Vite)        : React 18, Vite bundler, JSX structure
echo  7. Vite Vanilla        : Lightning fast vanilla frontend tooling
echo  8. C++ Native          : MSVC / GCC ready, build automation script
echo  9. CMake C++           : Cross-platform CMake 3.20+ build definitions
echo  10. Java Application   : Modern Java 21 console application
echo  11. Java Maven         : Enterprise pom.xml with standard directories
echo  12. Java Gradle        : Gradle application plugin structure
echo  13. Static Web         : Pure HTML5, modern CSS3, vanilla JavaScript
echo  14. Generic Git        : Universal gitignore, README, docs directory
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] INITIALIZE GIT
REM ------------------------------------------------------------
:INIT_GIT_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!INITIALIZE GIT REPOSITORY!C_RESET!
echo  ----------------------------------------------------------------------
set "TARGET_DIR="
echo  Target directory [Press Enter for last project: !LAST_CREATED_PATH!]:
set /p "TARGET_DIR=Path: "
if not defined TARGET_DIR set "TARGET_DIR=!LAST_CREATED_PATH!"
if not defined TARGET_DIR set "TARGET_DIR=%CD%"

call :INIT_GIT_DIR "%TARGET_DIR%"
pause
goto :MAIN_MENU

:INIT_GIT_DIR
set "GDIR=%~1"
where git >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Git CLI is not found in PATH.!C_RESET!
    exit /b
)
if not exist "%GDIR%" (
    echo !C_RED![FAIL] Directory does not exist: %GDIR%!C_RESET!
    exit /b
)
cd /d "%GDIR%"
if exist ".git" (
    echo !C_YELLOW![INFO] Git repository is already initialized in: %GDIR%!C_RESET!
    exit /b
)
git init >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Git init encountered an error.!C_RESET!
) else (
    echo !C_GREEN![OK] Git repository initialized in: %GDIR%!C_RESET!
)
exit /b

REM ------------------------------------------------------------
REM [4] CREATE README
REM ------------------------------------------------------------
:CREATE_README_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CREATE README.md!C_RESET!
echo  ----------------------------------------------------------------------
set "R_DIR="
set /p "R_DIR=Target folder [Enter for current: %CD%]: "
if not defined R_DIR set "R_DIR=%CD%"

set "R_TITLE="
set /p "R_TITLE=Project Title: "
if not defined R_TITLE set "R_TITLE=My Project"

set "R_SUMMARY="
set /p "R_SUMMARY=Brief Description: "
if not defined R_SUMMARY set "R_SUMMARY=Created with DEV Tools Suite."

call :WRITE_README "%R_DIR%" "%R_TITLE%" "%R_SUMMARY%"
echo.
echo !C_GREEN![OK] README.md created at: %R_DIR%\README.md!C_RESET!
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] CREATE .GITIGNORE
REM ------------------------------------------------------------
:CREATE_GITIGNORE_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CREATE .GITIGNORE!C_RESET!
echo  ----------------------------------------------------------------------
echo    !C_CYAN![1]!C_RESET! Python
echo    !C_CYAN![2]!C_RESET! Node.js
echo    !C_CYAN![3]!C_RESET! C / C++
echo    !C_CYAN![4]!C_RESET! Java
echo    !C_CYAN![5]!C_RESET! Universal / General
echo.
set "GI_OPT="
set /p "GI_OPT=Select type [1-5]: "

set "GI_DIR="
set /p "GI_DIR=Target folder [Enter for current: %CD%]: "
if not defined GI_DIR set "GI_DIR=%CD%"

if "%GI_OPT%"=="1" call :WRITE_GITIGNORE_PYTHON "%GI_DIR%"
if "%GI_OPT%"=="2" call :WRITE_GITIGNORE_NODE "%GI_DIR%"
if "%GI_OPT%"=="3" call :WRITE_GITIGNORE_CPP "%GI_DIR%"
if "%GI_OPT%"=="4" call :WRITE_GITIGNORE_JAVA "%GI_DIR%"
if "%GI_OPT%"=="5" call :WRITE_GITIGNORE_UNIVERSAL "%GI_DIR%"

echo.
echo !C_GREEN![OK] .gitignore created in: %GI_DIR%!C_RESET!
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] CREATE VIRTUAL ENVIRONMENT
REM ------------------------------------------------------------
:CREATE_VENV_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CREATE PYTHON VIRTUAL ENVIRONMENT (.venv)!C_RESET!
echo  ----------------------------------------------------------------------
where python >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Python is not installed or not in PATH.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "VENV_DIR="
set /p "VENV_DIR=Project folder [Enter for current: %CD%]: "
if not defined VENV_DIR set "VENV_DIR=%CD%"

if not exist "%VENV_DIR%" (
    echo !C_RED![FAIL] Directory does not exist.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo.
echo  Creating virtual environment at: %VENV_DIR%\.venv ...
cd /d "%VENV_DIR%"
python -m venv .venv
if errorlevel 1 (
    echo !C_RED![FAIL] Could not create virtual environment.!C_RESET!
) else (
    echo !C_GREEN![OK] Virtual environment created successfully.!C_RESET!
    echo To activate: !C_CYAN!%VENV_DIR%\.venv\Scripts\activate!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] OPEN PROJECT
REM ------------------------------------------------------------
:OPEN_PROJECT_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!OPEN PROJECT!C_RESET!
echo  ----------------------------------------------------------------------
set "OP_DIR="
set /p "OP_DIR=Project folder [Enter for last: !LAST_CREATED_PATH!]: "
if not defined OP_DIR set "OP_DIR=!LAST_CREATED_PATH!"
if not defined OP_DIR set "OP_DIR=%CD%"

echo.
echo    !C_CYAN![1]!C_RESET! Visual Studio Code
echo    !C_CYAN![2]!C_RESET! Windows File Explorer
echo    !C_CYAN![3]!C_RESET! Windows Terminal (New tab)
echo.
set "HOW_OPEN="
set /p "HOW_OPEN=Choose application [1-3]: "

if "%HOW_OPEN%"=="1" (
    code "%OP_DIR%" >nul 2>&1
    if errorlevel 1 explorer "%OP_DIR%"
)
if "%HOW_OPEN%"=="2" explorer "%OP_DIR%"
if "%HOW_OPEN%"=="3" (
    where wt >nul 2>&1
    if not errorlevel 1 (
        start wt -d "%OP_DIR%"
    ) else (
        start cmd /k "cd /d %OP_DIR%"
    )
)
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [8] PROJECT INFORMATION
REM ------------------------------------------------------------
:PROJECT_INFO_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PROJECT INFORMATION & DIAGNOSTICS!C_RESET!
echo  ----------------------------------------------------------------------
set "INFO_DIR="
set /p "INFO_DIR=Target project folder [Enter for current: %CD%]: "
if not defined INFO_DIR set "INFO_DIR=%CD%"

if not exist "%INFO_DIR%" (
    echo !C_RED![FAIL] Folder does not exist: %INFO_DIR%!C_RESET!
    pause
    goto :MAIN_MENU
)

echo.
echo  Location   : !C_CYAN!%INFO_DIR%!C_RESET!
if exist "%INFO_DIR%\.git" (
    echo  Git Status : !C_GREEN!Git Repository Detected!C_RESET!
) else (
    echo  Git Status : !C_YELLOW!Not a Git repository!C_RESET!
)

if exist "%INFO_DIR%\package.json" echo  Framework  : Node.js / JavaScript project
if exist "%INFO_DIR%\requirements.txt" echo  Framework  : Python project
if exist "%INFO_DIR%\CMakeLists.txt" echo  Framework  : CMake C++ project
if exist "%INFO_DIR%\pom.xml" echo  Framework  : Java Maven project
if exist "%INFO_DIR%\build.gradle" echo  Framework  : Java Gradle project

echo.
echo  Directory Statistics:
powershell -NoProfile -Command "$f=Get-ChildItem -LiteralPath '%INFO_DIR%' -Recurse -File -ErrorAction SilentlyContinue; $s=($f | Measure-Object -Property Length -Sum).Sum/1MB; Write-Host ('  Total Files: ' + $f.Count); Write-Host ('  Size on Disk: {0:N2} MB' -f $s)" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [9] SETTINGS
REM ------------------------------------------------------------
:SETTINGS_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DEV PROJECT FORGE SETTINGS!C_RESET!
echo  ----------------------------------------------------------------------
echo  Current Default Projects Directory:
echo  !C_CYAN!%DEFAULT_PROJECTS_DIR%!C_RESET!
echo.
set "NEW_DIR="
set /p "NEW_DIR=Enter new default path [Press Enter to keep current]: "
if defined NEW_DIR (
    set "DEFAULT_PROJECTS_DIR=%NEW_DIR:"=%"
    echo !C_GREEN![OK] Default projects folder updated.!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [0] EXIT
REM ------------------------------------------------------------
:EXIT
cls
call :HEADER
echo  !C_GREEN!Thank you for using DEV.!C_RESET!
echo  !C_GRAY!Provider: AnoS ^| Developer Tools Suite!C_RESET!
echo.
echo  Press any key to close...
pause >nul
endlocal
exit /b 0
