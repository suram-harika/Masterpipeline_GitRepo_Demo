@echo off

rem
rem   Input Argument 1: TC_ROOT folder path
rem   Input Argument 2: Specify RAC or AWC folder name
rem 

set TC_ROOT=%1
if not defined TC_ROOT  goto tcrooterror

echo %ipwfile%
if not defined TC_BIN   goto tcbinerror
if not defined TC_DATA  goto tcdataerror

IF %2 == goto invalid_stylesheet_folder_error

set CURRENTDIR=%~dp0
rem set ARTIFACT_FOLDER=%CURRENTDIR%%2
set ARTIFACT_FOLDER=%CURRENTDIR%
set TC_TMP_DIR=%ARTIFACT_FOLDER%
rem set TC_SSO_SERVICE=
rem set TC_SSO_APP_ID=
powershell.exe -Command "Write-Host 'This is a message'"
echo %ARTIFACT_FOLDER%

%TC_BIN%\install_xml_stylesheet_datasets.exe -g=dba -u=infodba -p=infodba  -input=%ARTIFACT_FOLDER%/input_stylesheets.txt -filepath=%ARTIFACT_FOLDER% -replace>%ARTIFACT_FOLDER%/Stylesheets_Import.log

set logfile="%ARTIFACT_FOLDER%/Stylesheets_Import.log"
find /c /I "Error" %logfile%  && (goto error ) || ( echo  Stylesheet Imported Successfully!!! )
goto :eof



:invalid_stylesheet_folder_error
echo Supplied argument of stylesheet folder is invalid. Valid value are AWC/RAC
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
echo Failed to import stylesheets
echo Input File = %ARTIFACT_FOLDER%/input_stylesheets.txt
goto :eof

:eof 
