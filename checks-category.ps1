# In diesem Skript lese ich die Eingabedatei Zeile für Zeile und analysiere die Kategorien und IPs.
# Die Funktion RunTests führt die gleichen Tests wie zuvor aus und zeigt die Ergebnisse für jede
# Kategorie und jedes Element an.

# Lese die Eingabedatei

$inputFile = "C:\Users\Grubelnik.ZEINTLINGER\eingabedatei.txt"
$inputContent = Get-Content -Path $inputFile

# Erstelle ein assoziatives Array, um die Kategorien und ihre IPs zu speichern
$categories = @{}
$currentCategory = ""

# Verarbeite jede Zeile in der Eingabedatei
foreach ($line in $inputContent) {
    # Prüfe, ob die Zeile eine Kategorie ist (z.B. "Drucker:")
    if ($line -match "^(.*):$") {
        $currentCategory = $matches[1].Trim()
        $categories[$currentCategory] = @{}
    }
    # Prüfe, ob die Zeile eine IP-Adresse ist (z.B. "Drucker1: 192.168.1.146")
    elseif ($line -match "^(.*): (.*)$") {
        $name = $matches[1].Trim()
        $ip = $matches[2].Trim()
        $categories[$currentCategory][$name] = $ip
    }
}

# Funktion zur Ausführung der Tests
function RunTests($category, $name, $ip) {
    Write-Host "Analyzing $category - $name ($ip)"

    # Ping prüfen
    $pingResult = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue
    if ($pingResult -ne $null) {
        Write-Host "Ping successful to $ip"

        # NSLookup durchführen
        $nslookupResult = Resolve-DnsName -Name $ip -ErrorAction SilentlyContinue
        if ($nslookupResult -ne $null) {
            $ipAddress = $nslookupResult.IPAddress
            Write-Host "NSLookup result: $ipAddress"

            # Portscan durchführen
            # $commonTCPPorts = 80, 443, 22
            $Ports = 80,445,443,22,53,2000
            foreach ($port in $Ports) {
            #$portscanResult = Test-NetConnection -ComputerName $ip -Port $commonTCPPorts -ErrorAction SilentlyContinue
            $portscanResult = Test-NetConnection -ComputerName $ip -Port $port -ErrorAction SilentlyContinue
                if ($portscanResult -ne $null) {
                    foreach ($portResult in $portscanResult) {
                        if ($portResult.TcpTestSucceeded) {
                            Write-Host "Port $($portResult.RemotePort) is open on $ip"
                        } else {
                            Write-Host "Port $($portResult.RemotePort) is closed on $ip"
                        }
                    }
                } else {
                    Write-Host "Portscan failed"
                }
            }
        } else {
            Write-Host "NSLookup failed"
        }
    } else {
        Write-Host "Ping failed"
    }

    Write-Host "`n"
}

# Durchlaufe die Kategorien und führe Tests aus
foreach ($category in $categories.Keys) {
    foreach ($entry in $categories[$category].Keys) {
        $ip = $categories[$category][$entry]
        RunTests -category $category -name $entry -ip $ip
    }
}
