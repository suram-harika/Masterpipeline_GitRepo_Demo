set TC_ROOT=C:\apps\siemens\Teamcenter14
set FMS_HOME=C:\apps\siemens\Teamcenter14\tccs
set JAVA_HOME=C:\apps\siemens\Java64\jdk-11.0.15.10-hotspot
rem set JRE_HOME=C:\apps\siemens\Java64\jdk-11\jre
set CLASSPATH=%TC_ROOT%\portal
set PATH=%FMS_HOME%\bin;%FMS_HOME%\lib;TC_ROOT\portal;%PATH%;C:\apache-ant-1.10.13\bin
rem start "TAO ImR" /min cmd /c "TC_ROOT\iiopservers\start_imr.bat"
set ANT_HOME=C:\apache-ant-1.10.13
