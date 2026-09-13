@echo off
setlocal
cd /d "%~dp0..\..\.."
set "GODOT=%USERPROFILE%\.gemini\antigravity\bin\godot.exe"
if not exist "%GODOT%" (
  echo Godot was not found at "%GODOT%".
  pause
  exit /b 1
)
"%GODOT%" --path "%CD%" --rendering-method forward_plus --resolution 1600x900 --position 80,60 res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/dungeon.tscn
