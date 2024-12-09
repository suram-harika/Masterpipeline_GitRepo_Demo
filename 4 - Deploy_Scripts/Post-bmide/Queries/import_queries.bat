@echo off

rem
rem   Input Argument 1: Saved Queries XML file name to deploy
rem   Input Argument 2: TC_ROOT folder path
rem 

IF %1 == goto invalidquerynameerror 
set TC_ROOT=%2
if not defined TC_ROOT  goto tcrooterror
call %3

if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror

set CURRENTDIR=%~dp0
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=

set "FORMATTED_FNAME=%~1"
set LOG_FILE=%CURRENTDIR%/import_queries.log
echo Importing Saved Queries...

%TC_ROOT%\bin\plmxml_import -g=dba -u=infodba -pf=%ipwfile% -xml_file=%CURRENTDIR%/%FORMATTED_FNAME% -import_mode=overwrite >> %LOG_FILE%

find /c /I "Error" %CURRENTDIR%/import_queries.log  && (goto error ) || ( echo  Saved Queries Imported Successfully!!! )

goto :eof 

:invalidquerynameerror
echo Supplied argument of query name is invalid. 
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
echo Failed to import Saved Query
echo FileName = %CURRENTDIR%/%FORMATTED_FNAME%
goto :eof

:eof 
 
