module col.impl.AbstractIterator;

private import  exception;

private import  col.model.View,
        col.model.GuardIterator;



/**
 * Соответствующий базовый класс для реализации СтражОбходчик
**/

public abstract class АбстрактныйОбходчик(T) : СтражОбходчик!(T)
{
    /**
     * Нумеруемая коллекция.
    **/

    private Обзор!(T) вид;

    /**
     * Версионный номер коллекции, полученный при построении.
    **/

    private бцел изменение;

    /**
     * Число элементов, которое у нас осталось.
     * Инициализуется в вид.размер() при построении.
    **/

    private бцел ещё;


    protected this (Обзор!(T) знач)
    {
        вид = знач;
        ещё = знач.размер();
        изменение = знач.изменение();
    }

    /**
     * Реализует col.impl.Collection.CollectionIterator.повреждён.
     * Заявляет о повреждении, если номер версии отличается.
     * См_Также: col.impl.Collection.CollectionIterator.повреждён
    **/

    public final бул повреждён()
    {
        return изменение != вид.изменение;
    }

    /**
     * Реализует col.impl.Collection.CollectionIterator.numberOfRemaingingElements.
     * См_Также: col.impl.Collection.CollectionIterator.остаток
    **/
    public final бцел остаток()
    {
        return ещё;
    }

    /**
     * Реализует col.model.IteratorX.ещё.
     * Возвращает да, если остаток > 0 и not повреждён
     * См_Также: col.model.IteratorX.ещё
    **/
    public final бул ещё()
    {
        return ещё > 0 && изменение is вид.изменение;
    }

    /**
     * Subclass utility.
     * Пытается декрементировать ещё, выводя исключения.
     * if it is already zero or if повреждён()
     * Always вызов as the первый строка of получи.
    **/
    protected final проц декрементируйОстаток()
    {
        if (изменение != вид.изменение)
            throw new ИсклПовреждённыйОбходчик ("Коллекция изменена во время обхода");

        if (ещё is 0)
            throw new НетЭлементаИскл ("истощённое исчисление");

        --ещё;
    }
}


public abstract class АбстрактныйОбходчикКарты(К, З) : АбстрактныйОбходчик!(З), ОбходчикПар!(К, З)
{
    abstract З получи (inout К ключ);

    protected this (Обзор!(З) c)
    {
        super (c);
    }
}
