function Get-PrintJobArrayFromEvents {
    param (
        [Parameter(Mandatory=$true)][array]$PrintEvents
    )

    # Array für die PrintJob-Objekte erstellen
    $PrintJobArray = @()

    # Druckereignisse durchlaufen und Objekte erstellen
 foreach ($Event in $PrintEvents) {
    # Schleife über Event.Properties und Ausgabe der Eigenschaften
    for ($i = 0; $i -lt $Event.Properties.Count; $i++) {
        Write-Host "Property $($i): $($Event.Properties[$i].Value)"
    }
    Write-Host ""

    $documentID = $Event.Properties[0].Value # 102 = documentID 
    $documentName = $Event.Properties[1].Value # Print Document = documentName 
    $userID = $Event.Properties[2].Value # Adminstrator = userID 
    $computerID = $Event.Properties[3].Value # \\PRINTSERVER = computerID 
    $printer = $Event.Properties[4].Value # Kyocera TASKalfa 3252ci KX = printer 
    $printerPort = $Event.Properties[5].Value  # 192.168.0.50 = printerPort 
    $sizeInBytes = $Event.Properties[6].Value# 684932 = sizeInBytes 
    $numberOfPages = $Event.Properties[7].Value # 1 = numberOfPages 
    $JobDateTime = $Event.TimeCreated.ToString('yyyy-MM-dd HH:mm:ss')

    $PrintJob = New-Object -TypeName PSObject -Property @{
    documentID = $documentID
    documentName = $documentName
    userID = $userID
    computerID = $computerID
    printer = $printer
    printerPort = $printerPort
    sizeInBytes = $sizeInBytes
    numberOfPages = $numberOfPages
    JobDateTime = $JobDateTime
    }

    $PrintJobArray += $PrintJob
    }

    return $PrintJobArray
}

# Variablen
$OutputPath = "C:\_Stats\PrintJobs"
$DateNow = Get-Date
$OutputFilename = $DateNow.ToString("yyyyMMdd-HHmmss") + ".json"
$OutputFullPath = Join-Path -Path $OutputPath -ChildPath $OutputFilename

# Ermittle die neueste Datei im Pfad
$LatestFile = Get-ChildItem -Path $OutputPath -Filter "*.json" | Sort-Object -Property Name -Descending | Select-Object -First 1

# Verwende das Erstellungsdatum der neuesten Datei als Startdatum für das Auslesen aus dem Eventlog
if ($LatestFile) {
    $StartDate = [DateTime]::ParseExact($LatestFile.BaseName, "yyyyMMdd-HHmmss", $null)
} else {
    $StartDate = (Get-Date).AddDays(-30)
}

try {
    $PrintEvents = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PrintService/Operational'; StartTime=$StartDate; ID=307} -ErrorAction Stop
}
catch [System.Exception] {
    Write-Host "Keine Ereignisse gefunden, die den angegebenen Auswahlkriterien entsprechen." -ForegroundColor red -BackgroundColor Yellow
    return
}
# Verwende die Funktion, um das PrintJobArray zu erhalten
$PrintJobArray = Get-PrintJobArrayFromEvents -PrintEvents $PrintEvents

# JSON-Datei erstellen und speichern
$JsonString = $PrintJobArray | ConvertTo-Json
Set-Content -Path $OutputFullPath -Value $JsonString -Force

# Tabelle ausgeben
$PrintJobArray | Format-Table -AutoSize