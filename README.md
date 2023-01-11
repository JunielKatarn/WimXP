# Create Modern Windows XP Installation Image

Port of [XP2ESD](https://forums.mydigitallife.net/threads/tool-xp2esd-create-modern-windows-xp-installer-v1-6-2.82935/) by [George King](https://forums.mydigitallife.net/members/george-king.80650/).

Key differences with XP2ESD:
- WimXP supports Hyper-V, a Windows component, which reduces the number of third-party dependencies.

## System Requirements

### Environment
- Windows 10 or later

### Software
- 7Zip
- PowerShell modules:
  - powershell-yaml
- Virtualization (either of the following):
  - Hyper-V
  - VirtualBox

## Usage
```pwsh
# -Config defautls to 'Config.yaml'
ConvertTo-WimXP.ps1 -Config $pathToConfigFile
```

## References

- XP2ESD - Create modern Windows XP installer\
  https://forums.mydigitallife.net/threads/tool-xp2esd-create-modern-windows-xp-installer-v1-6-2.82935/
