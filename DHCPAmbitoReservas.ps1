##########################################
######### Jorge Fernández        #########
######### 27/10/2021             #########
######### Crear ámbito           #########
######### DHCPAmbitoReservas.ps1 #########
######### y opsciones            #########
##########################################
cls

Remove-DhcpServerv4Scope -scopeid 172.20.140.192 -force
Add-DhcpServerv4Scope -StartRange 172.20.140.193 -EndRange 172.20.140.195 -Name AmbitoPowershell -SubnetMask 255.255.255.192 -LeaseDuration 0.8:30 #d.h.m


# Añadir opciones al ámbito.
Set-DhcpServerv4OptionValue -DnsDomain domi.com -DnsServer 172.20.140.254,8.8.8.8 -Router 192.168.50.177 -ScopeId 172.20.140.192


$i=196
$fichero = "C:\Users\Administrador\Documents\GitHub\asir2sri-fernandezp2\DHCP\DHCPAmbitoReservasMAC.csv"
Write-Host $fichero
$macs= Import-Csv -path $fichero
foreach($linea in $macs){
    $linea
    write-host $linea
    add-dhcpserverv4reservation -IPAddress 172.20.140.$i -ClientId $linea.MAC -ScopeId 172.20.140.192 
    $i++
}