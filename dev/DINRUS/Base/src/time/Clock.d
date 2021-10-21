﻿
module time.Clock;

public  import  time.Time;
private import  dinrus;

export struct Часы
{
        static final бцел[] ДниВМесяцВЦелом = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
       
	    export static проц устДеньГода(ref ДатаВремя дв)
        {
            бцел деньгода = дв.дата.день + ДниВМесяцВЦелом[дв.дата.месяц - 1];
            бцел год = дв.дата.год;

            if(дв.дата.месяц > 2 && (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0)))
                деньгода++;

            дв.дата.деньгода = деньгода;
        }

        version (Win32)
        {
                /***************************************************************

                        Возвращает текущее время как UTC с начала эпохи

                ***************************************************************/

               export static Время сейчас ()
                {
                        ФВРЕМЯ фВремя = void;
                        ДайСистВремяКакФВремя (&фВремя);
                        return преобразуй (фВремя);
                }

                /***************************************************************

                        Набор полей Дата представляет текущее время. 

                ***************************************************************/

                export static ДатаВремя вДату ()
                {
                        return вДату (сейчас);
                }


                /***************************************************************

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                ***************************************************************/

               export static ДатаВремя вДату (Время время)
                {
                        ДатаВремя дв =void;
                        СИСТВРЕМЯ сВремя =void;

                        auto фВремя = преобразуй (время);
                        ФВремяВСистВремя (&фВремя, &сВремя);

                        дв.дата.год    = сВремя.год;
                        дв.дата.месяц   = сВремя.месяц;
                        дв.дата.день     = сВремя.день;
                        дв.дата.деньнед     = сВремя.день_недели;
                        дв.дата.эра     = 0;
                        дв.время.часы   = сВремя.час;
                        дв.время.минуты = сВремя.минута;
                        дв.время.сек = сВремя.секунда;
                        дв.время.миллисек  = сВремя.миллисекунды;

                        // Вычислить день годав
                        устДеньГода(дв);

                        return дв;
                }

                /***************************************************************

                        Преобразует поля Дата во Время

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                ***************************************************************/

               export static Время изДаты (ref ДатаВремя дв)
                {
                        СИСТВРЕМЯ сВремя =void;
                        ФВРЕМЯ   фВремя =void;

                        сВремя.год         = cast(бкрат) дв.дата.год;
                        сВремя.месяц        = cast(бкрат) дв.дата.месяц;
                        сВремя.день_недели    = 0;
                        сВремя.день          = cast(бкрат) дв.дата.день;
                        сВремя.час         = cast(бкрат) дв.время.часы;
                        сВремя.минута       = cast(бкрат) дв.время.минуты;
                        сВремя.секунда       = cast(бкрат) дв.время.сек;
                        сВремя.миллисекунды = cast(бкрат) дв.время.миллисек;

                        СистВремяВФВремя (&сВремя, &фВремя);
                        return преобразуй (фВремя);
                }

                /***************************************************************

                        Преобразует FILETIME во Время

                ***************************************************************/

                export static Время преобразуй (ФВРЕМЯ время)
                {
                        auto t = *cast(дол*) &время;
                        t *= 100 / ИнтервалВремени.НаносекВТике;
                        return Время.эпоха1601 + ИнтервалВремени(t);
                }

                /***************************************************************

                        Преобразует Время в FILETIME

                ***************************************************************/

               export  static ФВРЕМЯ преобразуй (Время дв)
                {
                        ФВРЕМЯ время =void;

                        ИнтервалВремени вринтервал = дв - Время.эпоха1601;
                        assert (вринтервал >= вринтервал.нуль);
                        *cast(дол*) &время.датаВремяМладш = вринтервал.тики;
                        return время;
                }
        }

        version (Posix)
        {
                /***************************************************************

                        Возвращает текущее время как UTC с начала эпохи

                ***************************************************************/

                export static Время сейчас ()
                {
                        значврем tv =void;
                        if (gettimeofday (&tv, пусто))
                            throw new PlatformException ("Часы.сейчас :: таймер Posix недоступен");

                        return преобразуй (tv);
                }

                /***************************************************************

                        Набор Дата fields в_ represent the текущ время. 

                ***************************************************************/

               export static ДатаВремя вДату ()
                {
                        return вДату (сейчас);
                }

                /***************************************************************

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                **************************************************************/

               export static ДатаВремя вДату (Время время)
                {
                        ДатаВремя дв =void;
                        auto значврем = преобразуй (время);
                        дв.время.миллисек = значврем.микросек / 1000;

                        tm t =void;
                        gmtime_r (&значврем.сек, &t);

                        дв.дата.год    = t.tm_year + 1900;
                        дв.дата.месяц   = t.tm_mon + 1;
                        дв.дата.день     = t.tm_mday;
                        дв.дата.деньнед     = t.tm_wday;
                        дв.дата.эра     = 0;
                        дв.время.часы   = t.tm_hour;
                        дв.время.минуты = t.tm_min;
                        дв.время.сек = t.tm_sec;

                        // Вычислить день года
                        устДеньГода(дв);

                        return дв;
                }

                /***************************************************************

                        Преобразует Дата во Время

                        Набор полей представляет собой время UTC. Заметьте, что 
                        преобразование ограничено хостинговой ОС, и не сможет
                        и правильно работать со значением Времени  для текущего домена.
                        На Win32 самой наименьшей датой является 1601 год. На Линукс
                        это 1970. Все системы также имеют ограничение на самые большие даты.
                        Дата в лучшем случае ограничивается точностью миллисекунды.

                ***************************************************************/

               export static Время изДаты (ref ДатаВремя дв)
                {
                        tm t =void;

                        t.tm_year = дв.дата.год - 1900;
                        t.tm_mon  = дв.дата.месяц - 1;
                        t.tm_mday = дв.дата.день;
                        t.tm_hour = дв.время.часы;
                        t.tm_min  = дв.время.минуты;
                        t.tm_sec  = дв.время.сек;

                        auto сек = timegm (&t);
                        return Время.epoch1970 + 
                               ИнтервалВремени.изСек(сек) + 
                               ИнтервалВремени.изМиллисек(дв.время.миллисек);
                }

                /***************************************************************

                        Преобразует значврем во Время

                ***************************************************************/

               export  static Время преобразуй (ref значврем tv)
                {
                        return Время.epoch1970 + 
                               ИнтервалВремени.изСек(tv.сек) + 
                               ИнтервалВремени.изМикросек(tv.микросек);
                }

                /***************************************************************

                        Преобразует Время в значврем

                ***************************************************************/

                export static значврем преобразуй (Время время)
                {
                        значврем tv =void;

                        ИнтервалВремени вринтервал = время - время.epoch1970;
                        assert (вринтервал >= ИнтервалВремени.zero);
                        tv.сек  = cast(typeof(tv.сек)) вринтервал.сек;
                        tv.микросек = cast(typeof(tv.микросек)) (вринтервал.micros % 1_000_000L);
                        return tv;
                }
        }
}



debug (UnitTest)
{
        unittest 
        {
                auto время = Часы.сейчас;
                auto часы=Часы.преобразуй(время);
                assert (Часы.преобразуй(часы) is время);

                время -= ИнтервалВремени(время.тики % ИнтервалВремени.ТиковВСек);
                auto дата = Часы.вДату(время);

                assert (время is Часы.изДаты(дата));
        }
}

debug (Часы)
{
        проц main() 
        {
                auto время = Часы.сейчас;
        }
}