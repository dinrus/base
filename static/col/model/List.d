/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.List;
public import col.model.Collection,
       col.model.Addable,
       col.model.Multi;

/**
 * Список - это коллекция, элементы которой находятся в порядке их добавления. Это
 * полезно, когда нужно проследить не только за значениями, но и за порядком
 * их появления.
 */
interface Список(V) : Коллекция!(V), Добавляемый!(V), Мульти!(V)
{
    /**
     * Соединяет два списка вместе. Тип результирующего списка
     * такой, как у списка слева.
     */
    Список!(V) opCat(Список!(V) rhs);

    /**
     * Соединяет список и массив вместе.
     *
     * Резулитирующий список такого же типа, как и исходный.
     */
    Список!(V) opCat(V[] массив);

    /**
     * Соединяет массив и этот список вместе.
     *
     * Резулитирующий список такого же типа, как и исходный.
     */
    Список!(V) opCat_r(V[] массив);

    /**
     * поставь the given list to this list.  Returns 'this'.
     */
    Список!(V) opCatAssign(Список!(V) rhs);

    /**
     * поставь the given массив to this list.  Returns 'this'.
     */
    Список!(V) opCatAssign(V[] массив);

    /**
     * Совариант очисти (из Коллекция)
     */
    Список!(V) очисти();

    /**
     * Совариант dup (из Коллекция)
     */
    Список!(V) dup();

    /**
     * Совариант удали (из Коллекция)
     */
    Список!(V) удали(V v);

    /**
     * Совариант удали (из Коллекция)
     */
    Список!(V) удали(V v, ref бул был_Удалён);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Список!(V) добавь(V v);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Список!(V) добавь(V v, ref бул был_добавлен);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Список!(V) добавь(Обходчик!(V) обх);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Список!(V) добавь(Обходчик!(V) обх, ref бцел чло_добавленных);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Список!(V) добавь(V[] массив);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Список!(V) добавь(V[] массив, ref бцел чло_добавленных);

    /**
     * Совариант удалиВсе (из Мульти)
     */
    Список!(V) удалиВсе(V v);

    /**
     * Совариант удалиВсе (из Мульти)
     */
    Список!(V) удалиВсе(V v, ref бцел чло_Удалённых);

    /**
     * сортируй this list according to the default сравни routine for V.  Returns
     * a ссылка to the list after обх is sorted.
     */
    Список!(V) сортируй();

    /**
     * сортируй this list according to the comparison routine given.  Returns a
     * ссылка to the list after обх is sorted.
     */
    Список!(V) сортируй(цел delegate(ref V v1, ref V v2) comp);

    /**
     * сортируй this list according to the comparison routine given.  Returns a
     * ссылка to the list after обх is sorted.
     */
    Список!(V) сортируй(цел function(ref V v1, ref V v2) comp);

    /**
     * сравни this list to another list.  Returns true if they have the same
     * number of элементы и all the элементы are equal.
     *
     * If o is not a list, then 0 is returned.
     */
    цел opEquals(Объект o);

    /**
     * Returns the элемент at the фронт of the list, or the oldest элемент
     * добавленный.  If the list is empty, calling фронт is undefined.
     */
    V фронт();

    /**
     * Returns the элемент at the конец of the list, or the most recent элемент
     * добавленный.  If the list is empty, calling тыл is undefined.
     */
    V тыл();

    /**
     * Takes the элемент at the фронт of the list, и return its значение.  This
     * operation can be as high as O(n).
     */
    V возьмиФронт();

    /**
     * Takes the элемент at the конец of the list, и return its значение.  This
     * operation can be as high as O(n).
     */
    V возьмиТыл();
}
