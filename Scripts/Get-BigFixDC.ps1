# certutil -delkey -csp "Microsoft Base Smart Card Crypto Provider" "herb.martin ENC11"
# certutil -scinfo >certutilafter23.txt


Function Main {
  Get-BigFixDC @Args  
}

Function Get-BigFixDC {
  [CmdletBinding()]Param(
    [Alias('Customer','CompanyName')][Parameter(Position=0)] [string[]]$Agency = '.*',
    [Alias('PrimaryDomain')]         [Parameter(Position=1)] [string[]]$Domain = '.*',
    [Alias('ComputerNames','DC')]    [Parameter(Position=2)] [Object[]]$Servers,
    [string]$Path = "$Home\documents\Server-478.csv",
    [switch]$AllServers = $False
  )

  Begin {
    If (!$Servers) { $Servers = import-csv $Path }
  }

  Process {
    $Servers | 
      Where-Object { $AllServers -or $_.DomainController      } |         
      Where-Object { $_.PrimaryDomain | Select-String $Domain } | 
      Where-Object { $_.Company       | Select-String $Agency } | 
      Select-Object Company,ComputerName,IPAddress,OS,PrimaryDomain,Location,LastReportTime
    # | ft  Company,ComputerName,IPAddress,OS,PrimaryDomain,Location,LastReportTime
  }

  End {}
}

If (!($MyInvocation.InvocationName -eq '.')) {
  Main @Args
}
