@echo off
rem This assumes dcollections.lib is in your link path
dinrus
for %%i in (*.d) do dmd %%i DinrusExeMain.lib
for %%i in (*.exe) do upx %%i
for %%i in (*.exe) do call %%i
for %%i in (*.obj) do delete %%i
for %%i in (*.map) do delete %%i
