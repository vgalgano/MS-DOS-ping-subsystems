# MS-DOS-ping-subsystems
MS-DOS script has been created which reads in a text file “servers.txt” with IP addresses and uses the ping command to find out alive machines on the network


The purpose of this project is to simulate a Manager server which will test connectivity with subsytems. This Main Manager will run (or autorun periodically) this batch file creating a Report called PingResult and a ErrorLogs files.

Description of the file:
@echo off
:: @echo off prevents the prompt and contents of the batch file from being displayed, so that only the output is visible.
:: declaring a variable FILE with the directory of the BAT file
:: notepad.exe ping_ip.bat [directory]
:: Use /w to show results in "wide format" which limits the items displayed to just folders (contained within brackets) and file names with their extensions.
 dir /w ping_ip.bat
:: will show where the ping_ip is located
:: a IF cycle has been created to check if the file is existing before proceeding
if exist ping_ip.bat goto yesfile
if not exist ping_ip.bat goto nofile
goto end
:: depending on the output of the IF condition, 2 options are created: Yesfile and nofile
:yesfile
echo. 
:: empty row
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

:: the purpose of this project is to simulate a server which will test connectivity with subsytems of a Manager main system.
:: This Main Manager will run (or autorun periodically) this batch file creating a Report called PingResult and a ErrorLogs files
:: reformatting the date is needed in order to create a daily report and log files with the date of testing;
:: in this way less confusion is made and a more organized way to check reports and logs files.
::appending with %date:~-4,4% the last 4 characters of the current date which is the year
::appending with %date:~-10,2% the tenth and ninth characters from right side of the current date which is the month
::appending with %date:~-7,2% the seventh and sixth characters from right side of the current date which is the day.
set day=%date:~7,2% 
set month=%date:~4,2%
set year=%date:~10,4%
set today=%year%%month%%day%

Cycle FOR
::File "servers.txt" is opened, read and processed. File “servers.txt” can be modified with different IP addresses or with wrong typo such as 2.wer.3.ed or 1.3.2 to check how the system responds to it.

::Processing consists of reading in the file, breaking it up into individual lines of text and then parsing ::each line into zero or more tokens. The body of the for loop is then called with the variable value(s) set ::to the found token string(s).
::By default, /F passes the first blank separated token from each line of each file.
::Blank lines are skipped.
:: usebackq specifies that the new semantics are in force, where a back quoted string is executed as a ::command 
::Delims =>  Delimiters separate one parameter from the next - they split the command line up into ::words. "delims=<tab><space>"
:: %%# is the new string and will be considered the variable of the FOR loop
:: ping -n 1 will ping the variable %%# from "servers.txt" only once. -n option specifies the number of ::echo Request messages be sent. The default is 4.
:: && runs the second command on the line when the first command comes back successfully (1>null  => ::i.e. errorlevel == 0 ). The opposite of && is || , which runs the second command when the first ::command is unsuccessful (i.e. errorlevel != 0 )
:: Echo. will create a blank row
:: Echo [+] Pinging: %%# will report the Ping attempt to the specific string %%#
:: Echo  %TIME%   [Node is Alive] will report the time of the ping and, if ping successful, will report the ::message and the related
:: Echo %TIME%    [FAILED - Check ErrorLogs!!] => in the event the ping is unsuccessful, Time stamp and ::error message will be recorded
:: echo %TIME%>>errorlogs-%today%  will initialize the error log file with Time stamp and keep writing ::on the same file (>>)
:: tracert -d -h 15 -w 1000 "%%#" >>errorlogs-%today% will traceroute the signal up to 15 hoops, with a ::max of 1ms time response and write on the same file initialize on the step above. This is a further step ::created on purpose to further troubleshoot the issue with that specific IP address.
:: >>PingResults-%today% will report the date and result of the ping file only.   


For /F "Usebackq Delims=" %%# in (
    "servers.txt"
) do (
    Echo.
    Echo [+] Pinging: %%#
    Ping -n 1 "%%#" 1>nul && (
       Echo  %TIME%   [Node is Alive] ) || (
       Echo %TIME%    [FAILED - Check ErrorLogs!!]
    echo %TIME%>>errorlogs-%today%.txt 
    tracert -d -h 15 -w 1000 "%%#" >>errorlogs-%today%.txt)
    echo.

  ) >>PingResults-%today%.txt

 

Pause&Exit

