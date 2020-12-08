Import-Module dbatools

$SqlInstance = "GEMSQL01\OBJECTIVE"

$Dbs = Get-DbaDbState -SqlInstance $SqlInstance

$jsonBase = @"
{
	"prtg": {
	 "result": [
	 
	 ]
	}
}
"@

$json = ConvertFrom-Json $jsonBase
Foreach ($Db in $Dbs) {
    $Obj = [PSCustomObject]@{
        Channel = $($Db.DatabaseName)
        Value = $($Db.Status)
        } #EndPSCustomObject
    $json.prtg.result += $Obj
}

$json | ConvertTo-Json -Depth 10 | Out-File "C:\temp\DbStatus.json" -Force
