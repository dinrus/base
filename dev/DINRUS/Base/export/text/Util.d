﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2004: Initial release
                        Dec 2006: South Seas version

        author:         Kris


        Placeholder for a variety of wee functions. These functions are все
        templated with the intent of being использован for массивы of сим, шим,
        и дим. However, they operate correctly with другой Массив типы
        also.

        Several of these functions return an индекс значение, representing where
        some criteria was опрentified. When saопр criteria is not matched, the
        functions return a значение representing the Массив length provопрed в_
        them. That is, for those scenarios where C functions might typically
        return -1 these functions return length instead. This operate nicely
        with D slices:
        ---
        auto текст = "happy:faces";

        assert (текст[0 .. местоположение (текст, ':')] == "happy");

        assert (текст[0 .. местоположение (текст, '!')] == "happy:faces");
        ---

        The содержит() function is ещё convenient for trivial отыщи
        cases:
        ---
        if (содержит ("fubar", '!'))
            ...
        ---

        Note that where some functions expect a т_мера as an аргумент, the
        D template-совпадают algorithm will краш where an цел is provопрed
        instead. This is the typically the cause of "template не найден"
        ошибки. Also note that имя overloading is not supported cleanly
        by IFTI at this время, so is not applied here.


        Рекомендуется применение механизма  D "import alias" к данному модулю,
		чтобы избежать загрязнений пространства имён:
        ---
        import Util = text.Util;

        auto s = Util.убери ("  foo ");
        ---


        Шаблоны функций:
        ---
        убери (исток)                               // убери пробел
        уберилев (исток)                              // убери пробел
        убериправ (исток)                              // убери пробел
        откинь (исток, свер)                       // убери элементы
        откиньлев (исток, свер)                      // убери элементы
        откиньправ (исток, свер)                      // убери элементы
        отсекилев (исток, свер)                       // убери образец свер
        отсекиправ (исток, свер)                       // убери образец свер
        разграничь (ист, установи)                          // разбей on delims
        разбей (исток, образец)                     // разбей on образец
        рабейнастр (исток);                        // разбей on строки
        голова (исток, образец, хвост)                // разбей в_ голова & хвост
        объедини (исток, постфикс, вывод)              // объедини текст segments
        префикс (приёмн, префикс, контент...)            // префикс текст segments
        постфикс (приёмн, постфикс, контент...)          // постфикс текст segments
        комбинируй (приёмн, префикс, постфикс, контент...)  // комбинируй lotsa stuff
        повтори (исток, счёт, вывод)              // повтори исток
        замени (исток, свер, замена)        // замени симвы
        подставь (исток, свер, замена)     // замени/удали matches
        счёт (исток, свер)                       // счёт экземпляры
        содержит (исток, свер)                    // имеется сим?
        естьОбразец (исток, свер)             // имеется образец?
        индекс (исток, свер, старт)                // найди свер индекс
        местоположение (исток, свер, старт)               // найди сим
        местоположениеПеред (исток, свер, старт)          // найди приор сим
        местоположениеОбразца (исток, свер, старт);       // найди образец
        местоположениеПередОбразцом (исток, свер, старт);  // найди приор образец
        индексУ (s*, свер, length)                 // low-уровень отыщи
        не_совпадают (s1*, s2*, length)                 // low-уровень сравни
        совпадают (s1*, s2*, length)                 // low-уровень сравни
        пбел_ли (свер)                             // is пробел?
        убериИскейп(исток, вывод)                    // преобразуй '\' prefixes
        выкладка (приёмник, форматируй ...)            // featherweight printf
        строки (стр)                                 // foreach строки
        кавычки (стр, установи)                           // foreach кавычки
        разграничители (стр, установи)                       // foreach разграничители
        образцы (стр, образец)                     // foreach образцы
        ---

        Please note that any 'образец' referred в_ within this module
        refers в_ a образец of characters, и not some kind of regex
        descrИПtor. Use the Regex module for regex operation.

*******************************************************************************/

module text.Util;

/******************************************************************************

        Обрезать предоставленный Массив, управ пробелы с обеих
        его краёв. Возвращает срез исходного содержимого.

******************************************************************************/

T[] убери(T) (T[] исток)
{
    T*   голова = исток.ptr,
    хвост = голова + исток.length;

    while (голова < хвост && пбел_ли(*голова))
        ++голова;

    while (хвост > голова && пбел_ли(*(хвост-1)))
        --хвост;

    return голова [0 .. хвост - голова];
}

/******************************************************************************

        Обрезать предоставленный Массив, убрав пробелы слева.
        Возвращает срез исходного содержимого.

******************************************************************************/

T[] уберилев(T) (T[] исток)
{
    T*   голова = исток.ptr,
    хвост = голова + исток.length;

    while (голова < хвост && пбел_ли(*голова))
        ++голова;

    return голова [0 .. хвост - голова];
}

/******************************************************************************

        Обрезать предоставленный Массив, убрав пробелы справа.
        Возвращает срез исходного содержимого.

******************************************************************************/

T[] убериправ(T) (T[] исток)
{
    T*   голова = исток.ptr,
    хвост = голова + исток.length;

    while (хвост > голова && пбел_ли(*(хвост-1)))
        --хвост;

    return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the given Массив by strИПping the provопрed свер из_
        Всё заканчивается. Returns a срез of the original контент

******************************************************************************/

T[] откинь(T) (T[] исток, T свер)
{
    T*   голова = исток.ptr,
    хвост = голова + исток.length;

    while (голова < хвост && *голова is свер)
        ++голова;

    while (хвост > голова && *(хвост-1) is свер)
        --хвост;

    return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the given Массив by strИПping the provопрed свер из_
        the left hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] откиньлев(T) (T[] исток, T свер)
{
    T*   голова = исток.ptr,
    хвост = голова + исток.length;

    while (голова < хвост && *голова is свер)
        ++голова;

    return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the given Массив by strИПping the provопрed свер из_
        the right hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] откиньправ(T) (T[] исток, T свер)
{
    T*   голова = исток.ptr,
    хвост = голова + исток.length;

    while (хвост > голова && *(хвост-1) is свер)
        --хвост;

    return голова [0 .. хвост - голова];
}

/******************************************************************************

        Chop the given исток by strИПping the provопрed свер из_
        the left hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] отсекилев(T) (T[] исток, T[] свер)
{
    if (свер.length <= исток.length)
        if (исток[0 .. свер.length] == свер)
            исток = исток [свер.length .. $];

    return исток;
}

/******************************************************************************

        Chop the given исток by strИПping the provопрed свер из_
        the right hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] отсекиправ(T) (T[] исток, T[] свер)
{
    if (свер.length <= исток.length)
        if (исток[$-свер.length .. $] == свер)
            исток = исток [0 .. $-свер.length];

    return исток;
}

/******************************************************************************

        Замени все экземпляры of one элемент with другой (in place)

******************************************************************************/

T[] замени(T) (T[] исток, T свер, T замена)
{
    foreach (ref c; исток)
    if (c is свер)
        c = замена;
    return исток;
}

/******************************************************************************

        Substitute все экземпляры of свер из_ исток. Набор замена
        в_ пусто in order в_ удали instead of замени

******************************************************************************/

T[] подставь(T) (T[] исток, T[] свер, T[] замена)
{
    T[] вывод;

    foreach (s; образцы (исток, свер, замена))
    вывод ~= s;
    return вывод;
}

/******************************************************************************

        Счёт все экземпляры of свер within исток

******************************************************************************/

т_мера счёт(T) (T[] исток, T[] свер)
{
    т_мера c;

    foreach (s; образцы (исток, свер))
    ++c;
    assert(c > 0);
    return c - 1;
}

/******************************************************************************

        Returns whether or not the provопрed Массив содержит an экземпляр
        of the given свер

******************************************************************************/

бул содержит(T) (T[] исток, T свер)
{
    return индексУ (исток.ptr, свер, исток.length) != исток.length;
}

/******************************************************************************

        Returns whether or not the provопрed Массив содержит an экземпляр
        of the given свер

******************************************************************************/

бул естьОбразец(T) (T[] исток, T[] свер)
{
    return местоположениеОбразца (исток, свер) != исток.length;
}

/******************************************************************************

        Return the индекс of the следщ экземпляр of 'свер' starting at
        позиция 'старт', либо исток.length where there is no свер.

        Parameter 'старт' defaults в_ 0

******************************************************************************/

т_мера индекс(T, U=т_мера) (T[] исток, T[] свер, U старт=0)
{
    return индекс!(T) (исток, свер, старт);
}

т_мера индекс(T) (T[] исток, T[] свер, т_мера старт=0)
{
    return (свер.length is 1) ? местоположение (исток, свер[0], старт)
           : местоположениеОбразца (исток, свер, старт);
}

/******************************************************************************

        Return the индекс of the приор экземпляр of 'свер' starting
        just перед 'старт', либо исток.length where there is no свер.

        Parameter 'старт' defaults в_ исток.length

******************************************************************************/

т_мера пиндекс(T, U=т_мера) (T[] исток, T[] свер, U старт=U.max)
{
    return пиндекс!(T)(исток, свер, старт);
}

т_мера пиндекс(T) (T[] исток, T[] свер, т_мера старт=т_мера.max)
{
    return (свер.length is 1) ? местоположениеПеред (исток, свер[0], старт)
           : местоположениеПередОбразцом (исток, свер, старт);
}

/******************************************************************************

        Return the индекс of the следщ экземпляр of 'свер' starting at
        позиция 'старт', либо исток.length where there is no свер.

        Parameter 'старт' defaults в_ 0

******************************************************************************/

т_мера местоположение(T, U = т_мера) (T[] исток, T свер, U старт=0)
{
    return местоположение!(T) (исток, свер, старт);
}

т_мера местоположение(T) (T[] исток, T свер, т_мера старт=0)
{
    if (старт > исток.length)
        старт = исток.length;

    return индексУ (исток.ptr+старт, свер, исток.length - старт) + старт;
}

/******************************************************************************

        Return the индекс of the приор экземпляр of 'свер' starting
        just перед 'старт', либо исток.length where there is no свер.

        Parameter 'старт' defaults в_ исток.length

******************************************************************************/

т_мера местоположениеПеред(T, U=т_мера) (T[] исток, T свер, U старт=U.max)
{
    return местоположениеПеред!(T)(исток, свер, старт);
}

т_мера местоположениеПеред(T) (T[] исток, T свер, т_мера старт=т_мера.max)
{
    if (старт > исток.length)
        старт = исток.length;

    while (старт > 0)
        if (исток[--старт] is свер)
            return старт;
    return исток.length;
}

/******************************************************************************

        Return the индекс of the следщ экземпляр of 'свер' starting at
        позиция 'старт', либо исток.length where there is no свер.

        Parameter 'старт' defaults в_ 0

******************************************************************************/

т_мера местоположениеОбразца(T, U=т_мера) (T[] исток, T[] свер, U старт=0)
{
    return местоположениеОбразца!(T) (исток, свер, старт);
}

т_мера местоположениеОбразца(T) (T[] исток, T[] свер, т_мера старт=0)
{
    т_мера    индкс;
    T*      p = исток.ptr + старт;
    т_мера    протяженность = исток.length - старт - свер.length + 1;

    if (свер.length && протяженность <= исток.length)
        while (протяженность)
            if ((индкс = индексУ (p, свер[0], протяженность)) is протяженность)
                break;
            else if (совпадают (p+=индкс, свер.ptr, свер.length))
                return p - исток.ptr;
            else
            {
                протяженность -= (индкс+1);
                ++p;
            }

    return исток.length;
}

/******************************************************************************

        Return the индекс of the приор экземпляр of 'свер' starting
        just перед 'старт', либо исток.length where there is no свер.

        Parameter 'старт' defaults в_ исток.length

******************************************************************************/

т_мера местоположениеПередОбразцом(T, U=т_мера) (T[] исток, T[] свер, U старт=U.max)
{
    return местоположениеПередОбразцом!(T)(исток, свер, старт);
}

т_мера местоположениеПередОбразцом(T) (T[] исток, T[] свер, т_мера старт=т_мера.max)
{
    auto длин = исток.length;

    if (старт > длин)
        старт = длин;

    if (свер.length && свер.length <= длин)
        while (старт)
        {
            старт = местоположениеПеред (исток, свер[0], старт);
            if (старт is длин)
                break;
            else if ((старт + свер.length) <= длин)
                if (совпадают (исток.ptr+старт, свер.ptr, свер.length))
                    return старт;
        }

    return длин;
}

/******************************************************************************

        разбей the provопрed Массив on the первый образец экземпляр, и
        return the resultant голова и хвост. The образец is excluded
        из_ the two segments.

        Where a segment is не найден, хвост will be пусто и the return
        значение will be the original Массив.

******************************************************************************/

T[] голова(T) (T[] ист, T[] образец, out T[] хвост)
{
    auto i = местоположениеОбразца (ист, образец);
    if (i != ист.length)
    {
        хвост = ист [i + образец.length .. $];
        ист = ист [0 .. i];
    }
    return ист;
}

/******************************************************************************

        разбей the provопрed Массив on the последний образец экземпляр, и
        return the resultant голова и хвост. The образец is excluded
        из_ the two segments.

        Where a segment is не найден, голова will be пусто и the return
        значение will be the original Массив.

******************************************************************************/

T[] хвост(T) (T[] ист, T[] образец, out T[] голова)
{
    auto i = местоположениеПередОбразцом (ист, образец);
    if (i != ист.length)
    {
        голова = ист [0 .. i];
        ист = ист [i + образец.length .. $];
    }
    return ист;
}

/******************************************************************************

        разбей the provопрed Массив wherever a delimiter-установи экземпляр is
        найдено, и return the resultant segments. The разграничители are
        excluded из_ each of the segments. Note that разграничители are
        matched as a установи of alternates rather than as a образец.

        Splitting on a single delimiter is consопрerably faster than
        splitting upon a установи of alternatives.

        Note that the ист контент is not duplicated by this function,
        but is sliced instead.

******************************************************************************/

T[][] разграничь(T) (T[] ист, T[] установи)
{
    T[][] результат;

    foreach (segment; разграничители (ист, установи))
    результат ~= segment;
    return результат;
}

/******************************************************************************

        разбей the provопрed Массив wherever a образец экземпляр is
        найдено, и return the resultant segments. The образец is
        excluded из_ each of the segments.

        Note that the ист контент is not duplicated by this function,
        but is sliced instead.

******************************************************************************/

T[][] разбей(T) (T[] ист, T[] образец)
{
    T[][] результат;

    foreach (segment; образцы (ист, образец))
    результат ~= segment;
    return результат;
}

/******************************************************************************

        Convert текст преобр_в a установи of строки, where each строка is опрentified
        by a \n or \r\n combination. The строка terminator is очищенный из_
        each resultant Массив

        Note that the ист контент is not duplicated by this function, but
        is sliced instead.

******************************************************************************/

alias вСтроки рабейнастр;
T[][] вСтроки(T) (T[] ист)
{

    T[][] результат;

    foreach (строка; строки (ист))
    результат ~= строка;
    return результат;
}

/******************************************************************************

        Return the indexed строка, where each строка is опрentified by a \n
        or \r\n combination. The строка terminator is очищенный из_ the
        resultant строка

        Note that ист контент is not duplicated by this function, but
        is sliced instead.

******************************************************************************/

T[] строкаУ(T) (T[] ист, т_мера индекс)
{
    цел i = 0;
    foreach (строка; строки (ист))
    if (i++ is индекс)
        return строка;
    return пусто;
}

/******************************************************************************

        Combine a series of текст segments together, each appended with
        a постфикс образец. An optional вывод буфер can be provопрed в_
        avoопр куча activity - it should be large enough в_ contain the
        entire вывод, otherwise the куча will be использован instead.

        Returns a действителен срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] объедини(T) (T[][] ист, T[] постфикс=пусто, T[] приёмн=пусто)
{
    return комбинируй!(T) (приёмн, пусто, постфикс, ист);
}

/******************************************************************************

        Combine a series of текст segments together, each prepended with
        a префикс образец. An optional вывод буфер can be provопрed в_
        avoопр куча activity - it should be large enough в_ contain the
        entire вывод, otherwise the куча will be использован instead.

        Note that, unlike объедини(), the вывод буфер is specified первый
        such that a установи of trailing strings can be provопрed.

        Returns a действителен срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] префикс(T) (T[] приёмн, T[] префикс, T[][] ист...)
{
    return комбинируй!(T) (приёмн, префикс, пусто, ист);
}

/******************************************************************************

        Combine a series of текст segments together, each appended with an
        optional постфикс образец. An optional вывод буфер can be provопрed
        в_ avoопр куча activity - it should be large enough в_ contain the
        entire вывод, otherwise the куча will be использован instead.

        Note that, unlike объедини(), the вывод буфер is specified первый
        such that a установи of trailing strings can be provопрed.

        Returns a действителен срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] постфикс(T) (T[] приёмн, T[] постфикс, T[][] ист...)
{
    return комбинируй!(T) (приёмн, пусто, постфикс, ист);
}

/******************************************************************************

        Combine a series of текст segments together, each псеп_в_начале и/or
        postfixed with optional strings. An optional вывод буфер can be
        provопрed в_ avoопр куча activity - which should be large enough в_
        contain the entire вывод, otherwise the куча will be использован instead.

        Note that, unlike объедини(), the вывод буфер is specified первый
        such that a установи of trailing strings can be provопрed.

        Returns a действителен срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] комбинируй(T) (T[] приёмн, T[] префикс, T[] постфикс, T[][] ист ...)
{
    т_мера длин = ист.length * префикс.length +
                           ист.length * постфикс.length;

    foreach (segment; ист)
    длин += segment.length;

    if (приёмн.length < длин)
        приёмн.length = длин;

    T* p = приёмн.ptr;
    foreach (segment; ист)
    {
        p[0 .. префикс.length] = префикс;
        p += префикс.length;
        p[0 .. segment.length] = segment;
        p += segment.length;
        p[0 .. постфикс.length] = постфикс;
        p += постфикс.length;
    }

    // удали trailing seperator
    if (длин)
        длин -= постфикс.length;
    return приёмн [0 .. длин];
}

/******************************************************************************

        Repeat an Массив for a specific число of times. An optional вывод
        буфер can be provопрed в_ avoопр куча activity - it should be large
        enough в_ contain the entire вывод, otherwise the куча will be использован
        instead.

        Returns a действителен срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] повтори(T, U = т_мера) (T[] ист, U счёт, T[] приёмн = пусто)
{
    return повтори!(T)(ист, счёт, приёмн);
}

T[] повтори(T) (T[] ист, т_мера счёт, T[] приёмн=пусто)
{
    т_мера длин = ист.length * счёт;
    if (длин is 0)
        return пусто;

    if (приёмн.length < длин)
        приёмн.length = длин;

    for (auto p = приёмн.ptr; счёт--; p += ист.length)
        p[0 .. ист.length] = ист;

    return приёмн [0 .. длин];
}

/******************************************************************************

        Is the аргумент a пробел character?

******************************************************************************/

бул пбел_ли(T) (T c)
{
    static if (T.sizeof is 1)
        return (c <= 32 && (c is ' ' || c is '\t' || c is '\r' || c is '\n' || c is '\f' || c is '\v'));
    else
        return (c <= 32 && (c is ' ' || c is '\t' || c is '\r' || c is '\n' || c is '\f' || c is '\v')) || (c is '\u2028' || c is '\u2029');
}

/******************************************************************************

        Return whether or not the two массивы have совпадают контент

******************************************************************************/

бул совпадают(T, U=т_мера) (T* s1, T* s2, U length)
{
    return совпадают!(T) (s1, s2, length);
}

бул совпадают(T) (T* s1, T* s2, т_мера length)
{
    return не_совпадают(s1, s2, length) is length;
}

/******************************************************************************

        Returns the индекс of the первый свер in стр, failing once
        length is reached. Note that we return 'length' for failure
        и a 0-based индекс on success

******************************************************************************/

т_мера индексУ(T, U=т_мера) (T* стр, T свер, U length)
{
    return индексУ!(T) (стр, свер, length);
}

т_мера индексУ(T) (T* стр, T свер, т_мера length)
{
    //assert (стр);

    static if (T.sizeof == 1)
        enum : т_мера {m1 = cast(т_мера) 0x0101010101010101,
                            m2 = cast(т_мера) 0x8080808080808080
                           }
        static if (T.sizeof == 2)
            enum : т_мера {m1 = cast(т_мера) 0x0001000100010001,
                                m2 = cast(т_мера) 0x8000800080008000
                               }
            static if (T.sizeof == 4)
                enum : т_мера {m1 = cast(т_мера) 0x0000000100000001,
                                    m2 = cast(т_мера) 0x8000000080000000
                                   }

                static if (T.sizeof < т_мера.sizeof)
                {
                    if (length)
                    {
                        т_мера m = свер;
                        m += m << (8 * T.sizeof);

                        static if (T.sizeof < т_мера.sizeof / 2)
                            m += (m << (8 * T.sizeof * 2));

                        static if (T.sizeof < т_мера.sizeof / 4)
                            m += (m << (8 * T.sizeof * 4));

                        auto p = стр;
                        auto e = p + length - т_мера.sizeof/T.sizeof;
                        while (p < e)
                        {
                            // очисть совпадают T segments
                            auto v = (*cast(т_мера*) p) ^ m;
                            // тест for zero, courtesy of Alan Mycroft
                            if ((v - m1) & ~v & m2)
                                break;
                            p += т_мера.sizeof/T.sizeof;
                        }

                        e += т_мера.sizeof/T.sizeof;
                        while (p < e)
                            if (*p++ is свер)
                                return p - стр - 1;
                    }
                    return length;
                }
                else
                {
                    auto длин = length;
                    for (auto p=стр-1; длин--;)
                        if (*++p is свер)
                            return p - стр;
                    return length;
                }
}

/******************************************************************************

        Returns the индекс of a не_совпадают between s1 & s2, failing when
        length is reached. Note that we return 'length' upon failure
        (Массив контент matches) и a 0-based индекс upon success.

        Use this as a faster opEquals. Also provопрes the basis for a
        faster opCmp, since the индекс of the первый mismatched character
        can be использован в_ determine the return значение

******************************************************************************/

т_мера не_совпадают(T, U=т_мера) (T* s1, T* s2, U length)
{
    return не_совпадают!(T)(s1, s2, length);
}

т_мера не_совпадают(T) (T* s1, T* s2, т_мера length)
{
    assert (s1 && s2);

    static if (T.sizeof < т_мера.sizeof)
    {
        if (length)
        {
            auto старт = s1;
            auto e = старт + length - т_мера.sizeof/T.sizeof;

            while (s1 < e)
            {
                if (*cast(т_мера*) s1 != *cast(т_мера*) s2)
                    break;
                s1 += т_мера.sizeof/T.sizeof;
                s2 += т_мера.sizeof/T.sizeof;
            }

            e += т_мера.sizeof/T.sizeof;
            while (s1 < e)
                if (*s1++ != *s2++)
                    return s1 - старт - 1;
        }
        return length;
    }
    else
    {
        auto длин = length;
        for (auto p=s1-1; длин--;)
            if (*++p != *s2++)
                return p - s1;
        return length;
    }
}

/******************************************************************************

        Обходчик в_ isolate строки.

        Converts текст преобр_в a установи of строки, where each строка is опрentified
        by a \n or \r\n combination. The строка terminator is очищенный из_
        each resultant Массив.

        ---
        foreach (строка; строки ("one\ntwo\nthree"))
                 ...
        ---

******************************************************************************/

Строкоплод!(T) строки(T) (T[] ист)
{
    Строкоплод!(T) строки;
    строки.ист = ист;
    return строки;
}

/******************************************************************************

        Обходчик в_ isolate текст элементы.

        Splits the provопрed Массив wherever a delimiter-установи экземпляр is
        найдено, и return the resultant segments. The разграничители are
        excluded из_ each of the segments. Note that разграничители are
        matched as a установи of alternates rather than as a образец.

        Splitting on a single delimiter is consопрerably faster than
        splitting upon a установи of alternatives.

        ---
        foreach (segment; разграничители ("one,two;three", ",;"))
                 ...
        ---

******************************************************************************/

Разделоплод!(T) разграничители(T) (T[] ист, T[] установи)
{
    Разделоплод!(T) элементы;
    элементы.установи = установи;
    элементы.ист = ист;
    return элементы;
}

/******************************************************************************

        Обходчик в_ isolate текст элементы.

        разбей the provопрed Массив wherever a образец экземпляр is найдено,
        и return the resultant segments. образец are excluded из_
        each of the segments, и an optional sub аргумент enables
        замена.

        ---
        foreach (segment; образцы ("one, two, three", ", "))
                 ...
        ---

******************************************************************************/

Образцоплод!(T) образцы(T) (T[] ист, T[] образец, T[] sub=пусто)
{
    Образцоплод!(T) элементы;
    элементы.образец = образец;
    элементы.sub = sub;
    элементы.ист = ист;
    return элементы;
}

/******************************************************************************

        Обходчик в_ isolate optionally quoted текст элементы.

        As per элементы(), but with the extension of being quote-aware;
        the установи of разграничители is ignored insопрe a пара of кавычки. Note
        that an unterminated quote will используй остаток контент.

        ---
        foreach (quote; кавычки ("one two 'three four' five", " "))
                 ...
        ---

******************************************************************************/

Кавычкоплод!(T) кавычки(T) (T[] ист, T[] установи)
{
    Кавычкоплод!(T) кавычки;
    кавычки.установи = установи;
    кавычки.ист = ист;
    return кавычки;
}

/*******************************************************************************

        Arranges текст strings in order, using индексы в_ specify where
        each particular аргумент should be positioned within the текст.
        This is handy for collating I18N components, либо as a simplistic
        и lightweight форматёр. Indices range из_ zero through nine.

        ---
        // пиши ordered текст в_ the console
        сим[64] врем;

        Квывод (выкладка (врем, "%1 is after %0", "zero", "one")).нс;
        ---

*******************************************************************************/

T[] выкладка(T) (T[] вывод, T[][] выкладка ...)
{
    static T[] badarg   = "{индекс вне диапазона}";
    static T[] toosmall = "{буфер вывода мал}";

    цел     поз,
    арги;
    бул    состояние;

    арги = выкладка.length - 1;
    foreach (c; выкладка[0])
    {
        if (состояние)
        {
            состояние = нет;
            if (c >= '0' && c <= '9')
            {
                т_мера индекс = c - '0';
                if (индекс < арги)
                {
                    T[] x = выкладка[индекс+1];

                    цел предел = поз + x.length;
                    if (предел < вывод.length)
                    {
                        вывод [поз .. предел] = x;
                        поз = предел;
                        continue;
                    }
                    else
                        return toosmall;
                }
                else
                    return badarg;
            }
        }
        else if (c is '%')
        {
            состояние = да;
            continue;
        }

        if (поз < вывод.length)
        {
            вывод[поз] = c;
            ++поз;
        }
        else
            return toosmall;
    }

    return вывод [0..поз];
}

/******************************************************************************

        Convert 'escaped' симвы в_ нормаль ones: \t => ^t for example.
        Supports \" \' \\ \a \b \f \n \r \t \v

******************************************************************************/

T[] убериИскейп(T) (T[] ист, T[] приёмн = пусто)
{
    цел delta;
    auto s = ист.ptr;
    auto длин = ист.length;

    // возьми a Просмотр первый в_ see if there's anything
    if ((delta = индексУ (s, '\\', длин)) < длин)
    {
        // сделай some room if not enough provопрed
        if (приёмн.length < ист.length)
            приёмн.length = ист.length;
        auto d = приёмн.ptr;

        // копируй segments over, a чанк at a время
        do
        {
            d [0 .. delta] = s [0 .. delta];
            длин -= delta;
            s += delta;
            d += delta;

            // bogus trailing '\'
            if (длин < 2)
            {
                *d++ = '\\';
                длин = 0;
                break;
            }

            // translate \сим
            auto c = s[1];
            switch (c)
            {
            case '\\':
                break;
            case '\'':
                c = '\'';
                break;
            case '"':
                c = '"';
                break;
            case 'a':
                c = '\a';
                break;
            case 'b':
                c = '\b';
                break;
            case 'f':
                c = '\f';
                break;
            case 'n':
                c = '\n';
                break;
            case 'r':
                c = '\r';
                break;
            case 't':
                c = '\t';
                break;
            case 'v':
                c = '\v';
                break;
            default:
                *d++ = '\\';
            }
            *d++ = c;
            длин -= 2;
            s += 2;
        }
        while ((delta = индексУ (s, '\\', длин)) < длин);

        // копируй хвост too
        d [0 .. длин] = s [0 .. длин];
        return приёмн [0 .. (d + длин) - приёмн.ptr];
    }
    return ист;
}


/******************************************************************************

        джейхэш() -- хэш a переменная-length ключ преобр_в a 32-bit значение

          k     : the ключ (the unaligned переменная-length Массив of байты)
          длин   : the length of the ключ, counting by байты
          уровень : can be any 4-байт значение

        Returns a 32-bit значение.  Every bit of the ключ affects every bit of
        the return значение.  Every 1-bit и 2-bit delta achieves avalanche.

        About 4.3*длин + 80 X86 instructions, with excellent pИПelining

        The best хэш таблица размеры are powers of 2.  There is no need в_ do
        mod a prime (mod is sooo slow!).  If you need less than 32 биты,
        use a bitmask.  For example, if you need only 10 биты, do

                    h = (h & hashmask(10));

        In which case, the хэш таблица should have hashsize(10) элементы.
        If you are hashing n strings (ub1 **)k, do it like this:

                    for (i=0, h=0; i<n; ++i) h = хэш( k[i], длин[i], h);

        By Bob Jenkins, 1996.  bob_jenkins@burtleburtle.net.  You may use
        this код any way you wish, private, educational, либо commercial.
        It's free.

        See http://burtleburtle.net/bob/хэш/evahash.html
        Use for хэш таблица отыщи, либо anything where one collision in 2^32
        is acceptable. Do NOT use for cryptographic purposes.

******************************************************************************/

т_мера джейхэш (ббайт* k, т_мера длин, т_мера c = 0)
{
    т_мера a = 0x9e3779b9,
                b = 0x9e3779b9,
                i = длин;

    // укз most of the ключ
    while (i >= 12)
    {
        a += *cast(бцел *)(k+0);
        b += *cast(бцел *)(k+4);
        c += *cast(бцел *)(k+8);

        a -= b;
        a -= c;
        a ^= (c>>13);
        b -= c;
        b -= a;
        b ^= (a<<8);
        c -= a;
        c -= b;
        c ^= (b>>13);
        a -= b;
        a -= c;
        a ^= (c>>12);
        b -= c;
        b -= a;
        b ^= (a<<16);
        c -= a;
        c -= b;
        c ^= (b>>5);
        a -= b;
        a -= c;
        a ^= (c>>3);
        b -= c;
        b -= a;
        b ^= (a<<10);
        c -= a;
        c -= b;
        c ^= (b>>15);
        k += 12;
        i -= 12;
    }

    // укз the последний 11 байты
    c += длин;
    switch (i)
    {
    case 11:
        c+=(cast(бцел)k[10]<<24);
    case 10:
        c+=(cast(бцел)k[9]<<16);
    case 9 :
        c+=(cast(бцел)k[8]<<8);
    case 8 :
        b+=(cast(бцел)k[7]<<24);
    case 7 :
        b+=(cast(бцел)k[6]<<16);
    case 6 :
        b+=(cast(бцел)k[5]<<8);
    case 5 :
        b+=(cast(бцел)k[4]);
    case 4 :
        a+=(cast(бцел)k[3]<<24);
    case 3 :
        a+=(cast(бцел)k[2]<<16);
    case 2 :
        a+=(cast(бцел)k[1]<<8);
    case 1 :
        a+=(cast(бцел)k[0]);
    default:
    }

    a -= b;
    a -= c;
    a ^= (c>>13);
    b -= c;
    b -= a;
    b ^= (a<<8);
    c -= a;
    c -= b;
    c ^= (b>>13);
    a -= b;
    a -= c;
    a ^= (c>>12);
    b -= c;
    b -= a;
    b ^= (a<<16);
    c -= a;
    c -= b;
    c ^= (b>>5);
    a -= b;
    a -= c;
    a ^= (c>>3);
    b -= c;
    b -= a;
    b ^= (a<<10);
    c -= a;
    c -= b;
    c ^= (b>>15);

    return c;
}

/// описано ранее
т_мера джейхэш (проц[] x, т_мера c = 0)
{
    return джейхэш (cast(ббайт*) x.ptr, x.length, c);
}


/******************************************************************************

        Helper fruct for обходчик строки(). A fruct is a low
        impact mechanism for capturing контекст relating в_ an
        opApply (conjunction of the names struct и foreach)

******************************************************************************/

private struct Строкоплод(T)
{
    private T[] ист;

    цел opApply (цел delegate (ref T[] строка) дг)
    {
        цел     возвр;
        т_мера  поз,
        метка;
        T[]     строка;

        const T нс = '\n';
        const T вк = '\r';

        while ((поз = местоположение (ист, нс, метка)) < ист.length)
        {
            auto конец = поз;
            if (конец && ист[конец-1] is вк)
                --конец;

            строка = ист [метка .. конец];
            if ((возвр = дг (строка)) != 0)
                return возвр;
            метка = поз + 1;
        }

        строка = ист [метка .. $];
        if (метка <= ист.length)
            возвр = дг (строка);

        return возвр;
    }
}

/******************************************************************************

        Helper fruct for обходчик delims(). A fruct is a low
        impact mechanism for capturing контекст relating в_ an
        opApply (conjunction of the names struct и foreach)

******************************************************************************/

private struct Разделоплод(T)
{
    private T[] ист;
    private T[] установи;

    цел opApply (цел delegate (ref T[] сема) дг)
    {
        цел     возвр;
        т_мера  поз,
        метка;
        T[]     сема;

        // оптимизируй for single delimiter case
        if (установи.length is 1)
            while ((поз = местоположение (ист, установи[0], метка)) < ист.length)
            {
                сема = ист [метка .. поз];
                if ((возвр = дг (сема)) != 0)
                    return возвр;
                метка = поз + 1;
            }
        else if (установи.length > 1)
            foreach (i, elem; ист)
            if (содержит (установи, elem))
            {
                сема = ист [метка .. i];
                if ((возвр = дг (сема)) != 0)
                    return возвр;
                метка = i + 1;
            }

        сема = ист [метка .. $];
        if (метка <= ист.length)
            возвр = дг (сема);

        return возвр;
    }
}

/******************************************************************************

        Helper fruct for обходчик образцы(). A fruct is a low
        impact mechanism for capturing контекст relating в_ an
        opApply (conjunction of the names struct и foreach)

******************************************************************************/

private struct Образцоплод(T)
{
    private T[] ист,
            sub,
            образец;

    цел opApply (цел delegate (ref T[] сема) дг)
    {
        цел     возвр;
        т_мера  поз,
        метка;
        T[]     сема;

        while ((поз = индекс (ист, образец, метка)) < ист.length)
        {
            сема = ист [метка .. поз];
            if ((возвр = дг(сема)) != 0)
                return возвр;
            if (sub.ptr && (возвр = дг(sub)) != 0)
                return возвр;
            метка = поз + образец.length;
        }

        сема = ист [метка .. $];
        if (метка <= ист.length)
            возвр = дг (сема);

        return возвр;
    }
}

/******************************************************************************

        Helper fruct for обходчик кавычки(). A fruct is a low
        impact mechanism for capturing контекст relating в_ an
        opApply (conjunction of the names struct и foreach)

******************************************************************************/

private struct Кавычкоплод(T)
{
    private T[] ист;
    private T[] установи;

    цел opApply (цел delegate (ref T[] сема) дг)
    {
        цел     возвр;
        т_мера  метка;
        T[]     сема;

        if (установи.length)
            for (т_мера i=0; i < ист.length; ++i)
            {
                T c = ист[i];
                if (c is '"' || c is '\'')
                    i = местоположение (ист, c, i+1);
                else if (содержит (установи, c))
                {
                    сема = ист [метка .. i];
                    if ((возвр = дг (сема)) != 0)
                        return возвр;
                    метка = i + 1;
                }
            }

        сема = ист [метка .. $];
        if (метка <= ист.length)
            возвр = дг (сема);

        return возвр;
    }
}


/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
    unittest
    {
        сим[64] врем;

        assert (пбел_ли (' ') && !пбел_ли ('d'));

        assert (индексУ ("abc".ptr, 'a', 3) is 0);
        assert (индексУ ("abc".ptr, 'b', 3) is 1);
        assert (индексУ ("abc".ptr, 'c', 3) is 2);
        assert (индексУ ("abc".ptr, 'd', 3) is 3);
        assert (индексУ ("abcabcabc".ptr, 'd', 9) is 9);

        assert (индексУ ("abc"d.ptr, cast(дим)'c', 3) is 2);
        assert (индексУ ("abc"d.ptr, cast(дим)'d', 3) is 3);

        assert (индексУ ("abc"w.ptr, cast(шим)'c', 3) is 2);
        assert (индексУ ("abc"w.ptr, cast(шим)'d', 3) is 3);
        assert (индексУ ("abcdefghijklmnopqrstuvwxyz"w.ptr, cast(шим)'x', 25) is 23);

        assert (не_совпадают ("abc".ptr, "abc".ptr, 3) is 3);
        assert (не_совпадают ("abc".ptr, "abd".ptr, 3) is 2);
        assert (не_совпадают ("abc".ptr, "acc".ptr, 3) is 1);
        assert (не_совпадают ("abc".ptr, "ccc".ptr, 3) is 0);

        assert (не_совпадают ("abc"w.ptr, "abc"w.ptr, 3) is 3);
        assert (не_совпадают ("abc"w.ptr, "acc"w.ptr, 3) is 1);

        assert (не_совпадают ("abc"d.ptr, "abc"d.ptr, 3) is 3);
        assert (не_совпадают ("abc"d.ptr, "acc"d.ptr, 3) is 1);

        assert (совпадают ("abc".ptr, "abc".ptr, 3));
        assert (совпадают ("abc".ptr, "abb".ptr, 3) is нет);

        assert (содержит ("abc", 'a'));
        assert (содержит ("abc", 'b'));
        assert (содержит ("abc", 'c'));
        assert (содержит ("abc", 'd') is нет);

        assert (естьОбразец ("abc", "ab"));
        assert (естьОбразец ("abc", "bc"));
        assert (естьОбразец ("abc", "abc"));
        assert (естьОбразец ("abc", "zabc") is нет);
        assert (естьОбразец ("abc", "abcd") is нет);
        assert (естьОбразец ("abc", "za") is нет);
        assert (естьОбразец ("abc", "cd") is нет);

        assert (убери ("") == "");
        assert (убери (" abc  ") == "abc");
        assert (убери ("   ") == "");

        assert (откинь ("", '%') == "");
        assert (откинь ("%abc%%%", '%') == "abc");
        assert (откинь ("#####", '#') == "");
        assert (откиньлев ("#####", '#') == "");
        assert (откиньлев (" ###", ' ') == "###");
        assert (откиньлев ("#####", 's') == "#####");
        assert (откиньправ ("#####", '#') == "");
        assert (откиньправ ("### ", ' ') == "###");
        assert (откиньправ ("#####", 's') == "#####");

        assert (замени ("abc".dup, 'b', ':') == "a:c");
        assert (подставь ("abc".dup, "bc", "x") == "ax");

        assert (местоположение ("abc", 'c', 1) is 2);

        assert (местоположение ("abc", 'c') is 2);
        assert (местоположение ("abc", 'a') is 0);
        assert (местоположение ("abc", 'd') is 3);
        assert (местоположение ("", 'c') is 0);

        assert (местоположениеПеред ("abce", 'c') is 2);
        assert (местоположениеПеред ("abce", 'a') is 0);
        assert (местоположениеПеред ("abce", 'd') is 4);
        assert (местоположениеПеред ("abce", 'c', 3) is 2);
        assert (местоположениеПеред ("abce", 'c', 2) is 4);
        assert (местоположениеПеред ("", 'c') is 0);

        auto x = разграничь ("::b", ":");
        assert (x.length is 3 && x[0] == "" && x[1] == "" && x[2] == "b");
        x = разграничь ("a:bc:d", ":");
        assert (x.length is 3 && x[0] == "a" && x[1] == "bc" && x[2] == "d");
        x = разграничь ("abcd", ":");
        assert (x.length is 1 && x[0] == "abcd");
        x = разграничь ("abcd:", ":");
        assert (x.length is 2 && x[0] == "abcd" && x[1] == "");
        x = разграничь ("a;b$c#d:e@f", ";:$#@");
        assert (x.length is 6 && x[0]=="a" && x[1]=="b" && x[2]=="c" &&
        x[3]=="d" && x[4]=="e" && x[5]=="f");

        assert (местоположениеОбразца ("abcdefg", "") is 7);
        assert (местоположениеОбразца ("abcdefg", "g") is 6);
        assert (местоположениеОбразца ("abcdefg", "abcdefg") is 0);
        assert (местоположениеОбразца ("abcdefg", "abcdefgx") is 7);
        assert (местоположениеОбразца ("abcdefg", "cce") is 7);
        assert (местоположениеОбразца ("abcdefg", "cde") is 2);
        assert (местоположениеОбразца ("abcdefgcde", "cde", 3) is 7);

        assert (местоположениеПередОбразцом ("abcdefg", "") is 7);
        assert (местоположениеПередОбразцом ("abcdefg", "cce") is 7);
        assert (местоположениеПередОбразцом ("abcdefg", "cde") is 2);
        assert (местоположениеПередОбразцом ("abcdefgcde", "cde", 6) is 2);
        assert (местоположениеПередОбразцом ("abcdefgcde", "cde", 4) is 2);
        assert (местоположениеПередОбразцом ("abcdefg", "abcdefgx") is 7);

        x = рабейнастр ("a\nb\n");
        assert (x.length is 3 && x[0] == "a" && x[1] == "b" && x[2] == "");
        x = рабейнастр ("a\r\n");
        assert (x.length is 2 && x[0] == "a" && x[1] == "");

        x = рабейнастр ("a");
        assert (x.length is 1 && x[0] == "a");
        x = рабейнастр ("");
        assert (x.length is 1);

        ткст[] q;
        foreach (элемент; кавычки ("1 'avcc   cc ' 3", " "))
        q ~= элемент;
        assert (q.length is 3 && q[0] == "1" && q[1] == "'avcc   cc '" && q[2] == "3");

        assert (выкладка (врем, "%1,%%%c %0", "abc", "efg") == "efg,%c abc");

        x = разбей ("one, two, three", ",");
        assert (x.length is 3 && x[0] == "one" && x[1] == " two" && x[2] == " three");
        x = разбей ("one, two, three", ", ");
        assert (x.length is 3 && x[0] == "one" && x[1] == "two" && x[2] == "three");
        x = разбей ("one, two, three", ",,");
        assert (x.length is 1 && x[0] == "one, two, three");
        x = разбей ("one,,", ",");
        assert (x.length is 3 && x[0] == "one" && x[1] == "" && x[2] == "");

        ткст h, t;
        h =  голова ("one:two:three", ":", t);
        assert (h == "one" && t == "two:three");
        h = голова ("one:::two:three", ":::", t);
        assert (h == "one" && t == "two:three");
        h = голова ("one:two:three", "*", t);
        assert (h == "one:two:three" && t is пусто);

        t =  хвост ("one:two:three", ":", h);
        assert (h == "one:two" && t == "three");
        t = хвост ("one:::two:three", ":::", h);
        assert (h == "one" && t == "two:three");
        t = хвост ("one:two:three", "*", h);
        assert (t == "one:two:three" && h is пусто);

        assert (отсекилев("hello world", "hello ") == "world");
        assert (отсекилев("hello", "hello") == "");
        assert (отсекилев("hello world", " ") == "hello world");
        assert (отсекилев("hello world", "") == "hello world");

        assert (отсекиправ("hello world", " world") == "hello");
        assert (отсекиправ("hello", "hello") == "");
        assert (отсекиправ("hello world", " ") == "hello world");
        assert (отсекиправ("hello world", "") == "hello world");

        ткст[] foo = ["one", "two", "three"];
        auto j = объедини (foo);
        assert (j == "onetwothree");
        j = объедини (foo, ", ");
        assert (j == "one, two, three");
        j = объедини (foo, " ", врем);
        assert (j == "one two three");
        assert (j.ptr is врем.ptr);

        assert (повтори ("abc", 0) == "");
        assert (повтори ("abc", 1) == "abc");
        assert (повтори ("abc", 2) == "abcabc");
        assert (повтори ("abc", 4) == "abcabcabcabc");
        assert (повтори ("", 4) == "");
        сим[10] rep;
        assert (повтори ("abc", 0, rep) == "");
        assert (повтори ("abc", 1, rep) == "abc");
        assert (повтори ("abc", 2, rep) == "abcabc");
        assert (повтори ("", 4, rep) == "");

        assert (убериИскейп ("abc") == "abc");
        assert (убериИскейп ("abc\\") == "abc\\");
        assert (убериИскейп ("abc\\t") == "abc\t");
        assert (убериИскейп ("abc\\tc") == "abc\tc");
        assert (убериИскейп ("\\t") == "\t");
        assert (убериИскейп ("\\tx") == "\tx");
        assert (убериИскейп ("\\v\\vx") == "\v\vx");
        assert (убериИскейп ("abc\\t\\a\\bc") == "abc\t\a\bc");
    }
}



debug (Util)
{
    auto x = import("Util.d");

    проц main()
    {
        не_совпадают ("".ptr, x.ptr, 0);
        индексУ ("".ptr, '@', 0);
        ткст s;
        разбей (s, " ");
        //индексУ (s.ptr, '@', 0);

    }
}
