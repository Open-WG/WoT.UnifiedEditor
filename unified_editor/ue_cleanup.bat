CALL :del_temp_files

exit /b 0

:del_temp_files
	DEL /F /Q "%localappdata%\Unified Editor\unifiededitor.uesettings"
	DEL /F /Q "%localappdata%\Unified Editor\unifiededitor_docking.layout"
	DEL /F /Q "%localappdata%\Unified Editor. Developer version\unifiededitor.uesettings"
	DEL /F /Q "unifiededitor.options"
	
	exit /b 0