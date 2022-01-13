﻿module io.Console;

private import  io.device.Device,
                io.stream.Buffered;

version = Dinrus;
 /***
 Импортируемые сторонние функции.
*/          
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
	ук консВход();
	ук консВыход();
	ук консОш();
}
/***
 Перечень цветов консоли.
*/		 
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


/***
 ОСНОВНАЯ КОНСОЛЬНАЯ СТРУКТУРА.
*/
export struct Консоль 
{
        version (Win32)
                 const ткст Кс = "\r\n";
              else
                 const ткст Кс = "\n";
				 
private{

	//шим* буфЭкрана;
	//alias буфЭкрана ввод, вывод;
	ИНФОКОНСЭКРБУФ инфОбКонсБуф;
	ИНФОСТАРТА стартИнфо;
	КООРД размБуфера ={300, 10000};
	МПРЯМ размОкна ={300, 100, 800, 900} ;
	БЕЗАТРЫ баБуфЭкрана;
	ЗАПВВОДА запвво;
	ИНФОКОНСКУРСОР консКурсорИнфо;
	//Консоль.Провод провод;
	//Консоль.Ввод    Кввод;                    /// стандартный поток ввода
	//Консоль.Вывод   Квывод,                   /// стандартный поток вывода
                      //  Кош;                   /// стандартный поток ошибок
	ткст интро =
		"
			_______________________________________
				 Язык Программирования Динруc
			Авторское право "~\u00A9~" 2012-2021 Лицензия GPL3
				Разработчик DinrusPro (Виталий Кулич)	    		      
			Сайт проекта: http://www.github.com/DinrusGroup	
			_______________________________________
			
			
		";
		
}

		//КОНСВВОД = ДайСтдДескр(ПСтд.Ввод);
		//КОНСВЫВОД = ДайСтдДескр(ПСтд.Вывод);
		///КОНСОШ = ДайСтдДескр(ПСтд.Ошибка);
		
			//version(EmbeddedConsoleDetached)
		//	{			
			//После такой манипуляции каждая программа становится единоличницей!)))
			//Иногда это может быть полезным, например, если в WinMain выполнить такую команду, то
			//создаваемая здесь консоль будет затёрта, т.е. надпись "интро" перестанет досаждать(!)				
				//ОсвободиКонсоль();
				//РазместиКонсоль();
		//	}
		//	else
		//	{
			//Это поможет прикрепиться к вызывающей программе консольно.
			//В ExeMain|WinMain|DllMain делается то же самое, таким образом сшивается цепочка
			//между системной консолью, ДЛЛ и Экзешником.
			//	assert(ИДПРОЦЕССА);
			//	ПрикрепиКонсоль(ИДПРОЦЕССА);
		//	}
  
		//Получим важные данные о  трёх консольных адресах, которые
		//далее становятся аналогами стдвхо, стдвых и стдош
		// (эти элементы могли бы потеряться, но, получается, что мы их просто меняем на новые,
		//конкретные указатели на конкретную область памяти, в которой располагается наша консоль).			

		//ДайИнфоСтарта(&стартИнфо);
		//============================================================
		//Функция обратного вызова, используемая в WinMain, может
		//устанавливать соответствующий её  имени заголовок, либо выводить в заголовок
		//какие=либо сообщения. Для этого мы просто создадим такую возможность:					
				
	//	УстановиРазмерБуфераЭкранаКонсоли(КОНСВЫВОД, размБуфера) ;
	//	УстановиИнфОКурсореКонсоли(КОНСВЫВОД, &консКурсорИнфо);
	//	УстановиИнфОбОкнеКонсоли(КОНСВЫВОД, да, &размОкна);	
		
		//УстановиЗагКонсоли("Язык Программирования ДИНРУС");
				
		   //Проверка и установка кодовой страницы на УТФ-8
	//	if(ДайКСКонсоли() != cast(бцел)ПКодСтр.УТФ8) УстановиКСКонсоли(cast(ПКодСтр) ПКодСтр.УТФ8);
	//	if(ДайКСВыводаКонсоли() != cast(бцел)ПКодСтр.УТФ8) УстановиКСВыводаКонсоли(cast(ПКодСтр) ПКодСтр.УТФ8);
			
			//Это открывает доступ для чтения и записи из консольного буфера.
		//баБуфЭкрана.длина = БЕЗАТРЫ.sizeof;
		//баБуфЭкрана.дескрБезоп = пусто;
		//баБуфЭкрана.наследДескр = да;
		//буфЭкрана = cast(шим*) СоздайБуферЭкранаКонсоли(ППраваДоступа.ГенерноеЧтение| ППраваДоступа.ГенернаяЗапись, ПСовмИспФайла.Чтение|ПСовмИспФайла.Запись, &баБуфЭкрана);
			//УстановиАктивныйБуферКонсоли(&буфЭкрана);

		  // вв.указатель = cast(ук) буфЭкрана; ????
		  
		  
		  
/+
///////////
КООРД верхлево = {0, 0};

export extern (C) проц  перейдиНаТочкуКонсоли( цел aX, цел aY)
{
КООРД коорд;

  коорд.X = aX;
  коорд.Y = aY;
  УстановиПозициюКурсораКонсоли(КОНСВЫВОД,коорд);
}

export extern (C) проц установиАтрыКонсоли(ПТекстКонсоли атр)
{
  УстановиАтрибутыТекстаКонсоли(КОНСВЫВОД,атр);
}

export extern (C) цел гдеИксКонсоли()
{
  ДайИнфОБуфЭкранаКонсоли(КОНСВЫВОД,&инфОбКонсБуф);
  return инфОбКонсБуф.позКурсора.X;
}

export extern (C) цел гдеИгрекКонсоли()
{ 
  ДайИнфОБуфЭкранаКонсоли(КОНСВЫВОД,&инфОбКонсБуф);
  return инфОбКонсБуф.позКурсора.Y;
}

export extern (C) ПТекстКонсоли дайАтрыКонсоли()
{
  ДайИнфОБуфЭкранаКонсоли(КОНСВЫВОД,&инфОбКонсБуф);
  return инфОбКонсБуф.атрибуты;
}

extern(Windows) BOOL FillConsoleOutputCharacter(HANDLE hConsoleOutput, TCHAR cCharacter, DWORD nLength, COORD dwWriteCoord, out  LPDWORD lpNumberOfCharsWritten);


проц очистьЭкран()
{
  ДайИнфОБуфЭкранаКонсоли(КОНСВЫВОД,&инфОбКонсБуф);
  auto заливка = инфОбКонсБуф.размер.X * инфОбКонсБуф.размер.Y;
  FillConsoleOutputCharacter(КОНСВЫВОД, ' ', заливка, cast(COORD) верхлево, cast(LPDWORD) заливка);
  АтрибутЗаливкиВыводаКонсоли(КОНСВЫВОД,инфОбКонсБуф.атрибуты, заливка,  верхлево, заливка);
}
+/


        /**********************************************************************

                Моделирует консольный ввод как буфер.
                Заметьте, что читается только utf8.

        **********************************************************************/
 export:

     class Ввод
        {
                private Бввод     буфер;
                private бул    перенаправ;

                public alias    копируйнс получи;
				
export:

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
		


                private Бвыв    буфер;
                private бул    перенаправ;

                public  alias   добавь opCall;
                public  alias   слей  opCall;
export:
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
                    Вывести нс в буфер, и автоматически слить содержимое
                    текущего буфера для интерактивной консоли.
                    Перенаправленные консоли не сливаются автоматически
                    при нс.

                **************************************************************/

                final Вывод нс()
                {
                        буфер.добавь (Кс);
                        if (перенаправ is нет)
                            буфер.слей;

                        return this;
                }           

                /**************************************************************

                        Непосредственно слить консольный вывод.

                        Возвращает:
                        Возвращает связующую ссылку, если контент был записан. 
                        Выводит исключение ВВИскл , указывающее на кф или кб, если нет.

                        Примечания:
                        Сливает консольный буфер в прикреплённый провод.

                **************************************************************/

                final Вывод слей()
                {
                        буфер.слей;
                        return this;
                }           

                /**************************************************************


                        Возвращает ассоциированный поток.

                **************************************************************/

                final ИПотокВывода поток()
                {
                        return буфер;
                }

                /**************************************************************

                        Перенаправлено ли это устройство?

                        Возвращает:
                        Да, если перенаправлено, нет иначе.

                        Примечания:
                        Отображает статус редирекции консоли.

                **************************************************************/

                final бул перенаправленый()
                {
                        return перенаправ;
                }           

                /**************************************************************

                        Установить статус перенаправленности на указанное булево
						значение.

                        Примечания:
                        Конфигурирует статус перенаправленности консоли, когда 
                        перенаправленная консоль ещё в силе (диктует, 
                        выполняет ли нс() автоматическое сливание или же нет.)

                **************************************************************/

                final Вывод перенаправленый(бул нда)
                {
                         перенаправ = нда;
                         return this;
                }           

                /**************************************************************

                        Возвращает сконфигурированный сток для вывода.

                        Примечания:
                        Предоставляет доступ к низлежащему механизму 
                        консольного вывода. Используется для удержания предыдущего
                        статуса при временном переключении выводов. 
                        
                **************************************************************/

                final ИПотокВывода вывод ()
                {
                        return буфер.вывод;
                }           

                /**************************************************************

                    Изменяет вывод на альтернативный сток.

                **************************************************************/

                final Вывод вывод (ИПотокВывода сток)
                {
                        буфер.вывод = сток;
                        return this;
                }  


        }


        /***********************************************************************

                Провод для особой обработки консольных устройств. В нём 
                учитываются тонкости реализации на платформе Win32.

                Заметьте, что консоль фиксирована на Utf8 как для всех linux,
                так и для Win32. На последней в действительности исконен Utf16,
                и для разработчика всегда возникает трудность с указанием
                разницы.. В частности, функции консоли Win32 не работают с
				перенаправлением. Это создаёт дополнительные сложности.

        ***********************************************************************/

    class Провод : Устройство
        {
		


                private бул перенапр = нет;
				
		
			export	бул перенаправленый(){return перенапр;}
				
			export	проц перенаправленый (бул нда)
                {
                         перенапр = нда;                      
                }

                /***********************************************************************

                        Возвращает название данного провода

                ***********************************************************************/

             export   override ткст вТкст()
                {
                        return "<io.Console.Консоль>";
                }

                /***************************************************************

                        Код, специфичный для Windows

                ***************************************************************/

                version (Win32)
                        {
                        private шим[] ввод;
                        private шим[] вывод;

                        /*******************************************************

                                Ассоциирует данное устройство с предоставленным укз. 

                                Строго для адаптирования существующих устройств, 
                                таких как Стдвыв и проч.

                        *******************************************************/

                    export  this (т_мера укз)
                        {                           						
                                ввод = new шим [1024 * 1];
                                вывод = new шим [1024 * 1];				
								
							switch(укз)
							{								
											case 0:
											вв.указатель = КОНСВВОД;										 
											break;

											case 1:				
											вв.указатель = КОНСВЫВОД;
											break;

											case 2:
											вв.указатель = КОНСОШ;
											break;
											
											default:
											переоткрой(укз);
											break;
							}		
                        } 
						

					export	final проц цвет(Цвет ц)
						{
							устЦветКонсоли( ц);
						}

                     export   ~this()	{сбросьЦветКонсоли();}

                        /*******************************************************

                                Получает доступ к стандартным рычагам IO 

                        *******************************************************/

                        private проц переоткрой (т_мера ук_)
                        {
						   static const бцел[] ид = [
                                                          cast(бцел) -10, 
                                                          cast(бцел) -11, 
                                                          cast(бцел) -12
                                                          ];
                                static const ткст[] ф = [
                                                          "CONIN$\0", 
                                                          "CONOUT$\0", 
                                                          "CONOUT$\0"
                                                          ];

                                assert (ук_ < 3);
								
                               вв.указатель = sys.WinFuncs.ДайСтдДескр (cast(ПСтд) ид[ук_]);

						if (вв.указатель is пусто || вв.указатель is sys.WinConsts.НЕВЕРНХЭНДЛ)
							вв.указатель = СоздайФайлА ( cast(ткст) ф[ук_], 
							ППраваДоступа.ГенерноеЧтение| ППраваДоступа.ГенернаяЗапись , ПСовмИспФайла.Чтение|ПСовмИспФайла.Запись, 
																	пусто,cast(ПРежСоздФайла) 3, cast(ПФайл) 0, cast(ук) 0);
												
                                // allow не_годится handles в_ remain, since it
                                // may be patched later in some special cases
                                if (вв.указатель != sys.WinConsts.НЕВЕРНХЭНДЛ)
                                   {
                                   sys.WinConsts.ПРежимКонсоли режим;
                                   // are we redirecting? Note that we cannot
                                   // use the 'appending' режим triggered via
                                   // настройка overlapped.Offset в_ -1, so we
                                   // just track the байт-счёт instead
                                   if (!sys.WinFuncs.ДайРежимКонсоли (cast(ук) вв.указатель, режим))
                                         перенапр = вв.след = да;
										
                                   }
                        }

                        /*******************************************************

                                Записать чанк байтов в консоль из 
                                указанного Массива. 

                        *******************************************************/

                        version (Dinrus) 
                                {
								export override т_мера пиши (проц[] ист){win.скажинс("Привет"); win.скажи(cast(ткст) ист); return ист.length;}							
								
								} 
                             else
                                {
								export  override т_мера пиши (проц[] ист)
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
                             export   override т_мера читай (проц[] приёмн)
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

                        private this (т_мера укз)
                        {
						
                                this.укз = cast(Дескр) укз;
                                перенапр = (isatty(укз) is 0);
                        }
                 }
        }
}

/+
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
	
alias скажи say, console, консоль;

	проц скажинс(ткст ткт){Квывод(ткт).нс;}
	
	проц скажинс(бдол ткт)
	{
	сим[25] врем = void;
	Квывод(бдолВЮ8(врем,ткт)).нс;
	}
	
	проц нс(){Квывод("").нс;}
	проц таб(){Квывод("\t");}
	
+/