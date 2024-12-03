@echo off

REM set tc_root=X:\Siemens\Teamcenter11
REM set tc_data=X:\Siemens\tcdata11
REM call %tc_data%\tc_profilevars.bat

set cat_sso=NO

call D:\apps_server\Siemens\cat\cat_setenv.bat
rem call X:\Siemens\Teamcenter11\cat\cat_setenv.bat
set file = %1


REM D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=remove -file="%~dp0\AWC_iPi_Tiles_Config_remove.xml"

REM D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=add -file="%~dp0\AWC_iPi_Tiles_Config_Update.xml"

call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=update -file="%~dp0\CATUpdateRequestTile.xml"

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=add -file="%~dp0\EnableNowLearningTemplate.xml" 

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=add -file="%~dp0\EnableNowLearningTile.xml" 

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=update -file="%~dp0\ElearningTile.xml" 

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=update -file="%~dp0\ELearningLinkTemplate.xml" 

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=remove -file="%~dp0\PLMDigitalTile.xml" 

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=remove -file="%~dp0\PLMDigitalTemplate.xml" 

REM call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=update -file="%~dp0\Site-TileCollection.xml" 

call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=add -file="%~dp0\Analyst.xml" 

call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=update -file="%~dp0\Analyst.xml" 

call D:\apps_server\Siemens\Teamcenter14\bin\aws2_install_tilecollections -u=infodba -pf=%ipwfile%  -g=dba -mode=update -file="%~dp0\Simulation Lead.xml" 
