module col.iterator.ArrayIterator;

private import exception;

private import col.model.GuardIterator;


/**
 *
 * ОбходчикМассива допускается you в_ use массивы as Iterators
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class ОбходчикМассива(T) : СтражОбходчик!(T)
{
    private T [] масс_;
    private цел тек_;
    private цел разм_;

    /**
     * Build an enumeration that returns successive элементы of the Массив
    **/
    public this (T масс[])
    {
        // масс_ = масс; тек_ = 0; разм_ = масс.длина;
        масс_ = масс;
        тек_ = -1;
        разм_ = масс.length;
    }

    /**
     * Implements col.impl.Collection.CollectionIterator.остаток
     * See_Also: col.impl.Collection.CollectionIterator.остаток
    **/
    public бцел остаток()
    {
        return разм_;
    }

    /**
     * Implements col.model.IteratorX.ещё.
     * See_Also: col.model.IteratorX.ещё
    **/
    public бул ещё()
    {
        return разм_ > 0;
    }

    /**
     * Implements col.impl.Collection.CollectionIterator.повреждён.
     * Always нет. Inconsistency cannot be reliably detected for массивы
     * Возвращает: нет
     * See_Also: col.impl.Collection.CollectionIterator.повреждён
    **/

    public бул повреждён()
    {
        return нет;
    }

    /**
     * Implements col.model.IteratorX.получи().
     * See_Also: col.model.IteratorX.получи()
    **/
    public T получи()
    {
        if (разм_ > 0)
        {
            --разм_;
            ++тек_;
            return масс_[тек_];
        }
        throw new НетЭлементаИскл ("Исчерпаный Обходчик");
    }


    цел opApply (цел delegate (inout T значение) дг)
    {
        цел результат;

        for (auto i=разм_; i--;)
        {
            auto значение = получи();
            if ((результат = дг(значение)) != 0)
                break;
        }
        return результат;
    }
}
