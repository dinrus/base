﻿module text.locale.Convert;

private import  time.WallClock;

private import  exception;

private import  text.locale.Core;

private import  time.chrono.Calendar;

private import  Целое = text.convert.Integer;

/******************************************************************************

******************************************************************************/

private struct Результат
{
    private бцел    индекс;
    private ткст  цель_;

    /**********************************************************************

    **********************************************************************/

    private static Результат opCall (ткст мишень);

    /**********************************************************************

    **********************************************************************/

    private проц opCatAssign (ткст правткт);

    /**********************************************************************

    **********************************************************************/

    private проц opCatAssign (сим правткт);

    /**********************************************************************

    **********************************************************************/

    private ткст получи ();

    /**********************************************************************

    **********************************************************************/

    private ткст черновик ();
}


/******************************************************************************

   * Converts the значение of this экземпляр в_ its equivalent ткст representation using the specified _format и культура-specific formatting information.
   * Параметры:
   *   форматируй = A _format ткст.
   *   службаФормата = An ИСлужбаФормата that provопрes культура-specific formatting information.
   * Возвращает: A ткст representation of the значение of this экземпляр as specified by форматируй и службаФормата.
   * Remarks: See $(LINK2 datetimeformat.html, Время Formatting) for ещё information about дата и время formatting.
   * Примеры:
   * ---
   * import io.stream.Format, text.locale.Core, time.WallClock;
   *
   * проц main() {
   *   Культура культура = Культура.текущ;
   *   Время сейчас = Куранты.сейчас;
   *
   *   скажифнс("Текущий дата и время: %s", сейчас.вТкст());
   *   нс();
   *
   *   // Формат the текущ дата и время in a число of ways.
   *   скажифнс("Культура: %s", культура.англИмя);
   *   нс();
   *
   *   скажифнс("Short дата:              %s", сейчас.вТкст("d"));
   *   скажифнс("Long дата:               %s", сейчас.вТкст("D"));
   *   скажифнс("Short время:              %s", сейчас.вТкст("t"));
   *   скажифнс("Long время:               %s", сейчас.вТкст("T"));
   *   скажифнс("General дата крат время: %s", сейчас.вТкст("g"));
   *   скажифнс("General дата дол время:  %s", сейчас.вТкст("G"));
   *   скажифнс("Месяц:                   %s", сейчас.вТкст("M"));
   *   скажифнс("RFC1123:                 %s", сейчас.вТкст("R"));
   *   скажифнс("Sortable:                %s", сейчас.вТкст("s"));
   *   скажифнс("Год:                    %s", сейчас.вТкст("Y"));
   *   нс();
   *
   *   // Display the same значения using a different культура.
   *   культура = Культура.дайКультуру("fr-FR");
   *   скажифнс("Культура: %s", культура.англИмя);
   *   нс();
   *
   *   скажифнс("Short дата:              %s", сейчас.вТкст("d", культура));
   *   скажифнс("Long дата:               %s", сейчас.вТкст("D", культура));
   *   скажифнс("Short время:              %s", сейчас.вТкст("t", культура));
   *   скажифнс("Long время:               %s", сейчас.вТкст("T", культура));
   *   скажифнс("General дата крат время: %s", сейчас.вТкст("g", культура));
   *   скажифнс("General дата дол время:  %s", сейчас.вТкст("G", культура));
   *   скажифнс("Месяц:                   %s", сейчас.вТкст("M", культура));
   *   скажифнс("RFC1123:                 %s", сейчас.вТкст("R", культура));
   *   скажифнс("Sortable:                %s", сейчас.вТкст("s", культура));
   *   скажифнс("Год:                    %s", сейчас.вТкст("Y", культура));
   *   нс();
   * }
   *
   * // Produces the following вывод:
   * // Текущий дата и время: 26/05/2006 10:04:57 AM
   * //
   * // Культура: English (United Kingdom)
   * //
   * // Short дата:              26/05/2006
   * // Long дата:               26 May 2006
   * // Short время:              10:04
   * // Long время:               10:04:57 AM
   * // General дата крат время: 26/05/2006 10:04
   * // General дата дол время:  26/05/2006 10:04:57 AM
   * // Месяц:                   26 May
   * // RFC1123:                 Fri, 26 May 2006 10:04:57 GMT
   * // Sortable:                2006-05-26T10:04:57
   * // Год:                    May 2006
   * //
   * // Культура: French (France)
   * //
   * // Short дата:              26/05/2006
   * // Long дата:               vendredi 26 mai 2006
   * // Short время:              10:04
   * // Long время:               10:04:57
   * // General дата крат время: 26/05/2006 10:04
   * // General дата дол время:  26/05/2006 10:04:57
   * // Месяц:                   26 mai
   * // RFC1123:                 ven., 26 mai 2006 10:04:57 GMT
   * // Sortable:                2006-05-26T10:04:57
   * // Год:                    mai 2006
   * ---

******************************************************************************/

public ткст форматируйДатуВремя (ткст вывод, Время датаВремя, ткст форматируй, ИСлужбаФормата службаФормата = пусто);

ткст форматируйДатуВремя (ткст вывод, Время датаВремя, ткст форматируй, ФорматДатыВремени фдв);

/**********************************************************************

**********************************************************************/

ткст форматируйОсобо (ref Результат результат, Время датаВремя, ткст форматируй);

/*******************************************************************************

*******************************************************************************/

private extern (C) сим* ecvt(дво d, цел цифры, out цел decpt, out бул знак);

/*******************************************************************************

*******************************************************************************/

// Должно соответствовать ФорматЧисла.образецПоложитДесятка
package const   ткст форматПоложительногоЧисла = "#";

// Должно соответствовать ФорматЧисла.образецОтрицатДесятка
package const   ткст[] форматыОтрицательныхЧисел =
    [
        "(#)", "-#", "- #", "#-", "# -"
    ];

// Должно соответствовать ФорматЧисла.валютнПоложитОбразец
package const   ткст[] форматыПоложительнойВалюты =
    [
        "$#", "#$", "$ #", "# $"
    ];

// Должно соответствовать ФорматЧисла.валютнОтрицатОбразец
package const   ткст[] форматыОтрицательнойВалюты =
    [
        "($#)", "-$#", "$-#", "$#-", "(#$)",
        "-#$", "#-$", "#$-", "-# $", "-$ #",
        "# $-", "$ #-", "$ -#", "#- $", "($ #)", "(# $)"
    ];

/*******************************************************************************

*******************************************************************************/

package template симвОкончание (T)
{
    package цел симвОкончание(T* s)
    {
        цел i;
        while (*s++ != '\0')
            i++;
        return i;
    }
}

/*******************************************************************************

*******************************************************************************/

ткст долВТкст (ткст буфер, дол значение, цел цифры, ткст отрицатЗнак);

/*******************************************************************************

*******************************************************************************/

ткст долВГексТкст (ткст буфер, бдол значение, цел цифры, сим формат);

/*******************************************************************************

*******************************************************************************/

ткст долВБинТкст (ткст буфер, бдол значение, цел цифры);

/*******************************************************************************

*******************************************************************************/

сим разборОпределенияФормата (ткст формат, out цел длина);

/*******************************************************************************

*******************************************************************************/

ткст форматируйЦелое (ткст вывод, дол значение, ткст формат, ФорматЧисла nf);

/*******************************************************************************

*******************************************************************************/

private enum
{
    ЭКСП = 0x7ff,
    ФЛАГ_НЧ = 0x80000000,
    ФЛАГ_БЕСК = 0x7fffffff,
}

ткст форматируйДво (ткст вывод, дво значение, ткст форматируй, ФорматЧисла nf);

/*******************************************************************************

*******************************************************************************/

проц форматируйВОбщем (ref Число число, ref Результат мишень, цел длина, сим форматируй, ФорматЧисла nf);

/*******************************************************************************

*******************************************************************************/

проц форматируйЧисло (ref Число число, ref Результат мишень, цел длина, ФорматЧисла nf);

/*******************************************************************************

*******************************************************************************/

проц форматируйВалюту (ref Число число, ref Результат мишень, цел длина, ФорматЧисла nf);

/*******************************************************************************

*******************************************************************************/

проц форматируйФиксированно (ref Число число, ref Результат мишень, цел длина,
        цел[] размерыГруппы, ткст десятичнРазделитель, ткст групповойРазделитель);

/******************************************************************************

******************************************************************************/

ткст вТкст (ref Число число, ref Результат результат, сим форматируй, цел длина, ФорматЧисла nf);


/*******************************************************************************

*******************************************************************************/

private struct Число
{
    цел шкала;
    бул знак;
    цел точность;
    сим[32] цифры =void;

    /**********************************************************************

    **********************************************************************/

    private static Число opCall (дол значение);

    /**********************************************************************

    **********************************************************************/

    private static Число opCall (дво значение, цел точность);

    /**********************************************************************

    **********************************************************************/

    private бул вДво(out дво значение);


    /**********************************************************************

    **********************************************************************/

    private ткст вТкстФормат (ref Результат результат, ткст формат, ФорматЧисла nf);

    /**********************************************************************

    **********************************************************************/

    private проц округли (цел поз);
}
