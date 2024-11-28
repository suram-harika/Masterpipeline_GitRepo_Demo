@echo off

rem
rem   Input Argument 1: Input Daaset file name to deploy
rem   Input Argument 2: TC_ROOT folder path
rem 

IF %1 == goto invalid_input_file_error 
set TC_ROOT=%2
if not defined TC_ROOT  goto tcrooterror
set CAT_SSO=NO
call D:/apps_server/Siemens/cat/cat_setenv.bat

if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror

set CURRENTDIR=%~dp0
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=
set "XML_FILE=%~1"
set LOG_FILE=%XML_FILE%.log
set LOG=%CURRENTDIR%/import_ui_dataset.log
echo Importing UI Config ...

"%TC_ROOT%\bin\import_file" -u=%IUID% -pf=%ipwfile% -g=dba -type=Rv1XML -ref=Rv1XMLFile -d=RelationBrowserConf -f=%CURRENTDIR%/%XML_FILE% -de=r -log=%LOG%

find /c /I "Created dataset" %LOG%  && (echo Dataset %XML_FILE% Imported Successfully!!! ) || ( goto  error)

goto :eof

:invalid_input_file_error
echo Supplied argument of input file is invalid. 
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
echo Failed to import Dataset
echo FileName-%CURRENTDIR%/%XML_FILE%
goto :eof

:eof 
 
