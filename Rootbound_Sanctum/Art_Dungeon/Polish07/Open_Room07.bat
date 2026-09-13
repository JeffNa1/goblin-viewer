@echo off
set "GODOT=%USERPROFILE%\.gemini\antigravity\bin\godot.exe"
if not exist "%GODOT%" set "GODOT=godot"
"%GODOT%" --path "%~dp0..\..\.." --rendering-method forward_plus --resolution 1600x900 --script res://Rootbound_Sanctum/Art_Dungeon/Polish07/open_review.gd %*
