# =================================================================
# SCRIPT POWERSHELL DE TAO CHIA SE MANG MOT CACH AN TOAN
# Phien ban 3.1 - Kien truc Client on dinh (Tu dong sua loi dich vu)
# =================================================================

# --- Ham de kiem tra va khoi dong dich vu can thiet ---
function Start-RequiredServices {
    $services = "LanmanServer", "LanmanWorkstation"
    foreach ($serviceName in $services) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($null -eq $service) {
            throw "Dich vu he thong quan trong '$serviceName' khong ton tai."
        }
        if ($service.Status -ne 'Running') {
            Write-Host "Phat hien dich vu '$serviceName' dang khong chay. Dang khoi dong..." -ForegroundColor Yellow
            try {
                Start-Service -Name $serviceName -ErrorAction Stop
                Write-Host "=> Khoi dong thanh cong." -ForegroundColor Green
            } catch {
                throw "Khong the khoi dong dich vu '$serviceName'. Chia se tep se that bai."
            }
        }
    }
}

# --- BAT DAU SCRIPT CHINH ---
Clear-Host
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "      CHUONG TRINH TAO CHIA SE MANG TU DONG (v3.1)" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green; Write-Host

try {
    # BUOC 0: Kiem tra cac dich vu he thong
    Start-RequiredServices
} catch {
    Write-Host "`n!!! LOI HE THONG !!!`n" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Nhan Enter de thoat"
    exit 1
}

Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog; $dialog.Description = 'CHON THU MUC DE CHIA SE'
if ($dialog.ShowDialog() -ne 'OK') { Write-Host "Da huy." -ForegroundColor Yellow; Read-Host; return }
$folderPath = $dialog.SelectedPath

if (-not (Test-Path -Path $folderPath)) {
    Write-Host "`n!!! LOI: THU MUC KHONG TON TAI !!!`n" -ForegroundColor Red
    Write-Host "Thu muc '$folderPath' khong con ton tai. Vui long chon lai." -ForegroundColor Red
    Read-Host "Nhan Enter de thoat"
    exit 1
}

Write-Host "Ban da chon: '$folderPath'" -ForegroundColor Cyan
$defaultShareName = (Split-Path -Leaf -Path $folderPath) -replace '[\\/:*?\""<>|]'
$shareName = Read-Host "`nNhap ten chia se (goi y: '$defaultShareName'), hoac nhan Enter"
if ([string]::IsNullOrWhiteSpace($shareName)) { $shareName = $defaultShareName }
Write-Host "`n--- THONG TIN CAU HINH ---"; Write-Host "   - Thu muc goc  : '$folderPath'"; Write-Host "   - Ten tren mang: '$shareName'"; Write-Host "----------------------------"; Read-Host "Nhan Enter de bat dau"; Write-Host
try {
    Write-Host "Dang cau hinh..." -ForegroundColor Yellow
    $acl = Get-Acl -Path $folderPath; $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "Modify", "ContainerInherit, ObjectInherit", "None", "Allow"); $acl.SetAccessRule($accessRule); Set-Acl -Path $folderPath -AclObject $acl
    if (Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue) { Remove-SmbShare -Name $shareName -Confirm:$false }
    New-SmbShare -Name $shareName -Path $folderPath -FullAccess 'Everyone' -Confirm:$false -ErrorAction Stop
    Write-Host "`n>>> TAO CHIA SE THANH CONG! <<<`n" -ForegroundColor Green
} catch { Write-Host "`n!!! LOI NANG !!!`n" -ForegroundColor Red; Write-Host ($_.ToString()) -ForegroundColor Red; Read-Host; exit 1 }
Write-Host "Dang tao goi huong dan cho Client..." -ForegroundColor Yellow
$serverName = $env:COMPUTERNAME; $packageDir = "$($env:USERPROFILE)\Desktop\Goi_Ket_Noi_$shareName"
if (Test-Path $packageDir) { Remove-Item -Path $packageDir -Recurse -Force }; New-Item -Path $packageDir -ItemType Directory | Out-Null
"HUONG DAN: Nhap dup vao tep 'KetNoiOdiaMang.bat'." | Set-Content -Path "$packageDir\HUONG_DAN.txt" -Encoding UTF8
@"
@echo off
title Client - Trinh Ket Noi O Dia Mang
set "SCRIPT_PATH=%~dp0\_Logic.ps1"
set "FLAG_FILE=%ProgramData%\LANDriveManager\SetupComplete.flag"
if exist "%FLAG_FILE%" (
    echo Cau hinh da chuan. Dang tien hanh ket noi...
    powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_PATH%" -Mode Connect -ServerName "${serverName}" -ShareName "${shareName}"
) else (
    echo. & powershell -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"%SCRIPT_PATH%`" -Mode Setup' -Verb RunAs"
)
pause
"@ | Set-Content -Path "$packageDir\KetNoiOdiaMang.bat" -Encoding OEM
@"
# Client Logic Script v3.1
param([string]`$Mode,[string]`$ServerName,[string]`$ShareName)
if (`$Mode -eq 'Setup') {
    `$flagDir = Join-Path -Path `$env:ProgramData -ChildPath 'LANDriveManager'; if (-not (Test-Path `$flagDir)) { New-Item -Path `$flagDir -ItemType Directory | Out-Null }
    `$flagFile = Join-Path -Path `$flagDir -ChildPath 'SetupComplete.flag'
    `$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'; if (-not (Test-Path `$regPath)) { New-Item -Path `$regPath -Force | Out-Null }; Set-ItemProperty -Path `$regPath -Name 'DisabledComponents' -Value 0xFF -Force
    New-Item -Path `$flagFile -ItemType File -Force | Out-Null
    Write-Host "`nDa cau hinh xong. BAN PHAI KHOI DONG LAI MAY TINH." -ForegroundColor Cyan; Read-Host "Nhan Enter"
}
if (`$Mode -eq 'Connect') {
    try {
        `$sharePath = "\\`$ServerName\`$ShareName"
        `$ping = Test-Connection -ComputerName `$ServerName -Count 1 -Quiet -ErrorAction Stop
        `$driveLetters = 'Z','Y','X','W','V','U','T','S','R','P','O','N','M'; `$targetDrive = `$null
        foreach (`$l in `$driveLetters) { if (-not (Get-PSDrive `$l -ErrorAction SilentlyContinue)) { `$targetDrive = `$l; break } }
        if (`$targetDrive) {
            if (Get-PSDrive `$targetDrive -ErrorAction SilentlyContinue) { Remove-PSDrive -Name `$targetDrive -Force }
            New-PSDrive -Name `$targetDrive -PSProvider FileSystem -Root `$sharePath -Persist -ErrorAction Stop
            Write-Host ("`n>>> THANH CONG! Da ket noi den o {0}: <<<" -f `$targetDrive) -ForegroundColor Green; explorer.exe
        } else {
            Remove-PSDrive -Name 'Z' -Force -ErrorAction SilentlyContinue; New-PSDrive -Name 'Z' -PSProvider FileSystem -Root `$sharePath -Persist -ErrorAction Stop
            Write-Host ("`n>>> THANH CONG! Da ket noi den o Z: <<<") -ForegroundColor Green; explorer.exe
        }
    } catch { Write-Host "`n!!! LOI KET NOI !!!" -ForegroundColor Red; Write-Host `$_.Exception.Message -ForegroundColor Red }
}
"@ | Set-Content -Path "$packageDir\_Logic.ps1" -Encoding UTF8
Write-Host "Da tao goi huong dan thanh cong!" -ForegroundColor Green; Invoke-Item $packageDir
Write-Host "`n--- HOAN TAT ---"; Read-Host "Nhan Enter"