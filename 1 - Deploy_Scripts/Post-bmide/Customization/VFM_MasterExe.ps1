param(
    [string]$VFMExeMapping, [string]$ExeSharedLocation
)

Foreach ($row in (Get-Content -Path $VFMExeMapping | Where {$_ -notmatch '^#.*'}|Select-String -Pattern (Get-ChildItem -Path $ExeSharedLocation| %{$_.Name}))) 
{ 
  $ExeName=$row.Line.Split('|')[0]
  $Destination=$row.Line.Split('|')[1]  
   if (!(Test-Path -path $Destination)) {New-Item $Destination -Type Directory}
   Copy-Item -Path $ExeSharedLocation\$ExeName $Destination -Force
   Write-Host "Copying $ExeName to the $Destination"
}
