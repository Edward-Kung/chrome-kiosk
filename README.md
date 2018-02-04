# chrome-kiosk

Prerequisites

* Registry key https://technet.microsoft.com/en-us/library/cc957208.aspx must be set
* In Powershell folder, a windows shortcut to launch Chrome "Kiosk.lnk"

Shortcut to open startup folder, Start>Run>shell:startup

Link contents:


`"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --kiosk --incognito https://url/`
