@echo off
set "source=\\printserver\c$\_Stats"
set "destination=d:\_Data\_OneDrive\Erhard Rainer\Computer - Programmierung\powershell_PrintServer"

xcopy "%source%" "%destination%" /E /I /Y

for /R "%destination%" %%f in (*.json) do (
    type nul > "%%f"
)