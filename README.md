# powershell_PrintServer
Reporting (Power BI Dashboard) about a Windows Print Server

## History
- 2023-04-05 ER initial Version

## Configuration
### PRINTSERVER
1.) Change the _Scripts\install_server.ps1: $scriptPath

2.) Install using install_Server.ps1

### CLIENTS
1.) install on all Clients - the printer.ps1

2.) Schedule the following command: .\Get-PrinterInfo.ps1 -OutputPath "C:\Temp" [Change C:\Temp to the Network Path \Clients]
