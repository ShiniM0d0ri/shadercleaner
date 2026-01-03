@echo off
setlocal EnableDelayedExpansion
title Universal Shader Cache Cleaner v1.0
color 0b

:: ============================================================================
::  UNIVERSAL SHADER CACHE CLEANER
::  Author: [Your GitHub Username]
::  Description: Clears DirectX, NVIDIA, AMD, Intel, and Steam Shader Caches.
::  License: MIT
:: ============================================================================

:CHECK_ADMIN
:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    cls
    color 0c
    echo ============================================================================
    echo  ERROR: ADMINISTRATOR PRIVILEGES REQUIRED
    echo ============================================================================
    echo.
    echo  This script requires admin rights to access system folders (ProgramData/AppData).
    echo.
    echo  [ACTION REQUIRED]
    echo  Please right-click this file and select "Run as Administrator".
    echo.
    echo ============================================================================
    pause
    exit
)

:DETECT_STEAM
:: Auto-detect Steam Path from Registry
set "STEAM_PATH="
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v SteamPath 2^>nul') do set "STEAM_PATH=%%B"

:: If Registry fails, check default location
if not defined STEAM_PATH (
    if exist "C:\Program Files (x86)\Steam" (
        set "STEAM_PATH=C:\Program Files (x86)\Steam"
    )
)

:: Fix slashes in path (Registry uses / but Windows uses \)
if defined STEAM_PATH set "STEAM_PATH=!STEAM_PATH:/=\!"

:MAIN_MENU
cls
color 0b
echo ============================================================================
echo   UNIVERSAL SHADER CACHE CLEANER
echo ============================================================================
echo.
echo   Detected Steam Path: !STEAM_PATH!
echo.
echo   [1] Clear ALL Shader Caches (Recommended)
echo   [2] Clear GPU Caches Only (NVIDIA / AMD / INTEL / DX)
echo   [3] Clear Steam Shader Cache Only
echo   [4] Exit
echo.
echo ============================================================================
set /p choice="Select an option (1-4): "

if "%choice%"=="1" goto PREP_FULL
if "%choice%"=="2" goto PREP_GPU
if "%choice%"=="3" goto PREP_STEAM
if "%choice%"=="4" exit
goto MAIN_MENU

:PREP_FULL
call :CLOSE_STEAM
call :CLEAN_GPU
call :CLEAN_STEAM
goto FINISHED

:PREP_GPU
call :CLEAN_GPU
goto FINISHED

:PREP_STEAM
call :CLOSE_STEAM
call :CLEAN_STEAM
goto FINISHED

:: ============================================================================
::  FUNCTIONS
:: ============================================================================

:CLOSE_STEAM
echo.
echo ----------------------------------------------------------------------------
echo  Checking Steam Process...
echo ----------------------------------------------------------------------------
tasklist /FI "IMAGENAME eq steam.exe" 2>NUL | find /I /N "steam.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo   ! Steam is running. Closing it now to prevent file locks...
    taskkill /F /IM steam.exe >nul 2>&1
    timeout /t 3 /nobreak >nul
    echo   ! Steam closed.
) else (
    echo   ! Steam is not running. Proceeding...
)
exit /b

:CLEAN_GPU
echo.
echo ----------------------------------------------------------------------------
echo  Cleaning GPU & DirectX Caches...
echo ----------------------------------------------------------------------------

:: NVIDIA
call :DELETE_FOLDER "%LOCALAPPDATA%\NVIDIA\GLCache" "NVIDIA GL Cache"
call :DELETE_FOLDER "%LOCALAPPDATA%\NVIDIA\DXCache" "NVIDIA DX Cache"
call :DELETE_FOLDER "%APPDATA%\NVIDIA\ComputeCache" "NVIDIA Compute Cache"
call :DELETE_FOLDER "%ProgramData%\NVIDIA Corporation\NV_Cache" "NVIDIA NV_Cache"
call :DELETE_FOLDER "%LOCALAPPDATA%\NVIDIA Corporation\GpuCache" "NVIDIA Global GPU Cache"

:: AMD
call :DELETE_FOLDER "%LOCALAPPDATA%\AMD\DxCache" "AMD DxCache"
call :DELETE_FOLDER "%LOCALAPPDATA%\AMD\GLCache" "AMD GLCache"

:: INTEL
call :DELETE_FOLDER "%LOCALAPPDATA%\Intel\ShaderCache" "Intel ShaderCache"

:: DIRECTX (Windows)
call :DELETE_FOLDER "%LOCALAPPDATA%\D3DSCache" "Windows D3DS Cache"
call :DELETE_FOLDER "%LOCALAPPDATA%\DirectX Shader Cache" "Windows DirectX Shader Cache"

exit /b

:CLEAN_STEAM
echo.
echo ----------------------------------------------------------------------------
echo  Cleaning Steam Shader Cache...
echo ----------------------------------------------------------------------------
if defined STEAM_PATH (
    if exist "!STEAM_PATH!\steamapps\shadercache" (
        call :DELETE_FOLDER "!STEAM_PATH!\steamapps\shadercache" "Steam Shader Cache"
    ) else (
        echo   [SKIP] Steam Shader Cache folder not found (Clean).
    )
) else (
    echo   [ERROR] Could not detect Steam path. Skipping Steam cleanup.
)
exit /b

:DELETE_FOLDER
:: Usage: call :DELETE_FOLDER "Path" "NameForLog"
if exist "%~1" (
    echo   [CLEANING] %~2...
    rmdir /s /q "%~1" >nul 2>&1
    echo      Done.
)
exit /b

:FINISHED
echo.
echo ============================================================================
echo  CLEANUP COMPLETE!
echo ============================================================================
echo.
echo  Note: Your next game launch may take longer as shaders rebuild.
echo        Stuttering during the first few minutes of gameplay is normal.
echo.
pause
goto MAIN_MENU
