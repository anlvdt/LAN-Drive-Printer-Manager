@echo off
title Trinh Khoi Chay Tao Chia Se

::----------------------------------------------------------------------
:: BUOC 1: Kiem tra quyen Administrator
::----------------------------------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Dang yeu cau quyen Administrator...
    
    ::----------------------------------------------------------------------
    :: BUOC 2: Tu dong nang quyen bang PowerShell
    :: %~s0 la duong dan ngan (an toan voi dau cach) den chinh tep .bat nay
    ::----------------------------------------------------------------------
    powershell.exe -Command "Start-Process cmd.exe -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

::----------------------------------------------------------------------
:: BUOC 3: Neu da co quyen Admin, chay script PowerShell
:: Pushd "%~dp0" de dam bao script chay dung thu muc
::----------------------------------------------------------------------
pushd "%~dp0"

echo Da co quyen Administrator. Dang khoi chay script PowerShell...
echo Vui long doi, mot cua so PowerShell se duoc mo...
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File ".\Tao-ChiaSe.ps1"

echo.
echo Script PowerShell da thuc thi xong.
popd
pause