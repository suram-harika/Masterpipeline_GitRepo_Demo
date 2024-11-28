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
$TILES_BAT=$Env_Config_Path.TILES_BAT
$TILES_PATH=$Env_Config_Path.TILES_PATH

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

$filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$TILES_PATH -Recurse -Name -attributes !Directory | Where-Object {$_ -match "\.xml$"} 
$error_level=0
$siteName=(Get-Content $TC_DATA\model\siteinfo.properties | Where-Object {$_ -match "^siteName="} ).split("=")
$mode=""

foreach ($filename in $filenames)
{
    $only_filename = $filename.split("\")
    
    if ($only_filename)
    {
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt | Where-Object {$_ -match $only_filename}
        #$found = Get-Content "D:\apps_server\devops\Delta\MasterDelta.txt" | Where-Object {$_ -match $only_filename}
        if ($found) 
        { 
            $fileName = Split-Path -Path $found -Leaf
        Write-Host $fileName
        $command = "$(pwd)/$REPOSITORY/$TILES_PATH/$TILES_BAT $fileName $TC_ROOT"
              
        
            If($env:dryrun -eq "yes")
            {
                Add-content $env:logdir/DryRunReport.txt "Installing Tiles: $command"
            }
            else
            {   
                $result=Invoke-Expression $command
                Write-Host "Printing Output: " $result
                if($result.contains("Failed to install Tiles"))
                {
                    $error_level=1
                }
            }
            break
        }
    }
}

if($error_level -eq 0)
{
    Write-Host "##vso[task.setvariable variable=taskfail]0"
}
else
{
    Write-Host "Installation of AWC Tiles failed"
    exit 1
}
