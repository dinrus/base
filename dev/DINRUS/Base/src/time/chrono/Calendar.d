module time.chrono.Calendar;

public  import time.Time;
private import exception;


export abstract class Календарь
{
    /**
    * Указывает текущ эру Календаря.
    */
    package enum {ТЕКУЩАЯ_ЭРА = 0};

    // Соответствует Win32 Календарь IDs
    package enum
    {
        ГРЕГОРИАНСКИЙ = 1,
        ГРЕГОРИАНСКИЙ_США = 2,
        ЯПОНСКИЙ = 3,
        ТАЙВАНЬСКИЙ = 4,
        КОРЕЙСКИЙ = 5,
        ХИДЖРИ = 6,
        ТАИ = 7,
        ЕВРЕЙСКИЙ = 8,
        ГРЕГОРИАН_СВ_ФРАНЦ = 9,
        ГРЕГОРИАН_АРАБ = 10,
        ГРЕГОРИАН_ТРАНСЛИТ_АНГЛ = 11,
        ГРЕГОРИАН_ТРАНСЛИТ_ФРАНЦ = 12
    }

    package enum ПравилоНедели
    {
        ПервыйДень,         /// Показывает, что первая неделя года - это первоя неделя, вкоторой первый день годв.
        ПерваяПолнаяНеделя,    /// Показывает, что первая неделя года - это первая полная неделя, следующая за первым днём годв.
        ПерваяНеделяС4Днями  /// Показывает, что первая неделя года - это первая неделя, в которй, как минимум, 4 дня.
    }

    package enum ЧастьДаты
    {
        Год,
        Месяц,
        День,
        ДеньГода
    }

    public enum ДеньНедели
    {
        Воскресенье,    /// Указывает _Воскресенье.
        Понедельник,    /// Указывает _Понедельник.
        Вторник,   /// Указывает _Вторник.
        Среда, /// Указывает _Среда.
        Четверг,  /// Указывает _Четверг.
        Пятница,    /// Указывает _Пятница.
        Суббота   /// Указывает _Суббота.
    }


    /**
     * Получить компоненты структуры Время, используя правила
     * Календаря. Полезно, если нужно более одного из заданных
     * компонентов. Здесь не указывается время дня, так как оно
     * вычисляется прямо из структуры Время.
     *
     * В дефолтной реализации вызываются все другие аксессоры
     * непосредственно, а производный класс может переписать,
     * если в нём более действенный метод.
     */
    export Дата вДату (Время время)
    {
        Дата d;
        разбей (время, d.год, d.месяц, d.день, d.деньгода, d.деньнед, d.эра);
        return d;
    }

    /**
     * Получить компоненты структуры Время, используя правила
     * Календаря. Полезно, если нужно более одного из заданных
     * компонентов. Здесь не указывается время дня, так как оно
     * вычисляется прямо из структуры Время.
     *
     * В дефолтной реализации вызываются все другие аксессоры
     * непосредственно, а производный класс может переписать,
     * если в нём более действенный метод.
     */
    export проц разбей (Время время, ref бцел год, ref бцел месяц, ref бцел день, ref бцел деньгода, ref бцел деньнед, ref бцел эра)
    {
        год = дайГод(время);
        месяц = дайМесяц(время);
        день = дайДеньМесяца(время);
        деньгода = дайДеньГода(время);
        деньнед = дайДеньНедели(время);
        эра = дайЭру(время);
    }

    /**
    * Возвращает Значение Времени, установленное в указанный дата и время в текущ эра.
    * Параметры:
    *   год = Целое, представляющее _год.
    *   месяц = Целое, представляющее _месяц.
    *   день = Целое, представляющее _день.
    *   час = Целое, представляющее _час.
    *   минута = Целое, представляющее _минута.
    *   секунда = Целое, представляющее _секунда.
    *   миллисекунда = Целое, представляющее _миллисекунда.
    * Возвращает: The Время, установленное в указанный дата и время.
    */
   export Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда=0)
    {
        return воВремя (год, месяц, день, час, минута, секунда, миллисекунда, ТЕКУЩАЯ_ЭРА);
    }

    /**
    * Возвращает Значение Времени для данной Даты, в текущ эра
    * Параметры:
    *   дата = Представление Даты
    * Возвращает:  Время, установленное в указанный дата.
    */
   export Время воВремя (Дата d)
    {
        return воВремя (d.год, d.месяц, d.день, 0, 0, 0, 0, d.эра);
    }

    /**
    * Возвращает Значение Времени для данной ДатаВремя, в текущ эра
    * Параметры:
    *   dt = a представление даты и времени
    * Возвращает: Время, установленное в заданные дату и время.
    */
   export Время воВремя (ДатаВремя dt)
    {
        return воВремя (dt.дата, dt.время);
    }

    /**
    * Возвращает Значение Времени для заданных Дата и ВремяДня, в текущ эра
    * Параметры:
    *   d = a представление даты
    *   t = a представление времени дня
    * Возвращает: Время, установленное в указанные дата и время.
    */
   export Время воВремя (Дата d, ВремяДня t)
    {
        return воВремя (d.год, d.месяц, d.день, t.часы, t.минуты, t.сек, t.миллисек, d.эра);
    }

    /**
    * При переписании, возвращает a Значение Времени, установленное в указанный дата и время в указанном _эра.
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
    abstract Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра);

    /**
    * При переписании, возвращает день недели в указанном Время.
    * Параметры: время = Значение Времени.
    * Возвращает: Значение ДняНедели, представляющий день недели времени.
    */
    abstract ДеньНедели дайДеньНедели (Время время);

    /**
    * При переписании, возвращает день месяца в указанном Время.
    * Параметры: время = Значение Времени.
    * Возвращает: Целое, представляющее день месяца времени.
    */
    abstract бцел дайДеньМесяца (Время время);

    /**
    * При переписании, возвращает день годв в указанном Время.
    * Параметры: время = Значение Времени.
    * Возвращает: Целое, представляющее день годв времени.
    */
    abstract бцел дайДеньГода (Время время);

    /**
    * При переписании, возвращает месяц в указанном Время.
    * Параметры: время = Значение Времени.
    * Возвращает: Целое, представляющее месяц во времени.
    */
    abstract бцел дайМесяц (Время время);

    /**
    * При переписании, возвращает год в указанном Время.
    * Параметры: время = Значение Времени.
    * Возвращает: Целое, представляющее год во времени.
    */
    abstract бцел дайГод (Время время);

    /**
    * При переписании, возвращает эра в указанном Время.
    * Параметры: время = Значение Времени.
    * Возвращает: Целое, представляющее ear во времени.
    */
    abstract бцел дайЭру (Время время);

    /**
    * Возвращает число дней в указанном _год и _месяц текущ эры.
    * Параметры:
    *   год = Целое, представляющее _год.
    *   месяц = Целое, представляющее _месяц.
    * Возвращает: The число дней в указанном _год и _месяц текущ эры.
    */
   export бцел дайДниМесяца (бцел год, бцел месяц)
    {
        return дайДниМесяца (год, месяц, ТЕКУЩАЯ_ЭРА);
    }

    /**
    * При переписании, возвращает число дней в указанном _год и _месяц указанного _эра.
    * Параметры:
    *   год = Целое, представляющее _год.
    *   месяц = Целое, представляющее _месяц.
    *   эра = Целое, представляющее _эра.
    * Возвращает: The число дней в указанном _год и _месяц указанного _эра.
    */
    abstract бцел дайДниМесяца (бцел год, бцел месяц, бцел эра);

    /**
    * Возвращает число дней в указанном _год текущ эры.
    * Параметры: год = Целое, представляющее _год.
    * Возвращает: The число дней в указанном _год в текущ эра.
    */
   export бцел дайДниГода (бцел год)
    {
        return дайДниГода (год, ТЕКУЩАЯ_ЭРА);
    }

    /**
    * При переписании, возвращает число дней в указанном _год указанного _эра.
    * Параметры:
    *   год = Целое, представляющее _год.
    *   эра = Целое, представляющее _эра.
    * Возвращает: The число дней в указанном _год в указанном _эра.
    */
    abstract бцел дайДниГода (бцел год, бцел эра);

    /**
    * Возвращает число месяцев в указанном _год текущ эры.
    * Параметры: год = Целое, представляющее _год.
    * Возвращает: The число месяцев в указанном _год в текущ эра.
    */
   export бцел дайМесяцыГода (бцел год)
    {
        return дайМесяцыГода (год, ТЕКУЩАЯ_ЭРА);
    }

    /**
    * При переписании, возвращает число месяцев в указанном _год указанного _эра.
    * Параметры:
    *   год = Целое, представляющее _год.
    *   эра = Целое, представляющее _эра.
    * Возвращает: The число месяцев в указанном _год в указанном _эра.
    */
    abstract бцел дайМесяцыГода (бцел год, бцел эра);

    /**
    * Возвращает неделю года, включающую указанное Время.
    * Параметры:
    *   время = Значение Времени.
    *   правило = Значение ПравилоНедели , определяющий календарную Неделю.
    *   первыйДеньНед = Значение ДняНедели, представляющее первый день недели.
    * Возвращает: Целое, представляющее неделю года, включающую эту дату во времени.
    */
   export бцел дайНеделюГода (Время время, ПравилоНедели правило, ДеньНедели первыйДеньНед)
    {
        auto год = дайГод (время);
        auto янв1 = cast(цел) дайДеньНедели (воВремя (год, 1, 1, 0, 0, 0, 0));

        switch (правило)
        {
        case ПравилоНедели.ПервыйДень:
            цел n = янв1 - cast(цел) первыйДеньНед;
            if (n < 0)
                n += 7;
            return (дайДеньГода (время) + n - 1) / 7 + 1;

        case ПравилоНедели.ПерваяПолнаяНеделя:
        case ПравилоНедели.ПерваяНеделяС4Днями:
            цел полныеДни = (правило is ПравилоНедели.ПерваяПолнаяНеделя) ? 7 : 4;
            цел n = cast(цел) первыйДеньНед - янв1;
            if (n != 0)
            {
                if (n < 0)
                    n += 7;
                else if (n >= полныеДни)
                    n -= 7;
            }

            цел день = дайДеньГода (время) - n;
            if (день > 0)
                return (день - 1) / 7 + 1;
            год = дайГод(время) - 1;
            цел месяц = дайМесяцыГода (год);
            день = дайДниМесяца (год, месяц);
            return дайНеделюГода(воВремя(год, месяц, день, 0, 0, 0, 0), правило, первыйДеньНед);

        default:
            break;
        }
        throw new ИсклНелегальногоАргумента("Значение вышло за пределы диапазона.");
    }

    /**
    * Показывает, является ли указанный _год в текущ эра високосный _год.
    * Параметры: год = Целое, представляющее _год.
    * Возвращает: да, указанный _год високосный _год; иначе, false.
    */
   export бул високосен_ли(бцел год)
    {
        return високосен_ли(год, ТЕКУЩАЯ_ЭРА);
    }

    /**
    * При переписании, показывает, является ли указанный _год в указанном _эра високосным _год.
    * Параметры: год = Целое, представляющее _год.
    * Параметры: эра = Целое, представляющее _эра.
    * Возвращает: да,указанный _год високосный _год; иначе, false.
    */
    abstract бул високосен_ли(бцел год, бцел эра);

    /**
    * $(I Свойство.) Припереписании, выдаёт список эр в текущ Календарь.
    * Возвращает: Массив целых чисел, представляющий эры в текущ Календарь.
    */
    abstract бцел[] эры();

    /**
    * $(I Свойство.) Выдаётe определитель, ассоциированный с текущ Календарь.
    * Возвращает: Целое, представляющее определитель текущ Календаря.
    */
   export бцел ид()
    {
        return -1;
    }

    /**
     * Возвращает новое Время с добавкой заданного числа месяцев. Если
     * месяцы отрицательны, месяцы отнимаются.
     *
     * Если целевой месяц не поддерживает компонент день введённого времени,
     * выволится ошибка, - когда обрезатьДень не установлен в
     * true. Если обрезатьДень установлен в да, тогжа день сводится к
     * максимальному дню этого месяца.
     *
     * Например, добавим один месяц к 1/31/2000, с обрезатьДень установленным в
     * да,- получим 2/28/2000.
     *
     * В дефолтной реализации используется информация, предоставленная
     * Календарём, чтобы правильно расчитать добавку времени. В производных классах
     * это можо переписать, если есть более оптимальный метод.
     *
     * Note that the генерный метод does not возьми преобр_в account crossing
     * эра boundaries.  Derived classes may support this.
     *
     * Параметры: t = A время в_ добавь the месяцы в_
     * Параметры: члоМес = The число месяцев в_ добавь.  This can be
     * негатив.
     * Параметры: обрезатьДень = Round the день down в_ the maximum день of the
     * мишень месяц if necessary.
     *
     * Возвращает: A Время that represents the предоставленный время with the число
     * of месяцы добавьed.
     */
   export Время добавьМесяцы(Время t, цел члоМес, бул обрезатьДень = false)
    {
        бцел эра = дайЭру(t);
        бцел год = дайГод(t);
        бцел месяц = дайМесяц(t);

        //
        // Assume we go задний в_ день 1 of the текущ год, taking
        // преобр_в account that смещение using the члоМес и nDays
        // offsets.
        //
        члоМес += месяц - 1;
        цел origDom = cast(цел)дайДеньМесяца(t);
        дол nDays = origDom - cast(цел)дайДеньГода(t);
        if(члоМес > 0)
        {
            //
            // добавим, добавь все the годы until the год we want в_
            // be in.
            //
            auto miy = дайМесяцыГода(год, эра);
            while(члоМес >= miy)
            {
                //
                // пропусти a whole год
                //
                nDays += дайДниГода(год, эра);
                члоМес -= miy;
                год++;

                //
                // обнови miy
                //
                miy = дайМесяцыГода(год, эра);
            }
        }
        else if(члоМес < 0)
        {
            //
            // subtracting месяцы
            //
            while(члоМес < 0)
            {
                auto miy = дайМесяцыГода(--год, эра);
                nDays -= дайДниГода(год, эра);
                члоМес += miy;
            }
        }

        //
        // we сейчас are смещение в_ the результатing год.
        // Добавь the rest of the месяцы в_ получи в_ the день we want.
        //
        цел newDom = cast(цел)дайДниМесяца(год, члоМес + 1, эра);
        if(origDom > newDom)
        {
            //
            // ошибка, the результатing день of месяц is out of range.  See
            // if we should упрости
            //
            if(обрезатьДень)
                nDays -= newDom - origDom;
            else
                throw new ИсклНелегальногоАргумента("дни вышли вне допустимого диапазона");

        }
        for(цел m = 0; m < члоМес; m++)
            nDays += дайДниМесяца(год, m + 1, эра);
        return t + ИнтервалВремени.изДней(nDays);
    }

    /**
     * Добавь the specified число of годы в_ the given Время.
     *
     * The генерный algorithm uses information предоставленный by the abstract
     * methods.  Derived classes may re-implement this in order в_
     * оптимизируй the algorithm
     *
     * Note that the генерный algorithm does not возьми преобр_в account crossing
     * эра boundaries.  Derived classes may support this.
     *
     * Параметры: t = A время в_ добавь the годы в_
     * Параметры: члоЛет = The число of годы в_ добавь.  This can be негатив.
     *
     * Возвращает: A Время that represents the предоставленный время with the число
     * of годы добавьed.
     */
    export Время добавьГоды(Время t, цел члоЛет)
    {
        auto дата = вДату(t);
        auto врдня = t.тики % ИнтервалВремени.ТиковВДень;
        if(врдня < 0)
            врдня += ИнтервалВремени.ТиковВДень;
        дата.год += члоЛет;
        return воВремя(дата) + ИнтервалВремени(врдня);

    }

    package static дол дайТикиВремени (бцел час, бцел минута, бцел секунда)
    {
        return (ИнтервалВремени.изЧасов(час) + ИнтервалВремени.изМин(минута) + ИнтервалВремени.изСек(секунда)).тики;
    }
}
