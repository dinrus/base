%DINRUS%\ruladaex
%DINRUS%\dsss build -full
if not exist dwt.lib (dsss_objs\D\dwt.bat)
if exist dwt.lib (move dwt.lib %DINRUS%\..\lib\rulada_eng)
pause