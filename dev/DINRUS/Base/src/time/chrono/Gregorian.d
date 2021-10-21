﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris, schveiguy

******************************************************************************/

module time.chrono.Gregorian;

private import time.chrono.Calendar;

private import exception;

/**
 * $(ANCHOR _Gregorian)
 * Представляет Грегорианский Календарь.
 *
 * Заметьте, что это Пролептический Грегорианский Календарь.  Большинство
 * календарей подразумевает, что даты до 9/14/1752 были Юлианскими Датами.
 * Юлиан отличается от Грегориана тем, что високосные годы бывают каждые 4 года,
 * даже при приращении 100 лет.
 * Пролептический Грегорианский Календарь применяет правила Грегорианского
 * високосного года к датам до 9/14/1752, что облегчает расчёт дат.
 */
export class Грегориан : Календарь 
{
        // import baseclass воВремя()
        alias Календарь.воВремя воВремя;

        /// static /*shared*/ экземпляр
        public static Грегориан генерный;

        enum Тип 
        {
                Локализованный = 1,               /// Refers в_ the localized version of the Грегориан Календарь.
                АнглСША = 2,               /// Refers в_ the US English version of the Грегориан Календарь.
                СреднеВостФранц = 9,        /// Refers в_ the Mопрdle East French version of the Грегориан Календарь.
                Арабский = 10,                 /// Refers в_ the _Arabic version of the Грегориан Календарь.
                ТранслитерАнгл = 11,  /// Refers в_ the transliterated English version of the Грегориан Календарь.
                ТранслитерФранц = 12    /// Refers в_ the transliterated French version of the Грегориан Календарь.
        }

        private Тип тип_;                 

        /**
        * Представляет текущ эру.
        */
        enum {НАША_ЭРА = 1, ДО_НАШЕЙ_ЭРЫ = 2, МАКС_ГОД = 9999};

        private static final бцел[] ДниВМесОбщ = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];

        private static final бцел[] ДниВМесВисокос   = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

        /**
        * Создает генерный экземпляр this Календарь
        */
        static this()
        {       
                генерный = new Грегориан;
        }

        /**
        * Initializes an экземпляр of the Грегориан class using the specified GregorianTypes значение. If no значение is 
        * specified, the default is Грегориан.Types.Локализованный.
        */
       export this (Тип тип = Тип.Локализованный) 
        {
                тип_ = тип;
        }

        /**
        * Переписано. Возвращает Значение Времени, установленное в указанный дата и время в указанном _era.
        * Параметры:
        *   год = Целое, представляющее _год.
        *   месяц = Целое, представляющее _месяц.
        *   день = Целое, представляющее _день.
        *   час = Целое, представляющее _час.
        *   минута = Целое, представляющее _минута.
        *   секунда = Целое, представляющее _секунда.
        *   миллисекунда = Целое, представляющее _миллисекунда.
        *   эра = Целое, представляющее _era.
        * Возвращает: Время, установленное в указанную дата и время.
        */
       export override Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра)
        {
                return Время (дайТикиДаты(год, месяц, день, эра) + дайТикиВремени(час, минута, секунда)) + ИнтервалВремени.изМиллисек(миллисекунда);
        }

        /**
        * Переписано. Возвращает день недели в указанном Время.
        * Параметры: время = Значение Времени.
        * Возвращает: Значение ДняНедели  representing день недели времени.
        */
      export  override ДеньНедели дайДеньНедели(Время время) 
        {
                auto тики = время.тики;
                цел смещение = 1;
                if (тики < 0)
                {
                    ++тики;
                    смещение = 0;
                }
       
                auto деньнед = cast(цел) ((тики / ИнтервалВремени.ТиковВДень + смещение) % 7);
                if (деньнед < 0)
                    деньнед += 7;
                return cast(ДеньНедели) деньнед;
        }

        /**
        * Переписано. Возвращает день месяца в указанном Время.
        * Параметры: время = Значение Времени.
        * Возвращает: Целое, представляющее день месяца времени.
        */
       export override бцел дайДеньМесяца(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.День);
        }

        /**
        * Переписано. Возвращает день годв в указанном Время.
        * Параметры: время = Значение Времени.
        * Возвращает: Целое, представляющее день годв времени.
        */
       export override бцел дайДеньГода(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.ДеньГода);
        }

        /**
        * Переписано. Возвращает the месяц в указанном Время.
        * Параметры: время = Значение Времени.
        * Возвращает: Целое, представляющее месяц во времени.
        */
       export override бцел дайМесяц(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.Месяц);
        }

        /**
        * Переписано. Возвращает the год в указанном Время.
        * Параметры: время = Значение Времени.
        * Возвращает: Целое, представляющее год во времени.
        */
       export override бцел дайГод(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.Год);
        }

        /**
        * Переписано. Возвращает the эра в указанном Время.
        * Параметры: время = Значение Времени.
        * Возвращает: Целое, представляющее эра во времени.
        */
      export  override бцел дайЭру(Время время) 
        {
                if(время < время.эпоха)
                        return ДО_НАШЕЙ_ЭРЫ;
                else
                        return НАША_ЭРА;
        }

        /**
        * Переписано. Возвращает число дней в указанном _год и _месяц указанного _era.
        * Параметры:
        *   год = Целое, представляющее _год.
        *   месяц = Целое, представляющее _месяц.
        *   эра = Целое, представляющее _era.
        * Возвращает: The число дней в указанном _год и _месяц указанного _era.
        */
      export  override бцел дайДниМесяца(бцел год, бцел месяц, бцел эра) 
        {
                //
                // проверь арги.  високосен_ли verifies the год is действителен.
                //
                if(месяц < 1 || месяц > 12)
                        ошАрга("месяцы вне диапазона");
                auto monthDays = високосен_ли(год, эра) ? ДниВМесВисокос : ДниВМесОбщ;
                return monthDays[месяц] - monthDays[месяц - 1];
        }

        /**
        * Переписано. Возвращает число дней в указанном _год указанного _era.
        * Параметры:
        *   год = Целое, представляющее _год.
        *   эра = Целое, представляющее _era.
        * Возвращает: The число дней в указанном _год в указанном _era.
        */
      export  override бцел дайДниГода(бцел год, бцел эра) 
        {
                return високосен_ли(год, эра) ? 366 : 365;
        }

        /**
        * Переписано. Возвращает число месяцев в указанном _год указанного _era.
        * Параметры:
        *   год = Целое, представляющее _год.
        *   эра = Целое, представляющее _era.
        * Возвращает: The число месяцев в указанном _год в указанном _era.
        */
      export  override бцел дайМесяцыГода(бцел год, бцел эра) 
        {
                return 12;
        }

        /**
        * Переписано. Показывает, является ли указанный _год в указанном _era is a leap _год.
        * Параметры: год = Целое, представляющее _год.
        * Параметры: эра = Целое, представляющее _era.
        * Возвращает: да is the specified _год is a leap _год; иначе, нет.
        */
        override бул високосен_ли(бцел год, бцел эра) 
        {
                return статВисокосен_ли(год, эра);
        }

        /**
        * $(I Property.) Retrieves the GregorianTypes значение indicating the language version of the Грегориан.
        * Возвращает: The Грегориан.Тип значение indicating the language version of the Грегориан.
        */
       export Тип типКалендаря() 
        {
                return тип_;
        }

        /**
        * $(I Property.) Переписано. Retrieves the список эр в текущ Календарь.
        * Возвращает: An целое Массив representing the эры в текущ Календарь.
        */
      export  override бцел[] эры() 
        {       
                бцел[] врем = [НАША_ЭРА, ДО_НАШЕЙ_ЭРЫ];
                return врем.dup;
        }

        /**
        * $(I Property.) Переписано. Retrieves the определитель associated with the текущ Календарь.
        * Возвращает: Целое, представляющее определитель of the текущ Календарь.
        */
      export  override бцел опр() 
        {
                return cast(цел) тип_;
        }

        /**
         * Переписано.  Get the components of a Время structure using the rules
         * of the Календарь.  Полезно, если you want ещё than one of the
         * given components.  Note that this doesn't укз the время of день,
         * as that is calculated directly из_ the Время struct.
         */
      export  override проц разбей(Время время, ref бцел год, ref бцел месяц, ref бцел день, ref бцел деньгода, ref бцел деньнед, ref бцел эра)
        {
            разбейДату(время.тики, год, месяц, день, деньгода, эра);
            деньнед = дайДеньНедели(время);
        }

        /**
         * Переписано. Возвращает new Время with the specified число месяцев
         * добавьed.  If the месяцы are негатив, the месяцы are subtracted.
         *
         * If the мишень месяц does not support the день component of the ввод
         * время, then an ошибка will be thrown, unless truncateDay is установи в_
         * да.  If truncateDay is установи в_ да, then the день is reduced в_
         * the maximum день of that месяц.
         *
         * Например, добавим one месяц в_ 1/31/2000 with truncateDay установи в_
         * да результатs in 2/28/2000.
         *
         * Параметры: t = A время в_ добавь the месяцы в_
         * Параметры: члоМес = The число месяцев в_ добавь.  This can be
         * негатив.
         * Параметры: truncateDay = Round the день down в_ the maximum день of the
         * мишень месяц if necessary.
         *
         * Возвращает: A Время that represents the предоставленный время with the число
         * of месяцы добавьed.
         */
       export override Время добавьМесяцы(Время t, цел члоМес, бул truncateDay=нет)
        {
                //
                // We know все годы are 12 месяцы, so use the в_/из_ дата
                // methods в_ сделай the calculation an O(1) operation
                //
                auto дата = вДату(t);
                члоМес += дата.месяц - 1;
                цел члоЛет = члоМес / 12;
                члоМес %= 12;
                if(члоМес < 0)
                {
                        члоЛет--;
                        члоМес += 12;
                }
                цел realYear = дата.год;
                if(дата.эра == ДО_НАШЕЙ_ЭРЫ)
                        realYear = -realYear + 1;
                realYear += члоЛет;
                if(realYear < 1)
                {
                        дата.год = -realYear + 1;
                        дата.эра = ДО_НАШЕЙ_ЭРЫ;
                }
                else
                {
                        дата.год = realYear;
                        дата.эра = НАША_ЭРА;
                }
                дата.месяц = члоМес + 1;
                //
                // упрости the день if necessary
                //
                if(truncateDay)
                {
                    бцел maxday = дайДниМесяца(дата.год, дата.месяц, дата.эра);
                    if(дата.день > maxday)
                        дата.день = maxday;
                }
                auto врдня = t.тики % ИнтервалВремени.ТиковВДень;
                if(врдня < 0)
                        врдня += ИнтервалВремени.ТиковВДень;
                return воВремя(дата) + ИнтервалВремени(врдня);
        }

        /**
         * Переписано.  Добавь the specified число of годы в_ the given Время.
         *
         * Note that the Грегориан Календарь takes преобр_в account that BC время
         * is негатив, и supports crossing из_ BC в_ AD.
         *
         * Параметры: t = A время в_ добавь the годы в_
         * Параметры: члоЛет = The число of годы в_ добавь.  This can be негатив.
         *
         * Возвращает: A Время that represents the предоставленный время with the число
         * of годы добавьed.
         */
      export  override Время добавьГоды(Время t, цел члоЛет)
        {
                return добавьМесяцы(t, члоЛет * 12);
        }

        package static проц разбейДату (дол тики, ref бцел год, ref бцел месяц, ref бцел день, ref бцел dayOfYear, ref бцел эра) 
        {
                цел numDays;

                проц calculateYear()
                {
                        auto whole400Years = numDays / cast(цел) ИнтервалВремени.ДнейНа400Лет;
                        numDays -= whole400Years * cast(цел) ИнтервалВремени.ДнейНа400Лет;
                        auto whole100Years = numDays / cast(цел) ИнтервалВремени.ДнейНа100Лет;
                        if (whole100Years == 4)
                                whole100Years = 3;

                        numDays -= whole100Years * cast(цел) ИнтервалВремени.ДнейНа100Лет;
                        auto whole4Years = numDays / cast(цел) ИнтервалВремени.ДнейНа4Года;
                        numDays -= whole4Years * cast(цел) ИнтервалВремени.ДнейНа4Года;
                        auto wholeYears = numDays / cast(цел) ИнтервалВремени.ДнейВГоду;
                        if (wholeYears == 4)
                                wholeYears = 3;

                        год = whole400Years * 400 + whole100Years * 100 + whole4Years * 4 + wholeYears + эра;
                        numDays -= wholeYears * ИнтервалВремени.ДнейВГоду;
                }

                if(тики < 0)
                {
                        // in the BC эра
                        эра = ДО_НАШЕЙ_ЭРЫ;
                        //
                        // установи up numDays в_ be like AD.  AD дни старт at
                        // год 1.  However, in BC, год 1 is like AD год 0,
                        // so we must вычти one год.
                        //
                        numDays = cast(цел)((-тики - 1) / ИнтервалВремени.ТиковВДень);
                        if(numDays < 366)
                        {
                                // in the год 1 B.C.  This is a special case
                                // leap год
                                год = 1;
                        }
                        else
                        {
                                numDays -= 366;
                                calculateYear;
                        }
                        //
                        // numDays is число дней задний из_ the конец of
                        // the год, because the original тики were негатив
                        //
                        numDays = (статВисокосен_ли(год, эра) ? 366 : 365) - numDays - 1;
                }
                else
                {
                        эра = НАША_ЭРА;
                        numDays = cast(цел)(тики / ИнтервалВремени.ТиковВДень);
                        calculateYear;
                }
                dayOfYear = numDays + 1;

                auto monthDays = статВисокосен_ли(год, эра) ? ДниВМесВисокос : ДниВМесОбщ;
                месяц = numDays >> 5 + 1;
                while (numDays >= monthDays[месяц])
                       месяц++;

                день = numDays - monthDays[месяц - 1] + 1;
        }

        package static бцел откиньЧасть (дол тики, ЧастьДаты часть) 
        {
                бцел год, месяц, день, dayOfYear, эра;

                разбейДату(тики, год, месяц, день, dayOfYear, эра);

                if (часть is ЧастьДаты.Год)
                    return год;

                if (часть is ЧастьДаты.Месяц)
                    return месяц;

                if (часть is ЧастьДаты.ДеньГода)
                    return dayOfYear;

                return день;
        }

        package static дол дайТикиДаты (бцел год, бцел месяц, бцел день, бцел эра) 
        {
                //
                // проверь аргументы, дайДниМесяца verifies the год и
                // месяц is действителен.
                //
                if(день < 1 || день > генерный.дайДниМесяца(год, месяц, эра))
                        ошАрга("дни превышают допустимый диапазон");

                auto monthDays = статВисокосен_ли(год, эра) ? ДниВМесВисокос : ДниВМесОбщ;
                if(эра == ДО_НАШЕЙ_ЭРЫ)
                {
                        год += 2;
                        return -cast(дол)( (год - 3) * 365 + год / 4 - год / 100 + год / 400 + monthDays[12] - (monthDays[месяц - 1] + день - 1)) * ИнтервалВремени.ТиковВДень;
                }
                else
                {
                        год--;
                        return (год * 365 + год / 4 - год / 100 + год / 400 + monthDays[месяц - 1] + день - 1) * ИнтервалВремени.ТиковВДень;
                }
        }

        package static бул статВисокосен_ли(бцел год, бцел эра)
        {
                if(год < 1)
                        ошАрга("год не может быть равен 0");
                if(эра == ДО_НАШЕЙ_ЭРЫ)
                {
                        if(год == 1)
                                return да;
                        return статВисокосен_ли(год - 1, НАША_ЭРА);
                }
                if(эра == НАША_ЭРА || эра == ТЕКУЩАЯ_ЭРА)
                        return (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0));
                return нет;
        }

        package static проц ошАрга(ткст стр)
        {
                throw new ИсклНелегальногоАргумента(стр);
        }
}

debug(Грегориан)
{
        import io.Stdout;

        проц вывод(Время t)
        {
                Дата d = Грегориан.генерный.вДату(t);
                ВремяДня врдня = t.время;
                Стдвыв.форматируй("{}/{}/{:d4} {} {}:{:d2}:{:d2}.{:d3} деньнед:{}",
                                d.месяц, d.день, d.год, d.эра == Грегориан.НАША_ЭРА ? "AD" : "BC",
                                врдня.часы, врдня.минуты, врдня.сек, врдня.миллисек, d.деньнед).нс;
        }

        проц main()
        {
                Время t = Время(365 * ИнтервалВремени.ТиковВДень);
                вывод(t);
                for(цел i = 0; i < 366 + 365; i++)
                {
                        t -= ИнтервалВремени.изДней(1);
                        вывод(t);
                }
        }
}

debug(UnitTest)
{
        unittest
        {
                //
                // проверь Грегориан дата handles positive время.
                //
                Время t = Время.эпоха + ИнтервалВремени.изДней(365);
                Дата d = Грегориан.генерный.вДату(t);
                assert(d.год == 2);
                assert(d.месяц == 1);
                assert(d.день == 1);
                assert(d.эра == Грегориан.НАША_ЭРА);
                assert(d.деньгода == 1);
                //
                // note that this is in disagreement with the Julian Календарь
                //
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                //
                // проверь that it handles негатив время
                //
                t = Время.эпоха - ИнтервалВремени.изДней(366);
                d = Грегориан.генерный.вДату(t);
                assert(d.год == 1);
                assert(d.месяц == 1);
                assert(d.день == 1);
                assert(d.эра == Грегориан.ДО_НАШЕЙ_ЭРЫ);
                assert(d.деньгода == 1);
                assert(d.деньнед == Грегориан.ДеньНедели.Суббота);

                //
                // проверь that добавьМесяцы works properly, добавь 15 месяцы в_
                // 2/3/2004, 04:05:06.007008, then вычти 15 месяцы again.
                //
                t = Грегориан.генерный.воВремя(2004, 2, 3, 4, 5, 6, 7) + ИнтервалВремени.изМикросек(8);
                d = Грегориан.генерный.вДату(t);
                assert(d.год == 2004);
                assert(d.месяц == 2);
                assert(d.день == 3);
                assert(d.эра == Грегориан.НАША_ЭРА);
                assert(d.деньгода == 34);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                auto t2 = Грегориан.генерный.добавьМесяцы(t, 15);
                d = Грегориан.генерный.вДату(t2);
                assert(d.год == 2005);
                assert(d.месяц == 5);
                assert(d.день == 3);
                assert(d.эра == Грегориан.НАША_ЭРА);
                assert(d.деньгода == 123);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                t2 = Грегориан.генерный.добавьМесяцы(t2, -15);
                d = Грегориан.генерный.вДату(t2);
                assert(d.год == 2004);
                assert(d.месяц == 2);
                assert(d.день == 3);
                assert(d.эра == Грегориан.НАША_ЭРА);
                assert(d.деньгода == 34);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                assert(t == t2);

                //
                // проверь that illegal аргумент exceptions occur
                //
                try
                {
                        t = Грегориан.генерный.воВремя (0, 1, 1, 0, 0, 0, 0, Грегориан.НАША_ЭРА);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(Исключение iae)
                {
                }
                try
                {
                        t = Грегориан.генерный.воВремя (1, 0, 1, 0, 0, 0, 0, Грегориан.НАША_ЭРА);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }
                try
                {
                        t = Грегориан.генерный.воВремя (1, 1, 0, 0, 0, 0, 0, Грегориан.ДО_НАШЕЙ_ЭРЫ);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }

                try
                {
                    t = Грегориан.генерный.воВремя(2000, 1, 31, 0, 0, 0, 0);
                    t = Грегориан.генерный.добавьМесяцы(t, 1);
                    assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }

                try
                {
                    t = Грегориан.генерный.воВремя(2000, 1, 31, 0, 0, 0, 0);
                    t = Грегориан.генерный.добавьМесяцы(t, 1, да);
                    assert(Грегориан.генерный.дайДеньМесяца(t) == 29);
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                    assert(нет, "Should not throw illegal аргумент исключение");
                }



        }
}