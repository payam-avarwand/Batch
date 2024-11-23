@echo off

REM Suppose we have 10 SAN-switches, each with 30 to 100 interfaces.
REM This script will collect only the names of all Interfaces on all SAN switches in a single text file.
REM The disadvantage of this script is that the admin password is entered as a plain text in the script.

REM Create Variables:
set "script_dir=%~dp0"
set "sws=%script_dir%_"
set "Output=%USERPROFILE%\Desktop\SAN_Portnames.txt"
set "PW=%script_dir%__"
set "COM=portname"


REM Create a temporary file which include the Switch addresses:
> "%sws%" (
	echo 18.105.40.11
	echo 18.105.40.13
	echo 18.105.40.14
	echo 18.105.40.17
	echo 18.105.40.18
	echo 18.105.40.19
	echo 18.105.40.20
	echo 18.105.40.29
	echo 18.105.40.30
	echo 18.105.40.65
)
attrib +h "%sws%"

REM Create a temporary file which include the Password of admin account, to establish a SSH-Connection:
> "%PW%" (
    echo P@s$woRD
)
attrib +h "%PW%"

REM Clear/Create the output file before starting:
> "%Output%" echo       ..::Port Names::.. & echo.


REM Enable delayed expansion
setlocal enabledelayedexpansion

REM Loop through each line in the IP file
for /f "delims=" %%I in (%sws%) do (
    set "IP=%%I"
    for /f "usebackq delims=" %%P in ("%PW%") do set "PASSWORD=%%P"
    REM Extract the name using nslookup
    for /f "tokens=2 delims=: " %%A in ('nslookup !IP! ^| findstr "Name:"') do (
        echo .: %%A :. >> "%Output%"
        echo "Querying  %%A ..."
        REM Use plink to connect to the switch and run the command
        echo y | plink.exe -no-antispoof -ssh -C ftyousefi@!IP! -pw "!PASSWORD!" "!COM!" >> "%Output%"
        echo. >> "%Output%"
    )
)

timeout /t 1 >nul
if exist "%PW%" del "%PW%"
if exist "%sws%" del "%sws%"
echo The Port-Names on all Switches have been saved to %Output%
timeout /t 1 >nul
endlocal