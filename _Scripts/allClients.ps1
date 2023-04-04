$sourceDirectory = "\\printserver\c$\_Stats\Clients"
$destinationFile = "\\printserver\c$\_Stats\allclients.json"

# Hole alle JSON-Dateien im Verzeichnis
$jsonFiles = Get-ChildItem -Path $sourceDirectory -Filter "*.json"

# Initialisiere ein leeres Array, um die Daten zusammenzuführen
$mergedData = @()

# Durchlaufe alle JSON-Dateien und füge sie zur $mergedData hinzu
foreach ($file in $jsonFiles) {
    $content = Get-Content $file.FullName | ConvertFrom-Json
    $mergedData += $content
}

# Konvertiere die zusammengeführten Daten in JSON-Format und speichere sie in der Zieldatei
$mergedData | ConvertTo-Json -Depth 10 | Set-Content $destinationFile -Force