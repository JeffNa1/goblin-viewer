@echo off
set "GODOT=%USERPROFILE%\.gemini\antigravity\bin\godot.exe"
if not exist "%GODOT%" set "GODOT=godot"
start "" "%GODOT%" --path "%~dp0." res://scenes/rootbound_sanctum.tscn
