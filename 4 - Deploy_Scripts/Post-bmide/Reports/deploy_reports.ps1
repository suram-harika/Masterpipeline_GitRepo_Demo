param(
[string]$ENVCONFIG_PATH, [string]$REPOSITORY
)

if ($env:taskfail -eq 1 -Or $env:jobfail -eq "true")
{
    Write-Host "##vso[task.setvariable variable=agent.jobstatus;]Failed"
    Write-Host "##vso[task.complete result=Failed;]DONE"
    return
}
Write-Host "##vso[task.setvariable variable=taskfail]1"

$script:pwd = (Get-Item -Path ".\")

$Env_Config_Path = convertfrom-stringdata (get-content $pwd\$ENVCONFIG_PATH -raw)
Write-Host "Printing config values from file = "$Env_Config_Path.TC_DATA

$TC_ROOT=$Env_Config_Path.TC_ROOT
$TC_DATA=$Env_Config_Path.TC_DATA
$Reports_path=$Env_Config_Path.Reports_path
$Reports_bat=$Env_Config_Path.Reports_bat

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

$filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$Reports_path -Recurse -Name -attributes !Directory | Where-Object { $_ -match "\.xml$" -Or $_ -match "\.xsl$" } 
$error_value=0
$unique_reportid = [System.Collections.ArrayList]@()

$siteName=(Get-Content $TC_DATA\model\siteinfo.properties | Where-Object {$_ -match "^siteName="} ).split("=")
$siteName = $siteName.split(" ")
if($siteName.length -eq 2)
{
    $siteName  = $siteName[1]
}

foreach ($filename in $filenames)
{
    $filename = $filename.replace("\","/")
    $full_name = $filename
    if ($full_name)
    {
        $full_name = "$Reports_path/$full_name"
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt | Where-Object {$_ -match $full_name} 
        $match=$found
    
        if ($found) 
        {
            $full_name_list = $full_name.split("/")
            $only_filename =  $full_name_list[$full_name_list.length-1]

            $pathfolder = $found -replace "/$only_filename" , ""
            $PathArr = $pathfolder.split("/")

            if ( [IO.Path]::GetExtension($only_filename) -eq '.xml')
            {
                $reportID = $PathArr[$PathArr.length-1]
                $unique_reportid.Add($reportID)
            }
            if ( [IO.Path]::GetExtension($only_filename) -eq '.xsl')
            {
                $reportID = $PathArr[$PathArr.length-2]
                $unique_reportid.Add($reportID)
            }
        }
    }
}

If($env:dryrun -eq "yes")
{ 
    Add-content $env:logdir/DryRunReport.txt "`n"
}

$unique_reportid | Sort-Object | Get-Unique | foreach {

    $command = "$(pwd)/$REPOSITORY/$Reports_path/$Reports_bat $_ $(pwd)/$REPOSITORY/$Reports_path $TC_ROOT"

    If($env:dryrun -eq "yes")
    {
        Add-content $env:logdir/DryRunReport.txt "Importing Reports: $command"
    }
    else
    {
        Write-Host  "Non Site Specific - Execute cmd= "  $command
        $result=Invoke-Expression $command
        
        if($result.contains("Failed to import reports"))
        {
            Write-Host $result
            $error_value=1
        }
    }
}

if ($error_value -eq 0)
{
    Write-Host "##vso[task.setvariable variable=taskfail]0"
}
else
{
    Write-Host "Reports Import Operation failed"
    exit 1
}
 
