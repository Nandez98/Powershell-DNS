# Crear zona dns
# Jorge Fernández - 20/10/2021
cls
[string]$zona = Read-Host "Introduce el nombre de la zona"

Remove-DnsServerZone -Name $zona -Force
Add-DnsServerPrimaryZone -Name $zona -ZoneFile "$zona.dns"

Add-DnsServerResourceRecordA -Name ns1 -IPv4Address 172.20.140.111 -ZoneName $zona
Add-DnsServerResourceRecordCName -Name www -HostNameAlias ns1.$zona -ZoneName $zona
Add-DnsServerResourceRecord -Name "@" -NameServer ns1.$zona -ns -ZoneName $zona
remove-dnsserverresourcerecord -rrtype ns -name "@" -zonename $zona -force

$nuevosoa = Get-DnsServerResourceRecord -rrtype SOA -ZoneName $zona
$viejosoa = Get-DnsServerResourceRecord -rrtype SOA -ZoneName $zona

$nuevosoa.recorddata.SerialNumber = 2010202101
$nuevosoa.recorddata.primaryserver = "ns1.$zona"

set-dnsserverresourcerecord -OldInputObject $viejosoa `
                            -NewInputObject $nuevosoa

Remove-DnsServerResourceRecord -RRType NS -force

$misregistros = import -path "C:\Users\Administrador\Documents\GitHub\asir2sri-fernandezp2\DNS.csv" -delimiter ";"
foreach($registro in $misregistros){
    add-dnsserverrecorda -name $registro.nombre -ipv4addres $registro.ip -zonename $zona
    add-dnsserverrecordaaaa -name $registro.nombre -ipv6addres $registro.ip -zonename $zona
}