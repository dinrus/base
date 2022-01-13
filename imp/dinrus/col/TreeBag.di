module col.TreeBag;

private import  col.model.IteratorX,
        col.model.Comparator,
        col.model.SortedValues,
        col.model.GuardIterator;

private import  col.impl.RBCell,
        col.impl.BagCollection,
        col.impl.AbstractIterator;

/**
 * КрасноЧёрное trees.
 * author: Doug Lea
**/

deprecated public class РюкзакДерево(T) : КоллекцияРюкзак!(T), СортированныеЗначения!(T)
{
    alias КЧЯчейка!(T)        КЧЯчейкаТ;
    alias Сравнитель!(T)    КомпараторТ;

    alias КоллекцияРюкзак!(T).удали     удали;
    alias КоллекцияРюкзак!(T).удалиВсе  удалиВсе;


    // экземпляр variables

    /**
     * The корень of the дерево. Пусто if пустой.
    **/

    package КЧЯчейкаТ дерево;

    /**
     * The сравнитель в_ use for ordering.
    **/
    protected КомпараторТ кмп_;

    // constructors

    /**
     * Make an пустой дерево.
     * Initialize в_ use DefaultComparator for ordering
    **/
    public this ()
    {
        this(пусто, пусто, пусто, 0);
    }

    /**
     * Make an пустой дерево, using the supplied элемент скринер.
     * Initialize в_ use DefaultComparator for ordering
    **/

    public this (Предикат s)
    {
        this(s, пусто, пусто, 0);
    }

    /**
     * Make an пустой дерево, using the supplied элемент сравнитель for ordering.
    **/
    public this (КомпараторТ c)
    {
        this(пусто, c, пусто, 0);
    }

    /**
     * Make an пустой дерево, using the supplied элемент скринер и сравнитель
    **/
    public this (Предикат s, КомпараторТ c)
    {
        this(s, c, пусто, 0);
    }

    /**
     * Special version of constructor needed by клонируй()
    **/

    protected this (Предикат s, КомпараторТ cmp, КЧЯчейкаТ t, цел n)
    {
        super(s);
        счёт = n;
        дерево = t;
        if (cmp !is пусто)
            кмп_ = cmp;
        else
            кмп_ = &сравни;
    }

    /**
     * The default сравнитель
     *
     * @param перв первый аргумент
     * @param втор секунда аргумент
     * Возвращает: a негатив число if перв is less than втор; a
     * positive число if перв is greater than втор; else 0
    **/

    private final цел сравни(T перв, T втор)
    {
        if (перв is втор)
            return 0;

        return typeid(T).сравни (&перв, &втор);
    }


    /**
     * Make an independent копируй of the дерево. Does not клонируй элементы.
    **/

    public РюкзакДерево!(T) дубликат()
    {
        if (счёт is 0)
            return new РюкзакДерево!(T)(скринер, кмп_);
        else
            return new РюкзакДерево!(T)(скринер, кмп_, дерево.копируйДерево(), счёт);
    }



    // Коллекция methods

    /**
     * Implements col.impl.Collection.Коллекция.содержит
     * Временная ёмкость: O(лог n).
     * See_Also: col.impl.Collection.Коллекция.содержит
    **/
    public final бул содержит(T элемент)
    {
        if (!действительныйАргумент(элемент) || счёт is 0)
            return нет;

        return дерево.найди(элемент, кмп_) !is пусто;
    }

    /**
     * Implements col.impl.Collection.Коллекция.экземпляры
     * Временная ёмкость: O(лог n).
     * See_Also: col.impl.Collection.Коллекция.экземпляры
    **/
    public final бцел экземпляры(T элемент)
    {
        if (!действительныйАргумент(элемент) || счёт is 0)
            return 0;

        return дерево.счёт(элемент, кмп_);
    }

    /**
     * Implements col.impl.Collection.Коллекция.элементы
     * Временная ёмкость: O(1).
     * See_Also: col.impl.Collection.Коллекция.элементы
    **/
    public final СтражОбходчик!(T) элементы()
    {
        return new ОбходчикЯчейки!(T)(this);
    }

    /**
     * Implements col.model.View.Обзор.opApply
     * Временная ёмкость: O(n).
     * See_Also: col.model.View.Обзор.opApply
    **/
    цел opApply (цел delegate (inout T значение) дг)
    {
        auto scope обходчик = new ОбходчикЯчейки!(T)(this);
        return обходчик.opApply (дг);
    }


    // ElementSortedCollection methods


    /**
     * Implements col.ElementSortedCollection.сравнитель
     * Временная ёмкость: O(1).
     * See_Also: col.ElementSortedCollection.сравнитель
    **/
    public final КомпараторТ сравнитель()
    {
        return кмп_;
    }

    /**
     * Reset the сравнитель. Will cause a reorganization of the дерево.
     * Временная ёмкость: O(n лог n).
    **/
    public final проц сравнитель(КомпараторТ cmp)
    {
        if (cmp !is кмп_)
        {
            if (cmp !is пусто)
                кмп_ = cmp;
            else
                кмп_ = &сравни;

            if (счёт !is 0)
            {
                // must rebuild дерево!
                инкрВерсию();
                КЧЯчейкаТ t = дерево.левейший();
                дерево = пусто;
                счёт = 0;
                while (t !is пусто)
                {
                    добавь_(t.элемент(), нет);
                    t = t.потомок();
                }
            }
        }
    }


    // MutableCollection methods

    /**
     * Implements col.impl.Collection.Коллекция.очисть.
     * Временная ёмкость: O(1).
     * See_Also: col.impl.Collection.Коллекция.очисть
    **/
    public final проц очисть()
    {
        устСчёт(0);
        дерево = пусто;
    }

    /**
     * Implements col.impl.Collection.Коллекция.удалиВсе.
     * Временная ёмкость: O(лог n * экземпляры(элемент)).
     * See_Also: col.impl.Collection.Коллекция.удалиВсе
    **/
    public final проц удалиВсе(T элемент)
    {
        удали_(элемент, да);
    }


    /**
     * Implements col.impl.Collection.Коллекция.removeOneOf.
     * Временная ёмкость: O(лог n).
     * See_Also: col.impl.Collection.Коллекция.removeOneOf
    **/
    public final проц удали(T элемент)
    {
        удали_(элемент, нет);
    }

    /**
     * Implements col.impl.Collection.Коллекция.replaceOneOf
     * Временная ёмкость: O(лог n).
     * See_Also: col.impl.Collection.Коллекция.replaceOneOf
    **/
    public final проц замени(T старЭлемент, T новЭлемент)
    {
        замени_(старЭлемент, новЭлемент, нет);
    }

    /**
     * Implements col.impl.Collection.Коллекция.replaceAllOf.
     * Временная ёмкость: O(лог n * экземпляры(старЭлемент)).
     * See_Also: col.impl.Collection.Коллекция.replaceAllOf
    **/
    public final проц замениВсе(T старЭлемент, T новЭлемент)
    {
        замени_(старЭлемент, новЭлемент, да);
    }

    /**
     * Implements col.impl.Collection.Коллекция.возьми.
     * Временная ёмкость: O(лог n).
     * Takes the least элемент.
     * See_Also: col.impl.Collection.Коллекция.возьми
    **/
    public final T возьми()
    {
        if (счёт !is 0)
        {
            КЧЯчейкаТ p = дерево.левейший();
            T знач = p.элемент();
            дерево = p.удали(дерево);
            декрСчёт();
            return знач;
        }

        проверьИндекс(0);
        return T.init; // not reached
    }


    // MutableBag methods

    /**
     * Implements col.MutableBag.добавьIfAbsent
     * Временная ёмкость: O(лог n).
     * See_Also: col.MutableBag.добавьIfAbsent
    **/
    public final проц добавьЕсли (T элемент)
    {
        добавь_(элемент, да);
    }


    /**
     * Implements col.MutableBag.добавь.
     * Временная ёмкость: O(лог n).
     * See_Also: col.MutableBag.добавь
    **/
    public final проц добавь (T элемент)
    {
        добавь_(элемент, нет);
    }


    // helper methods

    private final проц добавь_(T элемент, бул проверьOccurrence)
    {
        проверьЭлемент(элемент);

        if (дерево is пусто)
        {
            дерево = new КЧЯчейкаТ(элемент);
            incCount();
        }
        else
        {
            КЧЯчейкаТ t = дерево;

            for (;;)
            {
                цел рознь = кмп_(элемент, t.элемент());
                if (рознь is 0 && проверьOccurrence)
                    return ;
                else if (рознь <= 0)
                {
                    if (t.лево() !is пусто)
                        t = t.лево();
                    else
                    {
                        дерево = t.вставьЛевый(new КЧЯчейкаТ(элемент), дерево);
                        incCount();
                        return ;
                    }
                }
                else
                {
                    if (t.право() !is пусто)
                        t = t.право();
                    else
                    {
                        дерево = t.вставьПравый(new КЧЯчейкаТ(элемент), дерево);
                        incCount();
                        return ;
                    }
                }
            }
        }
    }


    private final проц удали_(T элемент, бул всеСлучаи)
    {
        if (!действительныйАргумент(элемент))
            return ;

        while (счёт > 0)
        {
            КЧЯчейкаТ p = дерево.найди(элемент, кмп_);

            if (p !is пусто)
            {
                дерево = p.удали(дерево);
                декрСчёт();
                if (!всеСлучаи)
                    return ;
            }
            else
                break;
        }
    }

    private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
    {
        if (!действительныйАргумент(старЭлемент) || счёт is 0 || старЭлемент == новЭлемент)
            return ;

        while (содержит(старЭлемент))
        {
            удали(старЭлемент);
            добавь (новЭлемент);
            if (!всеСлучаи)
                return ;
        }
    }

    // ImplementationCheckable methods

    /**
     * Implements col.model.View.Обзор.проверьРеализацию.
     * See_Also: col.model.View.Обзор.проверьРеализацию
    **/
    public override проц проверьРеализацию()
    {

        super.проверьРеализацию();
        assert(кмп_ !is пусто);
        assert(((счёт is 0) is (дерево is пусто)));
        assert((дерево is пусто || дерево.размер() is счёт));

        if (дерево !is пусто)
        {
            дерево.проверьРеализацию();
            T последний = T.init;
            КЧЯчейкаТ t = дерево.левейший();
            while (t !is пусто)
            {
                T знач = t.элемент();
                if (последний !is T.init)
                    assert(кмп_(последний, знач) <= 0);
                последний = знач;
                t = t.потомок();
            }
        }
    }


    /***********************************************************************

            opApply() имеется migrated here в_ mitigate the virtual вызов
            on метод получи()

    ************************************************************************/

    private static class ОбходчикЯчейки(T) : АбстрактныйОбходчик!(T)
    {
        private КЧЯчейкаТ ячейка;

        public this (РюкзакДерево bag)
        {
            super(bag);

            if (bag.дерево)
                ячейка = bag.дерево.левейший;
        }

        public final T получи()
        {
            декрементируйОстаток();
            auto знач = ячейка.элемент();
            ячейка = ячейка.потомок();
            return знач;
        }

        цел opApply (цел delegate (inout T значение) дг)
        {
            цел результат;

            for (auto i=остаток(); i--;)
            {
                auto значение = получи();
                if ((результат = дг(значение)) != 0)
                    break;
            }
            return результат;
        }
    }
}



debug (Test)
{
    import io.Console;

    проц main()
    {
        auto bag = new РюкзакДерево!(ткст);
        bag.добавь ("zebra");
        bag.добавь ("bar");
        bag.добавь ("barrel");
        bag.добавь ("foo");
        bag.добавь ("apple");

        foreach (значение; bag.элементы) {}

        auto элементы = bag.элементы();
        while (элементы.ещё)
            auto знач = элементы.получи();

        foreach (значение; bag.элементы)
        Квывод (значение).нс;

        bag.проверьРеализацию();
    }
}
