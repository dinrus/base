@echo off
rem This assumes dcollections.lib is in your link path
for %%i in (*.d) do dmd -debug %%i -L+Dinrus.lib
