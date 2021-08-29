/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Multiset;
public import col.model.Collection,
       col.model.Addable,
       col.model.Multi;

/**
 * Мультинабор - это контейнер, плозволяющий добавлять несколько экземпляров
 * с одинаковым значением.
 *
 * It is similar to a list, except there is no requirement for ordering.  That
 * is, элементы may not be stored in the order добавленный.
 *
 * Since ordering is not important, the collection can reorder элементы on
 * removal or addition to optimize the operations.
 */
interface Мультинабор(З) : Коллекция!(З), Добавляемый!(З), Мульти!(З)
{
    /**
     * Совариант очисти (из Коллекция)
     */
    Мультинабор!(З) очисти();

    /**
     * Совариант dup (из Коллекция)
     */
    Мультинабор!(З) dup();

    /**
     * Совариант удали (из Коллекция)
     */
    Мультинабор!(З) удали(З знач);

    /**
     * Совариант удали (из Коллекция)
     */
    Мультинабор!(З) удали(З знач, ref бул удалён_ли);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Мультинабор!(З) добавь(З знач);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Мультинабор!(З) добавь(З знач, ref бул был_добавлен);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Мультинабор!(З) добавь(Обходчик!(З) обх);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Мультинабор!(З) добавь(Обходчик!(З) обх, ref бцел чло_добавленных);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Мультинабор!(З) добавь(З[] массив);

    /**
     * Совариант добавь (из Добавляемый)
     */
    Мультинабор!(З) добавь(З[] массив, ref бцел чло_добавленных);

    /**
     * Совариант удалиВсе (из Мульти)
     */
    Мультинабор!(З) удалиВсе(З знач);

    /**
     * Совариант удалиВсе (из Мульти)
     */
    Мультинабор!(З) удалиВсе(З знач, ref бцел чло_Удалённых);

    /**
     * gets the most convenient элемент in the multiset.  Note that no
     * particular order of элементы is assumed, so this might be the последн
     * элемент добавленный, might be the первый, might be one in the middle.  This
     * элемент would be the первый iterated if the multiset is используется as an
     * обходчик.  Therefore, the removal of this элемент via удали(дай())
     * would be less than the normal O(n) runtime.
     */
    З дай();

    /**
     * Remove the most convenient элемент in the multiset и return its
     * значение.  This is equivalent to удали(дай()), but only does one lookup.
     *
     * Undefined if called on an empty multiset.
     */
    З изыми();
}
