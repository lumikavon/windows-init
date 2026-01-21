@echo off

set "SCRIPT_DIR=%~dp0"
pwsh -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install.ps1" %*
