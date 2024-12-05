@echo off

REM ---------------------------------------------------------------------------------------------------------------------
REM Since we have some Broadcom FC-Switches with 30 to 100 interfaces each,
REM and the interfaces are named according to the device that is connected to them,
REM this script gathers the names of all Interfaces on all FC-Switches into a text file as an output-File on the local Desktop.
REM Notes:
    REM the admin password is entered as a plain text.
    REM to run this script on a system, the Plink must be installed or at list reachable.
	REM temporary files will be created next to the script file in the the hidden form, no matter where the script file is located.
	
REM Created:      Payam A. - 20.11.2024
REM Last change:  Payam A. - 05.12.2024

REM ---------------------------------------------------------------------------------------------------------------------
REM Check Plink-Installation
where plink >nul 2>&1
if errorlevel 1 (
	echo.
	echo Plink is not installed or I cannot find it,
	echo.
	echo therefore, I am unable to run!!
	echo.
	echo.
	pause
	exit /b
)

REM ---------------------------------------------------------------------------------------------------------------------
setlocal enabledelayedexpansion

REM ---------------------------------------------------------------------------------------------------------------------
REM Variable declaration:

REM set "Dt=%date%"
for /f "tokens=2,3,4 delims=/- " %%a in ('date /t') do set "Dt=%%b.%%a.%%c"
set "Tm=%time:~0,8%"
set "temp=%~dp0"
set "sws=%temp%_"
set "Output=%USERPROFILE%\Desktop\Portnames _ %DT%.txt"
set "PW=%temp%__"
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

REM 2d one
> "%PW%" (
    echo P@s$woRD
)
attrib +h "%PW%"

REM 3d one
> "%Output%" echo        ..::Port Names::..& echo.
>> "%Output%" echo    .: %Dt% ^| %Tm% :.& echo.
>> "%Output%" echo ^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|& echo. & echo.
>> "%Output%" echo.


REM ---------------------------------------------------------------------------------------------------------------------
REM work on FC-Switches

REM Loop through each line of the Switch-IP-file
for /f "delims=" %%I in (%sws%) do (
	set "IP=%%I"
	for /f "usebackq delims=" %%P in ("%PW%") do set "PASSWORD=%%P"
	REM Extract the name using nslookup
	for /f "tokens=2 delims=: " %%A in ('nslookup !IP! ^| findstr "Name:"') do (
		echo .: %%A :. >> "%Output%"
		(echo --------------------------------------) >> "%Output%"
		echo Querying  %%A ...
		REM Use plink to connect to the switch and run the command
		echo y | plink.exe -no-antispoof -ssh -C username@!IP! -pw "!PASSWORD!" "!COM!" >> "%Output%"
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

echo.
echo The Port-Names have been saved to %Output%
timeout /t 1 >nul
endlocal