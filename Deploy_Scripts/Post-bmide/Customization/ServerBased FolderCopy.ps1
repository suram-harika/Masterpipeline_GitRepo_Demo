param(
    [string]$FolderMapping, [string]$FolderSharedLocation, [string]$serverTag
)
#$FolderMapping="C:\Users\muthuv13\Desktop\Trash\FolderCopy.txt"
#$FolderSharedLocation="C:\Users\muthuv13\Desktop\Trash\zip\catroottools"
Foreach ($row in (Get-Content -Path $FolderMapping | Where {$_ -notmatch '^#.*'}|Select-String -Pattern (Get-ChildItem -Path $FolderSharedLocation| %{$_.Name}))) 
{ 
  $FolderName=$row.Line.Split('|')[0]
  $Destination=$row.Line.Split('|')[1]
  $Server=$row.Line.Split('|')[2]
if($serverTag -eq $server){  
  $sourceDir="$FolderSharedLocation\$FolderName"
  $DestinationDir="$Destination"  
   if (!(Test-Path -path $Destination)) {New-Item $Destination -Type Directory}
   Copy-Item -Path $sourceDir $DestinationDir -Force -Recurse
   Write-Host "Copying $FolderName to the $Destination"
}
}
 
