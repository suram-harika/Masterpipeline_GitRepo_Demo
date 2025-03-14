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


echo "DLL build"
set SRC_CODE_LOC=%Workspace%\Teamcenter\TCCustomization\VisualStudioProject\G4_CUST_Custom
call %MS_VS_HOME%\MSBuild.exe %SRC_CODE_LOC%\libG4_CUST_Custom.sln -m -property:Configuration=Release
xcopy %SRC_CODE_LOC%\x64\Release\*.dll %~dp0Binaries_output /F /Y /I
xcopy %SRC_CODE_LOC%\x64\Release\*.lib %~dp0Binaries_output /F /Y /I
xcopy %SRC_CODE_LOC%\x64\Release\*.pdb %~dp0Binaries_output /F /Y /I
goto :EOF

:EOF
endlocal