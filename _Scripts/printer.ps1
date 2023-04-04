<#
.SYNOPSIS
    Listet Druckerinformationen für den aktuellen Computer auf und speichert sie als JSON-Datei.

.DESCRIPTION
    Das Skript erfasst Druckerinformationen für den aktuellen Computer, einschließlich Druckername, 
    Printserver, Druckertyp und PortName. Die Ausgabe wird als JSON-Datei an den angegebenen 
    OutputPath gespeichert.

.PARAMETER OutputPath
    Der Pfad, an dem die Ausgabe als JSON-Datei gespeichert werden soll. Standardwert ist 
    "\\printserver\c$\_Stats\Clients".

.EXAMPLE
    .\Get-PrinterInfo.ps1 -OutputPath "C:\Temp"

.NOTES
    Erfordert Administratorrechte zum Ausführen.
#>

param(
    [string]$OutputPath = "\\printserver\c$\_Stats\Clients"
)

$Printers = Get-WmiObject -Query "SELECT * FROM Win32_Printer"
$ComputerName = (Get-WmiObject -Class Win32_ComputerSystem).Name

$PrinterInfoList = @()

foreach ($Printer in $Printers) {
    $PrinterName = $Printer.Name
    $PrintServer = $Printer.ServerName

    if ([string]::IsNullOrEmpty($PrintServer)) {
        $PrinterType = "direkt verbunden"
    } else {
        $PrinterType = "Printserver"
    }

    $PortName = $Printer.PortName

    $PrinterInfo = New-Object -TypeName PSObject -Property @{
        ComputerName = $ComputerName
        Name = $PrinterName
        ServerName = $PrintServer
        PrinterType = $PrinterType
        PortName = $PortName
    }

    $PrinterInfoList += $PrinterInfo
}

$OutputJson = $PrinterInfoList | ConvertTo-Json

# Erstelle den vollständigen Dateinamen basierend auf dem Computernamen
$OutputFileName = Join-Path -Path $OutputPath -ChildPath "$ComputerName.json"

Set-Content -Path $OutputFileName -Value $OutputJson -Force