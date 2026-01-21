@echo off
REM Switch Claude/Codex/Gemini API Key Tool
REM Calls the PowerShell script in the same directory

set "SCRIPT_DIR=%~dp0"
pwsh -ExecutionPolicy Bypass -File "%SCRIPT_DIR%switch.claude.key.ps1" %*
