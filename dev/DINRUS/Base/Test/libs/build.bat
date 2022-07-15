@echo off
dinrus
for %%i in (*.d) do drc %%i DinrusX86ExeMain.lib
for %%i in (*.exe) do upx %%i
for %%i in (*.obj) do del %%i
for %%i in (*.map) do del %%i
for %%i in (*.exe) do call %%i
