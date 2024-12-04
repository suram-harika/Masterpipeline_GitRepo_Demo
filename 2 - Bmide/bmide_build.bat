set cat_sso=no
call "D:\apps_server\Siemens\cat\cat_setenv.bat"
echo %1
echo %2
echo %3
set Envconfigtxt=%1
set WorkDir=%2
set PackageName=%3
if exist %Envconfigtxt% for /F "eol=# delims=" %%A IN (%Envconfigtxt%) Do Set %%A
echo %WorkDir%\%projectLocation%\%PackageName%
echo %dependencyTemplateFolder%
echo %softwareVersion%
echo %WorkDir%\%projectLocation%\%PackageName%.log
call %TC_BIN%\bmide_generate_package -projectLocation=%WorkDir%\%projectLocation%\%PackageName% -dependencyTemplateFolder=%dependencyTemplateFolder% -softwareVersion=%softwareVersion% -log=%WorkDir%\%projectLocation%\%PackageName%.log
exit
