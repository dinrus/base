﻿module text.locale.Convert;

private import  time.WallClock;
private import  text.locale.Core;


extern(D):

/******************************************************************************

   * Converts the значение of this экземпляр в_ its equivalent ткст представление using the specified _format и культура-specific formatting information.
   * Параметры: 
   *   формат = A _format ткст.
   *   службаФормата = An ИСлужбаФормата that provопрes культура-specific formatting information.
   * Возвращает: A ткст представление of the значение of this экземпляр as specified by формат и службаФормата.
   * Примечания: See $(LINK2 datetimeformat.html, Время Formatting) for ещё information about дата и время formatting.
   * Примеры:
   * ---
   * import io.stream.Format, text.locale.Core, time.WallClock;
   *
   * проц main() {
   *   Культура культура = Культура.текущ;
   *   Время сейчас = Куранты.сейчас;
   *
   *   Println("Текущий дата и время: %s", сейчас.вТкст());
   *   Println();
   *
   *   // Формат the текущ дата и время in a число of ways.
   *   Println("Культура: %s", культура.англИмя);
   *   Println();
   *
   *   Println("Short дата:              %s", сейчас.вТкст("d"));
   *   Println("Long дата:               %s", сейчас.вТкст("D"));
   *   Println("Short время:              %s", сейчас.вТкст("t"));
   *   Println("Long время:               %s", сейчас.вТкст("T"));
   *   Println("General дата крат время: %s", сейчас.вТкст("g"));
   *   Println("General дата дол время:  %s", сейчас.вТкст("G"));
   *   Println("Месяц:                   %s", сейчас.вТкст("M"));
   *   Println("RFC1123:                 %s", сейчас.вТкст("R"));
   *   Println("Сортируемый:                %s", сейчас.вТкст("s"));
   *   Println("Год:                    %s", сейчас.вТкст("Y"));
   *   Println();
   *
   *   // Display the same значения using a different культура.
   *   культура = Культура.дайКультуру("fr-FR");
   *   Println("Культура: %s", культура.англИмя);
   *   Println();
   *
   *   Println("Short дата:              %s", сейчас.вТкст("d", культура));
   *   Println("Long дата:               %s", сейчас.вТкст("D", культура));
   *   Println("Short время:              %s", сейчас.вТкст("t", культура));
   *   Println("Long время:               %s", сейчас.вТкст("T", культура));
   *   Println("General дата крат время: %s", сейчас.вТкст("g", культура));
   *   Println("General дата дол время:  %s", сейчас.вТкст("G", культура));
   *   Println("Месяц:                   %s", сейчас.вТкст("M", культура));
   *   Println("RFC1123:                 %s", сейчас.вТкст("R", культура));
   *   Println("Сортируемый:                %s", сейчас.вТкст("s", культура));
   *   Println("Год:                    %s", сейчас.вТкст("Y", культура));
   *   Println();
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
   * // Сортируемый:                2006-05-26T10:04:57
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
   * // Сортируемый:                2006-05-26T10:04:57
   * // Год:                    mai 2006
   * ---

******************************************************************************/

public ткст форматируйДатуВремя (ткст вывод, Время датаВремя, ткст формат, ИСлужбаФормата службаФормата = пусто) ;

//ткст форматируйДатуВремя (ткст вывод, Время датаВремя, ткст формат, ФорматДатыВремени фдв);

//ткст долВТкст (ткст буфер, дол значение, цел цифры, ткст отрицатЗнак);

//ткст долВБинТкст (ткст буфер, бдол значение, цел цифры);

//сим разборОпределенияФормата (ткст формат, out цел длина);

public ткст форматируйЦелое (ткст вывод, дол значение, ткст формат, ФорматЧисла nf);
public ткст форматируйДво (ткст вывод, дво значение, ткст формат, ФорматЧисла nf);

//проц форматируйВОбщем (ref Число число, ref Результат мишень, цел length, сим формат, ФорматЧисла nf);

//проц форматируйЧисло (ref Число число, ref Результат мишень, цел length, ФорматЧисла nf);

//проц форматируйВалюту (ref Число число, ref Результат мишень, цел длина, ФорматЧисла nf);

//проц форматируйФиксированно (ref Число число, ref Результат мишень, цел длина,
                 // цел[] размерыГруппы, ткст десятичнРазделитель, ткст групповойРазделитель);

//ткст вТкст (ref Число число, ref Результат результат, сим формат, цел длина, ФорматЧисла nf);

//struct - уры Число и Результат приватные, поэтому вывод закоментированных функций отсутствует.