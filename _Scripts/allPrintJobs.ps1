$sourceFolder = "C:\_Stats\PrintJobs\" # Setze den Pfad zum Ordner mit den JSON-Dateien
$allPrintJobs = "C:\_Stats\allPrintJobs.json" # Setze den Pfad zur Zieldatei

# Suche nach JSON-Dateien im Quellordner
$jsonFiles = Get-ChildItem -Path $sourceFolder -Filter "*.json"

# Erstelle ein leeres Array, um die Inhalte der JSON-Dateien zu speichern
$mergedContent = @()

# Durchlaufe alle JSON-Dateien und füge ihren Inhalt zum Array hinzu
foreach ($file in $jsonFiles) {
    $content = Get-Content $file.FullName | ConvertFrom-Json
    $mergedContent += $content
}

# Konvertiere das Array zurück in JSON und speichere es in der Zieldatei
$mergedContent | ConvertTo-Json | Set-Content $allPrintJobs