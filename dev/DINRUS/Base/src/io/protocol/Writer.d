﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2004: Initial release
                        Dec 2006: Outback release

        author:         Kris

*******************************************************************************/

module io.protocol.Writer;

private import  io.Buffer;

public  import             io.model;

public  import  io.protocol.model;


/*******************************************************************************

        Писатель основа-class. Writers предоставляет the means в_ добавь formatted
        данные в_ an ИБуфер, и expose a convenient метод of handling a
        variety of данные типы. In добавьition в_ writing исконный типы such
        as целое и ткст, writers also process any class which имеется
        implemented the ИЗаписываемое interface (one метод).

        все writers support the full установи of исконный данные типы, plus their
        fundamental Массив variants. Operations may be chained задний-в_-задний.

        Writers support a Java-esque помести() notation. However, the Dinrus стиль
        is в_ place IO элементы внутри their own parenthesis, like so:

        ---
        пиши (счёт) (" green bottles");
        ---

        Note that each записано элемент is distict; this стиль is affectionately
        known as "whisper". The код below illustrates basic operation upon a
        память буфер:

        ---
        auto буф = new Буфер (256);

        // карта same буфер преобр_в Всё читатель и писатель
        auto читай = new Читатель (буф);
        auto пиши = new Писатель (буф);

        цел i = 10;
        дол j = 20;
        дво d = 3.14159;
        ткст c = "fred";

        // пиши данные типы out
        пиши (c) (i) (j) (d);

        // читай them задний again
        читай (c) (i) (j) (d);


        // same thing again, but using помести() syntax instead
        пиши.помести(c).помести(i).помести(j).помести(d);
        читай.получи(c).получи(i).получи(j).получи(d);
        ---

        Writers may also be использован with any class implementing the ИЗаписываемое
        interface, along with any struct implementing an equivalent function.

*******************************************************************************/


export class Писатель : ИПисатель
{


    // the буфер associated with this писатель. Note that this
    // should not change over the lifetime of the читатель, since
    // it is assumed в_ be immutable elsewhere
    package ИБуфер                 буфер_;

    package ИПротокол.ПисательМассива   массивы;
    package ИПротокол.Писатель        элементы;

    // конец of строка sequence
    package ткст                  кс = ФайлКонст.НовСтрЗнак;

    /***********************************************************************

            Construct a Писатель on the предоставленный Protocol

    ***********************************************************************/
export:
    this (ИПротокол протокол)
    {
        буфер_ = протокол.буфер;
        элементы = &протокол.пиши;
        массивы = &протокол.пишиМассив;
    }

    /***********************************************************************

            Construct a Писатель on the given ИПотокВывода. We do our own
            протокол handling, equivalent в_ the ПротоколНатив.

    ***********************************************************************/

    this (ИПотокВывода поток)
    {
        auto b = cast(ИБуферированный) поток;
        буфер_ = b ? b.буфер() : объБуфер(поток.провод);

        массивы = &пишиМассив;
        элементы = &пишиЭлемент;
    }

    /***********************************************************************

            Возвращает associated буфер

    ***********************************************************************/

    final ИБуфер буфер ()
    {
        return буфер_;
    }

    /***********************************************************************

            Emit a нс

    ***********************************************************************/

    ИПисатель нс ()
    {
        return помести (кс);
    }

    /***********************************************************************

            Устанавливает нс sequence

    ***********************************************************************/

    ИПисатель нс (ткст кс)
    {
        this.кс = кс;
        return this;
    }

    /***********************************************************************

            Flush the вывод of this писатель и return a chaining ref

    ***********************************************************************/

    final ИПисатель слей ()
    {
        буфер_.слей;
        return this;
    }

    /***********************************************************************

            Flush this писатель. This is a convenience метод использован by
            the "whisper" syntax.

    ***********************************************************************/

    final ИПисатель помести ()
    {
        return слей;
    }

    /***********************************************************************

            Зап via a delegate в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (ИПисатель.Клозура дг)
    {
        дг (this);
        return this;
    }

    /***********************************************************************

            Зап a class в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (ИЗаписываемое x)
    {
        if (x is пусто)
            буфер_.ошибка ("Писатель.помести :: attempt в_ пиши a пусто ИЗаписываемое объект");

        return помести (&x.пиши);
    }

    /***********************************************************************

            Зап a булево значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бул x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Bool);
        return this;
    }

    /***********************************************************************

            Зап an unsigned байт значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (ббайт x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.UByte);
        return this;
    }

    /***********************************************************************

            Зап a байт значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (байт x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Byte);
        return this;
    }

    /***********************************************************************

            Зап an unsigned крат значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бкрат x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.UShort);
        return this;
    }

    /***********************************************************************

            Зап a крат значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (крат x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Short);
        return this;
    }

    /***********************************************************************

            Зап a unsigned цел значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бцел x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.UInt);
        return this;
    }

    /***********************************************************************

            Зап an цел значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (цел x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Int);
        return this;
    }

    /***********************************************************************

            Зап an unsigned дол значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бдол x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.ULong);
        return this;
    }

    /***********************************************************************

            Зап a дол значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (дол x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Long);
        return this;
    }

    /***********************************************************************

            Зап a плав значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (плав x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Float);
        return this;
    }

    /***********************************************************************

            Зап a дво значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (дво x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Double);
        return this;
    }

    /***********************************************************************

            Зап a реал значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (реал x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Real);
        return this;
    }

    /***********************************************************************

            Зап a сим значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (сим x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Utf8);
        return this;
    }

    /***********************************************************************

            Зап a шим значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (шим x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Utf16);
        return this;
    }

    /***********************************************************************

            Зап a дим значение в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (дим x)
    {
        элементы (&x, x.sizeof, ИПротокол.Тип.Utf32);
        return this;
    }

    /***********************************************************************

            Зап a булево Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бул[] x)
    {
        массивы (x.ptr, x.length * бул.sizeof, ИПротокол.Тип.Bool);
        return this;
    }

    /***********************************************************************

            Зап a байт Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (байт[] x)
    {
        массивы (x.ptr, x.length * байт.sizeof, ИПротокол.Тип.Byte);
        return this;
    }

    /***********************************************************************

            Зап an unsigned байт Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (ббайт[] x)
    {
        массивы (x.ptr, x.length * ббайт.sizeof, ИПротокол.Тип.UByte);
        return this;
    }

    /***********************************************************************

            Зап a крат Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (крат[] x)
    {
        массивы (x.ptr, x.length * крат.sizeof, ИПротокол.Тип.Short);
        return this;
    }

    /***********************************************************************

            Зап an unsigned крат Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бкрат[] x)
    {
        массивы (x.ptr, x.length * бкрат.sizeof, ИПротокол.Тип.UShort);
        return this;
    }

    /***********************************************************************

            Зап an цел Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (цел[] x)
    {
        массивы (x.ptr, x.length * цел.sizeof, ИПротокол.Тип.Int);
        return this;
    }

    /***********************************************************************

            Зап an unsigned цел Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бцел[] x)
    {
        массивы (x.ptr, x.length * бцел.sizeof, ИПротокол.Тип.UInt);
        return this;
    }

    /***********************************************************************

            Зап a дол Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (дол[] x)
    {
        массивы (x.ptr, x.length * дол.sizeof, ИПротокол.Тип.Long);
        return this;
    }

    /***********************************************************************

            Зап an unsigned дол Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (бдол[] x)
    {
        массивы (x.ptr, x.length * бдол.sizeof, ИПротокол.Тип.ULong);
        return this;
    }

    /***********************************************************************

            Зап a плав Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (плав[] x)
    {
        массивы (x.ptr, x.length * плав.sizeof, ИПротокол.Тип.Float);
        return this;
    }

    /***********************************************************************

            Зап a дво Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (дво[] x)
    {
        массивы (x.ptr, x.length * дво.sizeof, ИПротокол.Тип.Double);
        return this;
    }

    /***********************************************************************

            Зап a реал Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (реал[] x)
    {
        массивы (x.ptr, x.length * реал.sizeof, ИПротокол.Тип.Real);
        return this;
    }

    /***********************************************************************

            Зап a сим Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (ткст x)
    {
        массивы (x.ptr, x.length * сим.sizeof, ИПротокол.Тип.Utf8);
        return this;
    }

    /***********************************************************************

            Зап a шим Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (шим[] x)
    {
        массивы (x.ptr, x.length * шим.sizeof, ИПротокол.Тип.Utf16);
        return this;
    }

    /***********************************************************************

            Зап a дим Массив в_ the текущ буфер-позиция

    ***********************************************************************/

    final ИПисатель помести (дим[] x)
    {
        массивы (x.ptr, x.length * дим.sizeof, ИПротокол.Тип.Utf32);
        return this;
    }

    /***********************************************************************

            Dump Массив контент преобр_в the буфер. Note that the default
            behaviour is в_ префикс with the Массив байт счёт

    ***********************************************************************/

    private проц пишиМассив (ук ист, бцел байты, ИПротокол.Тип тип)
    {
        помести (байты);
        пишиЭлемент (ист, байты, тип);
    }

    /***********************************************************************

            Dump контент преобр_в the буфер

    ***********************************************************************/

    private проц пишиЭлемент (ук ист, бцел байты, ИПротокол.Тип тип)
    {
        буфер_.добавь (ист [0 .. байты]);
    }
}
