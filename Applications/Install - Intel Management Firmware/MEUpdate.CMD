@ECHO OFF

CLS

echo Updating the ME Firmware...
echo.

%~dp0meinfowin.exe -feat "M3 Autotest" -value "Enabled" > %~dp0NULL
If errorlevel 1 goto Consumer


:Corporate
IF "%PROCESSOR_ARCHITECTURE%"=="x86" GOTO Corp_32bit

:Corp_64bit
%~dp0FWUpdLcl64.exe -F %~dp0ME_11.6_Corporate_C0_LP_Production.BIN -OEMID 4C656E6F-766F-0000-0000-000000000000 -generic -allowsv
GOTO RESTART

:Corp_32bit
%~dp0FWUpdLcl.exe -F %~dp0ME_11.6_Corporate_C0_LP_Production.BIN -OEMID 4C656E6F-766F-0000-0000-000000000000 -generic -allowsv
GOTO RESTART


:Consumer
IF "%PROCESSOR_ARCHITECTURE%"=="x86" GOTO Cons_32bit

:Cons_64bit
%~dp0FWUpdLcl64.exe -F %~dp0ME_11.6_Consumer_C0_LP_Production.BIN -OEMID 4C656E6F-766F-0000-0000-000000000000 -generic -allowsv
GOTO RESTART

:Cons_32bit
%~dp0FWUpdLcl.exe -F %~dp0ME_11.6_Consumer_C0_LP_Production.BIN -OEMID 4C656E6F-766F-0000-0000-000000000000 -generic -allowsv
GOTO RESTART


:RESTART
:Shutdown.exe -r -t 10

:END
