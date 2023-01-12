<#
.SYNOPSIS
	Produce a modern Windows XP install image.
.DESCRIPTION
	Wraps the installation media in a Windows XP ISO into a modern WIM bootable image.
.EXAMPLE
	WimXp.ps1
	Creates a Windows XP WIM image with the settings provided by Config.yaml located in the current directory.
.EXAMPLE
	WimXp.ps1 -Config path\to\my\config.yaml
	Creates a Windows XP WIM image with the settings provided by the -Config parameter.
.NOTES
	Ported from https://forums.mydigitallife.net/threads/tool-xp2esd-create-modern-windows-xp-installer-v1-6-2.82935/
.LINK
	https://github.com/JunielKatarn/WimXP
#>

param(
	# YAML settings. See https://github.com/JunielKatarn/WimXP/main/Config.yaml.template
	[System.IO.FileInfo] $ConfigPath = (Join-Path $PSScriptRoot, 'Config.yaml'),

	# Ignore interactive prompts
	[switch] $Force
)

function AutoSysPrep {
	param (
		[Parameter(Mandatory=$true)]
		[hashtable] $Config
	)

	#TODO: Clean build paths?

	#TODO: Apply updates INI?

	if (!(Test-Path $Config.WinXPISO)) {
		Write-Error 'Windows XP disk image not found:'
		Write-Error "[$Config.WinXPISO]"
		exit
	}

	Write-Host 'Extracting ISO'

	Expand-7Zip -ArchiveFileName $Config.WinXPISO -TargetPath $Config.BuildPath
	$buildPath = [System.IO.DirecoryInfo] $Config.BuildPath
	#rd /q /s "%~dp0_output\[BOOT]" >nul

	#TODO: Support integration

	Write-Host 'Adding Auto-Sysprep'

	# Add Auto-Sysprep support files
	mkdir -Force (Join-Path $buildPath '$OEM$')
	New-Item -ItemType SymbolicLink -Value "$PSScriptRoot\Auto-Sysprep.reg" -Path "$buildPath\`$OEM`$\Auto-Sysprep.reg"
	Write-Output '[COMMANDS]' | Out-File -Encoding utf8 "$buildPath\`$OEM`$\cmdlines.txt"
	Write-Output 'regedit /s Auto-Sysprep.reg' | Out-File -Append "$buildPath\`$OEM`$\cmdlines.txt"

	mkdir -Force (Join-Path $buildPath '$OEM$' '$1')
	

	#TODO: Eventually execute this:
	#[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
	#"MyFactoryLogon"="C:\\sysprep\\Launch.cmd"



	#New-VHD -Path vm0.vhd -SizeBytes 10gb -Dynamic
	#New-VM -Name vm0 -VHDPath vm0.vhd -MemoryStartupBytes 1GB -BootDevice CD -Generation 1
	#Set-VM -Name erasme0 -CheckpointType Disabled
	#Set-VMDvdDrive -VMName vm0 -Path xp.iso
<#
pwsh.exe -Command "Remove-VM -Name %MachineName% -Force"

pwsh.exe -Command "if (Test-Path %VirtualMachinePath%\%MachineName%_DISK.%HDDType%) { Remove-Item %VirtualMachinePath%\%MachineName%_DISK.%HDDType% }"
pwsh.exe -Command "New-VHD -Path %VirtualMachinePath%\%MachineName%_DISK.%HDDType% -SizeBytes 10gb -Dynamic"
pwsh.exe -Command "New-VM -Name %MachineName% -VHDPath %VirtualMachinePath%\%MachineName%_DISK.%HDDType% -MemoryStartupBytes 1GB -BootDevice CD -Generation 1"
pwsh.exe -Command "Set-VM -Name %MachineName% -CheckpointType Disabled"
pwsh.exe -Command "Set-VMDvdDrive -VMName %MachineName% -Path %ISO%"

pwsh.exe -Command "Start-VM -Name %MachineName%"
pwsh.exe -Command "while ((Get-VM -Name %MachineName%).State -ne [Microsoft.HyperV.PowerShell.VMState]::Off) { Start-Sleep -s 5 }"

dism  /Capture-Image /ImageFile:"captured.wim" /Name:"Windows XP Professonal" /Description:"Windows XP Professional SP3+" /CaptureDir:"X:" /compress:none /checkintegrity /verify 
#>
}

# Main routine

Import-Module powershell-yaml

$config = Get-Content $Config | ConvertFrom-Yaml | Out-Null

if (! (Test-Path (Join-Path $PSScriptRoot, 'install.wim'))) {
	AutoSysPrep
}
