@echo off

rem
rem   Input Argument 1: Workflow Template XML file name to deploy
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
set LOG_FILE=%XML_FILE%.log
set LOG=%CURRENTDIR%/import_workflow.log
echo Importing Workflow Template ...
%TC_BIN%\plmxml_import -g=dba -u=infodba -pf=%ipwfile% -xml_file=%CURRENTDIR%/%XML_FILE% -ignore_originid -transfermode=workflow_template_overwrite -log=%CURRENTDIR%/%LOG_FILE% >> %LOG%
find /c /I "ERROR:" %LOG%  && (goto error ) || ( echo Workflow template %XML_FILE% Imported Successfully!!! )


:invalidwf_nameerror
echo Supplied argument of workflow template name is invalid. 
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
echo Failed to import Wokflow Template
echo FileName-%CURRENTDIR%/%XML_FILE%
goto :eof

:eof 
