param(
[string]$REPOSITORY, [string]$ENVCONFIG_PATH
)
#if ($env:taskfail -eq 1 -Or $env:jobfail -eq "true")
#{
#   Write-Host "##vso[task.setvariable variable=agent.jobstatus;]Failed"
#   Write-Host "##vso[task.complete result=Failed;]DONE"
#   return
#}
#Write-Host "##vso[task.setvariable variable=taskfail]1"

$script:pwd = (Get-Item -Path ".\")
$Env_Config_Path = convertfrom-stringdata (get-content $pwd\$ENVCONFIG_PATH -raw)
$TC_ROOT=$Env_Config_Path.TC_ROOT
$TC_DATA=$Env_Config_Path.TC_DATA
$Organization_path=$Env_Config_Path.Organization_path
$Organization_bat=$Env_Config_Path.Organization_bat
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

$script:pwd = (Get-Item -Path ".\")

$filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$Organization_path -Recurse -Name -attributes !Directory | Where-Object {$_ -match "\.txt$"} 

$siteName=(Get-Content $TC_DATA\model\siteinfo.properties | Where-Object {$_ -match "^siteName="} ).split("=")
$siteName = $siteName.split(" ")
if($siteName.length -eq 2)
{
    $siteName  = $siteName[1]
}
Write-Host "sitename= " $siteName
If($env:dryrun -eq "yes")
{ 
    Add-content $env:logdir/DryRunReport.txt "`n"
}
$error_level=0
foreach ($filename in $filenames)
{
    $filename = $filename.replace("\","/")
    $full_name = $filename
    if ($full_name)
    {
        $full_name = "$Organization_path/$full_name"
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt | Where-Object {$_ -match $full_name} 
        $match=$found
        
        if ($found) 
        {
            $full_name_list = $full_name.split("/")
            $only_filename =  $full_name_list[$full_name_list.length-1]
            
            $pathfolder = $found -replace "/$only_filename" , ""
            
            if ($pathfolder -eq "$Organization_path")
            {
                $command = "$(pwd)/$REPOSITORY/$Organization_path/$Organization_bat $filename $TC_ROOT"
                If($env:dryrun -eq "yes")
                {
                    Add-content $env:logdir/DryRunReport.txt "Importing Non Site Specific Organization: $command"
                }
                else
                {
                    Write-Host  "Non Site Specific - Execute cmd= "  $command
                    $result = Invoke-Expression $command
                    if($result.contains("Organization Import Failed."))
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
                    $command = "$(pwd)/$REPOSITORY/$Organization_path/$Organization_bat $filename $TC_ROOT"
                    If($env:dryrun -eq "yes")
                    {
                        Add-content $env:logdir/DryRunReport.txt "Importing Site Specific Organization: $command"
                    }
                    else
                    {
                        Write-Host  " Site Specific - Execute cmd= "  $command
                        $result = Invoke-Expression $command
                        Write-Host "printing Output =" $result
                        if($result.contains("Organization Import Failed."))
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
    Write-Host "Failed to import organization"
    exit 1
}
