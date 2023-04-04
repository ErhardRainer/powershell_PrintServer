function Get-PrintData {
    # Druckerinformationen abrufen
    $printData = Get-CimInstance 'Win32_PerfFormattedData_Spooler_PrintQueue' |
        Select-Object Name, Jobs, TotalJobsPrinted, TotalPagesPrinted

    # JSON-Daten zurückgeben
    return $printData
}

function Get-LastPrintSpoolerReset {
    # Filter für Print Spooler-Start-Events (Event ID 7036, "Service Control Manager" als Quelle und "running" als Beschreibung)
    $filterXml = @"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">
      *[System[(EventID=7036)]]
      and
      *[EventData[Data[@Name='param1']='Print Spooler']]
      and
      *[EventData[Data[@Name='param2']='running']]
    </Select>
  </Query>
</QueryList>
"@

    # Letztes Event abrufen, das den Start des Print Spoolers anzeigt
    $lastPrintSpoolerStartEvent = Get-WinEvent -FilterXml $filterXml | Select-Object -First 1

    if ($lastPrintSpoolerStartEvent) {
        return $lastPrintSpoolerStartEvent.TimeCreated
    } else {
        return $null
    }
}

##########

# Allgemeine Pfade
$printspooler = "C:\_Stats\Print_Spooler\"
$printdiff = "C:\_Stats\Print_Spooler_Differences\"

# Aktuelles Datum und Uhrzeit im gewünschten Format generieren
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# Letzte JSON-Datei im aktuellen Verzeichnis suchen
$lastJsonFile = Get-ChildItem -Path $printspooler -Filter *.json | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
$lastPrintSpoolerReset = Get-LastPrintSpoolerReset

$printData = Get-PrintData
if ($lastJsonFile) {
    # Wenn eine JSON-Datei vorhanden ist, lese sie aus und speichere sie in einem Objekt
    $jsonDataFromFile = Get-Content -Path $lastJsonFile.FullName | ConvertFrom-Json

    # Vergleiche die $printData und $jsonDataFromFile, indem du die Differenz der TotalJobsPrinted und TotalPagesPrinted berechnest
    $differences = @()
    foreach ($printerData in $printData) {
        $printerName = $printerData.Name

        # Suche das passende Druckerobjekt in $jsonDataFromFile basierend auf dem Namen
        $matchingPrinterDataFromFile = $jsonDataFromFile | Where-Object { $_.Name -eq $printerName }

        if ($matchingPrinterDataFromFile -and $lastJsonFile.LastWriteTime -gt $lastPrintSpoolerReset) {
            $diffTotalJobsPrinted = $printerData.TotalJobsPrinted - $matchingPrinterDataFromFile.TotalJobsPrinted
            $diffTotalPagesPrinted = $printerData.TotalPagesPrinted - $matchingPrinterDataFromFile.TotalPagesPrinted
        } else {
            $diffTotalJobsPrinted = $printerData.TotalJobsPrinted
            $diffTotalPagesPrinted = $printerData.TotalPagesPrinted
        }
        $differences += New-Object -TypeName PSObject -Property @{
            Name                 = $printerName
            DiffTotalJobsPrinted  = $diffTotalJobsPrinted
            DiffTotalPagesPrinted = $diffTotalPagesPrinted
        }
    }

    # Filtere die Elemente heraus, deren Name mit "_" beginnt
    $filteredDifferences = $differences | Where-Object { $_.Name -notlike "_*" }

    # Zeige die gefilterten Differenzen an
    $filteredDifferences | Select-Object Name, DiffTotalJobsPrinted, DiffTotalPagesPrinted | Format-Table -AutoSize

    # Speichere die gefilterten Differenzen als JSON im Ordner $printdiff
    $diffFilename = "{0}.json" -f $timestamp
    $diffFilename = Join-Path -Path $printdiff -ChildPath $diffFilename
    $filteredDifferencesJson = $filteredDifferences | Select-Object Name, DiffTotalJobsPrinted, DiffTotalPagesPrinted | ConvertTo-Json
    Set-Content -Path $diffFilename -Value $filteredDifferencesJson
}

# Schreiben der Datei
# Ergebnis als JSON konvertieren
$jsonData = $printData | ConvertTo-Json

# JSON-Dateinamen mit Zeitstempel erstellen
$jsonFilename = "{0}.json" -f $timestamp
$jsonFilename = Join-Path -Path $printspooler -ChildPath $jsonFilename

# JSON-Daten in die Datei schreiben
Set-Content -Path $jsonFilename -Value $jsonData 
