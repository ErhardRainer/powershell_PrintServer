## ACHTUNG PFADE anpassen: $scriptX
$scriptPath = "C:\_Stats\_Scripts\"

## Am Printserver zu installieren: Printer Event
$TaskName = "PRINTSERVER - Printer Event"
$TaskDescription = "Runs the script every hour"
$script1 = "Printer_Event.ps1"
$script1 = Join-Path -Path $scriptPath -ChildPath $script1

# Überprüfen, ob der Task bereits existiert und löschen, falls vorhanden
$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File $script1"
$Trigger = New-ScheduledTaskTrigger -Once -At "00:00" -RepetitionInterval (New-TimeSpan -Hours 1)
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

if ($TaskAction -and $Trigger -and $Settings -and $Principal) {
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $Trigger -Settings $Settings -Principal $Principal -Description $TaskDescription
} else {
    Write-Host "An error occurred while creating the scheduled task components."
}

## Am Printserver zu installieren: Printer Spooler
$TaskName = "PRINTSERVER - Printer Spooler"
$TaskDescription = "Runs the script every hour"
$script2 = "Spooler_PrintQueue.ps1"
$script2 = Join-Path -Path $scriptPath -ChildPath $script2

# Überprüfen, ob der Task bereits existiert und löschen, falls vorhanden
$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File $script2"
$Trigger = New-ScheduledTaskTrigger -Once -At "00:05" -RepetitionInterval (New-TimeSpan -Hours 1)
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

if ($TaskAction -and $Trigger -and $Settings -and $Principal) {
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $Trigger -Settings $Settings -Principal $Principal -Description $TaskDescription
} else {
    Write-Host "An error occurred while creating the scheduled task components."
}

## Am Printserver zu installieren: allPrintJobs
$TaskName = "PRINTSERVER - Join all Print Jobs"
$TaskDescription = "Runs the script every hour"
$script3 = "allPrintJobs.ps1"
$script3 = Join-Path -Path $scriptPath -ChildPath $script3

# Überprüfen, ob der Task bereits existiert und löschen, falls vorhanden
$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File $script3"
$Trigger = New-ScheduledTaskTrigger -Once -At "00:10" -RepetitionInterval (New-TimeSpan -Hours 1)
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

if ($TaskAction -and $Trigger -and $Settings -and $Principal) {
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $Trigger -Settings $Settings -Principal $Principal -Description $TaskDescription
} else {
    Write-Host "An error occurred while creating the scheduled task components."
}

## Am Printserver zu installieren: all Clients
$TaskName = "PRINTSERVER - all Clients"
$TaskDescription = "Runs the script every hour"
$script4 = "allClients.ps1"
$script4 = Join-Path -Path $scriptPath -ChildPath $script4

# Überprüfen, ob der Task bereits existiert und löschen, falls vorhanden
$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File $script4"
$Trigger = New-ScheduledTaskTrigger -Once -At "00:00" -RepetitionInterval (New-TimeSpan -Hours 1)
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

if ($TaskAction -and $Trigger -and $Settings -and $Principal) {
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $Trigger -Settings $Settings -Principal $Principal -Description $TaskDescription
} else {
    Write-Host "An error occurred while creating the scheduled task components."
}