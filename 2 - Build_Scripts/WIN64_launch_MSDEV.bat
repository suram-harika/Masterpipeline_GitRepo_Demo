rem ##################################################################################
rem # set env
rem # do not put  " " around LIB and INCLUDE - PATH, cause this is made in the project-file
rem #
rem #
rem # please create YOUR OWN SECTION for host specific settings - e.g. :SN
rem ##################################################################################
 
set TC_ROOT=C:\apps\siemens\Teamcenter14
rem set AZURE_ROOT=%2
set DEV_TOOL=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.com
set WS_ROOT=C:\apps\siemens\Teamcenter14\webservice
set pwd=%2
set Solutionpath=%1
set cat_common=%pwd%/iPI/post_templates/Customization/ITK_Projects/C4CB_validateAndSetBOMMaturity/cat_common
rem set CAT_TcSC_ServerDLL=%pwd%/CRGB/post_templates/Customization/ITK_Projects/CAT_Compliance_Grading
rem set CAT_TcSC_ServerDLL=%pwd%/CRGB/post_templates/Customization/ITK_Projects/CRGB_eds_supplier_import
rem set CAT_TcSC_ServerDLL=%pwd%/CRGB/post_templates/Customization/ITK_Projects/CRGB_material_library_import
set CAT_TcSC_ServerDLL=%pwd%/%3
 
"C:\build-wrapper-win-x86\build-wrapper-win-x86-64.exe" --out-dir  build_wrapper_output_directory "%DEV_TOOL%"  "%Solutionpath%" /rebuild "Release|x64"
