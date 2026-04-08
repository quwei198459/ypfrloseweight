# 按文件名顺序执行 database/migrations 下全部 V*.sql（不含 V014 可选脚本）
# 用法（PowerShell）:
#   cd d:\mycode\ypfrloseweight\database\migrations
#   $env:MYSQL_PWD='你的密码'   # 可选，避免交互；注意安全
#   .\run_all.ps1 -User root -Database loseweight
#
# 依赖: mysql 客户端在 PATH 中

param(
  [string]$User = "root",
  [string]$Host = "127.0.0.1",
  [int]$Port = 3306,
  [string]$Database = "loseweight"
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$files = Get-ChildItem -Path $here -Filter "V*.sql" |
  Where-Object { $_.Name -notmatch '^V014__' } |
  Sort-Object Name

foreach ($f in $files) {
  Write-Host ">>> $($f.Name)" -ForegroundColor Cyan
  $p = $f.FullName -replace '/', '\\'
  cmd.exe /c "mysql -h$Host -P$Port -u$User --default-character-set=utf8mb4 $Database < `"$p`""
  if ($LASTEXITCODE -ne 0) {
    Write-Host "FAILED: $($f.Name)" -ForegroundColor Red
    exit $LASTEXITCODE
  }
}

Write-Host "Done. (V014 optional_drop_legacy_tables.sql 未执行，需手工验收后处理)" -ForegroundColor Green
