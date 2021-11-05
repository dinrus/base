﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Nov 2005: Initial release

        author:         Kris

*******************************************************************************/

module text.convert.Sprint;

private import text.convert.Layout;

/******************************************************************************

        Конструирует вывод в стиле sprintf. Является заменой
        семейству функций vsprintf(),вывод записывается в отдельный буфер:
        ---
        // создать экземпляр Тпечать
        auto sprint = new Тпечать!(сим);

        // записать форматированный вывод в логгер
        лог.инфо (sprint ("{} green bottles, sitting on a wall\n", 10));
        ---

        Тпечать удобен, когда требуется форматировать вывод для Логгера
        или в подобной ситуации, т.к. при преобразовании используется
		не куча, а буфер преобразования фиксированного размера.
		Это важно при отладке, так как из-за использования кучи могут
		изменяться поведенческие моменты. Экземпляр Тпечать можно создать
		заблаговременно, и использовать его в связке с пакетом логгинга.

        Please note that the class itself is stateful, и therefore a
        single экземпляр is not shareable across multИПle threads. The
        returned контент is not .dup'd either, so do that yourself if
        you require a persistent копируй.

        Note also that Тпечать is templated, и can be instantiated for
        wide симвы through a Тпечать!(дим) or Тпечать!(шим). The wide
        versions differ in that Всё the вывод и the форматируй-ткст
        are of the мишень тип. Variadic текст аргументы are transcoded
        appropriately.

        See also: text.convert.Layout

******************************************************************************/

class Тпечать(T)
{
    protected T[]           буфер;
    Выкладка!(T)              выкладка;

    alias форматируй            opCall;

    /**********************************************************************

            Созд new Тпечать экземпляры with a буфер of the specified
            размер

            Deprecated - use Стдвыв.выкладка.sprint() instead

    **********************************************************************/

    deprecated this (цел размер = 256)
    {
        this (размер, Выкладка!(T).экземпляр);
    }

    /**********************************************************************

            Созд new Тпечать экземпляры with a буфер of the specified
            размер, и the provопрed форматёр. The секунда аргумент can be
            использован в_ apply cultural specifics (I18N) в_ Тпечать

    **********************************************************************/

    this (цел размер, Выкладка!(T) форматёр)
    {
        буфер = new T[размер];
        this.выкладка = форматёр;
    }

    /**********************************************************************

            Выкладка a установи of аргументы

    **********************************************************************/

    T[] форматируй (T[] фмт, ...)
    {
        return выкладка.vprint (буфер, фмт, _arguments, _argptr);
    }

    /**********************************************************************

            Выкладка a установи of аргументы

    **********************************************************************/

    T[] форматируй (T[] фмт, ИнфОТипе[] аргументы, АргСписок argptr)
    {
        return выкладка.vprint (буфер, фмт, аргументы, argptr);
    }
}

