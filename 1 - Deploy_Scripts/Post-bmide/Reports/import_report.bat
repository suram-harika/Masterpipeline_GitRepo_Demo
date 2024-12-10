@echo on

rem
rem   Input Argument 1: Report ID to import
rem   Input Argument 2: Staging Directory Folder Path
rem   Input Argument 3: TC_ROOT folder path
rem 
echo starting script
IF %1 == goto invalidreportnameerror
IF %2 == goto invalidstagedirerror  
set TC_ROOT=%3
if not defined TC_ROOT  goto tcrooterror
if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror
set CURRENTDIR=%~dp0
set DATADIR=%2
echo after datadir setting 
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=

echo %CURRENTDIR%

echo Importing Report...
"%TC_BIN%\import_export_reports" -u=infodba -pf=%ipwfile%  -g=dba -import -stageDir="%DATADIR%" -reportId=%1 -overwrite >> %CURRENTDIR%/import_export_reports.log

find /c /I "Error" %CURRENTDIR%/import_export_reports.log  && (goto error ) || ( echo  Reports Imported Successfully!!! )

goto :eof 

:invalidreportnameerror
echo Supplied argument of report name is invalid. 
goto :eof

:invalidstagedirerror
echo Supplied argument of -stageDir  name is invalid. 
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
echo Failed to import reports
echo Report Name = %1
goto :eof

:eof 

