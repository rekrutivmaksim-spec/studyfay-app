# Studyfay: generate keystore + Base64 for GitHub Secrets (Windows PowerShell)
# Run:
#   powershell -ExecutionPolicy Bypass -File .\scripts\windows\make_keystore_for_github.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== Studyfay: Keystore generator for GitHub Actions (AAB signing) ==="
Write-Host "This will create a keystore file and a Base64 string for GitHub Secrets."
Write-Host ""

$keystoreDir = Join-Path $PSScriptRoot "..\..\keystore"
$keystoreDir = [System.IO.Path]::GetFullPath($keystoreDir)
New-Item -ItemType Directory -Force -Path $keystoreDir | Out-Null

$keystorePath = Join-Path $keystoreDir "studyfay-release.jks"
$base64Path   = Join-Path $keystoreDir "studyfay-release.base64.txt"

$alias = Read-Host "Key alias (default: studyfay)"
if ([string]::IsNullOrWhiteSpace($alias)) { $alias = "studyfay" }

$storePass = Read-Host "Keystore password"
$keyPass   = Read-Host "Key password (can be same)"

try { $null = & keytool -help 2>$null } catch {
  Write-Host ""
  Write-Host "ERROR: keytool not found. Install JDK 17 and reopen PowerShell."
  exit 1
}

if (Test-Path $keystorePath) {
  Write-Host ""
  Write-Host "Keystore already exists: $keystorePath"
  $overwrite = Read-Host "Overwrite? (y/N)"
  if ($overwrite -eq "y" -or $overwrite -eq "Y") { Remove-Item $keystorePath -Force }
}

if (-not (Test-Path $keystorePath)) {
  Write-Host ""
  Write-Host "Generating keystore..."
  & keytool -genkeypair -v `
    -keystore $keystorePath `
    -alias $alias `
    -keyalg RSA -keysize 2048 -validity 10000 `
    -storepass $storePass -keypass $keyPass `
    -dname "CN=Studyfay, OU=Mobile, O=Studyfay, L=Unknown, S=Unknown, C=RU"
}

Write-Host ""
Write-Host "Encoding keystore to Base64..."
$bytes = [System.IO.File]::ReadAllBytes($keystorePath)
$base64 = [System.Convert]::ToBase64String($bytes)
Set-Content -Path $base64Path -Value $base64 -NoNewline -Encoding ascii

Write-Host ""
Write-Host "DONE ✅"
Write-Host "Keystore: $keystorePath"
Write-Host "Base64  : $base64Path"
Write-Host ""
Write-Host "GitHub Secrets to add:"
Write-Host "  KEYSTORE_BASE64  (paste Base64 file content)"
Write-Host "  KEYSTORE_PASSWORD"
Write-Host "  KEY_ALIAS"
Write-Host "  KEY_PASSWORD"
Write-Host ""
