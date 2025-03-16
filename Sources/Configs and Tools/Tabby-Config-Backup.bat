@echo off

REM Define the source file and destination path
set "source=%USERPROFILE%\AppData\Roaming\tabby\config.yaml"
set "destination=D:\Tabby\"

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
