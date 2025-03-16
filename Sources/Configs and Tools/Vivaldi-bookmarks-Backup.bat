@echo off

REM Define the source file and destination path
REM set "source=%USERPROFILE%\AppData\Local\Vivaldi\User Data\Default\Bookmarks"
set "source=%USERPROFILE%\AppData\Local\Vivaldi\User Data\Profile 1\Bookmarks"
set "destination=D:\Vivaldi\"

REM Checks the existence of Pathes
if exist "%source%" (
    if not exist "%destination%" (
        mkdir "%destination%"
    )
	REM Copies the content
    xcopy "%source%" "%destination%" /Y
    echo File copied successfully to "%destination%"
) else (
    echo Source file "%source%" does not exist.
)

REM in xcopy:
REM /Y: to confirm overwriting.