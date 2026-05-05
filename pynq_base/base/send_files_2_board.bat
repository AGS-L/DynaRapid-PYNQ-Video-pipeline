@REM #######################################################################################################################
@REM # Copyright (C) HES-SO University of Applied Sciences and Arts Western Switzerland
@REM # Engineering and Architecture Department
@REM # AGSL - Adaptive Heterogeneous Systems Lab
@REM # Created by John Biselx (john.biselx@hevs.ch)
@REM # All rights reserved.
@REM # See LICENSE file for full license information.
@REM #######################################################################################################################

@setlocal enabledelayedexpansion
@echo off

@REM Create the Escape character
for /F "tokens=1 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do (
    set "ESC=%%a"
)

set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RESET=%ESC%[0m"

set "FILTER_NAME=%~1"

@REM Make sure the current working directory is where the script is located
for %%I in ("%~dp0.") do (
    set "SCRIPT_DIR=%%~fI"
)

cd /d "%SCRIPT_DIR%"

set "FOLDER_NAME=%SCRIPT_DIR%\filters\%FILTER_NAME%"

@REM Check if the folder exists
if not exist "%FOLDER_NAME%\" (
    echo %RED%[ERROR] Folder "%FOLDER_NAME%\" not found%RESET%
    if /I %0 equ "%~f0" pause
    exit /b 1
)

@REM Create temp folder, as to avoid sending dcp
set "TEMP_FOLDER=%SCRIPT_DIR%\filters\tmp\%FILTER_NAME%"

mkdir "%TEMP_FOLDER%"

@REM Check if all files exist
set "FILES=base.bit base.dtbo base.hwh base.py __init__.py"

for %%F in (%FILES%) do (
    if not exist "%FOLDER_NAME%\%%F" (
        echo %RED%[ERROR] Source file "%FOLDER_NAME%\%%F" not found%RESET%
        rd /S /Q "%TEMP_FOLDER%"
        if /I %0 equ "%~f0" pause
        exit /b 1
    ) else (
        copy /y "%FOLDER_NAME%\%%F" "%TEMP_FOLDER%\%%F" > NUL
    )
)

@REM Pynq remote path
set "REMOTE_PATH=xilinx@192.168.3.1:/home/xilinx"

@REM Send files to board
scp -r "%TEMP_FOLDER%" "%REMOTE_PATH%/pynq/overlays"

if %errorlevel% neq 0 (
    echo %RED%[ERROR] Failed to send files to the board%RESET%
    rd /S /Q "%TEMP_FOLDER%"
    if /I %0 equ "%~f0" pause
    exit /b 1
)

rd /S /Q "%TEMP_FOLDER%"

@REM Check if the notebooks should be sent to the board
if "%~2" == "true" (
    echo %YELLOW%[WARNING] If notebooks of identical names exist on the AUP-ZU3, they will be overwritten.%RESET%
    set /p USER_INPUT=Are you sure you want to send all jupyter notebooks to the AUP-ZU3 board? ^<yes^/no^>:

    if "!USER_INPUT!" == "yes" (
        @REM Send notebooks to board
        scp -r "%SCRIPT_DIR%\notebook_examples" "%REMOTE_PATH%/jupyter_notebooks"

        if %errorlevel% neq 0 (
            echo %RED%[ERROR] Failed to send notebooks to the board%RESET%
            if /I %0 equ "%~f0" pause
            exit /b 1
        )

        echo %GREEN%[SUCCESS] Sent notebooks to the board%RESET%
    )
)

echo %GREEN%[SUCCESS] Folder '%FOLDER_NAME%' created, files copied, and sent to the board%RESET%

if /I %0 equ "%~f0" pause
