##Requires -Module dbatools
Param (
    [String]$SqlInstance = ""
)
$jsonBase = @"
{
	"prtg": {
	 "result": [
	 
	 ]
	}
}
"@

#Predefined the database statuses:
$DatabaseStatuses = @{
    ONLINE = '0'
    OFFLINE = '1'
    RESTORING = '2'
    RECOVERING = '3'
    'RECOVERY PENDING' = '4'
    SUSPECT = '5'
    EMERGENCY = '6'
}

$Dbs = Get-DbaDbState -SqlInstance $SqlInstance
$json = ConvertFrom-Json $jsonBase
Foreach ($Db in $Dbs) {
    $Obj = [PSCustomObject]@{
        Channel = $($Db.DatabaseName)
        Value = ($DatabaseStatuses.GetEnumerator() | Where-Object { $_.Name -eq $($Db.Status) }).Value
        valuelookup = "oid.ardo.databasestatus"
        } #EndPSCustomObject
    $json.prtg.result += $Obj
}

Return $json | ConvertTo-Json -Depth 10
