module col.iterator.ArrayIterator;

private import exception;

private import col.model.GuardIterator;


/**
 * ОбходчикМассива допускает использование массивов в качестве итераторов.
**/

public class ОбходчикМассива(T) : СтражОбходчик!(T)
{
    private T [] масс_;
    private цел тек_;
    private цел разм_;

    /**
     * Строит перечисление, которое возвращает последовательные элементы массива.
    **/
    public this (T масс[])
    {
        // масс_ = масс; тек_ = 0; разм_ = масс.длина;
        масс_ = масс;
        тек_ = -1;
        разм_ = масс.length;
    }

    /**
     * Реализует col.impl.Collection.CollectionIterator.остаток
     * См_Также: col.impl.Collection.CollectionIterator.остаток
    **/
    public бцел остаток()
    {
        return разм_;
    }

    /**
     * Реализует col.model.IteratorX.ещё.
     * См_Также: col.model.IteratorX.ещё
    **/
    public бул ещё()
    {
        return разм_ > 0;
    }

    /**
     * Реализует col.impl.Collection.CollectionIterator.повреждён.
     * Всегда нет. Легко надёжно обнаружить неконсистентность для массивов.
     * Возвращает: нет
     * См_Также: col.impl.Collection.CollectionIterator.повреждён
    **/

    public бул повреждён()
    {
        return нет;
    }

    /**
     * Реализует col.model.IteratorX.получи().
     * См_Также: col.model.IteratorX.получи()
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
