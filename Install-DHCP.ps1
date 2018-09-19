Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Restart-service dhcpserver
Add-DhcpServerInDC -DnsName controller.lab.local -IPAddress 10.200.0.5
Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
Set-DhcpServerv4DnsSetting -ComputerName "controller.lab.local" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True

Add-DhcpServerv4Scope -name "Desktops" -StartRange 10.200.0.10 -EndRange 10.200.0.154 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -OptionID 3 -Value 10.200.0.2 -ScopeID 10.200.0.0 -ComputerName controller.lab.local
Set-DhcpServerv4OptionValue -DnsDomain lab.local -DnsServer 10.200.0.5