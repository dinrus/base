@echo off
rem This assumes dcollections.lib is in your link path
for %%i in (*.d) do dmd -release %%i -L+Dinrus.lib+DinrusTango.lib
