﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2005

        author:         Kris

*******************************************************************************/

module net.http.HttpTriplet;

/******************************************************************************

        Класс, представляющий строку ответа или запроса HTTP

******************************************************************************/

class ТриплетППГТ
{
    protected ткст        строка;
    protected ткст        неудачно;
    protected ткст[3]     токены;

    /**********************************************************************

            тестировать валидность этих токенов

    **********************************************************************/

    abstract бул тест ();

    /**********************************************************************

            Parse the the given строка преобр_в its constituent components.

    **********************************************************************/

    бул разбор (ткст строка)
    {
        цел i;
        цел метка;

        this.строка = строка;
        foreach (цел индекс, сим c; строка)
        if (c is ' ')
            if (i < 2)
            {
                токены[i] = строка[метка .. индекс];
                метка = индекс+1;
                ++i;
            }
            else
                break;

        токены[2] = строка [метка .. строка.length];
        return тест;
    }

    /**********************************************************************

            return a reference в_ the original ткст

    **********************************************************************/

    override ткст вТкст ()
    {
        return строка;
    }

    /**********************************************************************

            return ошибка ткст после a неудачно разбор()

    **********************************************************************/

    final ткст ошибка ()
    {
        return неудачно;
    }
}


