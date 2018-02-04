cd $PSScriptRoot
# https://technet.microsoft.com/en-us/library/cc957208.aspx This needs to be set to 0
# Windows API ref https://msdn.microsoft.com/en-us/library/windows/desktop/ms633539(v=vs.85).aspx
$title_needle = "Panel |"
$title_needle = "Tablet "
$oldvalue = ""

$cs = @"
using System;
using System.Runtime.InteropServices;
public class ChangeFocus {
 [DllImport("user32.dll")]
 [return: MarshalAs(UnmanagedType.Bool)]
 public static extern bool SetForegroundWindow(IntPtr hWnd);
 }
"@
Add-Type -TypeDefinition $cs -Language CSharp -ErrorAction SilentlyContinue
Function Logger {
    param ([string] $msg = "")
    Write-Host (Get-Date).ToUniversalTime() $msg
}
function Launch-Kiosk {
    Logger "Killing all Chrome instances"
    Stop-Process -Processname Chrome
    Stop-Process -Processname Chrome -Force
    sleep 5
    Logger "Starting Chrome"
    start .\Kiosk.lnk
}
function ReFocus-Window {
    param ([int] $handle = 0)
    [void] [ChangeFocus]::SetForegroundWindow($handle)
}

Logger "Chrome kiosk monitoring started"

while ($true) {
	$processes = Get-Process | where {$_.mainWindowTitle} | where { $_.Name -eq "chrome"}
	if ($processes.Count -eq 0) {
        Logger "Chrome not running, launching"
		Launch-Kiosk
        Logger "Sleeping 30 seconds..."
	    Sleep 30
        Logger ("Changing focus on process ID: " + $process.Id + " Handle: " + $process.MainWindowHandle)
        ReFocus-Window -handle $process.MainWindowHandle
        Continue
	}
	foreach ($process in $processes) {
		$title = $process.mainWindowTitle.SubString(0,7)
		$timestamp = $process.mainWindowTitle.SubString(9)
		
		Logger ("Changing focus on process ID: " + $process.Id + " Handle: " + $process.MainWindowHandle)
		ReFocus-Window -handle $process.MainWindowHandle

        if ($title -eq $title_needle) {
			if ($timestamp -ne $oldvalue) { $oldvalue = $timestamp }
			else {
				Logger "Kiosk page hung. Kill all bots!"
				#Launch-Kiosk
			}
		}
		if ($title -ne $title_needle) {
			Logger "Kiosk page not loaded! Kill all humans!"
			Launch-Kiosk
		}
	}
	Logger "Sleeping 60 seconds..."
	Sleep 60
}