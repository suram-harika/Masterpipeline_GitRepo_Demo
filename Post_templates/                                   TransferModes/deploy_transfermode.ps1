param(
[string]$REPOSITORY, [string]$ENVCONFIG_PATH
)

# if ($env:taskfail -eq 1 -Or $env:jobfail -eq "true")
# {
#   Write-Host "##vso[task.setvariable variable=agent.jobstatus;]Failed"
#   Write-Host "##vso[task.complete result=Failed;]DONE"
#   return
# }
# Write-Host "##vso[task.setvariable variable=taskfail]1"

$script:pwd = (Get-Item -Path ".\")

$Env_Config_Path = convertfrom-stringdata (get-content $pwd\$ENVCONFIG_PATH -raw)
$TC_ROOT=$Env_Config_Path.TC_ROOT
$TC_DATA=$Env_Config_Path.TC_DATA
$TRANSFERMODE_PATH=$Env_Config_Path.TRANSFERMODE_PATH
$TRANSFERMODE_BAT=$Env_Config_Path.TRANSFERMODE_BAT

$ValidPath = Test-Path -Path $TC_ROOT
if ($ValidPath -eq $False) 
{
    Write-Host "***ERROR:Failed to find the TC_ROOT path"
    return
}

$ValidPath = Test-Path -Path $TC_DATA
if ($ValidPath -eq $False) 
{
    Write-Host "***ERROR:Failed to find the TC_DATA path"
    return
}

If($env:dryrun -eq "yes")
{ 
    Add-content $env:logdir/DryRunReport.txt "`n"
}

$filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$TRANSFERMODE_PATH -Recurse -Name -attributes !Directory | Where-Object {$_ -match "\.xml$"} 

$siteName=(Get-Content $TC_DATA\model\siteinfo.properties | Where-Object {$_ -match "^siteName="} ).split("=")
$siteName = $siteName.split(" ")
if($siteName.length -eq 2)
{
    $siteName  = $siteName[1]
}
$error_level=0
foreach ($filename in $filenames)
{
    $filename = $filename.replace("\","/")
    $full_name = $filename
    if ($full_name)
    {
        $full_name = "$TRANSFERMODE_PATH/$full_name"
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt | Where-Object {$_ -match $full_name} 

        $match=$found
    
        if ($found) 
        {
            $full_name_list = $full_name.split("/")
            $only_filename =  $full_name_list[$full_name_list.length-1]
            
            $pathfolder = $found -replace "/$only_filename" , ""
            
            if ($pathfolder -eq "$TRANSFERMODE_PATH")
            {
                $command = "$(pwd)/$REPOSITORY/$TRANSFERMODE_PATH/$TRANSFERMODE_BAT  $filename $TC_ROOT"
                If($env:dryrun -eq "yes")
                {
                    Add-content $env:logdir/DryRunReport.txt "Importing Transfer Mode: $command"
                }
                else
                {
                    Write-Host  "Execute cmd= "  $command
                    $result = Invoke-Expression $command
                    if($result.contains("Failed to import TransferMode"))
                    {
                        Write-Host $result
                        $error_level=1
                    }
                }
            }
            else
            {
                if($match.contains($siteName))
                {
                    $command = "$(pwd)/$REPOSITORY/$TRANSFERMODE_PATH/$TRANSFERMODE_BAT  $filename $TC_ROOT"
                    If($env:dryrun -eq "yes")
                    {
                        Add-content $env:logdir/DryRunReport.txt "Importing Transfer Mode: $command"
                    }
                    else
                    {
                        Write-Host  "Site Specific - Execute cmd= "  $command
                        $result = Invoke-Expression $command
                        if($result.contains("Failed to import TransferMode"))
                        {
                            Write-Host $result
                            $error_level=1
                        }
                    }
                }
            }       
        }
    }
}

if($error_level -eq 0)
{
    Write-Host "##vso[task.setvariable variable=taskfail]0"
}
else
{
    Write-Host "Transfer Mode Import failed"
    exit 1
}
