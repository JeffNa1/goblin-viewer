@echo off
set "GODOT=%USERPROFILE%\.gemini\antigravity\bin\godot.exe"
if not exist "%GODOT%" set "GODOT=godot"
start "" "%GODOT%" --path "%~dp0..\.." --rendering-method forward_plus --resolution 1600x900 res://Rootbound_Sanctum/Art_Sample/sanctuary.tscn
