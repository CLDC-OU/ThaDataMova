# Removes the scheduled task for ThaDataMova
$TaskName = "ThaDataMova"
$Exists = Get-ScheduledTask | Where-Object {$_.TaskName -like $TaskName}
If ($Exists) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}