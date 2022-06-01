# Crear treinta zonas DNS.
# Jorge Fernández - 21/10/2021

cls
$sufijo="systems"
for($i=1;$i-ne31;$i++){
    if($i-lt10){$zona= "fernandez0$i.$sufijo"
    }else{$zona= "fernandez$i.$sufijo"}

    Remove-DnsServerZone -Name $zona -Force
    Add-DnsServerPrimaryZone -Name $zona -ZoneFile "$zona.dns"
    Add-DnsServerResourceRecord -name "@" -NameServer ns1.$zona -NS -ZoneName $zona
    Add-DnsServerResourceRecord -name "@" -NameServer ns2.$zona -NS -ZoneName $zona
    Add-DnsServerResourceRecordA -IPv4Address 172.20.140.111 -Name ns1 -ZoneName $zona
    Add-DnsServerResourceRecordA -IPv4Address 172.20.140.254 -Name ns2 -ZoneName $zona
}


# Añadir como secundarias en el 254.
cls
$sufijo="systems"
for($i=1;$i-ne31;$i++){
    if($i-lt10){$zona= "fernandez0$i.$sufijo"
    }else{$zona= "fernandez$i.$sufijo"}
    Add-DnsServerSecondaryZone -Name $zona -ZoneFile "$zona.dns" -MasterServers 172.20.140.111 -ComputerName 172.20.140.254
}

# Para borrar.
cls
$sufijo="systems"
for($i=1;$i-ne31;$i++){
    if($i-lt10){$zona= "fernandez0$i.$sufijo"
    }else{$zona= "fernandez$i.$sufijo"}
    Remove-DnsServerZone -Name $zona -Force
    Remove-DnsServerZone -Name $zona -Force -ComputerName 172.20.140.254
}