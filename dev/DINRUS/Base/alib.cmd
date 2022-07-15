::gendef DinrusBaseX86.dll
::pause
dlltool --def DinrusBaseX86.def --dllname DinrusBaseX86.dll --output-lib DinrusBaseX86.dll.a
pause
gcc -shared -o cyg${module}.dll \
    -Wl,--out-implib=lib${module}.dll.a \
    -Wl,--export-all-symbols \
    -Wl,--enable-auto-import \
    -Wl,--whole-archive ${old_libs} \
    -Wl,--no-whole-archive ${dependency_libs}