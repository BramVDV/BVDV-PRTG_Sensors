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

$Jobs = Get-DbaAgentJob -SqlInstance $SqlInstance | Where-Object { $_.LastRunOutcome -ne "Succeeded" }
$json = ConvertFrom-Json $jsonBase
Foreach ($Job in $Jobs) {
    $Obj = [PSCustomObject]@{
        Channel = $($Job.Name)
        Value = $($Job.LastRunOutcome)
        } #EndPSCustomObject
    $json.prtg.result += $Obj
}

Return $($json | ConvertTo-Json)
