@echo off
rem Adds "Analizar con Spek-X" to the right-click menu of every file.
rem Expects spek.exe in the same folder as this script.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0context-menu.ps1" -ExePath "%~dp0spek.exe"
pause
