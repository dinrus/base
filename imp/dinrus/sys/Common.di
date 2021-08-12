module sys.Common;

version (Win32)
        {
		public  import sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs, sys.uuid;
		
		public static
{
ук КОНСВВОД;
ук КОНСВЫВОД;
ук КОНСОШ;
бцел ИДПРОЦЕССА;
//ук   УКНАПРОЦЕСС;
ук   УКНАНИТЬ;
}

static this()
{
ИДПРОЦЕССА =  ДайИдТекущегоПроцесса();
//УКНАПРОЦЕСС = cast(ук) ОткройПроцесс(cast(ППраваПроцесса)(0x000F0000|0x00100000|0x0FFF),нет,ИДПРОЦЕССА);
УКНАНИТЬ  = ДайТекущуюНить();
    КОНСВВОД = ДайСтдДескр(ПСтд.Ввод);
    //КОНСВЫВОД = ДайСтдДескр(cast(ПСтд) 0xfffffff5);
    КОНСВЫВОД = ДайСтдДескр(ПСтд.Вывод);
    КОНСОШ = ДайСтдДескр(ПСтд.Ошибка);
}

extern(C)
{
    struct БКонсоль
    {
        alias новстр opCall;
        alias выдай    opCall;

        /// выдай a utf8 string to the консоль
        БКонсоль выдай(ткст s);
        БКонсоль ош(ткст s);
        /// выдай an unsigned integer to the консоль
        БКонсоль выдай(ulong i);
        /// выдай a новстр to the консоль
        БКонсоль новстр();
        alias новстр нс;
    }
/+	
    проц ошибнс(ткст ткт);
	проц скажибд(бдол ткт);
	проц скажинсбд(бдол ткт);
	проц скажи(ткст ткт);
	проц скажинс(ткст ткт);
	проц нс();
	проц таб();
	+/
	//цел скажиф(ткст ткт,...);
	 
	цел сравниСтроки (ткст s1, ткст s2);
	проц консЦелое (бдол i);
	проц консТкст (ткст s);
	проц консТкстОш (ткст s);
	ук адаптВыхУкз(ук укз);
	ук адаптВхоУкз(ук укз);
	проц укВызывающегоПроцесса(ук процесс);
	бцел идБазовогоПроцесса();
	ук консБуфЭкрана(); 
	проц  перейдиНаТочкуКонсоли( цел aX, цел aY);
    проц установиАтрыКонсоли(ПТекстКонсоли атр);
    цел гдеИксКонсоли();
    цел гдеИгрекКонсоли();
    ПТекстКонсоли дайАтрыКонсоли();
    проц сбросьЦветКонсоли();
	ук консВход();
	ук консВыход(); 
	ук консОш();

}

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

        Stuff for sysErrorMsg(), kindly provопрed by Regan Heath.

*******************************************************************************/

version (Win32)
        {

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