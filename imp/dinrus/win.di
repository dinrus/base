﻿module win;
public  import sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs, sys.uuid;
private import cidrus;
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
