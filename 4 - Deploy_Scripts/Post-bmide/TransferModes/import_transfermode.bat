@echo off

rem bat file for closurerule, transferoptionset, transfermode deployment
rem   Input Argument 1: XML file name to deploy
rem   Input Argument 2: TC_ROOT folder path
rem 

IF %1 == goto invalidnameerror 
set TC_ROOT=%2
if not defined TC_ROOT  goto tcrooterror
if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror

set CURRENTDIR=%~dp0
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=

echo "%CURRENTDIR%%~1"
echo "%~1"
set LOG=%CURRENTDIR%/import_transfermode.log
echo Importing TransferMode...
rem "%TC_BIN%\plmxml_import" -g=dba -u=infodba -pf=%ipwfile% -xml_file="%CURRENTDIR%%~1" -import_mode=overwrite
rem "%TC_BIN%\tcxml_import.exe" -u=infodba -pf=%ipwfile% -g=dba -file="%CURRENTDIR%%~1" -scope_rules_mode=overwrite >> %LOG%
%TC_BIN%\plmxml_import.exe -u=infodba -pf=%ipwfile% -g=dba -xml_file=%CURRENTDIR%%~1 -import_mode=overwrite >> %LOG%

find /c /I "Error" %LOG%  && (goto error ) || ( echo %XML_FILE% Imported Successfully!!!)

goto :eof

if errorlevel 1 goto error
echo Imported Successfully!!!
goto :eof 

:invalidnameerror
echo Supplied argument of file name is invalid. 
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
echo Failed to import
goto :eof

:eof 
 
