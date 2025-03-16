@echo off

REM ---------------------------------------------------------------------------------------------------------------------
REM This script generates passwords containing uppercase and lowercase letters, numbers and special characters.

setlocal enabledelayedexpansion

REM Set the desired password length
set "length=15"

REM Define the character pool including uppercase, lowercase, numbers, and special characters
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+"

REM Initialize the password variable
set "password="

REM Generate random characters for the password
for /l %%i in (1,1,%length%) do (
    
    REM Get a random index within the character pool
    set /a "rand=!random! %% 72"
    REM !random! (or %random% in standard Batch syntax) is a default variable in Batch.
    
    REM Extract the character with the random index
    for %%j in (!rand!) do set "password=!password!!chars:~%%j,1!"
)

REM Output the generated password
echo Generated Password: !password!

REM Optionally save the password to a file
echo !password!
REM echo !password! Rand_Password.txt
REM echo Password saved to Rand_Password.txt

endlocal
