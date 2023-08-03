﻿$inputPath = "D:\UserData\Ibraaheem\Scripts\VMWare\VM_Datastore"
$outputPath = "D:\UserData\Ibraaheem\Scripts\VMWare\VM_Datastore"

$vmList = Get-Content $inputPath\serverList.txt

if(Test-Path $outputPath\dsvmsMultiLine.xlsx){
    Remove-Item $outputPath\dsvmsMultiLine.xlsx
}

$finalOut = @()

foreach($vm in $vmList){

$vmData = Get-VM $vm
$clusterData = $vmData | Get-Cluster
$dataStoreData = $vmData | Get-Datastore

    foreach($dataStore in $dataStoreData){
        
        $out = [pscustomobject] @{
            "VM Name" = $vmData.Name
            "VM Size" = ([Math]::Round($vmData.UsedSpaceGB,2))
            "VM Cluster" = $clusterData.Name
            "VM Datastore" = $dataStore.Name
        }
        $finalOut += $out
        
    }
}

$finalOut | Export-Excel -Path $outputPath\dsvmsMultiLine.xlsx -AutoSize -AutoFilter -BoldTopRow