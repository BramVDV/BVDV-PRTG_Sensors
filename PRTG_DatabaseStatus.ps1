#Requires -Module dbatools
Param (
    [String]$SqlInstance = "DC2MSQL02-DEV"
)
$jsonBase = @"
{
	"prtg": {
	 "result": [
	 
	 ]
	}
}
"@

$Dbs = Get-DbaDbState -SqlInstance $SqlInstance
$json = ConvertFrom-Json $jsonBase
Foreach ($Db in $Dbs) {
    $Obj = [PSCustomObject]@{
        Channel = $($Db.DatabaseName)
        Value = $($Db.Status)
        } #EndPSCustomObject
    $json.prtg.result += $Obj
}

Return $json | ConvertTo-Json -Depth 10
