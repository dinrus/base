module py;

import amigos.pyd.python, std.c;

extern(System)
{
char* GetCommandLineA();
wchar* GetCommandLineW();
}
extern(C)       char*    wcbuf;
extern(C)      size_t    wclen;
проц main(ткст[] аргс)
{

wcbuf = GetCommandLineA();
wclen = strlen(wcbuf);

 Py_Main(wclen, &wcbuf);
 }