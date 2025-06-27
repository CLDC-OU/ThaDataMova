# Load .env
Get-Content .env | ForEach-Object {
  $name, $value = $_.split('=')
  if ([string]::IsNullOrWhiteSpace($name) -or $name.Contains('#')) {
    return
  }
  Set-Content env:\$name $value
}

$TaskName = "ThaDataMova"
$ScriptName = "main.ps1"
$ScriptDirectory = Get-Location
$ScriptPath = "$ScriptDirectory\$ScriptName"

$TaskDescription = "Runs the $ScriptName script in the $ScriptDirectory directory to move data files to the configured directory."

$Username = (Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem).UserName
$Credentials = Get-Credential -Username $Username

# Manually set duration far in the future to avoid overflow with using max time ([TimeSpan]::MaxValue)
$Duration = ([DateTime]::Now).AddYears(10) -([DateTime]::Now)

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" -WorkingDirectory "$ScriptDirectory"
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Days $env:THAMOVA_REDEPLOY_INTERVAL_DAYS -Hours $env:THAMOVA_REDEPLOY_INTERVAL_HOURS -Minutes $env:THAMOVA_REDEPLOY_INTERVAL_MINUTES) -RepetitionDuration $Duration

#$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Principal = New-ScheduledTaskPrincipal -UserId $Username -LogonType Password
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Hidden -RunOnlyIfNetworkAvailable -NetworkName $env:THAMOVA_REQUIRE_NETWORK -RestartCount $env:THAMOVA_FAILURE_RESTART_COUNT -RestartInterval (New-TimeSpan -Minutes 5) -ExecutionTimeLimit (New-TimeSpan -Hours 1)
$Task = New-ScheduledTask -Description $TaskDescription -Principal $Principal -Settings $Settings -Action $Action -Trigger $Trigger

# Unregister existing task
$Exists = Get-ScheduledTask | Where-Object {$_.TaskName -like $TaskName}
If ($Exists) {Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false}

$Password = $Credentials.GetNetworkCredential().Password
Register-ScheduledTask -Force -TaskName $TaskName -InputObject $Task -Password $Password -User $Username

$Credentials = ""
$Password = ""