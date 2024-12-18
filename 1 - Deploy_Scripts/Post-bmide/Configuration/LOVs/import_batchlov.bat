@echo off

rem
rem   Input Argument 1: Batchlov Template XML file name to deploy
rem   Input Argument 2: TC_ROOT folder path
rem 

IF %1 == goto invalidwf_nameerror 
set TC_ROOT=%2
if not defined TC_ROOT  goto tcrooterror

if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror

set CURRENTDIR=%~dp0
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=
set "XML_FILE=%~1"
set batch_lov= %3
set LOG_FILE=%XML_FILE%.log
set LOG=%CURRENTDIR%/import_batchlov.log
echo Importing batch lov  ...
rem "%TC_BIN%\bmide_manage_batch_lovs.bat" -u=%IUID% -pf=%ipwfile% -g=dba -option=update -file="%CURRENTDIR%/PartDataSourceLOV/%XML_FILE%" -log="%CURRENTDIR%/%LOG_FILE%" >> %LOG%
"%TC_BIN%\bmide_manage_batch_lovs.bat" -u=%IUID% -pf=%ipwfile% -g=dba -option=update -file="%CURRENTDIR%/%XML_FILE%" -log="%CURRENTDIR%/%LOG_FILE%" >> %LOG%
find /c /I "ERROR:" %LOG%  && (goto error ) || ( echo Batchlov %XML_FILE% Imported Successfully!!! )



:invalidwf_nameerror
echo Supplied argument of Batchlov template name is invalid. 
goto :eof

:tcrooterror
echo Please set the TC_ROOT environment variable (Or) Use TCCommand prompt to run this batch file
goto :eof

:tcbinerror
echo Please set the TC_BIN environment variable (Or) Use TCCommand prompt to run this batch file
goto :eof

:tcdataerror
echo Please set the TC_DATA environment variable (Or) Use TCCommand prompt to run this batch file
goto :eof

:error
echo Failed to import Batchlov Template
echo FileName-%CURRENTDIR%/%XML_FILE%
goto :eof

:eof 

