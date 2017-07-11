:: Copy files locally
robocopy "%~dp0\Source" C:\DHCPServer /E /S

:: Configure Firewall Rules
C:\DHCPServer\dhcpsrv.exe -configfirewall

:: Installs Service
C:\DHCPServer\dhcpsrv.exe -install
