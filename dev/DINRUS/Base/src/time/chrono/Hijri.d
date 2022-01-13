﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Hijri;

private import time.chrono.Calendar;


/**
 * $(ANCHOR _Hijri)
 * Представляет Hijri Календарь.
 */
export class Хиджри : Календарь
{

    private static const бцел[] ДНИ_В_МЕСЯЦ = [ 0, 30, 59, 89, 118, 148, 177, 207, 236, 266, 295, 325, 355 ];

    /**
     * Представляет текущ эра.
     */
    public const бцел ХИДЖРИ_ЭРА = 1;

    /**
     * Переписано. Возвращает Значение Времени, установленное в указанный дата и время в указанном _эра.
     * Параметры:
     *   год = Целое, представляющее _год.
     *   месяц = Целое, представляющее _месяц.
     *   день = Целое, представляющее _день.
     *   час = Целое, представляющее _час.
     *   минута = Целое, представляющее _минута.
     *   секунда = Целое, представляющее _секунда.
     *   миллисекунда = Целое, представляющее _миллисекунда.
     *   эра = Целое, представляющее _эра.
     * Возвращает: Время, установленное в указанную дата и время.
     */
    export override Время воВремя(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра)
    {
        return Время((днейС1Янв(год, месяц, день) - 1) * ИнтервалВремени.ТиковВДень + дайТикиВремени(час, минута, секунда)) + ИнтервалВремени.изМиллисек(миллисекунда);
    }

    /**
     * Переписано. Возвращает день недели в указанном Время.
     * Параметры: время = Значение Времени.
     * Возвращает: Значение ДняНедели, представляющее день недели времени.
     */
    export override ДеньНедели дайДеньНедели(Время время)
    {
        return cast(ДеньНедели) (cast(бцел) (время.тики / ИнтервалВремени.ТиковВДень + 1) % 7);
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
     * Переписано. Возвращает день годв в указанном Время.
     * Параметры: время = Значение Времени.
     * Возвращает: Целое, представляющее день годв времени.
     */
    export override бцел дайМесяц(Время время)
    {
        return откиньЧасть(время.тики, ЧастьДаты.Месяц);
    }

    /**
     * Переписано. Возвращает год в указанном Время.
     * Параметры: время = Значение Времени.
     * Возвращает: Целое, представляющее год во времени.
     */
    export override бцел дайГод(Время время)
    {
        return откиньЧасть(время.тики, ЧастьДаты.Год);
    }

    /**
     * Переписано. Возвращает эру в указанном Время.
     * Параметры: время = Значение Времени.
     * Возвращает: Целое, представляющее эру во времени.
     */
    export override бцел дайЭру(Время время)
    {
        return ХИДЖРИ_ЭРА;
    }

    /**
     * Переписано. Возвращает число дней в указанном _год и _месяц указанной _эра.
     * Параметры:
     *   год = Целое, представляющее _год.
     *   месяц = Целое, представляющее _месяц.
     *   эра = Целое, представляющее _эра.
     * Возвращает: The число дней в указанном _год и _месяц указанной _эра.
     */
    export override бцел дайДниМесяца(бцел год, бцел месяц, бцел эра)
    {
        if (месяц == 12)
            return високосен_ли(год, ТЕКУЩАЯ_ЭРА) ? 30 : 29;
        return (месяц % 2 == 1) ? 30 : 29;
    }

    /**
     * Переписано. Возвращает число дней в указанном _год указанной _эра.
     * Параметры:
     *   год = Целое, представляющее _год.
     *   эра = Целое, представляющее _эра.
     * Возвращает: The число дней в указанном _год в указанном _эра.
     */
    export override бцел дайДниГода(бцел год, бцел эра)
    {
        return високосен_ли(год, эра) ? 355 : 354;
    }

    /**
     * Переписано. Возвращает число месяцев в указанном _год указанной _эра.
     * Параметры:
     *   год = Целое, представляющее _год.
     *   эра = Целое, представляющее _эра.
     * Возвращает: The число месяцев в указанном _год в указанном _эра.
     */
    export override бцел дайМесяцыГода(бцел год, бцел эра)
    {
        return 12;
    }

    /**
     * Переписано. Показывает. является ли указанный _год в указанном _эра високосным _год.
     * Параметры: год = Целое, представляющее _год.
     * Параметры: эра = Целое, представляющее _эра.
     * Возвращает: да , если указанный _год високосный _год; иначе, нет.
     */
    export override бул високосен_ли(бцел год, бцел эра)
    {
        return (14 + 11 * год) % 30 < 11;
    }

    /**
     * $(I Свойство.) Переписано. Выводит список эр в текущ Календаре.
     * Возвращает: Массив целых чисел, представляющий эры в текущ Календаре.
     */
    export override бцел[] эры()
    {
        auto врем = [ХИДЖРИ_ЭРА];
        return врем.dup;
    }

    /**
     * $(I Свойство.) Переписано. Получает определитель, ассоциированный с текущ Календарём.
     * Возвращает: Целое, представляющее определитель текущ Календаря.
     */
    export override бцел ид()
    {
        return ХИДЖРИ;
    }

    private дол дниВГод(бцел год)
    {
        цел цикл = ((год - 1) / 30) * 30;
        цел остаток = год - цикл - 1;
        дол дни = ((цикл * 10631L) / 30L) + 227013L;
        while (остаток > 0)
        {
            дни += 354 + (високосен_ли(остаток, ТЕКУЩАЯ_ЭРА) ? 1 : 0);
            остаток--;
        }
        return дни;
    }

    private дол днейС1Янв(бцел год, бцел месяц, бцел день)
    {
        return cast(дол)(дниВГод(год) + ДНИ_В_МЕСЯЦ[месяц - 1] + день);
    }

    private цел откиньЧасть(дол тики, ЧастьДаты часть)
    {
        дол дни = ИнтервалВремени(тики).дни + 1;
        цел год = cast(цел)(((дни - 227013) * 30) / 10631) + 1;
        дол daysUpToYear = дниВГод(год);
        дол daysInYear = дайДниГода(год, ТЕКУЩАЯ_ЭРА);
        if (дни < daysUpToYear)
        {
            daysUpToYear -= daysInYear;
            год--;
        }
        else if (дни == daysUpToYear)
        {
            год--;
            daysUpToYear -= дайДниГода(год, ТЕКУЩАЯ_ЭРА);
        }
        else if (дни > daysUpToYear + daysInYear)
        {
            daysUpToYear += daysInYear;
            год++;
        }

        if (часть == ЧастьДаты.Год)
            return год;

        дни -= daysUpToYear;
        if (часть == ЧастьДаты.ДеньГода)
            return cast(цел)дни;

        цел месяц = 1;
        while (месяц <= 12 && дни > ДНИ_В_МЕСЯЦ[месяц - 1])
            месяц++;
        месяц--;
        if (часть == ЧастьДаты.Месяц)
            return месяц;

        return cast(цел)(дни - ДНИ_В_МЕСЯЦ[месяц - 1]);
    }

}

