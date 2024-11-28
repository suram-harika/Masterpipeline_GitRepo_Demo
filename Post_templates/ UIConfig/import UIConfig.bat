@echo off

rem
rem   Input Argument 1: uiconfig Template XML file name to deploy
rem   Input Argument 2: TC_ROOT folder path
rem 

REM setting TC Env
set cat_sso=no
call D:\apps_server\Siemens\cat\cat_setenv.bat
set AM_BYPASS=TRUE

rem set CURRENTDIR=%~dp0
set CURRENTDIR=%3
set TC_TMP_DIR=%CURRENTDIR%
set TC_SSO_SERVICE=
set TC_SSO_APP_ID=
set "XML_FILE=%~1"
set LOG_FILE=%XML_FILE%.log
set LOG=%CURRENTDIR%/import_uiconfig.log
echo Importing uiconfig Template ...

rem %TC_ROOT%\bin\import_uiconfig.exe -u=infodba -pf="D:\TCSecure\security\tcdata12_infodba.pwf" -g=dba -file="%~dp0\config_OccMgmt.xml"
%TC_ROOT%\bin\import_uiconfig.exe -u=infodba -pf=%ipwfile% -g=dba -file=%CURRENTDIR%/%XML_FILE% -log="%CURRENTDIR%/%LOG_FILE%" >> %LOG%
