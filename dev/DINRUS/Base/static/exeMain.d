﻿module exeMain;
import dinrus, cidrus;//
/+
private
{
import  stdrusex;	
    ткст иницТекПап;
}

// Module constructor
// ----------------------------------------------
static this()
// ----------------------------------------------
{
    иницТекПап = stdrusex.дайТекПап();
	устДайТекИницПап(иницТекПап);
}
 +/
///////////////////////////////////////

 //debug=НА_КОНСОЛЬ;
		 extern (Windows)
		{
		 DWORD  GetCurrentProcessId(); 
		}

		extern (C)
		{
			бул смДобавьКорень( ук p );
			бул смДобавьПространство( ук p, т_мера разм );
			бул смСобери();
			проц максПриоритетПроцессу();
			ткст[] ртПолучиАрги(цел аргчло, сим **аргткст);
			бул рт_вЗадержке();
			бул ртПущен();
			бул ртОстановлен();
			бул ртСтарт(ПередВходом передвхо = пусто, ОбработчикИсключения дг = пусто);
			проц ртСтоп();	
			проц  ртСоздайОбработчикСледа( Следопыт h );
			Исключение.ИнфОСледе ртСоздайКонтекстСледа( ук  укз );
			проц  ртУстановиОбработчикСборки(ОбработчикСборки h);
			ткст[] дайАргиКС();
			проц перейдиНаТочкуКонсоли( цел aX, цел aY);
			проц установиАтрыКонсоли(ПТекстКонсоли атр);
			цел гдеИксКонсоли();
			цел гдеИгрекКонсоли();
			ПТекстКонсоли дайАтрыКонсоли();
			проц сбросьЦветКонсоли();
			бцел идБазовогоПроцесса();
			проц укВызывающегоПроцесса(ук п);
			ук консБуфЭкрана();
			ук консВход(); 
			ук консВыход();
			ук консОш();
			ИНФОСТАРТА дайСтартИнфо();
		}


		extern  (C) ИнфОМодуле[] _moduleinfo_array;

	//	static экз g_hInst;
		private СМ см;

		extern(C) ук указательНаИспМодуль()
		{
		  const бцел ДУБЛИРУЙ_ПРАВА_ДОСТУПА = 0x00000002;

		 ук   proc = ДайТекущийПроцесс(),
							   hndl;

		ДублируйДескр( proc, ДайДескрМодуляА(пусто), proc, &hndl, cast(ППраваДоступа) 0, да, ДУБЛИРУЙ_ПРАВА_ДОСТУПА );
						return hndl;
		}

		 extern(C) бцел идПроцесса(){return GetCurrentProcessId();} 
		 


		/////////////////////////////////////////////
		 void  ассертОбр( ткст файл = __FILE__, т_мера строка =__LINE__, ткст сооб = пусто )
		   {
			auto ex = new ПроверОшиб(сооб, файл, строка );
			ex.выведи;
		   }
		   
			проц ошиб()
				{
				бцел кодош = ДайПоследнююОшибку();
				throw new Исключение (текстСисОшибки(кодош));
				}
				
		проц стартРТ()
		{
				try
				{
					укВызывающегоПроцесса(указательНаИспМодуль());
					debug(НА_КОНСОЛЬ) скажинс("Вход в ртМодКонстр");
					см = new СМ();
						debug(НА_КОНСОЛЬ) скажинс("Создан СМ экзешника");
					см.сканируйСтатДан(см);
					нить_иниц();
					нить_прикрепиЭту();
					 _minit();			 
					 _рт.интегрируй(_moduleinfo_array);
					foreach( к; см.обходКорня )
					{
						смДобавьКорень( к );
						debug(НА_КОНСОЛЬ) скажинс("Добавление корня");
					}
					foreach( п; см.обходПространства )
						{
						смДобавьПространство( п.Низ, п.Верх - п.Низ );
						debug(НА_КОНСОЛЬ) скажинс("Добавление пространства");
						}
						
					см.полныйСборБезСтэка();
					см.Дтор();

						//ПрикрепиКонсоль(идБазовогоПроцесса());				
				}
				catch(Исключение и){delete и; debug(НА_КОНСОЛЬ) скажинс("Исключение в ртМодКонстр");}

		}

		/***********************************
		 * Функция main() языка Динрус, предоставляемая программой пользователя
		 */
		цел main(ткст[] арги);

		/***********************************
		 * Замещает функцию main() языка Си.
		 * Её назначение состоит в том, чтобы сопроводить вызов главной функции
		 * Динрус/D main() & уловить все необработанные исключения.
		 */
static цел результат = цел.init;

проц главная(цел аргчло, ткст0 *аргткст)
		{
			
			static ткст[] арги; 
			

			цел пробуйВыполнить(проц delegate() дг)
				{
				try{
				 ртПолучиАрги(аргчло, аргткст);
				 арги = дайАргиКС();
						дг();
						}
						catch(Искл и){и.выведи; пз; delete и;}//ошиб(); return 1;}
						return результат;
				}

			проц пускГлавной()
				{
				результат = main(арги);
									
				}
	
			проц передВходом()
				{
				стартРТ();		
				}
				
			проц обрИскл1(Исключение и)
				{
				throw new Исключение("Проблема с пуском\nрантайма в функции (ртСтарт):\n"~и.сооб, и.файл, и.строка, и.следщ, и.инфо);
				}				
				
			цел пускВсех()
				{		
				//максПриоритетПроцессу();
				ртСтарт(&передВходом, &обрИскл1 );
				устПроверОбр(&ассертОбр);
				auto рез = пробуйВыполнить(&пускГлавной);				
				return рез;		

				}				
				
			//Основное выполнение происходит здесь:
			результат = пускВсех();
			сбросьЦветКонсоли();
			cidrus.выход(результат);			

								
		}
		
extern (C) цел main(цел аргчло, ткст0 *аргткст)
	{
	
	главная(аргчло, аргткст);
	if(результат != цел.init) return результат;
	
	}
/**************************************************************/
