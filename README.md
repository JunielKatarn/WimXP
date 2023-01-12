# Create Modern Windows XP Installation Image

Port of [XP2ESD](https://forums.mydigitallife.net/threads/tool-xp2esd-create-modern-windows-xp-installer-v1-6-2.82935/) by [George King](https://forums.mydigitallife.net/members/george-king.80650/).

Key differences with XP2ESD:
- WimXP supports Hyper-V, a Windows component, which reduces the number of third-party dependencies.

## System Requirements

### Environment
- Windows 10 or later

### Software
Tools:
- XP2ESD
  - [1.6.1](https://www.mediafire.com/file/v3efgw17yr1jy5t/XP2ESD_v1.6.1.7z/file)\
    SHA1: `869B5540E000BBFBF7C4481702508B782B41F68C`
  - [1.6.2](https://www.mediafire.com/file/qswm5z8z8iccha8/XP2ESD_v1.6.2.7z/file)\
    SHA1: `DD613BB7788CD6AEDC048996B456A0E9C9B6664E`\
    Patch. Extract on top of `1.6.1`.
- [wimlib](https://wimlib.net/downloads/index.html)

PowerShell modules:
- powershell-yaml
- 7Zip4PowerShell

Virtualization (either of the following):
- Hyper-V
- VirtualBox

## Usage
```pwsh
# -Config defautls to 'Config.yaml'
Create-WimXp.ps1 -ConfigPath $pathToConfigFile
```

## References

- XP2ESD - Create modern Windows XP installer\
  https://forums.mydigitallife.net/threads/tool-xp2esd-create-modern-windows-xp-installer-v1-6-2.82935/
