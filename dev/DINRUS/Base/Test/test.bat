:::Compiling and executing some test programs
@set DMD=%DINRUS%\dmd.exe
@set this=%DINRUS%\..\dev\dinrus\Base\Test

del %this%\*.exe

%DINRUS%\dinrusex
%DMD% -g -debug %this%\test2.d DinrusExeMain.lib
::%DINRUS%\upx %this%\test2.exe
pause
%this%\test2.exe

%DMD% -g -debug %this%\test.d DinrusExeMain.lib
::%DINRUS%\upx %this%\test.exe
pause
%this%\test.exe

%DMD% -g -debug %this%\testgc.d DinrusExeMain.lib
::%DINRUS%\upx %this%\testgc.exe
pause
%this%\testgc.exe

%DMD% -g -debug %this%\fiber.d DinrusExeMain.lib
::%DINRUS%\upx %this%\fiber.exe
pause
%this%\fiber.exe

:::%DMD% -run %this%\clean.d

exit