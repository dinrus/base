﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: April 2004

        author:         Kris

*******************************************************************************/

module net.http.HttpParams;

private import  time.Time;

private import  io.stream.Buffered;

private import  net.http.HttpTokens;

private import  io.stream.Delimiters;

public  import  net.http.model.HttpParamsView;

/******************************************************************************

        Maintains набор of запрос параметры, разобрано из_ an HTTP request.
        Use ПараметрыППГТ instead for вывод параметры.

        Note that these ввод парамы may have been кодирован by the пользователь-
        agent. Unfortunately there имеется been little consensus on что that
        кодировка should be (especially regarding GET запрос-парамы). With
        luck, that will change в_ a consistent usage of UTF-8 внутри the
        near future.

******************************************************************************/

class ПараметрыППГТ : ТокеныППГТ, ОбзорПараметровППГТ
{
    // tell compiler в_ expose super.разбор() also
    // alias ТокеныППГТ.разбор разбор;

    private Разграничители!(сим) amp;

    /**********************************************************************

            Строит параметры, сообщая СтэкППГТ, что пара
            имя/значение разделяется символом '='.

    **********************************************************************/

    this ()
    {
        super ('=');

        // construct a строка tokenizer for later usage
        amp = new Разграничители!(сим) ("&");
    }

    /**********************************************************************

            Возвращает число of заголовки

    **********************************************************************/

    бцел размер ()
    {
        return super.стэк.размер;
    }

    /**********************************************************************

            Читает все параметры запроса. Они помещаются в карту (map) вместо
			размещения в памяти или копирования.

    **********************************************************************/

    override проц разбор (БуфВвод ввод)
    {
        установиРазобран (да);
        amp.установи (ввод);

        while (amp.следщ || amp.получи.length)
            стэк.сунь (amp.получи);
    }

    /**********************************************************************

            Добавь a имя/значение пара в_ the запрос список

    **********************************************************************/

    проц добавь (ткст имя, ткст значение)
    {
        super.добавь (имя, значение);
    }

    /**********************************************************************

            Добавь a имя/целое пара в_ the запрос список

    **********************************************************************/

    проц добавьЦел (ткст имя, цел значение)
    {
        super.добавьЦел (имя, значение);
    }


    /**********************************************************************

            Добавь a имя/дата(дол) пара в_ the запрос список

    **********************************************************************/

    проц добавьДату (ткст имя, Время значение)
    {
        super.добавьДату (имя, значение);
    }

    /**********************************************************************

            Возвращает значение of the предоставленный заголовок, либо пусто if the
            заголовок does not есть_ли

    **********************************************************************/

    ткст получи (ткст имя, ткст возвр = пусто)
    {
        return super.получи (имя, возвр);
    }

    /**********************************************************************

            Возвращает целое значение of the предоставленный заголовок, либо the
            предоставленный default-значение if the заголовок does not есть_ли

    **********************************************************************/

    цел получиЦел (ткст имя, цел возвр = -1)
    {
        return super.получиЦел (имя, возвр);
    }

    /**********************************************************************

            Возвращает дата значение of the предоставленный заголовок, либо the
            предоставленный default-значение if the заголовок does not есть_ли

    **********************************************************************/

    Время дайДату (ткст имя, Время возвр = Время.эпоха)
    {
        return super.дайДату (имя, возвр);
    }


    /**********************************************************************

            Вывод the param список в_ the предоставленный consumer

    **********************************************************************/

    проц произведи (т_мера delegate(проц[]) используй, ткст кс=пусто)
    {
        return super.произведи (используй, кс);
    }
}
