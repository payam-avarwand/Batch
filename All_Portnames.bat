@echo off
REM ---------------------------------------------------------------------------------------------------------------------
REM We have 5 Broadcom FC-Switches, each could have 30 to 100 interfaces.
REM Each interface has a name that represents the device connected to it.
REM This script gathers the names of all Interfaces of all FC-Switches into a text file as an output-File on Desktop.
REM The disadvantage of this script is that the admin password is entered as a plain text in the script.

REM ---------------------------------------------------------------------------------------------------------------------
REM Variable declaration:

set "script_dir=%~dp0"
set "sws=%script_dir%_"
set "Output=%USERPROFILE%\Desktop\SAN_Portnames.txt"
set "PW=%script_dir%__"
set "COM=portname"

REM ---------------------------------------------------------------------------------------------------------------------
REM Create files 

REM 1st one: IP-addresses of all FC-Switches will be included in a temporary file:
> "%sws%" (
    echo 18.105.40.11
    echo 18.105.40.13
    echo 18.105.40.14
    echo 18.105.40.17
    echo 18.105.40.18
)
attrib +h "%sws%"

REM 2d one: the password for the user01 account to establish SSH-Connections, will be included in another temporary file:
> "%PW%" (
    echo P@s$woRD
)
attrib +h "%PW%"

REM 3d one: Clear/Create the output file before starting:
> "%Output%" echo       ..::Port Names::.. & echo.

REM ---------------------------------------------------------------------------------------------------------------------
REM work on FC-Switches

setlocal enabledelayedexpansion

REM Recall every single IP through a loop over the sws variable (IP file)
for /f "delims=" %%I in (%sws%) do (
    set "IP=%%I"

    REM Recall the Password
    for /f "usebackq delims=" %%P in ("%PW%") do set "PASSWORD=%%P"

    REM Extract the hostname and add it to the output file
    for /f "tokens=2 delims=: " %%A in ('nslookup !IP! ^| findstr "Name:"') do (
        echo .: %%A :. >> "%Output%"

        REM Connect to every single switch and recall the port names on that and add the response to the output file
        echo "Querying  %%A ..."
        echo y | plink.exe -no-antispoof -ssh -C user01@!IP! -pw "!PASSWORD!" "!COM!" >> "%Output%"
        echo. >> "%Output%"
    )   
)

REM ---------------------------------------------------------------------------------------------------------------------
REM make a 1 sec delay and remove the temporary files

timeout /t 1 >nul
if exist "%PW%" del /A:H "%PW%"
if exist "%sws%" del /A:H "%sws%"

REM ---------------------------------------------------------------------------------------------------------------------
REM End message and finish

echo The Port-Names on all FC-Switches have been saved to %Output%
timeout /t 1 >nul
endlocal