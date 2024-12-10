    Write-Host "Stopping Sevices"
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*IDSM*"} | Where-Object {$_.starttype -ne "Disabled"} |  Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more IDSM services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
 
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*portmapper*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more portmapper services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }

   try
   {
        Get-Service | Where-Object {$_.displayName -like "*Shared*Metadata*Cache*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
   }
   catch
   {
        Write-Host "Problem occured in stopping one one or more Meta data cache services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
   }

    try
    {
        Get-Service | Where-Object {$_.displayName -like "*Tomcat*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 20
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more Tomcat services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }

   try
   {
        Get-Service | Where-Object {$_.displayName -like "*Apache*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 20 
   }
   catch
   {
        Write-Host "Problem occured in stopping one one or more Apache services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
   }

   try
   {
        Get-Service | Where-Object {$_.ServiceName -like "*subscripmgrd*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
   }
   catch
   {
        Write-Host "Problem occured in stopping one one or more Subscription Manager services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
   }

   try
   {
        Get-Service | Where-Object {$_.ServiceName -like "*actionmgrd*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
   }
   catch
   {
        Write-Host "Problem occured in stopping one one or more Action Manager services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
   }

   try
   {
        Get-Process | Where-Object {$_.Path -like "*Dispatcher*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Process -Force -processname {$_.ProcessName}
        Start-Sleep -Seconds 5
   }
   catch
   {
        Write-Host "Problem occured in stopping one one or more Dispatcher/Module/Schduler services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
   }

    try
    {
        Get-Service | Where-Object {$_.displayName.StartsWith("Teamcenter")} | Where-Object {$_.displayName.Contains("Web")} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 15
    }
   catch
   {
        Write-Host "Problem occured in stopping one one or more Teamcenter Web services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
   }

    try
    {
        Get-Service | Where-Object {$_.displayName.StartsWith("Teamcenter")} | Where-Object {$_.displayName.Contains("FSC")} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more Teamcenter FSC services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }

    try
    {
        Get-Service | Where-Object {$_.displayName -like "*task*monitor*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5  
    } 
    catch
    {
        Write-Host "Problem occured in stopping one one or more Task Monitor services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }

    try
    {
        Get-Service | Where-Object {$_.displayName.StartsWith("Teamcenter")}  | Where-Object {!$_.displayName.Contains("Dispatcher")}| Where-Object {!$_.displayName.Contains("FCC")} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more Teamcenter services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*FCC *"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more FCC services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*Management Console*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more Management console services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*CodeMeter*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more Codemeter services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*SOLR*"} | Where-Object {!$_.displayName.Contains("Azure")} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more SOLR services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
    try
    {
        Get-Service | Where-Object {$_.displayName -like "*NSClient*"} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more NSClient services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
    try
    {
        Get-Service | Where-Object {$_.displayName.StartsWith("Teamcenter")} | Where-Object {$_.starttype -ne "Disabled"} | Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more Teamcenter services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
      try
    {
        Get-Service | Where-Object {$_.displayName -like "*VisPool*"} | Where-Object {$_.starttype -ne "Disabled"} |  Stop-Service -Force
        Start-Sleep -Seconds 5
    }
    catch
    {
        Write-Host "Problem occured in stopping one one or more IDSM services"
        Write-Host "Exception details: " $PSItem.Exception.Message
        $error_level=1
    }
    
 
