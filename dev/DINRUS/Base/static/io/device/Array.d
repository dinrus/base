﻿
module io.device.Array;

private import exception;
private import io.device.Conduit;
import cidrus: memcpy;

class Массив : Провод, БуферВвода, БуферВывода, ИПровод.ИШаг
{


    private проц[]  данные;                   // буфер необработанных данных
    private т_мера  индекс;                  // текущая позиция чтения
    private т_мера  протяженность;                 // предел действительного контента
    private т_мера  дименсия;              // максимальная протяженность контента
    private т_мера  расширение;              // для нарастающих экземпляров

    protected static ткст перебор  = "буфер вывода полон";
    protected static ткст недобор = "буфер ввода пуст";
    protected static ткст кфЧтен   = "достигнут конец потока при чтении";
    protected static ткст кфЗап  = "достигнут конец потока при записи";

    /***********************************************************************

            Гарантирует действительность буфера между вызовами методов.

    ***********************************************************************/

    invariant
    {
        assert (индекс <= протяженность);
        assert (протяженность <= дименсия);
    }

    /***********************************************************************

            Конструирует буфер.

            Параметры:
            ёмкость = число доступных байтов
            нарастает  = размер чанка нарастающего экземпляра, либо ноль,
                       если нужно запретить расширение

            Примечания:
            Конструирует Буфер с заданным числом байтов
            и политикой расширения.

    ***********************************************************************/
    this (т_мера ёмкость = 0, т_мера нарастает = 0)
    {
        присвой (new ббайт[ёмкость], 0);
        расширение = нарастает;
    }

    /***********************************************************************

            Конструирует буфер.

            Параметры:
            данные = поддерживающий Массив с внутренним буфером.

            Примечания:
            Буфер инициализуется прилагаемым приложением Массивом. Весь контент
            считается пригодным для чтения, и, следовательно, изначально
            отсутствует пространство для записи.

    ***********************************************************************/

    this (проц[] данные)
    {
        присвой (данные, данные.length);
    }

    /***********************************************************************

            Конструирует буфер.

            Параметры:
            данные =     поддерживающий Массив с внутренним буфером.
            читаемый =  число байтов, изначально читаемых по свойству.

            Примечания:
            Буфер инициализуется прилагаемым приложением Массивом, а
            следовательно, данные для чтения уже есть. Операция
            записи производится сразу после существующего контента
            для чтения.

            Это широко распространенный случай использования с прикреплением
            экземпляра Буфера к локальному Массиву.

    ***********************************************************************/

    this (проц[] данные, т_мера читаемый)
    {
        присвой (данные, читаемый);
    }

    /***********************************************************************

            Возвращает имя данного провода.

    ***********************************************************************/

    final override ткст вТкст ()
    {
        return "<io.device.Array.Массив>";
    }

    /***********************************************************************

            Заносит контент в предоставленный приёмник.

            Параметры:
            приёмн = приёмник контента

            Возвращает:
            возвращает число считанных байтов, которое должно быть меньше
            приёмн.length. Кф возвращается, когда больше нет доступного
            контента.

            Примечания:
            Населяет предоставленный Массив контентом. Пытаемся удовлетворить
            запрос контента буфера, и считать
            прямо из прикреплённого провода, когда буфер
            пустой.

    ***********************************************************************/

    final override т_мера читай (проц[] приёмн)
    {
        auto контент = читаемый;
        if (контент)
        {
            if (контент >= приёмн.length)
                контент = приёмн.length;

            // переместим контент буфера
            приёмн [0 .. контент] = данные [индекс .. индекс + контент];
            индекс += контент;
        }
        else
            контент = ИПровод.Кф;
        return контент;
    }

    /***********************************************************************

            Эмулирует ИПотокВывода.пиши()

            Параметры:
            ист = записываемый контент

            Возвращает:
            возвращает число записанных байтов, которое должно быть меньше
            предоставленного (концептуально). Возвращает Кф, когда буфер становится
            полным.

            Примечания:
            Добавляет ист контент в буфер, расширяяего, если требуется и
            сконфигурировано на это (этим конструктором).

    ***********************************************************************/

    final override т_мера пиши (проц[] ист)
    {
        auto длин = ист.length;
        if (длин)
        {
            if (длин > записываемый)
                if (расширь(длин) < длин)
                    return Кф;

            // контент может накладываться ...
            memcpy (&данные[протяженность], ист.ptr, длин);
            протяженность += длин;
        }
        return длин;
    }

    /***********************************************************************

            Вернуть предпочитаемый размер для буферирующего провода ввода-вывода

    ***********************************************************************/

    final override т_мера размерБуфера ()
    {
        return данные.length;
    }

    /***********************************************************************

            Освободить внешние ресурсы

    ***********************************************************************/

    override проц открепи ()
    {
    }

    /***********************************************************************

            Смещение внутри пределов назначенного контента

    ***********************************************************************/

    override дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
    {
        if (смещение > предел)
            смещение = предел;

        switch (якорь)
        {
        case Якорь.Кон:
            индекс = cast(т_мера) (предел - смещение);
            break;

        case Якорь.Нач:
            индекс = cast(т_мера) смещение;
            break;

        case Якорь.Тек:
            дол o = cast(т_мера) (индекс + смещение);
            if (o < 0)
                o = 0;
            if (o > предел)
                o = предел;
            индекс = cast(т_мера) o;
        default:
            break;
        }
        return индекс;
    }

    /***********************************************************************

            Сбросить контент буфера.

            Параметры:
            данные =  поддерживающий Массив с внутренним буфером. Весь контент
                    полагается действительным.

            Возвращает:
            экземпляр буфера

            Примечания:
            Устанавливает поддерживающий Массив с читаемым содержимым.

    ***********************************************************************/

    Массив присвой (проц[] данные)
    {
        return присвой (данные, данные.length);
    }

    /***********************************************************************

            Сбросить контент буфера.

            Параметры:
            данные     = поддерживающий Массив с внутренним буфером.
            читаемый = число байтов, внутренние данные которых считаются
                       действительными.

            Возвращает:
            экземпляр буфера

            Примечания:
            Устанавливает поддерживающий с некоторым контентом для чтения. Метод очисть()
            сбрасывает контент(делая его весь записываемым).

    ***********************************************************************/

    Массив присвой (проц[] данные, т_мера читаемый)
    {
        this.данные = данные;
        this.протяженность = читаемый;
        this.дименсия = данные.length;

        // сбросить на начало ввода
        this.расширение = 0;
        this.индекс = 0;
        return this;
    }

    /***********************************************************************

            Доступ к содержимому буфера.

            Примечания:
            Возвращает весь поддерживающий Массив.

    ***********************************************************************/

    final проц[] присвой ()
    {
        return данные;
    }

    /***********************************************************************

            Возвращает проц[] читай буфера от старт до конец, где
            конец  исключителен.

    ***********************************************************************/

    final проц[] opSlice (т_мера старт, т_мера конец)
    {
        assert (старт <= протяженность && конец <= протяженность && старт <= конец);
        return данные [старт .. конец];
    }

    /***********************************************************************

            Получить весь читаемый контент

            Возвращает:
            проц[] читай буфера

            Примечания:
            Return a проц[] читай of the буфер, из_ the текущ позиция
            up в_ the предел of действителен контент. The контент remains in the
            буфер for future выкиньion.

    ***********************************************************************/

    final проц[] срез ()
    {
        return данные [индекс .. протяженность];
    }

    /***********************************************************************

            Доступ буфер контент

            Параметры:
            размер =  доступное число байтов
            съешь =   использовать или нет контент

            Возвращает:
            соответствующий срез буфера в удачном случае, либо
            пусто, если недостаточно данных (Кф; Eob).

            Примечания:
            Делает срез читаемых данных. Указанное число байт is
            reдобавь из_ the буфер, и marked as having been читай
            when the 'съешь' parameter is установи да. When 'съешь' is установи
            нет, the читай позиция is not adjusted.

            Note that the срез cannot be larger than the размер of
            the буфер ~ use метод читай(проц[]) instead where you
            simply want the контент copied.

            Note also that the срез should be .dup'd if you wish в_
            retain it.

            Examples:
            ---
            // создай a буфер with some контент
            auto буфер = new Буфер ("hello world");

            // используй everything unread
            auto срез = буфер.срез (буфер.читаемый);
            ---

    ***********************************************************************/

    final проц[] срез (т_мера размер, бул съешь = да)
    {
        if (размер > читаемый)
            ошибка (недобор);

        auto i = индекс;
        if (съешь)
            индекс += размер;
        return данные [i .. i + размер];
    }

    /***********************************************************************

            Добавить контент

            Параметры:
            ист = добавляемый контент
            length = число байтов в ист

            Возвращает chaining reference, если весь контент был записан.
            Выводит ВВИскл, указывающее на eof или eob, если его нет.

            Примечания:
            Добавить Массив в данный буфер

    ***********************************************************************/

    final Массив добавь (проц[] ист)
    {
        if (пиши(ист) is Кф)
            ошибка (перебор);
        return this;
    }

    /***********************************************************************

            Обходчик support

            Параметры:
            скан = the delagate в_ invoke with the текущ контент

            Возвращает:
            Возвращает да if a токен was isolated, нет иначе.

            Примечания:
            Upon success, the delegate should return the байт-based
            индекс of the consumed образец (хвост конец of it). Failure
            в_ сверь a образец should be indicated by returning an
            ИПровод.Кф

            Note that добавьitional обходчик и/or читатель экземпляры
            will operate in lockstep when bound в_ a common буфер.

    ***********************************************************************/

    final бул следщ (т_мера delegate (проц[]) скан)
    {
        return читатель (скан) != ИПровод.Кф;
    }

    /***********************************************************************

            Available контент

            Примечания:
            Return счёт of _readable байты остаток in буфер. This is
            calculated simply as предел() - позиция()

    ***********************************************************************/

    final т_мера читаемый ()
    {
        return протяженность - индекс;
    }

    /***********************************************************************

            Available пространство

            Примечания:
            Return счёт of _writable байты available in буфер. This is
            calculated simply as ёмкость() - предел()

    ***********************************************************************/

    final т_мера записываемый ()
    {
        return дименсия - протяженность;
    }

    /***********************************************************************

            Доступ буфер предел

            Возвращает:
            Возвращает the предел of читаемый контент внутри this буфер.

            Примечания:
            Each буфер имеется a ёмкость, a предел, и a позиция. The
            ёмкость is the maximum контент a буфер can contain, предел
            represents the протяженность of действителен контент, и позиция marks
            the текущ читай location.

    ***********************************************************************/

    final т_мера предел ()
    {
        return протяженность;
    }

    /***********************************************************************

            Доступ буфер ёмкость

            Возвращает:
            Возвращает the maximum ёмкость of this буфер

            Примечания:
            Each буфер имеется a ёмкость, a предел, и a позиция. The
            ёмкость is the maximum контент a буфер can contain, предел
            represents the протяженность of действителен контент, и позиция marks
            the текущ читай location.

    ***********************************************************************/

    final т_мера ёмкость ()
    {
        return дименсия;
    }

    /***********************************************************************

            Доступ буфер читай позиция

            Возвращает:
            Возвращает the текущ читай-позиция внутри this буфер

            Примечания:
            Each буфер имеется a ёмкость, a предел, и a позиция. The
            ёмкость is the maximum контент a буфер can contain, предел
            represents the протяженность of действителен контент, и позиция marks
            the текущ читай location.

    ***********************************************************************/

    final т_мера позиция ()
    {
        return индекс;
    }

    /***********************************************************************

            Clear Массив контент

            Примечания:
            Reset 'позиция' и 'предел' в_ zero. This effectively
            clears все контент из_ the Массив.

    ***********************************************************************/

    final Массив очисть ()
    {
        индекс = протяженность = 0;
        return this;
    }

    /***********************************************************************

            Emit/purge buffered контент

    ***********************************************************************/

    final override Массив слей ()
    {
        return this;
    }

    /***********************************************************************

            Зап преобр_в this буфер

            Параметры:
            дг = the обрвызов в_ provопрe буфер доступ в_

            Возвращает:
            Возвращает whatever the delegate returns.

            Примечания:
            Exposes the необр данные буфер at the текущ _write позиция,
            The delegate is предоставленный with a проц[] representing пространство
            available внутри the буфер at the текущ _write позиция.

            The delegate should return the appropriate число of байты
            if it writes действителен контент, or ИПровод.Кф on ошибка.

    ***********************************************************************/

    final т_мера писатель (т_мера delegate (проц[]) дг)
    {
        auto счёт = дг (данные [протяженность..дименсия]);

        if (счёт != ИПровод.Кф)
        {
            протяженность += счёт;
            assert (протяженность <= дименсия);
        }
        return счёт;
    }

    /***********************************************************************

            Прямое чтение из данного буфера

            Параметры:
            дг = обрвызов, которому нужно обеспечить доступ к буферу

            Возвращает:
            Возвращает то, что возвращает сам делегат.

            Примечания:
            Exposes the необр данные буфер at the текущ _read позиция. The
            delegate is предоставленный with a проц[] representing the available
            данные, и should return zero в_ покинь the текущ _read позиция
            intact.

            If the delegate consumes данные, it should return the число of
            байты consumed; or ИПровод.Кф в_ indicate an ошибка.

    ***********************************************************************/

    final т_мера читатель (т_мера delegate (проц[]) дг)
    {
        auto счёт = дг (данные [индекс..протяженность]);

        if (счёт != ИПровод.Кф)
        {
            индекс += счёт;
            assert (индекс <= протяженность);
        }
        return счёт;
    }

    /***********************************************************************

            Расширить существующее пространство буфера

            Возвращает:
            Доступное пространство, без всякого расширение

            Примечания:
            Создать дополнительное место в буфере, как минимум, указанного
            размера. Не должно быть публичным во избежание проблем с
            не-наращиваемыми подклассами.

    ***********************************************************************/

    final т_мера расширь (т_мера размер)
    {
        if (расширение)
        {
            if (размер < расширение)
                размер = расширение;
            дименсия += размер;
            данные.length = дименсия;
        }
        return записываемый;
    }

    /***********************************************************************

            Переброс в целевой тип без вызова рантаймных проверок
            на неправильное размещение в памяти. Вместо этого упрощаеться
            длина Массива.

    ***********************************************************************/

    private static T[] преобразуй(T)(проц[] x)
    {
        return (cast(T*) x.ptr) [0 .. (x.length / T.sizeof)];
    }
}


/******************************************************************************

******************************************************************************/

debug (Array)
{
    import io.Stdout;
    import io.device.Array;

    проц main()
    {
        auto b = new Массив(6, 10);
        b.сместись (0);
        b.пиши ("fubar");

        Стдвыв.форматнс ("протяженность {}, поз {}, считано {}, размер буфера {}",
                                       b.предел, b.позиция, cast(ткст) b.срез, b.размерБуфера);


        b.пиши ("fubar");
        b.сместись (7);
        Стдвыв.форматнс ("протяженность {}, поз {}, считано {}, размер буфера {}",
                                       b.предел, b.позиция, cast(ткст) b.срез, b.размерБуфера);
    }
}