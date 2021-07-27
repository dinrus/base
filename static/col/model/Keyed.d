/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Keyed;

public import col.model.Iterator;

/**
 * Интерфейс, определяющий объект, имеющий доступ к значениям по ключу.
 */
interface СКлючом(К, З) : Ключник!(К, З), ЧистящийКлючи!(К, З)
{
    /**
     * Удалитьзначение по положению указанного ключа.
     *
     * Возвращает this.
     */
    СКлючом!(К, З) удалиПо(К ключ);

    /**
     * Удалить значение по положению указанного ключа.
     *
     * Возвращает this.
     *
     * удалён_ли is установи to true if the элемент existed и was removed.
     */
    СКлючом!(К, З) удалиПо(К ключ, ref бул удалён_ли);

    /**
     * Доступ к значению по ключу.
     */
    З opIndex(К ключ);

    /**
     * Присвоить значение по ключу.
     *
     * Используется для вставки пары ключ/значение в эту коллекцию.
     *
     * Note that some containers do not use user-specified ключи.  For those
     * containers, the ключ must already have existed перед setting.
     */
    З opIndexAssign(З значение, К ключ);

    /**
     * установи the ключ/значение пара.  This is similar to opIndexAssign, but returns
     * this, so the function can be chained.
     */
    СКлючом!(К, З) установи(К ключ, З значение);

    /**
     * Same as установи, but имеется a был_добавлен boolean to tell the caller whether the
     * значение was добавленный or not.
     */
    СКлючом!(К, З) установи(К ключ, З значение, ref бул был_добавлен);

    /**
     * Возвращает true, если в этой коллекции есть такой ключ.
     */
    бул имеетКлюч(К ключ);
}
