@echo off
rem Removes "Analizar con Spek-X" from the right-click menu.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0context-menu.ps1" -Uninstall
pause
