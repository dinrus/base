﻿
module io.device.Array;

private import io.device.Conduit;


extern(D)
 class Массив : Провод, ИБуферВвода, ИБуферВывода, ИПровод.ИШаг
{


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
     this (т_мера ёмкость = 0, т_мера нарастает = 0);

    /***********************************************************************

            Конструирует буфер.

            Параметры:
            данные = поддерживающий Массив с внутренним буфером.

            Примечания:
            Буфер инициализуется прилагаемым приложением Массивом. Весь контент
            считается пригодным для чтения, и, следовательно, изначально
            отсутствует пространство для записи.

    ***********************************************************************/

      this (проц[] данные);

    /***********************************************************************

            Конструирует буфер.

            Параметры:
            данные =     поддерживающий Массив с внутренним буфером.
            читаемо =  число байтов, изначально читаемых по свойству.

            Примечания:
            Буфер инициализуется прилагаемым приложением Массивом, а
            следовательно, данные для чтения уже есть. Операция
            записи производится сразу после существующего контента
            для чтения.

            Это широко распространенный случай использования с прикреплением
            экземпляра Буфера к локальному Массиву.

    ***********************************************************************/

      this (проц[] данные, т_мера читаемо);

    /***********************************************************************

            Возвращает имя данного провода.

    ***********************************************************************/

     final override ткст вТкст ();

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

      final override т_мера читай (проц[] приёмн);

    /***********************************************************************

            Эмулирует ИПотокВывода.пиши()

            Параметры:
            ист = записываемо контент

            Возвращает:
            возвращает число записанных байтов, которое должно быть меньше
            предоставленного (концептуально). Возвращает Кф, когда буфер становится
            полным.

            Примечания:
            Добавляет ист контент в буфер, расширяяего, если требуется и
            сконфигурировано на это (этим конструктором).

    ***********************************************************************/

    final override т_мера пиши (проц[] ист);

    /***********************************************************************

            Вернуть предпочитаемый размер для буферирующего провода ввода-вывода

    ***********************************************************************/

     final override т_мера размерБуфера ();

    /***********************************************************************

            Освободить внешние ресурсы

    ***********************************************************************/

     override проц открепи ();

    /***********************************************************************

            Смещение внутри пределов назначенного контента

    ***********************************************************************/

     override дол сместись (дол смещение, Якорь якорь = Якорь.Нач);

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

     Массив присвой (проц[] данные);

    /***********************************************************************

            Сбросить контент буфера.

            Параметры:
            данные     = поддерживающий Массив с внутренним буфером.
            читаемо = число байтов, внутренние данные которых считаются
                       действительными.

            Возвращает:
            экземпляр буфера

            Примечания:
            Устанавливает поддерживающий с некоторым контентом для чтения. Метод очисть()
            сбрасывает контент(делая его весь записываемым).

    ***********************************************************************/

     Массив присвой (проц[] данные, т_мера читаемо);

    /***********************************************************************

            Доступ к содержимому буфера.

            Примечания:
            Возвращает весь поддерживающий Массив.

    ***********************************************************************/

     final проц[] присвой ();

    /***********************************************************************

            Возвращает проц[] считанного буфера от старта до конца, где
            конец  исключителен.

    ***********************************************************************/

     final проц[] opSlice (т_мера старт, т_мера конец);

    /***********************************************************************

            Получить весь читаемый контент.

            Возвращает:
            проц[] считанного буфера

            Примечания:
            Возвращает проц[] считанного буфера, от текущей позиции
            до верхнего предела действительного контента. Этот контент
            остаётся в буфере до последующего освобождения.

    ***********************************************************************/

     final проц[] срез ();

    /***********************************************************************

            Доступ к контенту буфера.

            Параметры:
            размер =  доступное число байтов
            съешь =   использовать или нет контент

            Возвращает:
            соответствующий срез буфера в удачном случае, либо
            пусто, если недостаточно данных (Кф; Eob).

            Примечания:
            Делает срез читаемых данных. Указанное число байт
            пополняется из буфера, и метится как считанное,
            когда параметр 'съешь' = да. Когда 'съешь' =
            нет, позиция чтения не регулируется.

            Отметим, что срез не может превышать размер
            буфера ~ метод читай(проц[]) используется вместо этого, когда
            нужно просто скопировать контент.

            Также отметим, что срез следует дублировать (.dup'ом), если
            нужно передать его.

            Примеры:
            ---
            // создать буфер с некоторым контентом
            auto буфер = new Буфер ("привет мир");

            // использовать всё несчитанное
            auto срез = буфер.срез (буфер.читаемо);
            ---

    ***********************************************************************/

     final проц[] срез (т_мера размер, бул съешь = да);

    /***********************************************************************

            Добавить контент.

            Параметры:
            ист = добавляемый контент            

            Возвращает связующую ссылку, если весь контент был записан.
            Выводит ВВИскл, указывающее на eof или eob, если его нет.

            Примечания:
            Добавить Массив в данный буфер.

    ***********************************************************************/

     final Массив добавь (проц[] ист);

    /***********************************************************************

            Поддержка обходчика.

            Параметры:
            скан = делегат для вызова с текущим контентом

            Возвращает:
            Возвращает да, если какой-л. токен был изолирован, нет иначе.

            Примечания:
            При успехе этот делегат должен вернуть байт-based
            индекс потреблённого образца (хвостовой его край).
			Неудача при сверке образца указывается возвратом
            ИПровод.Кф

            Заметим, дополнительные экземпляры обходчика и/или читателя
            будут оперировать в lockstep, если лни привязаны к общему буферу.

    ***********************************************************************/

     final бул следщ (т_мера delegate (проц[]) скан);

    /***********************************************************************

            Доступный контент.

            Примечания:
            Возвращает счёт доступных для чтения остаточных байтов в буфере.
            Это вычисляется просто как предел() - позиция().

    ***********************************************************************/

     final т_мера читаемо ();

    /***********************************************************************

            Доступное пространство.

            Примечания:
            Возвращает счёт доступных для записи остаточных байтов в буфере.
            Это вычисляется просто как ёмкость() - предел()

    ***********************************************************************/

     final т_мера записываемо ();

    /***********************************************************************

            Доступный предел буфера.

            Возвращает:
            Возвращает the предел of читаемо контент внутри this буфер.

            Примечания:
            У каждого буфера есть ёмкость, предел и позиция.Эта
            ёмкость равна максимуму контента, который может помещаться в буфер,
			предел представляет протяженность действительного контента,
			а позиция отмесает текущее положение чтения.

    ***********************************************************************/

     final т_мера предел ();

    /***********************************************************************

            Доступная ёмкость буфера.

            Возвращает:
            Возвращает the maximum ёмкость of this буфер

            Примечания:
            У каждого буфера есть ёмкость, предел и позиция.Эта
            ёмкость равна максимуму контента, который может помещаться в буфер,
			предел представляет протяженность действительного контента,
			а позиция отмесает текущее положение чтения.

    ***********************************************************************/

     final т_мера ёмкость ();

    /***********************************************************************

            Доступная позиция чтения буфера.

            Возвращает:
            Возвращает текущую позицию чтения внутри этого буфера.

            Примечания:
            У каждого буфера есть ёмкость, предел и позиция.Эта
            ёмкость равна максимуму контента, который может помещаться в буфер,
			предел представляет протяженность действительного контента,
			а позиция отмесает текущее положение чтения.

    ***********************************************************************/

     final т_мера позиция ();
    /***********************************************************************

            Очистить контент массива.

            Примечания:
            Обнулить 'позиция' и 'предел'. Этим эффективно
            зачищается из массива все контент.

    ***********************************************************************/

     final Массив очисть ();

    /***********************************************************************

            Эмитировать/пургировать буферированный контент.

    ***********************************************************************/

     final override Массив слей ();

    /***********************************************************************

            Запись в этот буфер.

            Параметры:
            дг = обрвызов, дающий доступ к буферу

            Возвращает:
            Возвращает то, что вызратит делегат.

            Примечания:
            Экспонирует буфер с необработанными данными в текущей позиции записи.
            Этот делегат приводится с проц[], который представляет пространство,
            доступное внутри буфера в текущей позиции записи.

            Делегат должен возвращать соответствующее число байтов,
            если записывает действительный контент, либо ИПровод.Кф при ошибке.

    ***********************************************************************/

     final т_мера писатель (т_мера delegate (проц[]) дг);

    /***********************************************************************

            Прямое чтение из данного буфера

            Параметры:
            дг = обрвызов, которому нужно обеспечить доступ к буферу

            Возвращает:
            Возвращает то, что возвращает сам делегат.

            Примечания:
             Экспонирует буфер с необработанными данными в текущей позиции чтения.
            Этот делегат приводится с проц[], который представляет доступные
            данные, и должен возвращать ноль, чтобы оставить незатронутой
			текущую позицию чтения.

            Если делегат потребляет данные, он должен возвращать число
            потреблённых байтов; или ИПровод.Кф, чем указывать на ошибку.

    ***********************************************************************/

     final т_мера читатель (т_мера delegate (проц[]) дг);

    /***********************************************************************

            Расширить существующее пространство буфера

            Возвращает:
            Доступное пространство, без всякого расширение

            Примечания:
            Создать дополнительное место в буфере, как минимум, указанного
            размера. Не должно быть публичным во избежание проблем с
            не-наращиваемыми подклассами.

    ***********************************************************************/

     final т_мера расширь (т_мера размер);

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
