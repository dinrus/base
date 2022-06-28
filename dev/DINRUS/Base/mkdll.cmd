:::This file was developed for Dinrus Programming Language by Vitaliy Kulich
:::Copyright is by Dinrus Group.

:back
:::Setting environment variables
@set this=%DINRUS%\..\dev\dinrus\base
@set R=%DINRUS%\..\imp\dinrus
@set LIBS=%DINRUS%\..\lib\sysimport
@set LDIR=%DINRUS%\..\lib
@set DMD=%DINRUS%\drc.exe
@set DMC=%DINRUS%\dmc.exe
@set LIB=%DINRUS%\dmlib.exe
@set IMPLIB=%DINRUS%\implib.exe
@set ARCDIR=%this%\..\Arc
@set MINIDDIR=%this%\..\Minid
@set LS=%DINRUS%\ls2.exe
@set PACK=%DINRUS%\upx.exe

:::Compiling C code

%DMC% -c -o%this%\complex.obj %this%\src\rt\complex.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\critical.obj %this%\src\rt\critical.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\deh.obj %this%\src\rt\deh.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\monitor.obj %this%\src\rt\monitor.c -I%DINRUS%\..\include

%DMD% -lib -of%this%\Cdinr.lib %this%\complex.obj %this%\critical.obj %this%\deh.obj %this%\monitor.obj


:Base
:::Creating respond file
%LS% -d %this%\src\std\*.d %this%\src\*.d %this%\src\lib\*.d %this%\src\tpl\*.d %this%\src\rt\*.d %this%\src\sys\*.d %this%\src\sys\com\*.d %this%\src\math\*.d %this%\src\math\random\*.d %this%\src\time\*.d %this%\src\time\chrono\*.d %this%\src\crypto\*.d %this%\src\crypto\digest\*.d %this%\src\crypto\cipher\*.d %this%\src\text\*.d %this%\src\text\convert\*.d %this%\src\text\locale\*.d %this%\src\io\*.d %this%\src\io\device\*.d %this%\src\io\stream\*.d %this%\src\io\protocol\*.d %this%\src\col\*.d>>%this%\objs.rsp

:::Make BaseDinrus.dll

@if exist %DINRUS%\dinrus.exe %DINRUS%\dinrus.exe

%DMD% -g -O -debug -of%this%\DinrusBase.dll @%this%\objs.rsp %this%\res\base.def %this%\res\base.res %LDIR%\minit.obj %LDIR%\DImport.lib %this%\Cdinr.lib

@if not exist %this%\DinrusBase.dll pause
@if exist %this%\DinrusBase.dll goto nextStep
@del %this%\objs.rsp
@goto Base

:nextStep
:::Make its export lib
%IMPLIB% /system %this%\DinrusBaseDLL.lib %this%\DinrusBase.dll

@del %this%\CDinr.lib
@del %this%\*.rsp
@del %this%\*.obj
@del %this%\*.map
call impcoff 64 %this%\DinrusBase.dll
call impcoff 32 %this%\DinrusBase.dll
pause
exit

