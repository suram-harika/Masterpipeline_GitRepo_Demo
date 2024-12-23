param(
[string]$REPOSITORY, [string]$ENVCONFIG_PATH
)
#Write-Host "Identifying modified files"

#if ($env:taskfail -eq 1 -Or $env:jobfail -eq "true")
#{
    #Write-Host "##vso[task.setvariable variable=agent.jobstatus;]Failed"
#   Write-Host "##vso[task.complete result=Failed;]DONE"
    #return
#}
#Write-Host "##vso[task.setvariable variable=taskfail]1"

# $SOURCE_BRANCH - source tag or branch to compare 
# $DEPLOY_BRANCH - deploy tag or branch

$script:pwd = (Get-Item -Path ".\")
$Env_Config_Path = convertfrom-stringdata (get-content $pwd\$ENVCONFIG_PATH -raw)
$SOURCE_BRANCH=$Env_Config_Path.SOURCE_BRANCH
$DEPLOY_BRANCH=$Env_Config_Path.DEPLOY_BRANCH

$base_working_dir=$pwd

$ValidPath = Test-Path -Path $base_working_dir\$REPOSITORY
if ($ValidPath -eq $True) 
{
    cd $base_working_dir\$REPOSITORY
    
  #$VPath = Test-Path -PathType Any $tag_path, $branch_path

   $tag_path = Test-Path -Path "$base_working_dir\$REPOSITORY\.git\refs\tags\$DEPLOY_BRANCH"
   $branch_path = Test-Path -Path "$base_working_dir\$REPOSITORY\.git\refs\remotes\origin\$DEPLOY_BRANCH" 
   
   #for tag masterdelta.txt file creation
   if ($tag_path -eq $True) 
    {
        git diff $SOURCE_BRANCH $DEPLOY_BRANCH --name-only > MasterDelta.txt   
    }
    #for branch masterdelta.txt file creation
    elseif ($branch_path -eq $True) 
    {
        git diff origin/$SOURCE_BRANCH origin/$DEPLOY_BRANCH --name-only > MasterDelta.txt      
        #git checkout remotes/origin/$DEPLOY_BRANCH
    }
    cd ..
}
