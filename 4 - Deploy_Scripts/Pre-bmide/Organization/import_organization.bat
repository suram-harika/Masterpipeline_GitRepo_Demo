@echo off
rem
rem   Input Argument 1: Organization input file to deploy
rem   Input Argument 2: TC_ROOT path value
rem 
set TC_ROOT=%2
if not defined TC_ROOT  goto tcrooterror
set CAT_SSO=NO
call %TC_ROOT%\cat\cat_setenv.bat
if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror
set CURRENTDIR=%~dp0
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=
IF %1 == goto invalid_org_file_nameerror 
set "FORMATTED_FNAME=%~1"
set LOG_FILE=%CURRENTDIR%/import_org.log
"%TC_BIN%\make_user.exe" -u=infodba -pf=%ipwfile% -file="%CURRENTDIR%/%1" update > %LOG_FILE% 2>&1
find /c /I "ERROR:" %LOG_FILE%  && (goto error ) || ( echo Organization Imported Successfully!!!)
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
:invalid_org_file_nameerror
echo Please pass a valid organization file to be passed for -file argument of make_user utility
goto :eof
:error
echo Organization Import Failed.
goto :eof

:eof 
