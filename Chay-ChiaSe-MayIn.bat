@echo off
title Trinh Khoi Chay Chia Se May In

:: Kiem tra quyen Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Dang yeu cau quyen Administrator de chia se may in...
    
    :: Tu dong nang quyen
    powershell.exe -Command "Start-Process cmd.exe -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

:: Neu da co quyen Admin, chay script PowerShell
pushd "%~dp0"

echo Da co quyen Administrator. Dang khoi chay script chia se may in...
echo Vui long doi, mot cua so PowerShell se duoc mo...
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File ".\ChiaSe-MayIn.ps1"

echo.
echo Script PowerShell da thuc thi xong.
popd
pause