@REM #######################################################################################################################
@REM # Copyright (C) HES-SO University of Applied Sciences and Arts Western Switzerland
@REM # Engineering and Architecture Department
@REM # AGSL - Adaptive Heterogeneous Systems Lab
@REM # Created by John Biselx (john.biselx@hevs.ch)
@REM # All rights reserved.
@REM # See LICENSE file for full license information.
@REM #######################################################################################################################

@setlocal
@echo off

@REM -------------------------------------
@REM ADAPT TO WORK WITH YOUR SETUP - BEGIN
@REM -------------------------------------

@REM Vivado install location
set "VIVADO_INSTALL=C:\Xilinx\Vivado\2024.2\bin\vivado.bat"

@REM -------------------------------------
@REM ADAPT TO WORK WITH YOUR SETUP - END
@REM -------------------------------------

@REM Create the Escape character
for /F "tokens=1 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do (
    set "ESC=%%a"
)

set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "RESET=%ESC%[0m"

set "FILTER_NAME=%~1"

@REM Make sure the current working directory is where the script is located
for %%I in ("%~dp0.") do (
    set "SCRIPT_DIR=%%~fI"
)

cd /d "%SCRIPT_DIR%"

set "ROOT_DIR=%SCRIPT_DIR%\..\.."

@REM Folder where DynaRapid runs
set "DYNARAPID_INSTALL=%ROOT_DIR%\tools\DynaRapid"

@REM Folder where .dot files are found
set "OUTPUT_FOLDER=%SCRIPT_DIR%\filters\%FILTER_NAME%"

@REM Check if the folder exists
if not exist "%OUTPUT_FOLDER%\" (
    echo %RED%[ERROR] Folder "%OUTPUT_FOLDER%\" not found%RESET%
    if /I %0 equ "%~f0" pause
    exit /b 1
)

@REM Print variable values
echo ^> SCRIPT_DIR: "%SCRIPT_DIR%"
echo ^> ROOT_DIR: "%ROOT_DIR%"
echo ^> OUTPUT_FOLDER: "%OUTPUT_FOLDER%"
echo ^> VIVADO_INSTALL: "%VIVADO_INSTALL%"
echo ^> DYNARAPID_INSTALL: "%DYNARAPID_INSTALL%"

@REM Check if file present
if not exist "%OUTPUT_FOLDER%\filter.dot" (
    echo %RED%[ERROR] Failed to find DFG "%OUTPUT_FOLDER%\filter.dot"%RESET%
    if /I %0 equ "%~f0" pause
    exit /b 1
)

cd /d "%DYNARAPID_INSTALL%"

@REM Clean-up previous DynaRapid run, to check for successful DynaRapid run
if exist "%DYNARAPID_INSTALL%\designs\filter\" (
    rd /S /Q "%DYNARAPID_INSTALL%\designs\filter"
)

@REM Run DynaRapid; Gradle requires forward slashes for path
call gradlew.bat :GenerateDesign --args="-f %OUTPUT_FOLDER%/filter.dot -placer greedy -part xczu3eg -noClock -region 0 -targetPeriod 3 -streaming"

move /y "%DYNARAPID_INSTALL%\designs\filter\filter_routed.dcp" "%OUTPUT_FOLDER%\filter_routed1.dcp" > NUL

@REM Check if DynaRapid was successful
@REM Currently DynaRapid doesn't return an error code, so only way to check if successful is if output was created; check when moving
if %errorlevel% neq 0 (
    echo %RED%[ERROR] Failed run DynaRapid ^(1^)%RESET%
    if /I %0 equ "%~f0" pause
    exit /b 1
)

fc "%DYNARAPID_INSTALL%\designs\filter\filter.dot" "%OUTPUT_FOLDER%\filter.dot" > NUL

@REM Save modified dot file, if it has been modified
if %errorlevel% equ 1 (
    move /y "%DYNARAPID_INSTALL%\designs\filter\filter.dot" "%OUTPUT_FOLDER%\filter_modified.dot" > NUL
)

@REM Clean-up previous run, to check for successful DynaRapid run
rd /S /Q "%DYNARAPID_INSTALL%\designs\filter"

call gradlew.bat :GenerateDesign --args="-f %OUTPUT_FOLDER%/filter.dot -placer greedy -part xczu3eg -noClock -region 1 -targetPeriod 3 -streaming"

move /y "%DYNARAPID_INSTALL%\designs\filter\filter_routed.dcp" "%OUTPUT_FOLDER%\filter_routed2.dcp" > NUL

if %errorlevel% neq 0 (
    echo %RED%[ERROR] Failed to run DynaRapid ^(2^)%RESET%
    if /I %0 equ "%~f0" pause
    exit /b 1
)

cd /d "%SCRIPT_DIR%"

@REM Generate bitstream
call "%VIVADO_INSTALL%" -mode batch -source generate_bitstream.tcl -tclargs "%FILTER_NAME%"

if %errorlevel% neq 0 (
    echo %RED%[ERROR] Failed to create bitstream for filter '%FILTER_NAME%'%RESET%
    if /I %0 equ "%~f0" pause
    exit /b 1
)

echo %GREEN%[SUCCESS] Created bitstream for filter '%FILTER_NAME%'%RESET%

if /I %0 equ "%~f0" pause
