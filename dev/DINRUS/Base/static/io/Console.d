﻿module io.Console;

//private import  sys.Common: КОНСВВОД, КОНСВЫВОД, КОНСОШ;

private import  io.device.Device,
                io.stream.Buffered, sys.Common;
import stdrus: вТкст;
import sys.WinFuncs, sys.WinConsts;
              
version (Posix)
         /*private*/ import rt.core.stdc.posix.unistd;  // требуется для isatty()
		 
enum Цвет : бцел
{
    Чёрный         = 0,
    Красный           = 1,
    Зелёный         = 2,
    Синий          = 4,
    Жёлтый        = Красный | Зелёный,
    Магента       = Красный | Синий,
    Цыан          = Зелёный | Синий,
    СветлоСерый     = Красный | Зелёный | Синий,
    Яркий        = 8,
    ТёмноСерый      = Яркий | Чёрный,
    ЯркоКрасный     = Яркий | Красный,
    ЯркоЗелёный   = Яркий | Зелёный,
    ЯркоСиний    = Яркий | Синий,
    ЯркоЖёлтый  = Яркий | Жёлтый,
    ЯркоМагента = Яркий | Магента,
    ЯркоЦыан    = Яркий | Цыан,
    Белый         = Яркий | СветлоСерый,
}

alias Цвет.ЯркоКрасный красный;
alias Цвет.ЯркоЗелёный зелёный;

extern(C)
{
	проц установиКонсоль();
	проц  устЯркостьЦветаКонсоли(бул яркий);
    проц устЦветКонсоли(Цвет цвет);
	проц  перейдиНаТочкуКонсоли( цел aX, цел aY);
	проц установиАтрыКонсоли(ПТекстКонсоли атр);
	цел гдеИксКонсоли();
	цел гдеИгрекКонсоли();
	ПТекстКонсоли дайАтрыКонсоли();
	проц сбросьЦветКонсоли();
	//фук консВход();
//	фук консВыход();
	//фук консОш();
}


 struct Консоль 
{
        version (Win32)
                 const ткст Кс = "\r\n";
              else
                 const ткст Кс = "\n";


        /**********************************************************************

                Моделирует консольный ввод как буфер.
                Заметьте, что читается только utf8.

        **********************************************************************/


     class Ввод
        {
                /*private*/ Бввод     буфер;
                /*private*/ бул    перенаправ;

                public alias    копируйнс получи;
				


                /**************************************************************

                    Прикрепить консольный ввод к предоставленному устройству.

                **************************************************************/

                this (Провод провод, бул перенаправленый)
                {
                        перенаправ = перенаправленый;
                        буфер = new Бввод (провод);
                }

                /**************************************************************

                    Возвращает следующую доступную строку  в консоль, 
                    или пусто, когда ничего не доступно. Значение,
                    возвращаемое здесь, есть дубликат контента буфера (то
                    есть применяется .dup). 

                    Окончание каждой строки удаляется, если параметр необр is
                    не установлен в да.

                **************************************************************/

                final ткст копируйнс (бул необр = нет)
                {
                        ткст строка;

                        return читайнс (строка, необр) ? строка.dup : пусто;
                }

                /**************************************************************

                    Получить строку текста из консоли и картировать её в
                    данный аргумент. Делается срез ввода, ввод не копируется. 
                    Поэтому используется .dup. Окончание каждой строки
                    удаляется, если не установлен в да параметр необр.
                        
                    Возвращает нет, когда ввода больше не осталось.

                **************************************************************/

                final бул читайнс (ref ткст контент, бул необр=нет)
                {
                        т_мера строка (проц[] ввод)
                        {
                                auto текст = cast(ткст) ввод;
                                foreach (i, c; текст)
                                         if (c is '\n')
                                            {
                                            auto j = i;
                                            if (необр)
                                                ++j;
                                            else
                                               if (j && (текст[j-1] is '\r'))
                                                   --j;
                                            контент = текст [0 .. j];
                                            return i+1;
                                            }
                                return ИПровод.Кф;
                        }

                        // получить следщ строку, вернуть да
                        if (буфер.следщ (&строка))
                            return да;

                        // присвоить последующий контент и вернуть нет
                        контент = cast(ткст) буфер.срез (буфер.читаемый);
                        return нет;
                }

                /**************************************************************

                        Возвращает ассоциированный поток.

                **************************************************************/

                final ИПотокВвода поток ()
                {
                        return буфер;
                }

                /**************************************************************

                    Это перенаправленное устройство?

                    Возвращает:
                    Да, если перенаправленное, нет - в противном случае.

                    Примечания:
                    Отражает статус перенаправления консоли, как только 
                    создаётся экземпляр этого модуля.

                **************************************************************/

                final бул перенаправленый()
                {
                        return перенаправ;
                }           

                /**************************************************************

                    Установить состояние перенаправления в предоставленное булево

                    Примечания:
                    Сконфигурируйте статус перенаправления консоли, где 
                    перенаправленная консоль более эффективна (диктует, 
                    выполняет ли нс() автоматичексий слив или же нет).

                **************************************************************/

                final Ввод перенаправленый(бул да)
                {
                         перенаправ = да;
                         return this;
                }           

                /**************************************************************

                    Возвращает сконфигурированный исток.

                    Примечания:
                    Предоставляет доступ к нижележащему механизму консольного 
                    ввода. Используется для восстановления предыдущего состояния,
                    при временном переключении вводов. 
                        
                **************************************************************/

                final ИПотокВвода ввод ()
                {
                        return буфер.ввод;
                }           

                /**************************************************************

                        Поменять ввод на альтернативный исток.
                        
                **************************************************************/

                final Ввод ввод (ИПотокВвода исток)
                {
                        буфер.ввод = исток;
                        return this;
                }    


        }


        /**********************************************************************

                Консольный вывод принимает только utf8

        **********************************************************************/

     class Вывод
        {
		
                /*private*/ Бвыв    буфер;
                /*private*/ бул    перенаправ;

                public  alias   добавь opCall;
                public  alias   слей  opCall;

                /**************************************************************

                    Прикрепить консольный вывод к предоставленному устройству.

                **************************************************************/

                this (Провод провод, бул перенаправленый)
                {
                        перенаправ = перенаправленый;
                        буфер = new Бвыв (провод);
                }

                /**************************************************************

                    Добавить в консоль. Принимается только UTF8, поэтому
                    все иные кодировки нужно обрабатывать через более
                    высокоуровневый API.

                **************************************************************/

                final Вывод добавь(ткст x)
                {
                        буфер.добавь (x.ptr, x.length);
                        return this;
                } 
                          
                /**************************************************************

                    Добавить контент.

                    Параметры:
                    другой = объект с используемым методом вТкст()

                    Возвращает:
                    Возвращает скрепляющую ссылку, если весь контент был 
                    записан. Выводит ВВИскл, указывающий на кф или 
                    eob (конец буфера, кб), если ещё не конец файла.

                    Примечания:
                     Добавляет результат другой.вТкст() в эту консоль.

                **************************************************************/

                final Вывод добавь(Объект другой)        
                {           
                        return добавь (другой.вТкст);
                }

                /**************************************************************

                    Добавить нс и слить консольный буфер. Если вывод
                    перенаправленый, слив не производится автоматически.

                    Возвращает:
                    Возвращает скрепляющую ссылку, если весь контент был 
                    записан. Выводит ВВИскл, указывающий на кф или 
                    eob (конец буфера, кб), если ещё не конец файла.

                    Примечания:
                    Emit a нс преобр_в the буфер, and autoflush the
                    current буфер контент for an interactive console.
                    Redirected consoles do not слей automatically on
                    a нс.

                **************************************************************/

                final Вывод нс()
                {
                        буфер.добавь (Кс);
                        if (перенаправ is нет)
                            буфер.слей;

                        return this;
                }           

                /**************************************************************

                        Explicitly слей console вывод

                        Возвращает:
                        Возвращает chaining reference if контент was записано. 
                        Throws an ВВИскл indicating eof or eob if not.

                        Примечания:
                        Flushes the console буфер в_ attached провод

                **************************************************************/

                final Вывод слей()
                {
                        буфер.слей;
                        return this;
                }           

                /**************************************************************

                        Return the associated поток

                **************************************************************/

                final ИПотокВывода поток()
                {
                        return буфер;
                }

                /**************************************************************

                        Is this устройство перенаправленый?

                        Возвращает:
                        Да if перенаправленый, нет иначе.

                        Примечания:
                        Reflects the console redirection статус

                **************************************************************/

                final бул перенаправленый()
                {
                        return перенаправ;
                }           

                /**************************************************************

                        Набор redirection состояние в_ the предоставленный булево

                        Примечания:
                        Configure the console redirection статус, where 
                        a перенаправленый console is ещё efficient (dictates 
                        whether нс() performs automatic flushing or 
                        not)

                **************************************************************/

                final Вывод перенаправленый(бул нда)
                {
                         перенаправ = нда;
                         return this;
                }           

                /**************************************************************

                        Возвращает the configured вывод сток

                        Примечания:
                        Provопрes access в_ the underlying mechanism for 
                        console вывод. Use this в_ retain prior состояние
                        when temporarily switching outputs 
                        
                **************************************************************/

                final ИПотокВывода вывод ()
                {
                        return буфер.вывод;
                }           

                /**************************************************************

                        Divert вывод в_ an alternate сток

                **************************************************************/

                final Вывод вывод (ИПотокВывода сток)
                {
                        буфер.вывод = сток;
                        return this;
                }  


        }


        /***********************************************************************

                Провод for specifically handling the console devices. This 
                takes care of certain implementation details on the Win32 
                platform.

                Note that the console is fixed at Utf8 for Всё linux and
                Win32. The latter is actually Utf16 исконный, but it's just
                too much hassle for a developer в_ укз the distinction
                when it really should be a no-brainer. In particular, the
                Win32 console functions don't work with redirection. This
                causes добавьitional difficulties that can be ameliorated by
                asserting console I/O is always Utf8, in все modes.

        ***********************************************************************/

    class Провод : Устройство
        {
		
                /*private*/ бул перенапр = нет;
				
				бул перенаправленый(){return перенапр;}
				
				проц перенаправленый (бул нда)
                {
                         перенапр = нда;                      
                }

                /***********************************************************************

                        Возвращает название данного провода

                ***********************************************************************/

                override ткст вТкст()
                {
                        return "<io.Console.Консоль>";
                }

                /***************************************************************

                        Код, специфичный для Windows

                ***************************************************************/

                version (Win32)
                        {
                        /*private*/ шим[] ввод;
                        /*private*/ шим[] вывод;

                        /*******************************************************

                                Ассоциирует данное устройство с предоставленным укз. 

                                Строго для адаптирования существующих устройств, 
                                таких как Стдвыв и проч.

                        *******************************************************/

                        this (т_мера укз)
                        {
                                ввод = new шим [1024 * 1];
                                вывод = new шим [1024 * 1];
                                переоткрой (укз);
                        }   

						final проц цвет(Цвет ц)
						{
							устЦветКонсоли( ц);
						}

                        ~this()	{сбросьЦветКонсоли();}

                        /*******************************************************

                                Получает доступ к стандартным рычагам IO 

                        *******************************************************/

                        /*private*/ проц переоткрой (т_мера ук_)
                        {
                                static const бцел[] опр = [
                                                          cast(бцел) -10, 
                                                          cast(бцел) -11, 
                                                          cast(бцел) -12
                                                          ];
                                static const ткст[] f = [
                                                          "CONIN$\0", 
                                                          "CONOUT$\0", 
                                                          "CONOUT$\0"
                                                          ];

                                assert (ук_ < 3);
								
						//	if (вв.указатель is пусто || вв.указатель is НЕВЕРНХЭНДЛ)
						//	{
								switch(ук_)
								{

								default:
								case 0:
                                ук КОНСВВОД =  sys.WinFuncs.ДайСтдДескр(sys.WinConsts.ПСтд.Ввод);
								вв.указатель = cast(Дескр) 	КОНСВВОД;
								break;

								case 1:
                                ук КОНСВЫВОД = sys.WinFuncs.ДайСтдДескр(sys.WinConsts.ПСтд.Вывод);
								вв.указатель = cast(Дескр) КОНСВЫВОД;
								break;

								case 2:
                                 ук  КОНСОШ = cast(ук) sys.WinFuncs.ДайСтдДескр(sys.WinConsts.ПСтд.Ошибка); 
								вв.указатель = cast(Дескр) КОНСОШ;
								break;
								}
								
						//}          

			 
			if (вв.указатель is пусто || вв.указатель is sys.WinConsts.НЕВЕРНХЭНДЛ)
           вв.указатель = СоздайФайлА ( cast(ткст) f[ук_], 
                  ППраваДоступа.ГенерноеЧтение| ППраваДоступа.ГенернаяЗапись , ПСовмИспФайла.Чтение|ПСовмИспФайла.Запись, 
                      пусто,cast(ПРежСоздФайла) 3, cast(ПФайл) 0, cast(ук) 0);
												
						/+	else if (вв.указатель is пусто || вв.указатель is НЕВЕРНХЭНДЛ)
								{
								
								ИНФОСТАРТА _стартИнфо;
								_стартИнфо = дайСтартИнфо();
								
								switch(ук_)
								{
								case 0: вв.указатель = cast(Дескр) _стартИнфо.стдвво;	break;				
								case 1: вв.указатель = cast(Дескр) _стартИнфо.стдвыв; break;
								case 2: вв.указатель = cast(Дескр) _стартИнфо.стдош; break;
								}
								
								assert(вв.указатель !is пусто || вв.указатель !is НЕВЕРНХЭНДЛ, "Не удалось получить вв.указатель");
								
								}+/

                                // allow не_годится handles в_ remain, since it
                                // may be patched later in some special cases
                                if (вв.указатель != sys.WinConsts.НЕВЕРНХЭНДЛ)
                                   {
                                   sys.WinConsts.ПРежимКонсоли режим;
                                   // are we redirecting? Note that we cannot
                                   // use the 'appending' режим triggered via
                                   // настройка overlapped.Offset в_ -1, so we
                                   // just track the байт-счёт instead
                                   if (! sys.WinFuncs.ДайРежимКонсоли (cast(ук) вв.указатель, режим))
                                         перенапр = вв.след = да;
										 //ПрикрепиКонсоль(-1);
                                   }
                        }

                        /*******************************************************

                                Записать чанк байтов в консоль из 
                                указанного Массива. 

                        *******************************************************/

                        version (Win32SansUnicode) 
                                {} 
                             else
                                {
                                override т_мера пиши (проц[] ист)
                                {
                                if (перенапр)
								{
								debug(Console) эхо("redirected!");
                                    return super.пиши (ист);									
									}
                                else
                                   {
                                   бцел i = ист.length;

                                   // защита от преобразования пустых строк
                                   if (i is 0)
                                       return 0;

                                   // расширить буфер как следует
                                   if (вывод.length < i)
                                       вывод.length = i;

                                   // преобразовать в кодировку буфера вывода
                                   i = МультиБайтВШирСим (ПКодСтр.УТФ8, 0, cast(PCHAR) ист.ptr, i, 
                                                            вывод.ptr, вывод.length);
                                            
                                   // слить произведённый вывод
                                   for (шим* p=вывод.ptr, конец=вывод.ptr+i; p < конец; p+=i)
                                       {
                                       const цел MAX = 16 * 1024;

                                       // избежать ограничения консоли до 64KB 
                                       бцел длин = конец - p; 
                                       if (длин > MAX)
                                          {
                                          длин = MAX;
                                          // проверка на суррогатные остатки ...
                                          if ((p[длин-1] & 0xfc00) is 0xdc00)
                                               --длин;
                                          }
                                       if (! ПишиКонсоль ( вв.указатель, p, длин, &i, пусто))
                                             ошибка();
                                       }
                                   return ист.length;
                                   }
                                }
                                }
                        
                        /*******************************************************

                                Чтение чанка байтов из консол в 
                                предоставленный Массив.

                        *******************************************************/

                        version (Win32SansUnicode) 
                                {} 
                             else
                                {
                                override т_мера читай (проц[] приёмн)
                                {
                                if (перенапр)
                                    return super.читай (приёмн);
                                else
                                   {
                                   бцел i = приёмн.length / 4;

                                   assert (i);

                                   if (i > ввод.length)
                                       i = ввод.length;
                                       
                                   // читаем санк шткст0 из консоли
                                   if (! ЧитайКонсоль (вв.указатель, ввод.ptr, i, &i, пусто))
                                         ошибка();

                                   // нет ввода ~ пора домой
                                   if (i is 0)
                                       return Кф;

                                   // транслировать в utf8, прямо в приёмн
                                   i = ШирСимВМультиБайт (ПКодСтр.УТФ8, cast(ПШирСим) 0, ввод.ptr, i, 
                                                            cast(ткст0)приёмн.ptr, cast(бцел) приёмн.length, cast(ткст0)пусто, нет);
                                   if (i is 0)
                                       ошибка ();

                                   return i;
                                   }
                                }
                                }

                        }
                     else
                        {
                        /*******************************************************

                                Ассоциировать данное устройство с заданным укз. 

                                Это строго для адаптирования существующих 
                                устройств, таких как Стдвыв и подобные ему.

                        *******************************************************/

                        /*private*/ this (т_мера укз)
                        {
                                this.укз = cast(Дескр) укз;
                                перенапр = (isatty(укз) is 0);
                        }
                        }
        }
}


/******************************************************************************

        Глобальные переменные, представляющие Консоль IO

******************************************************************************/

static Консоль.Ввод    Кввод;                    /// стандартный поток ввода
static Консоль.Вывод   Квывод,                   /// стандартный поток вывода
                        Кош;                   /// стандартный поток ошибок


/******************************************************************************

        Инстанциировать доступ в Консоль.

******************************************************************************/

static this ()
{
        auto провод = new Консоль.Провод (0);
    провод.цвет(зелёный);
        Кввод  = new Консоль.Ввод (провод, провод.перенаправленый);
        
        провод = new Консоль.Провод (1);
        провод.цвет(Цвет.ЯркоСиний);
        Квывод = new Консоль.Вывод (провод, провод.перенаправленый);
        
        провод = new Консоль.Провод (2);
        провод.цвет(красный);
        Кош = new Консоль.Вывод (провод, провод.перенаправленый);
        
}


/******************************************************************************

        Слить выводы перед выходом

******************************************************************************/

static ~this()
{
   synchronized (Квывод.поток)
        Квывод.слей;

   synchronized (Кош.поток)
        Кош.слей;
}


/******************************************************************************/

ткст бдолВЮ8 (ткст врм, бдол знач)
in {
   assert (врм.length > 19, "буфер ulongToUtf8 должен быть длиною более 19 символов");
   }
body
{
    сим* p = врм.ptr + врм.length;

    do {
       *--p = cast(сим)((знач % 10) + '0');
       } while (знач /= 10);

    return врм [cast(т_мера)(p - врм.ptr) .. $];
}


		
	проц скажи(ткст ткт){Квывод(ткт);}
	
	проц скажи(бдол ткт)
	{
	сим[25] врем = void;
	Квывод(бдолВЮ8(врем,ткт));
	}
	
	проц скажинс(ткст ткт){Квывод(ткт).нс;}
	
	проц скажинс(бдол ткт)
	{
	сим[25] врем = void;
	Квывод(бдолВЮ8(врем,ткт)).нс;
	}
	
	проц нс(){Квывод("").нс;}
	проц таб(){Квывод("\t");}
	