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
$WORKFLOW_BAT=$Env_Config_Path.WORKFLOW_BAT
$WORKFLOW_PATH=$Env_Config_Path.WORKFLOW_PATH

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

$filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$WORKFLOW_PATH -Recurse -Name -attributes !Directory | Where-Object {$_ -match "\.xml$"} 
$error_level=0
$siteName=(Get-Content $TC_DATA\model\siteinfo.properties | Where-Object {$_ -match "^siteName="} ).split("=")

foreach ($filename in $filenames)
{
    $only_filename = $filename.split("\")
    
    if ($only_filename)
    {
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt | Where-Object {$_ -match $only_filename} 
        
        if ($found) 
        {
            $match=$found
            $found = $found -replace "/$only_filename" , ""
            if ($found -eq "$WORKFLOW_PATH" )
            {
                $command = "$(pwd)/$REPOSITORY/$WORKFLOW_PATH/$WORKFLOW_BAT `"$only_filename`" $TC_ROOT"
                Copy-Item -Path "$pwd\$REPOSITORY\$WORKFLOW_PATH\$only_filename" -Destination "$pwd" -Recurse

                If($env:dryrun -eq "yes")
                {
                    Add-content $env:logdir/DryRunReport.txt "Importing Workflow Template: $command"
                }
                else
                {
                    Write-Host  "Execute cmd="  $command
                    $result = Invoke-Expression $command
                    if($result.contains("Failed to import Wokflow Template"))
                    {
                        Write-Host $result
                        $error_level=1
                    }
                }
            }
            else
            {
                if (($siteName.Length -eq 2 )  -and ($siteName[1]))
                {
                    if($match.contains($siteName[1]))
                    {
                        $command = "$(pwd)/$REPOSITORY/$WORKFLOW_PATH/$WORKFLOW_BAT `"$only_filename[$only_filename.Length-1]`" $TC_ROOT"

                        If($env:dryrun -eq "yes")
                        {
                            Add-content $env:logdir/DryRunReport.txt "Importing Workflow Template: $command"
                        }
                        else
                        {
                            Write-Host  "Execute cmd="  $command
                            $result = Invoke-Expression $command
                            
                            if($result.contains("Failed to import Wokflow Template"))
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
}

if($error_level -eq 0)
{
    Write-Host "##vso[task.setvariable variable=taskfail]0"
}
else
{
    Write-Host "Importing of workflows failed"
    exit 1
}
