@echo off
if not exist upgrade_compiler.exe (
	echo Could not find upgrade_compiler.exe, please copy and rename batch_compiler.exe and try again.
	pause
	exit 1
)
@echo on
upgrade_compiler.exe -j 8 -intermediatePath ../../../../res/.temp/intermediate -report upgrade_report.html
pause
