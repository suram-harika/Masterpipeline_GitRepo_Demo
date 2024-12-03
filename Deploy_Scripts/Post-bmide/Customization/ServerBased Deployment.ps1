param(
    [string]$ExeMapping, [string]$ExeSharedLocation, [string]$serverTag
)

#$ExeMapping="C:\Users\muthuv13\Desktop\Trash\TEST.txt"
$ExeSharedLocation="\\ARWPLMD73\apps_server\Azure_Download\ipI\exe"
Foreach ($row in (Get-Content -Path $ExeMapping | Where {$_ -notmatch '^#.*'}|Select-String -Pattern (Get-ChildItem -Path $ExeSharedLocation| %{$_.Name}))) 
{ 
  $ExeName=$row.Line.Split('|')[0]
  $Destination=$row.Line.Split('|')[1]
  $Server=$row.Line.Split('|')[2]
if($serverTag -eq $server){

if (Test-Path -Path $Destination -PathType Container) {

   Copy-Item -Path $ExeSharedLocation\$ExeName $Destination -Force
   }
   else{
   Write-Host "Unable to copy $ExeName because $Destination doesn't exists"
   }
   
}    
}
