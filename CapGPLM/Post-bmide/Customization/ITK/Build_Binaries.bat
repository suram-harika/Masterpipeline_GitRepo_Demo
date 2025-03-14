@echo off

set arg=%1
set Workspace=%2
set MS_VS_HOME=%3
set TC_ROOT=%4
set TC_DATA=%5

echo %MS_VS_HOME%
IF [%TC_ROOT%] == [] (set TC_ROOT=E:\apps\Siemens\TC13\tc_root)
IF [%TC_DATA%] == [] (set TC_DATA=E:\apps\Siemens\TC13\tcdata)

call %TC_DATA%\tc_profilevars
set path=%path%;C:/Windows/System32



echo "Utility build"
set SRC_CODE_LOC=%Workspace%\CUST_Set_Effectivity
call %MS_VS_HOME%\MSBuild.exe %SRC_CODE_LOC%\CUST_Set_Effectivity.sln -m -property:Configuration=Release
REM echo %path%
echo %~dp0Binaries_output\Test
xcopy %SRC_CODE_LOC%\x64\Release\*.exe %~dp0Binaries_output /F /Y /I

goto :EOF


:EOF
endlocal