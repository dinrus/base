﻿module time.Time;
import stdrus: фм;

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
   export static ИнтервалВремени мин()
	{
	 return ИнтервалВремени(дол.min);
	 }

    /**
     * Максимальный ИнтервалВремени
     */
   export static ИнтервалВремени макс()
	{
	 return ИнтервалВремени(дол.max);
	 }

    /**
     * Нулевой ИнтервалВремени.  Используется для сравнений.
     */
    export static ИнтервалВремени нуль()
	{
	 return ИнтервалВремени(0);
	 }
	

   /**
   * Инициализует новый экземпляр.
   * Параметры: тики = Период времени, выраженный в 100-наносекундных единицах.
   */
    export static ИнтервалВремени opCall(дол тики)
    {
	ИнтервалВремени ив;
        ив.тики_ = тики;
        return ив;
    }

    /**
    *  Инициализует новый экземпляр.
    * Параметры:
    *  часы = Число  _hours.
    *  минуты = Число _minutes.
    *  секунды = Число _seconds.
    */
    export static ИнтервалВремени opCall(цел часы, цел минуты, цел секунды)
    {
	ИнтервалВремени ив;
        ив.тики_ = (часы * 3600 + минуты * 60 + секунды) * ТиковВСек;
        return ив;
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
   export static ИнтервалВремени opCall(цел дни, цел часы, цел минуты, цел секунды, цел миллисекунды = 0)
    {
	ИнтервалВремени ив;
        ив.тики_ = ((дни * 3600 * 24 + часы * 3600 + минуты * 60 + секунды) * 1000 + миллисекунды) * ТиковВМиллисек;
        return ив;
    }

    
	
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
        return тики_ is t.тики;
    }

    /**
     * Сравнивает объект this с другим значением ИнтервалВремени.
     */
   export цел opCmp(ИнтервалВремени t)
    {
        if (тики_ < t.тики)
            return -1;

        if (тики_ > t.тики)
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
        return ИнтервалВремени(тики_ + t.тики);
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
        тики_ += t.тики;
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
        return ИнтервалВремени(тики_ - t.тики);
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
        тики_ -= t.тики;
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
     * represents сек как дво.  This допускается Всё whole и
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
     * Compares two ИнтервалВремени values and returns an integer indicating whether the first is shorter than, equal to, либо longer than the second.
     * Возвращает: -1 if t1 is shorter than t2; 0 if t1 equals t2; 1 if t1 is longer than t2.
     */
   export static цел сравни(ИнтервалВремени t1, ИнтервалВремени t2)
    {
        if (t1.тики > t2.тики)
            return 1;
        else if (t1.тики < t2.тики)
            return -1;
        return 0;
    }

    /**
     * Compares this instance to a specified ИнтервалВремени and returns an integer indicating
     * whether the first is shorter than, equal to, либо longer than the second.
     * Возвращает: -1 if t1 is shorter than t2; 0 if t1 equals t2; 1 if t1 is longer than t2.
     */
   export цел сравниС(ИнтервалВремени другой)
    {
        if (тики_ > другой.тики)
            return 1;
        else if (тики_ < другой.тики)
            return -1;
        return 0;
    }

    /**
     * Возвращает значение, показывающее, равны ли два экземпляра.
     * Параметры:
     *   t1 = Первый ИнтервалВремени.
     *   t2 = Второйs ИнтервалВремени.
     * Возвращает: да, если значения t1 и t2 равны; иначе, нет.
     */
   export static бул равны(ИнтервалВремени t1, ИнтервалВремени t2)
    {
        return t1.тики == t2.тики;
    }

    /**
     * Возвращает значение indicating whether this instance is equal to another.
     * Параметры: другой = An ИнтервалВремени to сравни with this instance.
     * Возвращает: true if другой represents the same время интервал as this instance; иначе, false.
     */
  export  бул равен(ИнтервалВремени другой)
    {
        return тики_ == другой.тики;
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
        return ИнтервалВремени(тики_ + ts.тики);
    }

/// описано ранее
   export void opAddAssign(ИнтервалВремени ts)
    {
        тики_ += ts.тики;
    }

    /// Subtracts the specified ИнтервалВремени from this instance.
  export  ИнтервалВремени вычти(ИнтервалВремени ts)
    {
        return ИнтервалВремени(тики_ - ts.тики);
    }

    /// описано ранее
   export void opSubAssign(ИнтервалВремени ts)
    {
        тики_ -= ts.тики;
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


export struct Время
{
    private дол тики_;

    private enum : дол
    {
        максимум = (ИнтервалВремени.ДнейНа400Лет * 25 - 366) * ИнтервалВремени.ТиковВДень - 1,
        минимум = -((ИнтервалВремени.ДнейНа400Лет * 25 - 366) * ИнтервалВремени.ТиковВДень - 1),
    }
	
	    /// Представляет эпоху 1/1/1601 (Широко используется на системах Windows)
    export static Время эпоха1601()
	{
	return Время(ИнтервалВремени.Эпоха1601);
	}

    /// Представляет эпоха of 1/1/1970 (Широко используется на системах Unix)
    export static Время эпоха1970()
	{
	return Время(ИнтервалВремени.Эпоха1970);
	}
	
   export static Время opCall(бдол тики)
	{
	Время в;
	в.тики_ = тики;
	return в;
	}

    /// Представляет наименьшее и наибольшее значение Времени.
    export static Время мин()
	 {
	 return Время(минимум);
	 }
	 
    export static Время макс()
	 {
	 return Время(максимум);
	 }

    /// Представляет эпоху (1/1/0001)
    export static Время эпоха()
	{
	return Время(0);
	}
	
  export  дол тики()
    {
        return тики_;
    }

   export цел opEquals (Время t)
    {
        return тики_ is t.тики;
    }

   export цел opCmp (Время t)
    {
        if (тики_ < t.тики)
            return -1;

        if (тики_ > t.тики)
            return 1;

        return 0;
    }

   export Время opAdd (ИнтервалВремени t)
    {
        return Время (тики_ + t.тики);
    }

   export Время opAddAssign (ИнтервалВремени t)
    {
        тики_ += t.тики;
        return *this;
    }

    export Время opSub (ИнтервалВремени t)
    {
        return Время (тики_ - t.тики);
    }

   export ИнтервалВремени opSub (Время t)
    {
        return ИнтервалВремени(тики_ - t.тики);
    }

  export  Время opSubAssign (ИнтервалВремени t)
    {
        тики_ -= t.тики;
        return *this;
    }

  export  Время дата()
    {
        return *this - ВремяДня.модуль24(тики_);
    }

   export ВремяДня время()
    {
        return ВремяДня (тики_);
    }

  export  ИнтервалВремени вринтервал ()
    {
        return ИнтервалВремени (тики_);
    }

   export ИнтервалВремени юникс()
    {
        return ИнтервалВремени(тики_ - эпоха1970.тики_);
    }
}


export struct ВремяДня
{

    private бцел     часы_;
    private бцел     минуты_;
    private бцел     сек_;
    private бцел     миллисек_;

    export бцел  часы (бцел ч = бцел.init)
	{	
	if(ч != бцел.init) часы_ = ч;
	return часы_;
	};

    export бцел  минуты(бцел м = бцел.init)
	{
	if(м != бцел.init) минуты_ = м;
	return минуты_;
	};

    export бцел  сек(бцел с = бцел.init)
	{
	if(с != бцел.init) сек_ = с;
	return сек_;
	};;

    export бцел  миллисек(бцел мс = бцел.init)
	{
	if(мс != бцел.init) миллисек_ = мс;
	return миллисек_;
	};;

   export static ВремяДня opCall (бцел часы, бцел минуты, бцел сек, бцел миллисек=0)
    {
        ВремяДня t =void;
        t.часы_   = часы;
        t.минуты_ = минуты;
        t.сек_ = сек;
        t.миллисек_  = миллисек;
        return t;
    }

  export static ВремяДня opCall (дол тики)
    {
        ВремяДня t = void;
        тики = модуль24(тики).тики_;
        t.миллисек_  = cast(бцел) (тики / ИнтервалВремени.ТиковВМиллисек);
        t.сек_ = (t.миллисек_ / 1_000) % 60;
        t.минуты_ = (t.миллисек_ / 60_000) % 60;
        t.часы_   = (t.миллисек_ / 3_600_000) % 24;
        t.миллисек_ %= 1000;
        return t;
    }

  export  ИнтервалВремени вринтервал ()
    {
        return ИнтервалВремени.изЧасов(часы_) +
               ИнтервалВремени.изМин(минуты_) +
               ИнтервалВремени.изСек(сек_) +
               ИнтервалВремени.изМиллисек(миллисек_);
    }

  export  static ИнтервалВремени модуль24 (дол тики)
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
    import time.Clock;
    import time.chrono.Gregorian;

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

