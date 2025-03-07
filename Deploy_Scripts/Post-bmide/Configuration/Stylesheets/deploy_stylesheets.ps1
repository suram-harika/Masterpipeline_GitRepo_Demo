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
$FOLDER_PATH='Stylesheets'
$script:pwd = (Get-Item -Path ".\")
 
#Fetches the Env_Config.txt file which is in Deploy_Scripts repository.Assigns value to the below variables
$Env_Config_Path = convertfrom-stringdata (get-content $pwd\$ENVCONFIG_PATH -raw)
 
$TC_ROOT=$Env_Config_Path.TC_ROOT
$TC_DATA=$Env_Config_Path.TC_DATA
$STYLESHEET_PATH=$Env_Config_Path.STYLESHEET_PATH
$STYLESHEET_PATH=$STYLESHEET_PATH.Replace("/", "\")
#$STYLESHEET_PATH=$Env_Config_Path.RAC_PATH
#$AWC_PATH=$Env_Config_Path.AWC_PATH
$STYLESHEET_BAT=$Env_Config_Path.STYLESHEET_BAT
 
 
#Tests TC_ROOT a valid path or not
$ValidPath = Test-Path -Path $TC_ROOT
if ($ValidPath -eq $False) 
{
    Write-Host "***ERROR:Failed to find the TC_ROOT path"
    return
}
if ( $FOLDER_PATH -eq 'Stylesheets'){
#Tests TC_DATA a valid path or not
$ValidPath = Test-Path -Path $TC_DATA
if ($ValidPath -eq $False) 
{
    Write-Host "***ERROR:Failed to find the TC_DATA path"
    return
}
 
 
 
#Gets all the xmls of RAC from the Rich_client/Stylesheets path
    $filenames = Get-ChildItem -Path $pwd\$REPOSITORY\$STYLESHEET_PATH\ -Name -attributes !Directory | Where-Object {$_ -match "\.xml$"} 
    $error_value=0
    Write-Host "1"
        #Compares the filenames(i.e, xml from RAC stylesheets folder with masterdelta.txt)
        $found = Get-Content $pwd\$REPOSITORY\MasterDelta.txt 
 
foreach ($file in $found) { 
 
$FileName = [System.IO.Path]::GetFileName($file) 
 
if ($filenames -contains $FileName) { 
    Write-Host $FileName 
    $file_withoutextension = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $line =  $file_withoutextension + ", " + $FileName
        Add-Content -Path $pwd\$REPOSITORY\$STYLESHEET_PATH\input_stylesheets.txt -Value $line
                
    } }
 
    If($env:dryrun -eq "yes")
    { 
        Add-content $env:logdir/DryRunReport.txt "`n"
    }
    
#if input_stylesheet.txt exists, it will execute below statement
    if (Test-Path -Path $pwd\$REPOSITORY\$STYLESHEET_PATH\input_stylesheets.txt)
    {Write-Host "16"
        #batch file will run
        $command = "$pwd\$REPOSITORY\$STYLESHEET_PATH\$STYLESHEET_BAT $TC_ROOT $FOLDER_PATH"
        
        If($env:dryrun -eq "yes")
        {
            Add-content $env:logdir/DryRunReport.txt "Importing Stylesheets(RAC): $command"
        }
        else
        {Write-Host "7"
            Write-Host  "Execute cmd= "  $command
            $result=Invoke-Expression $command
            if($result.contains("Failed to import stylesheets"))
            {
                $error_value=1
                Write-Host  $result
            }
            
        }
    }
 
 
}
 
if ($error_value -eq 0)
{
    Write-Host "##vso[task.setvariable variable=taskfail]0"
}
else
{
   Write-Host "Style Sheet import operation failed"
   exit 1
}