﻿
module time.Time;
import stdrus: фм;

/******************************************************************************

    Эта структура представляет длину времени. Нижележащее представление состоит
    из единиц в 100 наносекунд. Это даёт временной интервал в +/- 10000 лет.

    В ней заметно отсутствуют представления недель, месяцев и лет.
    Поскольку недели, месяцы и годы отличаются согласно местным календарям.
    С этими понятиями имеет дело модуль время.chrono.*.

    Примечание: не следует менять эту структуру без серьёзного основания,
    так как она нужна как часть некоторых интерфейсов. Надо рассматривать её как
    встроеннный тип. Также заметьте, что здесь отсутствует конструктор opCall,
    так как он потенциально производит массу проблем. Если необходимо построить
    структуру ИнтервалВремени из значения тиков, используйте встроенную
    способность Ди создавать структуру с указанными значениями членов
    (смотрите описание функции тики() как пример выполнения этого).

    Пример:
    -------------------
    Время старт = Часы.сейчас;
    Нить.сон(0.150);
    Стдвыв.форматнс("проспал {} мс", (Часы.сейчас-старт).миллисек);
    -------------------

    See_Also: thread, время.Clock

******************************************************************************/

export struct ИнтервалВремени
{
    // Это единственный член структуры.
    private дол тики_;

    // Полезные константы. Не следует использовать в обычном коде,
    // используйте лучше статические члены ИнтервалВремени.  т.е. вместо
    // ИнтервалВремени.ТиковВСек используйте ИнтервалВремени.секунда.тики
    //
    enum : дол
    {
        /// Базовые значения тиков
        НаносекВТике  = 100,
        ТиковВМикросек = 1000 / НаносекВТике,
        ТиковВМиллисек = 1000 * ТиковВМикросек,
        ТиковВСек      = 1000 * ТиковВМиллисек,
        ТиковВМин      = 60 * ТиковВСек,
        ТиковВЧас        = 60 * ТиковВМин,
        ТиковВДень         = 24 * ТиковВЧас,

        // Счёт миллисекунд
        МиллисекВСек     = 1000,
        МиллисекВМин     = МиллисекВСек * 60,
        МиллисекВЧас       = МиллисекВМин * 60,
        МиллисекВДень        = МиллисекВЧас * 24,

        /// Счёт дней
        ДнейВГоду         = 365,
        ДнейНа4Года       = ДнейВГоду * 4 + 1,
        ДнейНа100Лет     = ДнейНа4Года * 25 - 1,
        ДнейНа400Лет     = ДнейНа100Лет * 4 + 1,

        // Счёт эпох
        Эпоха1601           = ДнейНа400Лет * 4 * ТиковВДень,
        Эпоха1970           = Эпоха1601 + ТиковВСек * 11644473600L,
    }

    const дво	МиллисекНаТик = 1.0 / ТиковВМиллисек;
    const дво    СекНаТик = 1.0 / ТиковВСек;
    const дво   МинутНаТик = 1.0 / ТиковВМин;


    /**
     * Минимальный ИнтервалВремени
     */

    /**
     * Минимальный ИнтервалВремени
     */
    static ИнтервалВремени мин = {дол.min};

    /**
     * Максимальный ИнтервалВремени
     */
    static ИнтервалВремени макс = {дол.max};

    /**
     * Нулевой ИнтервалВремени.  Используется для сравнений.
     */
    static ИнтервалВремени нуль = {0};

/+
   /**
   * Инициализует новый экземпляр.
   * Параметры: тики = Период времени, выраженный в 100-наносекундных единицах.
   */
    export ИнтервалВремени opCall(дол тики)
    {
        this.тики_ = тики;
        return *cast(ИнтервалВремени*) this;
    }

    /**
    *  Инициализует новый экземпляр.
    * Параметры:
    *  часы = Число  _hours.
    *  минуты = Число _minutes.
    *  секунды = Число _seconds.
    */
    export ИнтервалВремени opCall(цел часы, цел минуты, цел секунды)
    {
        this.тики_ = (часы * 3600 + минуты * 60 + секунды) * ТиковВСек;
        return *cast(ИнтервалВремени*) this;
    }

    /**
     *  Инициализует новый экземпляр.
     * Параметры:
     *  дни = Число _days.
     *  часы = Число _hours.
     *  минуты = Число _minutes.
     *  секунды = Число _seconds.
     *  миллисекунды = Число _milliseconds.
     */
   export ИнтервалВремени opCall(цел дни, цел часы, цел минуты, цел секунды, цел миллисекунды = 0)
    {
        this.тики_ = ((дни * 3600 * 24 + часы * 3600 + минуты * 60 + секунды) * 1000 + миллисекунды) * ТиковВМиллисек;
        return *cast(ИнтервалВремени*) this;
    }

    +/
	
	export ИнтервалВремени opAssign(дол т)
	{
	тики_ = т; 
	return *this;
	}
	
    /**
     * Получить число тиков, прелставляющее данный промежуток времени. Может
     * использоваться для построения другого ИнтервалВремени:
     *
     * --------
     * дол тики = мойИнтервалВремени.тики;
     * ИнтервалВремени копияМоегоИнтервалВремени = ИнтервалВремени(тики);
     * --------
     */
   export дол тики()
    {
        return тики_;
    }

    /**
     * Определяет равенство двух значений ИнтервалВремени.
     */
    export бул opEquals(ИнтервалВремени t)
    {
        return тики_ is t.тики_;
    }

    /**
     * Сравнивает объект this с другим значением ИнтервалВремени.
     */
   export цел opCmp(ИнтервалВремени t)
    {
        if (тики_ < t.тики_)
            return -1;

        if (тики_ > t.тики_)
            return 1;

        return 0;
    }

    /**
     * Добавить ИнтервалВремени к this, вернув новый ИнтервалВремени.
     *
     * Параметры: t = Добавляемое значение ИнтервалВремени.
     * Возвращает: Значение ИнтервалВремени, являющееся суммой этого экземпляра и t.
     */
  export  ИнтервалВремени opAdd(ИнтервалВремени t)
    {
        return ИнтервалВремени(тики_ + t.тики_);
    }

    /**
     * Добавить указанный ИнтервалВремени к this ИнтервалВремени, присвоив результат
     * экземпляру this.
     *
     * Параметры: t = Добавляемое значение ИнтервалВремени.
     * Возвращает: копию экземпляра this после прибавки t.
     */
    export ИнтервалВремени opAddAssign(ИнтервалВремени t)
    {
        тики_ += t.тики_;
        return *this;
    }

    /**
     * Отнять указанный ИнтервалВремени от this ИнтервалВремени.
     *
     * Параметры: t = Вычитаемый ИнтервалВремени.
     * Возвращает: Новый промежуток времени, являющийся разностью между this
     * экземпляром и t.
     */
   export ИнтервалВремени opSub(ИнтервалВремени t)
    {
        return ИнтервалВремени(тики_ - t.тики_);
    }

    /**
     *
     * Отнять указанный ИнтервалВремени от this ИнтервалВремени с присвоением.
     *
     * Параметры: t = Вычитаемый ИнтервалВремени.
     * Возвращает: Копия this экземпляра после вычитания t.
     */
   export ИнтервалВремени opSubAssign(ИнтервалВремени t)
    {
        тики_ -= t.тики_;
        return *this;
    }

    /**
     * Масштабировать ИнтервалВремени на заданное количество. Не следует
     * использовать для преобразования в иные единицы. Вместо этого используются
     * аксессоры единиц. Используется только в механизме масштабирования. 
     * Например, если имеется таймаут и нужен сон, дважды превышающий
     * таймаут, то используется таймаут * 2.
     *
     * Параметры: знач = Множитель, используемый для масштабирования этого интервала времени.
     * Возвращает: Новый ИнтервалВремени, масштабированный на знач.
     */
   export ИнтервалВремени opMul(дол знач)
    {
        return ИнтервалВремени(тики_ * знач);
    }

    /**
     * Масштабирует this ИнтервалВремени и присваивает результат this экземпляру.
     *
     * Параметры: знач = Множитель, используемый для масштабирования.
     * Возвращает: Копия this экземпляра после масштабирования.
     */
   export ИнтервалВремени opMulAssign(дол знач)
    {
        тики_ *= знач;
        return *this;
    }

    /**
     * Разделить этот ИнтервалВремени на указанное количество. Не следует
     * использовать для преобразования в иные единицы. Вместо этого используются
     * аксессоры единиц. Используется только в механизме масштабирования. 
     * Например,  если имеется таймаут и требуется сон в половину этого
     * таймаута, нужно использовать таймаут / 2.
     *
     *
     * Параметры: знач = Делитель, используемый для масштабирования этого вринтервала.
     * Возвращает: Новый ИнтервалВремени, поделенный на знач
     */
   export ИнтервалВремени opDiv(дол знач)
    {
        return ИнтервалВремени(тики_ / знач);
    }

    /**
     * Делит этот ИнтервалВремени и присваивает результат этому экземпляру.
     *
     * Параметры: знач = Множитель, используемый для деления.
     * Возвращает: Копию этого экземпляра после деления.
     */
   export ИнтервалВремени opDivAssign(дол знач)
    {
        тики_ /= знач;
        return *this;
    }

    /**
     * Выполняет целое деление с данным интервалом времени.
     *
     * Параметры: t = Делитель, используемый для деления
     * Возвращает: Результат целого деления между этим экземпляром и
     * t.
     */
   export дол opDiv(ИнтервалВремени t)
    {
        return тики_ / t.тики;
    }

    /**
     * Делает отрицательным интервал времени.
     *
     * Возвращает: Отрицательный эквивалени этого интервала времени
     */
  export  ИнтервалВремени opNeg()
    {
        return ИнтервалВремени(-тики_);
    }

    /**
     * Преобразует в наносекунды.
     *
     * Примечание: может происходить потеря данных, так как наносекунды не
     * могут представлять диапазон данных, который представляет ИнтервалВремени.
     *
     * Возвращает: Число наносекунд, которое представляет данный ИнтервалВремени.
     */
 export   дол наносек()
    {
        return тики_ * НаносекВТике;
    }

    /**
     * Преобразует в микросекунды.
     *
     * Возвращает: Число микросекунд, которое представляет данный ИнтервалВремени.
     */
  export  дол микросек()
    {
        return тики_ / ТиковВМикросек;
    }

    /**
     * Преобразует в миллисекунды.
     *
     * Возвращает: Число миллисек, которое представляет данный ИнтервалВремени.
     */
   export дол миллисек()
    {
        return тики_ / ТиковВМиллисек;
    }

    /**
     * Преобразует в секунды.
     *
     * Возвращает: Число сек, которое представляет данный ИнтервалВремени.
     */
    export дол сек()
    {
        return тики_ / ТиковВСек;
    }

    /**
     * Преобразует в минуты.
     *
     * Возвращает: Число минут, которое представляет данный ИнтервалВремени.
     */
   export дол минуты()
    {
        return тики_ / ТиковВМин;
    }

    /**
     * Преобразует в часы.
     *
     * Возвращает: Число часов, которое представляет данный ИнтервалВремени.
     */
   export дол часы()
    {
        return тики_ / ТиковВЧас;
    }

    /**
     * Преобразует в дни.
     *
     * Возвращает: Число дней, которое представляет данный ИнтервалВремени.
     */
   export дол дни()
    {
        return тики_ / ТиковВДень;
    }

    /**
     * Преобразует в интервал плавающей точкой, представляющий сек.
     *
     * Примечание: Может вызывать потерю точности, так как дво не может точно
     * представлять некоторые дробные значения.
     *
     * Возвращает: Интервал, представляющий эту секунду и её дробную
     * часть, которые представляют данный ИнтервалВремени.
     */
   export дво интервал()
    {
        return (cast(дво) тики_) / ТиковВСек;
    }

    /**
     * Преобразует в ВремяДня.
     *
     * Возвращает: ВремяДня, представленное этим ИнтервалВремени.
     */
   export ВремяДня время()
    {
        return ВремяДня(тики_);
    }

    /**
     * Конструирует ИнтервалВремени из заданного числа наносекунд.
     *
     * Note: This may cause a loss of данные since a ИнтервалВремени's resolution
     * is in 100ns increments.
     *
     * Параметры: значение = Число nanoseconds.
     * Возвращает: ИнтервалВремени representing the given число of nanoseconds.
     */
   export static ИнтервалВремени изНаносек(дол значение)
    {
        return ИнтервалВремени(значение / НаносекВТике);
    }

    /**
     * Конструирует ИнтервалВремени из заданного числа микросекунд.
     *
     * Параметры: значение = Число микросекунды.
     * Возвращает: ИнтервалВремени representing the given число of микросекунды.
     */
   export static ИнтервалВремени изМикросек(дол значение)
    {
        return ИнтервалВремени(ТиковВМикросек * значение);
    }

    /**
     * Конструирует ИнтервалВремени из заданного числа milliseconds
     *
     * Параметры: значение = Число milliseconds.
     * Возвращает: ИнтервалВремени representing the given число of milliseconds.
     */
    export static ИнтервалВремени изМиллисек(дол значение)
    {
        return ИнтервалВремени(ТиковВМиллисек * значение);
    }

    /**
     * Конструирует ИнтервалВремени из заданного числа сек
     *
     * Параметры: значение = Число сек.
     * Возвращает: ИнтервалВремени representing the given число of сек.
     */
   export static ИнтервалВремени изСек(дол значение)
    {
        return ИнтервалВремени(ТиковВСек * значение);
    }

    /**
     * Конструирует ИнтервалВремени из заданного числа минуты
     *
     * Параметры: значение = Число минуты.
     * Возвращает: ИнтервалВремени representing the given число of минуты.
     */
  export static ИнтервалВремени изМин(дол значение)
    {
        return ИнтервалВремени(ТиковВМин * значение);
    }

    /**
     * Конструирует ИнтервалВремени из заданного числа часы
     *
     * Параметры: значение = Число часы.
     * Возвращает: ИнтервалВремени representing the given число of часы.
     */
   export static ИнтервалВремени изЧасов(дол значение)
    {
        return ИнтервалВремени(ТиковВЧас * значение);
    }

    /**
     * Конструирует ИнтервалВремени из_ the given число дней
     *
     * Параметры: значение = The число дней.
     * Возвращает: ИнтервалВремени representing the given число дней.
     */
  export  static ИнтервалВремени изДней(дол значение)
    {
        return ИнтервалВремени(ТиковВДень * значение);
    }

    /**
     * Конструирует ИнтервалВремени из_ the given интервал.  The интервал
     * represents сек as a дво.  This допускается Всё whole и
     * fractional сек в_ be passed in.
     *
     * Параметры: значение = The интервал в_ преобразуй in сек.
     * Возвращает: ИнтервалВремени representing the given интервал.
     */
   export static ИнтервалВремени изИнтервала(дво сек)
    {
        return ИнтервалВремени(cast(дол)(сек * ТиковВСек + .1));
    }

    //+++++++++++++++++++++++
    /+
    цел часы()
    {
        return cast(цел)((тики_ / ТиковВЧас) % 24);
    }

    цел минуты()
    {
        return cast(цел)((тики_ / ТиковВМин) % 60);
    }

    цел секунды()()
    {
        return cast(цел)((тики_ / ТиковВСек) % 60);
    }

    цел миллисекунды()
    {
        return cast(цел)((тики_ / ТиковВМиллисек) % 1000);
    }
    +/
  export  дво всегоМиллисек()
    {
        return cast(дво)тики_ * МиллисекНаТик;
    }

   export дво всегоСек()
    {
        return cast(дво)тики_ * СекНаТик;
    }

   export дво всегоМин()
    {
        return cast(дво)тики_ * МинутНаТик;
    }
    /+
    /// Gets the _days component.
    цел дни()
    {
        return cast(цел)(тики_ / ТиковВДень);
    }


    static ИнтервалВремени интервал(дво значение, цел scale)
    {
        дво d = значение * scale;
        дво millis = d + (значение >= 0 ? 0.5 : -0.5);
        return ИнтервалВремени(cast(дол)millis * ТиковВМиллисек);
    }

    /// Возвращает ИнтервалВремени representing a specified number of seconds.
    static ИнтервалВремени изСек(дво значение)
    {
        return интервал(значение, МиллисекВСек);
    }

    /// Возвращает ИнтервалВремени representing a specified number of milliseconds.
    static ИнтервалВремени изМиллисек(дво значение)
    {
        return интервал(значение, 1);
    }
    +/
    /**
     * Compares two ИнтервалВремени values and returns an integer indicating whether the first is shorter than, equal to, or longer than the second.
     * Возвращает: -1 if t1 is shorter than t2; 0 if t1 equals t2; 1 if t1 is longer than t2.
     */
   export static цел сравни(ИнтервалВремени t1, ИнтервалВремени t2)
    {
        if (t1.тики_ > t2.тики_)
            return 1;
        else if (t1.тики_ < t2.тики_)
            return -1;
        return 0;
    }

    /**
     * Compares this instance to a specified ИнтервалВремени and returns an integer indicating whether the first is shorter than, equal to, or longer than the second.
     * Возвращает: -1 if t1 is shorter than t2; 0 if t1 equals t2; 1 if t1 is longer than t2.
     */
   export цел сравниС(ИнтервалВремени другой)
    {
        if (тики_ > другой.тики_)
            return 1;
        else if (тики_ < другой.тики_)
            return -1;
        return 0;
    }

    /**
     * Возвращает значение indicating whether two instances are equal.
     * Параметры:
     *   t1 = The first ИнтервалВремени.
     *   t2 = The seconds ИнтервалВремени.
     * Возвращает: true if the values of t1 and t2 are equal; иначе, false.
     */
   export static бул равны(ИнтервалВремени t1, ИнтервалВремени t2)
    {
        return t1.тики_ == t2.тики_;
    }

    /**
     * Возвращает значение indicating whether this instance is equal to another.
     * Параметры: другой = An ИнтервалВремени to сравни with this instance.
     * Возвращает: true if другой represents the same время интервал as this instance; иначе, false.
     */
  export  бул равен(ИнтервалВремени другой)
    {
        return тики_ == другой.тики_;
    }

  export  бцел вХэш()
    {
        return cast(цел)тики_ ^ cast(цел)(тики_ >> 32);
    }

    /// Возвращает string представление of the значение of this instance.
   export ткст вТкст()
    {
        ткст s;

        цел день = cast(цел)(тики_ / ТиковВДень);
        дол время = тики_ % ТиковВДень;

        if (тики_ < 0)
        {
            s ~= "-";
            день = -день;
            время = -время;
        }
        if (день != 0)
        {
            s ~= фм("%d", день);
            s ~= ".";
        }
        s ~= фм("%0.2d", cast(цел)((время / ТиковВЧас) % 24));
        s ~= ":";
        s ~= фм("%0.2d", cast(цел)((время / ТиковВМин) % 60));
        s ~= ":";
        s ~= фм("%0.2d", cast(цел)((время / ТиковВСек) % 60));

        цел frac = cast(цел)(время % ТиковВСек);
        if (frac != 0)
        {
            s ~= ".";
            s ~= фм("%0.7d", frac);
        }

        return s;
    }

    /// Adds the specified ИнтервалВремени to this instance.
 export   ИнтервалВремени прибавь(ИнтервалВремени ts)
    {
        return ИнтервалВремени(тики_ + ts.тики_);
    }

/// описано ранее
   export void opAddAssign(ИнтервалВремени ts)
    {
        тики_ += ts.тики_;
    }

    /// Subtracts the specified ИнтервалВремени from this instance.
  export  ИнтервалВремени отними(ИнтервалВремени ts)
    {
        return ИнтервалВремени(тики_ - ts.тики_);
    }

    /// описано ранее
   export void opSubAssign(ИнтервалВремени ts)
    {
        тики_ -= ts.тики_;
    }

    /// Возвращает ИнтервалВремени whose значение is the negated значение of this instance.
  export  ИнтервалВремени дайНегатив()
    {
        return ИнтервалВремени(-тики_);
    }

  export  ИнтервалВремени opPos()
    {
        return *this;

    }

}


/******************************************************************************

        Represents a точка во времени.

        Примечания: Время represents dates и times between 12:00:00
        mопрnight on January 1, 10000 BC и 11:59:59 PM on December 31,
        9999 AD.

        Время значения are measured in 100-nanosecond intervals, or тики.
        A дата значение is the число of тики that have elapsed since
        12:00:00 mопрnight on January 1, 0001 AD in the Грегориан
        Календарь.

        Negative Время значения are offsets из_ that same reference точка,
        but backwards in history.  Время значения are not specific в_ any
        Календарь, but for an example, the beginning of December 31, 1 BC
        in the Грегориан Календарь is Время.эпоха - ИнтервалВремени.дни(1).

******************************************************************************/

export struct Время
{
    private дол тики_;

    private enum : дол
    {
        максимум = (ИнтервалВремени.ДнейНа400Лет * 25 - 366) * ИнтервалВремени.ТиковВДень - 1,
        минимум = -((ИнтервалВремени.ДнейНа400Лет * 25 - 366) * ИнтервалВремени.ТиковВДень - 1),
    }

    /// Представляет smallest и largest Значение Времени.
    static const Время мин       = {минимум},
    макс       = {максимум};

    /// Представляет эпоха (1/1/0001)
    static const Время эпоха     = {0};

    /// Представляет эпоха of 1/1/1601 (Commonly использован in Windows systems)
    static const Время эпоха1601 = {ИнтервалВремени.Эпоха1601};

    /// Представляет эпоха of 1/1/1970 (Commonly использован in Unix systems)
    static const Время эпоха1970 = {ИнтервалВремени.Эпоха1970};

    /**********************************************************************

            $(I Property.) Retrieves the число of тики for this Время.
            This значение can be использован в_ construct другой Время struct by
            writing:

            ---------
            дол тики = myTime.тики;
            Время copyOfMyTime = Время(тики);
            ---------


            Возвращает: A дол represented by the время of this
                     экземпляр.

    **********************************************************************/

  export  дол тики()
    {
        return тики_;
    }

    /**********************************************************************

            Determines whether two Время значения are equal.

            Параметры:  значение = A Время _value.
            Возвращает: да if Всё экземпляры are equal; иначе, нет

    **********************************************************************/

   export цел opEquals (Время t)
    {
        return тики_ is t.тики_;
    }

    /**********************************************************************

            Compares two Время значения.

    **********************************************************************/

   export цел opCmp (Время t)
    {
        if (тики_ < t.тики_)
            return -1;

        if (тики_ > t.тики_)
            return 1;

        return 0;
    }

    /**********************************************************************

            добавьs the specified время вринтервал в_ the время, returning a new
            время.

            Параметры:  t = A ИнтервалВремени значение.
            Возвращает: A Время that is the sum of this экземпляр и t.

    **********************************************************************/

   export Время opAdd (ИнтервалВремени t)
    {
        return Время (тики_ + t.тики_);
    }

    /**********************************************************************

            добавьs the specified время вринтервал в_ the время, assigning
            the результат в_ this экземпляр.

            Параметры:  t = A ИнтервалВремени значение.
            Возвращает: The текущ Время экземпляр, with t добавьed в_ the
                     время.

    **********************************************************************/

   export Время opAddAssign (ИнтервалВремени t)
    {
        тики_ += t.тики_;
        return *this;
    }

    /**********************************************************************

            Subtracts the specified время вринтервал из_ the время,
            returning a new время.

            Параметры:  t = A ИнтервалВремени значение.
            Возвращает: A Время whose значение is the значение of this экземпляр
                     minus the значение of t.

    **********************************************************************/

    export Время opSub (ИнтервалВремени t)
    {
        return Время (тики_ - t.тики_);
    }

    /**********************************************************************

            Возвращает время вринтервал which represents the difference во времени
            between this и the given Время.

            Параметры:  t = Значение Времени.
            Возвращает: A ИнтервалВремени which represents the difference between
                     this и t.

    **********************************************************************/

   export ИнтервалВремени opSub (Время t)
    {
        return ИнтервалВремени(тики_ - t.тики_);
    }

    /**********************************************************************

            Subtracts the specified время вринтервал из_ the время,
            assigning the результат в_ this экземпляр.

            Параметры:  t = A ИнтервалВремени значение.
            Возвращает: The текущ Время экземпляр, with t subtracted
                     из_ the время.

    **********************************************************************/

  export  Время opSubAssign (ИнтервалВремени t)
    {
        тики_ -= t.тики_;
        return *this;
    }

    /**********************************************************************

            $(I Property.) Retrieves the дата component.

            Возвращает: A new Время экземпляр with the same дата as
                     this экземпляр, but with the время truncated.

    **********************************************************************/

  export  Время дата()
    {
        return *this - ВремяДня.модуль24(тики_);
    }

    /**********************************************************************

            $(I Property.) Retrieves the время of день.

            Возвращает: A ВремяДня representing the дво of the день
                     elapsed since mопрnight.

    **********************************************************************/

   export ВремяДня время()
    {
        return ВремяДня (тики_);
    }

    /**********************************************************************

            $(I Property.) Retrieves the equivalent ИнтервалВремени.

            Возвращает: A ИнтервалВремени representing this Время.

    **********************************************************************/

  export  ИнтервалВремени вринтервал ()
    {
        return ИнтервалВремени (тики_);
    }

    /**********************************************************************

            $(I Property.) Retrieves a ИнтервалВремени that corresponds в_ Unix
            время (время since 1/1/1970).  Use the ИнтервалВремени accessors в_ получи
            the время in сек, milliseconds, etc.

            Возвращает: A ИнтервалВремени representing this Время as Unix время.

            -------------------------------------
            auto unixTime = Часы.сейчас.unix.сек;
            auto javaTime = Часы.сейчас.unix.миллисек;
            -------------------------------------

    **********************************************************************/

   export ИнтервалВремени юникс()
    {
        return ИнтервалВремени(тики_ - эпоха1970.тики_);
    }
}


/******************************************************************************

        Represents a время of день. This is different из_ ИнтервалВремени in that
        each component is represented внутри the limits of everyday время,
        rather than из_ the старт of the Эпоха. Effectively, the ВремяДня
        эпоха is the первый секунда of each день.

        This is handy for dealing strictly with a 24-час clock instead of
        potentially thousands of годы. For example:
        ---
        auto время = Часы.сейчас.время;
        assert (время.миллисек < 1000);
        assert (время.сек < 60);
        assert (время.минуты < 60);
        assert (время.часы < 24);
        ---

        You can создай a ВремяДня из_ an existing Время or ИнтервалВремени экземпляр
        via the respective время() метод. To преобразуй задний в_ a ИнтервалВремени, use
        the вринтервал() метод

******************************************************************************/

struct ВремяДня
{
    /**
     * часы component of the время of день.  This should be between 0 и
     * 23, включительно.
     */
    public бцел     часы;

    /**
     * минуты component of the время of день.  This should be between 0 и
     * 59, включительно.
     */
    public бцел     минуты;

    /**
     * сек component of the время of день.  This should be between 0 и
     * 59, включительно.
     */
    public бцел     сек;

    /**
     * milliseconds component of the время of день.  This should be between
     * 0 и 999, включительно.
     */
    public бцел     миллисек;

    /**
     * constructor.
     * Параметры: часы = число of часы since mопрnight
     *         минуты = число of минуты преобр_в the час
     *         сек = число of сек преобр_в the минута
     *         миллисек = число of milliseconds преобр_в the секунда
     *
     * Возвращает: a ВремяДня representing the given время fields.
     *
     * Note: There is no verification of the range of значения, or
     * normalization made.  So if you пароль in larger значения than the
     * максимум значение for that field, they will be stored as that значение.
     *
     * example:
     * --------------
     * auto врдня = ВремяДня(100, 100, 100, 10000);
     * assert(врдня.часы == 100);
     * assert(врдня.минуты == 100);
     * assert(врдня.сек == 100);
     * assert(врдня.миллисек == 10000);
     * --------------
     */
   static ВремяДня opCall (бцел часы, бцел минуты, бцел сек, бцел миллисек=0)
    {
        ВремяДня t =void;
        t.часы   = часы;
        t.минуты = минуты;
        t.сек = сек;
        t.миллисек  = миллисек;
        return t;
    }

    /**
     * constructor.
     * Параметры: тики = тики representing a Значение Времени.  This is normalized
     * so that it represent a время of день (modulo-24 etc)
     *
     * Возвращает: a ВремяДня значение that corresponds в_ the время of день of
     * the given число of тики.
     */
  static ВремяДня opCall (дол тики)
    {
        ВремяДня t = void;
        тики = модуль24(тики).тики_;
        t.миллисек  = cast(бцел) (тики / ИнтервалВремени.ТиковВМиллисек);
        t.сек = (t.миллисек / 1_000) % 60;
        t.минуты = (t.миллисек / 60_000) % 60;
        t.часы   = (t.миллисек / 3_600_000) % 24;
        t.миллисек %= 1000;
        return t;
    }

    /**
     * construct a ИнтервалВремени из_ the текущ fields
     *
     * Возвращает: a ВремяДня representing the field значения.
     *
     * Note: that fields are not проверьed against a действителен range, so
     * настройка 60 for минуты is allowed, и will just добавь 1 в_ the час
     * component, и установи the минута component в_ 0.  The результат is
     * normalized, so the часы wrap.  If you пароль in 25 часы, the
     * результатing ВремяДня will have a час component of 1.
     */
   ИнтервалВремени вринтервал ()
    {
        return ИнтервалВремени.изЧасов(часы) +
               ИнтервалВремени.изМин(минуты) +
               ИнтервалВремени.изСек(сек) +
               ИнтервалВремени.изМиллисек(миллисек);
    }

    /**
     * internal routine в_ исправь тики by one день. Also adjusts for
     * offsets in the BC эра
     */
   static ИнтервалВремени модуль24 (дол тики)
    {
        тики %= ИнтервалВремени.ТиковВДень;
        if (тики < 0)
            тики += ИнтервалВремени.ТиковВДень;
        return ИнтервалВремени (тики);
    }
}

/******************************************************************************

    Генерное представление Даты

******************************************************************************/

struct Дата
{
    public бцел         эра,            /// AD, BC
           день,            /// 1 .. 31
           год,           /// 0 в_ 9999
           месяц,          /// 1 .. 12
           деньнед,            /// 0 .. 6
           деньгода;            /// 1 .. 366
}


/******************************************************************************

    Комбинация из Дата и ВремяДня

******************************************************************************/

struct ДатаВремя
{
    public Дата         дата;       /// дата представление
    public ВремяДня    время;       /// время представление
}




/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
    unittest
    {
        assert(ИнтервалВремени.нуль > ИнтервалВремени.мин);
        assert(ИнтервалВремени.макс  > ИнтервалВремени.нуль);
        assert(ИнтервалВремени.макс  > ИнтервалВремени.мин);
        assert(ИнтервалВремени.нуль >= ИнтервалВремени.нуль);
        assert(ИнтервалВремени.нуль <= ИнтервалВремени.нуль);
        assert(ИнтервалВремени.макс >= ИнтервалВремени.макс);
        assert(ИнтервалВремени.макс <= ИнтервалВремени.макс);
        assert(ИнтервалВремени.мин >= ИнтервалВремени.мин);
        assert(ИнтервалВремени.мин <= ИнтервалВремени.мин);

        assert (ИнтервалВремени.изСек(50).сек is 50);
        assert (ИнтервалВремени.изСек(5000).сек is 5000);
        assert (ИнтервалВремени.изМин(50).минуты is 50);
        assert (ИнтервалВремени.изМин(5000).минуты is 5000);
        assert (ИнтервалВремени.изЧасов(23).часы is 23);
        assert (ИнтервалВремени.изЧасов(5000).часы is 5000);
        assert (ИнтервалВремени.изДней(6).дни is 6);
        assert (ИнтервалВремени.изДней(5000).дни is 5000);

        assert (ИнтервалВремени.изСек(50).время.сек is 50);
        assert (ИнтервалВремени.изСек(5000).время.сек is 5000 % 60);
        assert (ИнтервалВремени.изМин(50).время.минуты is 50);
        assert (ИнтервалВремени.изМин(5000).время.минуты is 5000 % 60);
        assert (ИнтервалВремени.изЧасов(23).время.часы is 23);
        assert (ИнтервалВремени.изЧасов(5000).время.часы is 5000 % 24);

        auto врдня = ВремяДня (25, 2, 3, 4);
        врдня = врдня.вринтервал.время;
        assert (врдня.часы is 1);
        assert (врдня.минуты is 2);
        assert (врдня.сек is 3);
        assert (врдня.миллисек is 4);
    }
}


/*******************************************************************************

*******************************************************************************/

debug (Time)
{
    import io.Stdout;
    import время.Clock;
    import время.chrono.Gregorian;

    Время foo()
    {
        auto d = Время(10);
        auto e = ИнтервалВремени(20);

        return d + e;
    }

    проц main()
    {
        auto c = foo();
        Стдвыв (c.тики).нс;


        auto t = ИнтервалВремени(1);
        auto h = t.часы;
        auto m = t.время.минуты;

        auto сейчас = Часы.сейчас;
        auto время = сейчас.время;
        auto дата = Грегориан.генерный.вДату (сейчас);
        сейчас = Грегориан.генерный.воВремя (дата, время);
    }
}
