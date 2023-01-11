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

Param(
	# YAML settings. See https://github.com/timsutton/JunielKatarn/WimXP/main/Config.yaml.template
	[System.IO.FileInfo] $Config = (Join-Path $PSScriptRoot, 'Config.yaml'),

	# Ignore interactive prompts
	[switch] $Force
)

function AutoSysPrep {
	param (
	)
	
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
