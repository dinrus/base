module sys.Common;

version (Win32)
        {
/+
public static
{
ук КОНСВВОД;
ук КОНСВЫВОД;
ук КОНСОШ;
//бцел ИДПРОЦЕССА;
//ук   УКНАПРОЦЕСС;
//ук   УКНАНИТЬ;
}

static this()
{
//ИДПРОЦЕССА =  GetCurrentProcessId();
//УКНАПРОЦЕСС = cast(ук) OpenProcess(0x000F0000|0x00100000|0x0FFF,false,ИДПРОЦЕССА);
//УКНАНИТЬ  = GetCurrentThread();
			КОНСВВОД = ДайСтдДескр(ПСтд.Ввод);
			//КОНСВЫВОД = ДайСтдДескр(cast(ПСтд) 0xfffffff5);
			КОНСВЫВОД = ДайСтдДескр(ПСтд.Вывод);
			КОНСОШ = ДайСтдДескр(ПСтд.Ошибка);
}
+/	   
	  
public  import sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs, sys.uuid;

        }
/+
version (linux)
        {
        public import sys.linux.linux;
        alias sys.linux.linux posix;
        }

version (darwin)
        {
        public import sys.darwin.darwin;
        alias sys.darwin.darwin posix;
        }
version (freebsd)
        {
        public import sys.freebsd.freebsd;
        alias sys.freebsd.freebsd posix;
        }
version (solaris)
        {
        public import sys.solaris.solaris;
        alias sys.solaris.solaris posix;
        }

        +/

/*******************************************************************************

        Stuff for sysErrorMsg().

*******************************************************************************/

version (Win32)
        {
private import cidrus;
        }
else
version (Posix)
        {
        private import cidrus;
        }
else
   {
   pragma (msg, "Неподдерживаемая среда; не декларирован ни Win32, ни Posix");
   static assert(0);
   }

   
enum {
	GetFileInfoLevelStandard,
	GetFileInfoLevelMax
}

extern(C)
{
	проц  перейдиНаТочкуКонсоли( цел aX, цел aY);
	проц установиАтрыКонсоли(ПТекстКонсоли атр);
	цел гдеИксКонсоли();
	цел гдеИгрекКонсоли();
	ПТекстКонсоли дайАтрыКонсоли();
	проц сбросьЦветКонсоли();
	фук консВход();
	фук консВыход();
	фук консОш();

}