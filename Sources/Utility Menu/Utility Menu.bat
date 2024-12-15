@echo off

REM This script provides a menu to perform some utilities like network queries, file operations, and other tasks.

title Utility-Menu
color 0A

REM General Variables
set "Output=%USERPROFILE%\Desktop\"


REM descriptive label 1
:main_menu
cls
echo ==========================================
echo                   Tools
echo ==========================================
echo 1. Network Queries
echo 2. File Operations
echo 3. System Information
echo 4. Exit
echo.
choice /c 1234 /n /m "Please select an option: "

rem User's choice
if errorlevel 4 goto exit_script
if errorlevel 3 goto system_info
if errorlevel 2 goto file_operations
if errorlevel 1 goto network_queries

REM descriptive label 2
:network_queries
cls
echo ------------------------------------------
echo               Network Queries
echo ------------------------------------------
echo 1. Ping a Website
echo 2. Check Current IP Configuration
echo 3. Return to Main Menu
echo.
choice /c 123 /n /m "Please select an option: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto ip_config
if errorlevel 1 goto ping_website

REM descriptive label 3
:ping_website
set /p target="Enter the website or IP to ping: "
echo.
ping %target%
pause
goto network_queries

REM descriptive label 4
:ip_config
echo.
ipconfig
pause
goto network_queries

REM descriptive label 5
:file_operations
cls
echo ------------------------------------------
echo               File Operations
echo ------------------------------------------
echo 1. Create a New File
echo 2. Display File Contents
echo 3. Return to Main Menu
echo.
choice /c 123 /n /m "Please select an option: "

if errorlevel 3 goto main_menu
if errorlevel 2 goto display_file
if errorlevel 1 goto create_file

REM descriptive label 6
:create_file
set /p filename="Enter a name for the fime: "
echo Enter file content below. Press CTRL+Z and Enter to save.
copy con %Output%%filename%

echo File "%filename%" with the following contents, has been created:
REM to show the contents:
echo.
type %filename%
echo.
pause
goto file_operations

REM descriptive label 7
:display_file
set /p filename="Enter the filename to display: "
echo.
type %filename%
echo.
pause
goto file_operations

REM descriptive label 8
:system_info
cls
echo ------------------------------------------
echo           System Information
echo ------------------------------------------
echo.
systeminfo | more
echo.
pause
goto main_menu

REM descriptive label 9
:exit_script
echo Exiting ...
timeout /t 1 >nul
exit
