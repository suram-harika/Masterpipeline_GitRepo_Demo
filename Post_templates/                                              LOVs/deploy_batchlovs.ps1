
# if ($env:taskfail -eq 1 -Or $env:jobfail -eq "true")
# {
#   Write-Host "##vso[task.setvariable variable=agent.jobstatus;]Failed"
#Write-Host "##vso[task.complete result=Failed;]DONE"
#   return
# }
# Write-Host "##vso[task.setvariable variable=taskfail]1"
param(
[string]$REPOSITORY, [string]$ENVCONFIG_PATH
)

$script:pwd = (Get-Item -Path ".\")

$Env_Config_Path = convertfrom-stringdata (get-content $pwd\$ENVCONFIG_PATH -raw)
$TC_ROOT=$Env_Config_Path.TC_ROOT
$TC_DATA=$Env_Config_Path.TC_DATA
$BATCHLOV_PATH=$Env_Config_Path.BATCHLOV_PATH
$BATCHLOV_BAT=$Env_Config_Path.BATCHLOV_BAT
#$PARTDATA_FOLDER=$Env_Config_Path.PARTDATA_FOLDER
#$SUPPLIER_FOLDER=$Env_Config_Path.SUPPLIERDATA_FOLDER

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

$filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$BATCHLOV_PATH -Recurse -Name -attributes !Directory | Where-Object {$_ -match "\.xml$"} 
#Write-Host $filenames
$error_level=0
$siteName=(Get-Content $TC_DATA\model\siteinfo.properties | Where-Object {$_ -match "^siteName="} ).split("=")
$batchlov= @("$BATCHLOV_PATH","$BATCHLOV_PATH")
#$batchlov= @("$BATCHLOV_PATH/$PARTDATA_FOLDER","$BATCHLOV_PATH/$SUPPLIERDATA_FOLDER")

foreach ($filename in $filenames)
{
    $only_filename = $filename.split("\")
    $only_filename=$only_filename[$only_filename.Length-1]
    #Write-Host "file=" $only_filename 
    if ($only_filename)
    {
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt | Where-Object {$_ -match $only_filename} 
        Write-Host "found="$found
        if ($found) 
        {
            $match=$found
            $found = $found -replace "/$only_filename" , ""
            
            if ($found -in $batchlov)   
            {
                    $found = $found.split("/")
                    $found=$found[$found.Length-1]
                    $command = "$(pwd)/$REPOSITORY/$BATCHLOV_PATH/$BATCHLOV_BAT `"$only_filename`" $TC_ROOT  $found"
                

                If($env:dryrun -eq "yes")
                {
                    Add-content $env:logdir/DryRunReport.txt "Importing Batchlov Template: $command"
                }
                else
                {
                    Write-Host  "Execute cmd="  $command
                    $result = Invoke-Expression $command
                    if($result.contains("Failed to import Batchlov Template"))
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
                        $command = "$(pwd)/$REPOSITORY/$BATCHLOV_PATH/$BATCHLOV_BAT `"$only_filename[$only_filename.Length-1]`" $TC_ROOT"

                        If($env:dryrun -eq "yes")
                        {
                            Add-content $env:logdir/DryRunReport.txt "Importing Batchlov Template: $command"
                        }
                        else
                        {
                            Write-Host  "Execute cmd="  $command
                            $result = Invoke-Expression $command
                            
                            if($result.contains("Failed to import Batchlov Template"))
                            {
                                Write-Host $result
                                $error_level=1
                            }
                        }
                    }
                }
            }       
        }
        else
        {
        Write-Host  "BatchLOV imported succesfully" 
        }
    }
}

if($error_level -eq 0)
{
    Write-Host "##vso[task.setvariable variable=taskfail]0"
}
else
{
    Write-Host "Importing of Batchlov failed"
    exit 1
}
