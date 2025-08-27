# =================================================================
# SCRIPT POWERSHELL DE CHIA SE MAY IN TRONG MANG LAN
# Phien ban 3.2 - Kien truc Client "Co Hieu" on dinh nhat
# =================================================================

Clear-Host
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "      CHUONG TRINH CHIA SE MAY IN TU DONG (v3.2)" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green; Write-Host
try {
    $spooler = Get-Service -Name Spooler -ErrorAction Stop; if ($spooler.Status -ne 'Running') { throw "Dich vu 'Print Spooler' dang khong chay." }
} catch { Write-Host "`n!!! LOI HE THONG !!!`n" -Red; Write-Host $_.Exception.Message -Red; Read-Host; exit 1 }
$printers = Get-Printer | Where-Object { $_.Type -eq 'Local' }
if (-not $printers) { Write-Host "LOI: Khong tim thay may in cuc bo nao." -Red; Read-Host; return }
Write-Host "`nCac may in duoc tim thay:" -Yellow
$i = 1; $printers | ForEach-Object { Write-Host "   $i. $($_.Name)"; $i++ }; Write-Host
$choice = 0; while ($choice -lt 1 -or $choice -gt $printers.Count) { $input = Read-Host "Chon so thu tu may in"; if ($input -match '^\d+$') { $choice = [int]$input } }
$selectedPrinter = $printers[$choice - 1]
$shareName = Read-Host "`nNhap ten chia se (goi y: '$($selectedPrinter.Name)'), hoac nhan Enter"
if ([string]::IsNullOrWhiteSpace($shareName)) { $shareName = $selectedPrinter.Name -replace '[\\/:*?\""<>|]' }
Read-Host "`nNhan Enter de bat dau chia se"
try {
    Set-Printer -Name $selectedPrinter.Name -Shared $true -ShareName $shareName -ErrorAction Stop
    Write-Host "`n>>> CHIA SE MAY IN THANH CONG! <<<`n" -Green
} catch { Write-Host "`n!!! LOI NANG KHI CHIA SE !!!`n" -Red; Write-Host ($_.ToString()) -Red; Read-Host; exit 1 }
$serverName = $env:COMPUTERNAME; $packageDir = "$($env:USERPROFILE)\Desktop\Goi_Ket_Noi_May_In_$shareName"
if (Test-Path $packageDir) { Remove-Item -Path $packageDir -Recurse -Force }; New-Item -Path $packageDir -ItemType Directory | Out-Null
"HUONG DAN: Nhap dup vao tep 'KetNoiMayIn.bat'." | Set-Content -Path "$packageDir\HUONG_DAN.txt" -Encoding UTF8
@"
@echo off
title Client - Trinh Ket Noi May In

set "SCRIPT_PATH=%~dp0\_Logic.ps1"
set "FLAG_FILE=%ProgramData%\LANDriveManager\PrinterSetupComplete.flag"

if exist "%FLAG_FILE%" (
    echo Cau hinh da chuan. Dang tien hanh ket noi...
    powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_PATH%" -Mode Connect -ServerName "${serverName}" -ShareName "${shareName}"
) else (
    echo. & echo --- CAU HINH LAN DAU ---
    echo Script se cau hinh may tinh de chap nhan ket noi may in.
    echo. & echo --- YEU CAU QUYEN ADMINISTRATOR ---
    echo Vui long chon 'Yes' o cua so tiep theo de cap quyen.
    echo. & powershell -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"%SCRIPT_PATH%`" -Mode Setup' -Verb RunAs"
    echo. & echo --- VUI LONG KHOI DONG LAI MAY TINH roi chay lai tep nay ---
)
pause
"@ | Set-Content -Path "$packageDir\KetNoiMayIn.bat" -Encoding OEM
@"
# Client Logic Script v3.2
param([string]`$Mode,[string]`$ServerName,[string]`$ShareName)
if (`$Mode -eq 'Setup') {
    `$flagDir = Join-Path -Path `$env:ProgramData -ChildPath 'LANDriveManager'
    `$flagFile = Join-Path -Path `$flagDir -ChildPath 'PrinterSetupComplete.flag'
    if (-not (Test-Path `$flagDir)) { New-Item -Path `$flagDir -ItemType Directory | Out-Null }
    `$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'; if (-not (Test-Path `$regPath)) { New-Item -Path `$regPath -Force | Out-Null }; Set-ItemProperty -Path `$regPath -Name 'DisabledComponents' -Value 0xFF -Force
    `$regPath2 = 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint'; if (-not (Test-Path `$regPath2)) { New-Item -Path `$regPath2 -Force | Out-Null }; Set-ItemProperty -Path `$regPath2 -Name 'Restricted' -Value 0 -Force; Set-ItemProperty -Path `$regPath2 -Name 'TrustedServers' -Value 0 -Force
    # Tao tep "co hieu"
    New-Item -Path `$flagFile -ItemType File -Force | Out-Null
    Write-Host "`nDa cau hinh xong. BAN PHAI KHOI DONG LAI MAY TINH." -ForegroundColor Cyan
    Read-Host "Nhan Enter de dong cua so nay"
    exit
}
if (`$Mode -eq 'Connect') {
    try {
        `$printerPath = "\\`$ServerName\`$ShareName"
        `$ping = Test-Connection -ComputerName `$ServerName -Count 1 -Quiet -ErrorAction Stop
        `$existingPrinter = Get-Printer -Name `$printerPath -ErrorAction SilentlyContinue
        if (`$existingPrinter) { Write-Host "Phat hien ket noi cu. Dang xoa..." -ForegroundColor Yellow; `$existingPrinter | Remove-Printer }
        Add-Printer -ConnectionName `$printerPath -ErrorAction Stop
        Write-Host "`n>>> THEM MAY IN THANH CONG! <<<" -ForegroundColor Green
    } catch { Write-Host "`n!!! LOI KET NOI !!!" -ForegroundColor Red; Write-Host ('Chi tiet loi goc: ' + `$_.ToString()) -ForegroundColor Red }
}
"@ | Set-Content -Path "$packageDir\_Logic.ps1" -Encoding UTF8
Write-Host "Da tao goi huong dan thanh cong!" -ForegroundColor Green; Invoke-Item $packageDir
Write-Host "`n--- HOAN TAT ---"; Read-Host "Nhan Enter"