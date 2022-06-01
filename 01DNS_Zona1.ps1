# Crear zona dns
# Jorge Fernández - 20/10/2021

Remove-DnsServerZone -Name miercoles11.com -Force
Add-DnsServerPrimaryZone -Name miercoles11.com -ZoneFile miercoles11.com.dns

Add-DnsServerResourceRecordA -Name ns1 -IPv4Address 172.20.140.111 -ZoneName miercoles11.com
Add-DnsServerResourceRecordCName -Name www -HostNameAlias ns1.miercoles11.com -ZoneName miercoles11.com
Add-DnsServerResourceRecord -Name "@" -NameServer ns1.miercoles11.com -ns -ZoneName miercoles11.com

$nuevosoa = Get-DnsServerResourceRecord -rrtype SOA -ZoneName miercoles11.com
$viejosoa = Get-DnsServerResourceRecord -rrtype SOA -ZoneName miercoles11.com

$nuevosoa.recorddata.SerialNumber = 2010202101
$nuevosoa.recorddata.primaryserver = ns1.miercoles11.com

set-dnsserverresourcerecord -OldInputObject $viejosoa `
                            -NewInputObject $nuevosoa

Remove-DnsServerResourceRecord -RRType NS -force