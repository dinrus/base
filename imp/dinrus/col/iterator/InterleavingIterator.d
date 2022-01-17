module col.iterator.InterleavingIterator;

private import  exception;
private import  col.model.IteratorX;

/**
 *
 * InterleavingIterators allow you в_ комбинируй the элементы
 * of two different enumerations as if they were one enumeration
 * перед they are seen by their `consumers'.
 * This sometimes допускается you в_ avoопр having в_ use a
 * Коллекция объект в_ temporarily комбинируй two sets of Коллекция элементы()
 * that need в_ be собериed together for common processing.
 * <P>
 * The элементы are revealed (via получи()) in a purely
 * interleaved fashion, alternating between the первый и секунда
 * enumerations unless one of them имеется been exhausted, in which case
 * все остаток элементы of the другой are revealed until it too is
 * exhausted.
 * <P>
 * InterleavingIterators work as wrappers around другой Iterators.
 * To build one, you need two existing Iterators.
 * Например, if you want в_ process together the элементы of
 * two Collections a и b, you could пиши something of the form:
 * <PRE>
 * Обходчик items = ПеремежающийОбходчик(a.элементы(), b.элементы());
 * while (items.ещё())
 *  doSomethingWith(items.получи());
 * </PRE>
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/


public class ПеремежающийОбходчик(T) : Обходчик!(T)
{

    /**
     * The первый исток; nulled out once it is exhausted
    **/

    private Обходчик!(T) перв_;

    /**
     * The секунда исток; nulled out once it is exhausted
    **/

    private Обходчик!(T) втор_;

    /**
     * The исток currently being использован
    **/

    private Обходчик!(T) текущ_;



    /**
     * Создаётn enumeration interleaving элементы из_ перв и втор
    **/

    public this (Обходчик!(T) перв, Обходчик!(T) втор)
    {
        перв_ = перв;
        втор_ = втор;
        текущ_ = втор_; // флип will сбрось в_ перв (if it can)
        флип();
    }

    /**
     * Реализует col.model.IteratorX.ещё
    **/
    public final бул ещё()
    {
        return текущ_ !is пусто;
    }

    /**
     * Реализует col.model.IteratorX.получи.
    **/
    public final T получи()
    {
        if (текущ_ is пусто)
            throw new НетЭлементаИскл("обходчик завершён");
        else
        {
            // following строка may also throw ex, but there's nothing
            // reasonable в_ do except распространить
            auto результат = текущ_.получи();
            флип();
            return результат;
        }
    }


    цел opApply (цел delegate (inout T значение) дг)
    {
        цел результат;

        while (текущ_)
        {
            auto значение = получи();
            if ((результат = дг(значение)) != 0)
                break;
        }
        return результат;
    }

    /**
     * Alternate sources
    **/

    private final проц флип()
    {
        if (текущ_ is перв_)
        {
            if (втор_ !is пусто && !втор_.ещё())
                втор_ = пусто;
            if (втор_ !is пусто)
                текущ_ = втор_;
            else
            {
                if (перв_ !is пусто && !перв_.ещё())
                    перв_ = пусто;
                текущ_ = перв_;
            }
        }
        else
        {
            if (перв_ !is пусто && !перв_.ещё())
                перв_ = пусто;
            if (перв_ !is пусто)
                текущ_ = перв_;
            else
            {
                if (втор_ !is пусто && !втор_.ещё())
                    втор_ = пусто;
                текущ_ = втор_;
            }
        }
    }


}

