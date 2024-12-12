# DCM-NAR-Siemens-DevOps-Demo
Demo repository created for setting up TC DevOps Demonstrator in Azure VM labs

The purpose of this repo is to store sample configuration xml files and sample customization project files from Teamcenter installation under below the maine folder named "0 - CapGPLM" and 2 other folders namely "Deploy_Scripts" and "Build_Scripts" to demonstrate how a typical CI/CD Build/Release pipelines would work in conjunction with Teamcenter.
0. CapGPLM Custom Project
   1.1 Pre-Bmide
   1.2 Bmide
   1.3 Post-Bmide
1. Deploy_Scripts
2. Build_Scripts

We would use various configuration artifact export's batch files, provided in Teamcenter install, to export sample xml files for different UI hook points and add them under the respective sub-folders under the main 3 folders mentioned above and use combination of PowerShell/Batch scripts in Deploy-Scripts folder to setup Build and Release Pipelines
