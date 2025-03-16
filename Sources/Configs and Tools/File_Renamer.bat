@echo off
REM the word "test_ " will be added to the names of all files in a certain path

REM define the path
set "target_path=D:\Musics"

REM navigate to the Path 
cd /d "%target_path%"

for %%f in (*.*) do (
REM in case the target should be just MP3-Files: for %%f in (*.mp3) do (
    ren "%%f" "test_ %%f"
)

echo Renaming complete.

