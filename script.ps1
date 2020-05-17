#Script requires stageVar variable in release variables set to Release scope

param ( [string] $expVar )
#region variables
$ReleaseVariableName = 'StageVar'
$releaseurl = ('{0}{1}/_apis/release/releases/{2}?api-version=5.0' -f $($env:SYSTEM_TEAMFOUNDATIONSERVERURI), $($env:SYSTEM_TEAMPROJECTID), $($env:RELEASE_RELEASEID)  )
#endregion


#region Get Release Definition
Write-Host "URL: $releaseurl"
$Release = Invoke-RestMethod -Uri $releaseurl -Headers @{
    Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"
}
#endregion

#region Output current Release Pipeline
Write-Output ('Release Pipeline variables output: {0}' -f $($Release.variables | ConvertTo-Json -Depth 10))
#endregion


#region Update StageVar with new value
$release.variables.($ReleaseVariableName).value = "$expVar"
#endregion

#region update release pipeline
Write-Output ('Updating Release Definition')
$json = @($release) | ConvertTo-Json -Depth 99
Invoke-RestMethod -Uri $releaseurl -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN" }
#endregion

#region Get updated Release Definition
Write-Output ('Get updated Release Definition')
Write-Host "URL: $releaseurl"
$Release = Invoke-RestMethod -Uri $releaseurl -Headers @{
    Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"
}
#endregion

#region Output Updated Release Pipeline
Write-Output ('Updated Release Pipeline variables output: {0}' -f $($Release.variables | ConvertTo-Json -Depth 10))
#endregion
