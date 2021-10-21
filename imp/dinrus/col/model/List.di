﻿module col.model.List;
public import col.model.Collection,
       col.model.Addable,
       col.model.Multi;

/**
 * Список - это коллекция, элементы которой находятся в порядке их добавления. Это
 * полезно, когда нужно проследить не только за значениями, но и за порядком
 * их появления.
 */
interface Список(З) : Коллекция!(З), Добавляемый!(З), Мульти!(З)
{
    /**
     * Конкатенирует два списка вместе. Тип результирующего списка равен типу
     * левой стороны.
     */
    Список!(З) opCat(Список!(З) rhs);

    /**
     * Конкатенирует этот список и массив вместе.
     *
     * В итоге получается список такого же типа, как этот.
     */
    Список!(З) opCat(З[] массив);

    /**
     * Кокатенирует массив и этот список вместе.
     *
     * В итоге получается список такого же типа, как этот.
     */
    Список!(З) opCat_r(З[] массив);

    /**
     * Подставить заданный список к этому списку. Возвращает 'этот'.
     */
    Список!(З) opCatAssign(Список!(З) rhs);

    /**
     * Подставить заданный массив к этому списку.  Возвращает 'этот'.
     */
    Список!(З) opCatAssign(З[] массив);

    /**
     * Совариантно зачисть (из Коллекция)
     */
    Список!(З) зачисть();

    /**
     * Совариантно dup (из Коллекция)
     */
    Список!(З) dup();

    /**
     * Совариантно удали (из Коллекция)
     */
    Список!(З) удали(З з);

    /**
     * Совариантно удали (из Коллекция)
     */
    Список!(З) удали(З з, ref бул былУдалён);

    /**
     * Совариантно добавь (из Добавляемый)
     */
    Список!(З) добавь(З з);

    /**
     * Совариантно добавь (из Добавляемый)
     */
    Список!(З) добавь(З з, ref бул былДобавлен);

    /**
     * Совариантно добавь (из Добавляемый)
     */
    Список!(З) добавь(Обходчик!(З) обх);

    /**
     * Совариантно добавь (из Добавляемый)
     */
    Список!(З) добавь(Обходчик!(З) обх, ref бцел члоДобавленных);

    /**
     * Совариантно добавь (из Добавляемый)
     */
    Список!(З) добавь(З[] массив);

    /**
     * Совариантно добавь (из Добавляемый)
     */
    Список!(З) добавь(З[] массив, ref бцел члоДобавленных);

    /**
     * Совариантно удалиВсе (из Мульти)
     */
    Список!(З) удалиВсе(З з);

    /**
     * Совариантно удалиВсе (из Мульти)
     */
    Список!(З) удалиВсе(З з, ref бцел члоУдалённых);

    /**
     * Сортирует этот список в согласии с дефолтной функцией сравнения для З. Возвращает
     * ссылку на этот список, после сортировки обходчика.
     */
    Список!(З) сортируй();

    /**
     * Сортирует этот список в согласии с заданной процедурой сравнения. Возвращает
     * ссылку на этот список, после сортировки обходчика.
     */
    Список!(З) сортируй(цел delegate(ref З v1, ref З v2) comp);

    /**
     * Сортирует этот список в согласии с заданной процедурой сравнения. Возвращает
     * ссылку на этот список, после сортировки обходчика.
     */
    Список!(З) сортируй(цел function(ref З v1, ref З v2) comp);

    /**
     * Сравнивает этот список с другим списком. Возвращает да, если у них
     * одинаковое число элементов и все элементы равны.
     *
     * Если o не является списком, то возвращается 0.
     */
    цел opEquals(Объект o);

    /**
     * Возвращает элемент во фронте этого списка, или самый старейший из
     * добавленных элементов. Если список пуст, вызов фронт неопределён.
     */
    З фронт();

    /**
     * Возвращает элемент в конце этого списка, или самый свежий из
     * добавленных элементов. Если список пуст, вызов тыл неопределён.
     */
    З тыл();

    /**
     * Берёт элемент во фронте списка и возвращает его значение. Эта
     * операция может быть O(n).
     */
    З возьмиФронт();

    /**
     * Берёт элемент в конце списка и возвращает его значение. Эта
     * операция может быть O(n).
     */
    З возьмиТыл();
}
