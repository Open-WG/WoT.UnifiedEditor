@echo off
@setlocal EnableDelayedExpansion
@where svn >NUL
@if %ERRORLEVEL% neq 0 (
	@where TortoiseProc.exe >NUL
	@if !ERRORLEVEL! neq 0 (
		@echo TortoiseSVN wasn't found, download file manually from https://svn-by.wargaming.net/svn/wotdev/branches/misc/heatmaps/heatmaps.sqlite3 or install TortoiseSVN
	) else (
		@set var=https://svn-by.wargaming.net/svn/wotdev/branches/misc/heatmaps/heatmaps.sqlite3
		@echo Downloading database from !var! into %~dp0heatmaps.sqlite3
		TortoiseProc.exe /command:cat /path:!var! /savepath:%~dp0heatmaps.sqlite3
		@echo Downloading complete.
	)
) else (
	@for /f %%i in ('svn info --show-item repos-root-url') do set var=%%i
	@ECHO.!var!| FIND /i "wargaming.net/svn/wotdev">Nul || (
		@set var=https://svn-by.wargaming.net/svn/wotdev
	)
	@echo Downloading database from !var!/branches/misc/heatmaps/heatmaps.sqlite3 into %~dp0heatmaps.sqlite3
	svn export !var!/branches/misc/heatmaps/heatmaps.sqlite3 %~dp0heatmaps.sqlite3 --force
)
@pause