﻿/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Set;
public import col.model.Collection,
       col.model.Addable;

/**
 * Набор - это коллекция объектов, в которой может существовать только один
 * экземпляр объекта. Если добавляется 2 экземпляра объекта, то только первый
 * попадает в набор.
 */
interface Набор(З) : Коллекция!(З), Добавляемый!(З)
{
    /**
     * Удалить все значения, которые сверь the given обходчик.
     */
    Набор!(З) удали(Обходчик!(З) поднабор);

    /**
     * Удалить все значения, которые сверь the given обходчик.
     */
    Набор!(З) удали(Обходчик!(З) поднабор, ref бцел чло_Удалённых);

    /**
     * Удалить все значения, которые are not in the given обходчик.
     */
    Набор!(З) накладка(Обходчик!(З) поднабор);

    /**
     * Удалить все значения, которые are not in the given обходчик.
     */
    Набор!(З) накладка(Обходчик!(З) поднабор, ref бцел чло_Удалённых);

    /**
     * Совариант dup (from Коллекция)
     */
    Набор!(З) dup();

    /**
     * Совариант удали (from Коллекция)
     */
    Набор!(З) удали(З знач);

    /**
     * Совариант удали (from Коллекция)
     */
    Набор!(З) удали(З знач, ref бул удалён_ли);

    /**
     * Совариант добавь (from Добавляемый)
     */
    Набор!(З) добавь(З знач);

    /**
     * Совариант добавь (from Добавляемый)
     */
    Набор!(З) добавь(З знач, ref бул был_добавлен);

    /**
     * Совариант добавь (from Добавляемый)
     */
    Набор!(З) добавь(Обходчик!(З) обх);

    /**
     * Совариант добавь (from Добавляемый)
     */
    Набор!(З) добавь(Обходчик!(З) обх, ref бцел чло_добавленных);

    /**
     * Совариант добавь (from Добавляемый)
     */
    Набор!(З) добавь(З[] массив);

    /**
     * Совариант добавь (from Добавляемый)
     */
    Набор!(З) добавь(З[] массив, ref бцел чло_добавленных);

    /**
     * Сравни two sets.  Returns true if both sets have the same number of
     * элементы, и all элементы in one установи exist in the other установи.
     *
     * if o is not a Набор, return false.
     */
    цел opEquals(Объект o);

    /**
     * дай the most convenient элемент in the установи.  This is the элемент that
     * would be iterated первый.  Therefore, calling удали(дай()) is
     * guaranteed to be less than an O(n) operation.
     */
    З дай();

    /**
     * Remove the most convenient элемент from the установи, и return its значение.
     * This is equivalent to удали(дай()), except that only one lookup is
     * performed.
     */
    З изыми();
}
