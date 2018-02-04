# chrome-kiosk

Prerequisites

* Registry key https://technet.microsoft.com/en-us/library/cc957208.aspx must be set to 0
* In Powershell folder, a windows shortcut to launch Chrome "Kiosk.lnk"


Dump files to `%userprofile%\Desktop\powershell\`

Create a shortcut in the startup folder to run `%userprofile%\Desktop\powershell\Kiosk_Startup.bat`

_Quick way to open startup folder: `Start>Run>shell:startup`_

`Kiosk.lnk` could point to:
`"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk --incognito https://url/`
