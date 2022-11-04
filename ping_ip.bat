@echo off

:: declaring a variable FILE with the directory of the BAT file

:: ping_ip.bat [directory]
:: Use /w to show results in "wide format" which limits the items displayed to just folders (contained within brackets) and file names with their extensions.
dir /w ping_ip.bat
:: a IF cycle has been created to check if the file is existing before proceeding
if exist ping_ip.bat goto yesfile
if not exist ping_ip.bat goto nofile
goto end
:: depending on the output of the IF condition, 2 options are created: Yesfile and nofile
:yesfile
echo.
:: output on the cmd of the result, making the user aware 
echo Congratulations you have created a Ping test File
echo.
echo Now go ahead and test your subsystems connectivity
goto end
:nofile
echo.
echo Sorry try again File ping_ip.bat NOT FOUND
:end
echo.
:: the purpose of this project is to pretend to check connectivity with subsytems of a Manager main system, which is running the batch


:: reformatting the date in order to create a daily report and log files with the date of testing
set day=%date:~7,2%
set month=%date:~4,2%
set year=%date:~10,4%
set today=%year%%month%%day%


For /F "Usebackq Delims=" %%# in (
    "servers.txt"
) do (
    Echo+
    Echo [+] Pinging: %%#

    Ping -n 1 "%%#" 1>nul && (
       Echo  %TIME%   [Node is Alive] ) || (

       Echo %TIME%    [FAILED - Check ErrorLogs!!]
   
    echo.
    echo %TIME%>>errorlogs-%today%.txt 
    tracert -h 15 -w 1000 "%%#" >>errorlogs-%today%.txt)

  
) >>PingResults-%today%.txt


Pause&Exit

