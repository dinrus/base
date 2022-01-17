module col.ArrayBag;

private import  exception;
private import  col.model.GuardIterator;
private import  col.impl.CLCell,
        col.impl.BagCollection,
        col.impl.AbstractIterator;

/**
 *
 * Реализация Рюкзаков, буферная, линкованная. Рюкзак состоит из
 * любого числа буферов, хранящих элементы, организованных в список.
 * Каждый буфер содержит массив элементов. Размер каждого
 * буфера равен значению размЧанка, который был текущим при операции,
 * заставившей Рюкзак увеличиться в размере. размЧанка() можно
 * настроить в любое время. (Это не считается изменением версии.)
 *
 * <P>
 * Все, кроме последнего буфера, всегда остаются полными.
 * Когда в каком-то буфере нет элементов, он освобождается (
 * становится доступен для сборки мусора).
 * <P>
 * РюкзакМассивы - хороший выбор для коллекций, в которых
 * нужно поместить много вещей, и затем искать их по перечислениям,
 * но не столь часто искать отдельные элементы.
**/

deprecated public class РюкзакМассив(T) : КоллекцияРюкзак!(T)
{
    alias ЯчейкаЦС!(T[]) ЯчейкаЦСТ;

    alias КоллекцияРюкзак!(T).удали     удали;
    alias КоллекцияРюкзак!(T).удалиВсе  удалиВсе;

    /**
     * Дефолтный размер чанка, используемый для буферов.
    **/

    public static цел дефРазмЧанка = 32;

    // переменные экземпляра

    /**
     * Последний узел циркуляроного списка чанков. Пусто, если он пустой.
    **/

    package ЯчейкаЦСТ хвост;

    /**
     * The число of элементы of the хвост узел actually использован. (все другие
     * are kept full).
    **/
    protected цел последнСчёт;

    /**
     * The размер чанка в_ use for making следщ буфер
    **/

    protected цел размерЧанка_;

    // constructors

    /**
     * Создаётn пустой буфер.
    **/
    public this ()
    {
        this (пусто, 0, пусто, 0, дефРазмЧанка);
    }

    /**
     * Создаёт пустой буфер, using the supplied элемент скринер.
    **/

    public this (Предикат s)
    {
        this (s, 0, пусто, 0, дефРазмЧанка);
    }

    /**
     * Special version of constructor needed by клонируй()
    **/
    protected this (Предикат s, цел n, ЯчейкаЦСТ t, цел lc, цел cs)
    {
        super (s);
        счёт = n;
        хвост = t;
        последнСчёт = lc;
        размерЧанка_ = cs;
    }

    /**
     * Создаёт independent копируй. Does not клонируй элементы.
    **/

    public final РюкзакМассив!(T) дубликат ()
    {
        if (счёт is 0)
            return new РюкзакМассив!(T) (скринер);
        else
        {
            ЯчейкаЦСТ h = хвост.копируйСписок();
            ЯчейкаЦСТ p = h;

            do
            {
                T[] obuff = p.элемент();
                T[] nbuff = new T[obuff.length];

                for (цел i = 0; i < obuff.length; ++i)
                    nbuff[i] = obuff[i];

                p.элемент(nbuff);
                p = p.следщ();
            }
            while (p !is h);

            return new РюкзакМассив!(T) (скринер, счёт, h, последнСчёт, размерЧанка_);
        }
    }


    /**
     * Report the размер чанка использован when добавим new buffers в_ the список
    **/

    public final цел размЧанка()
    {
        return размерЧанка_;
    }

    /**
     * Набор the размер чанка в_ be использован when добавим new buffers в_ the
     * список during future добавь() operations.
     * Any значение greater than 0 is ОК. (A значение of 1 makes this a
     * преобр_в very медленно simulation of a linked список!)
    **/

    public final проц размЧанка (цел newЧанкРазмер)
    {
        if (newЧанкРазмер > 0)
            размерЧанка_ = newЧанкРазмер;
        else
            throw new ИсклНелегальногоАргумента("Попытка установки отрицательного размера чанка");
    }

    // Методы коллекции

    /*
      This код is pretty repetitive, but I don't know a nice way в_
      separate traversal logic из_ actions
    */

    /**
     * Реализует col.impl.Collection.Коллекция.содержит
     * Временная ёмкость: O(n).
     * См_Также: col.impl.Collection.Коллекция.содержит
    **/
    public final бул содержит(T элемент)
    {
        if (!действительныйАргумент(элемент) || счёт is 0)
            return нет;

        ЯчейкаЦСТ p = хвост.следщ();

        for (;;)
        {
            T[] buff = p.элемент();
            бул isLast = p is хвост;

            цел n;
            if (isLast)
                n = последнСчёт;
            else
                n = buff.length;

            for (цел i = 0; i < n; ++i)
            {
                if (buff[i] == (элемент))
                    return да;
            }

            if (isLast)
                break;
            else
                p = p.следщ();
        }
        return нет;
    }

    /**
     * Реализует col.impl.Collection.Коллекция.экземпляры
     * Временная ёмкость: O(n).
     * См_Также: col.impl.Collection.экземпляры
    **/
    public final бцел экземпляры(T элемент)
    {
        if (!действительныйАргумент(элемент) || счёт is 0)
            return 0;

        бцел c = 0;
        ЯчейкаЦСТ p = хвост.следщ();

        for (;;)
        {
            T[] buff = p.элемент();
            бул isLast = p is хвост;

            цел n;
            if (isLast)
                n = последнСчёт;
            else
                n = buff.length;

            for (цел i = 0; i < n; ++i)
            {
                if (buff[i] == (элемент))
                    ++c;
            }

            if (isLast)
                break;
            else
                p = p.следщ();
        }
        return c;
    }

    /**
     * Реализует col.impl.Collection.Коллекция.элементы
     * Временная ёмкость: O(1).
     * См_Также: col.impl.Collection.Коллекция.элементы
    **/
    public final СтражОбходчик!(T) элементы()
    {
        return new ОбходчикМассива!(T)(this);
    }

    /**
     * Реализует col.model.View.Обзор.opApply
     * Временная ёмкость: O(n).
     * См_Также: col.model.View.Обзор.opApply
    **/
    цел opApply (цел delegate (inout T значение) дг)
    {
        auto scope обходчик = new ОбходчикМассива!(T)(this);
        return обходчик.opApply (дг);
    }

    // MutableCollection methods

    /**
     * Реализует col.impl.Collection.Коллекция.очисть.
     * Временная ёмкость: O(1).
     * См_Также: col.impl.Collection.Коллекция.очисть
    **/
    public final проц очисть()
    {
        устСчёт(0);
        хвост = пусто;
        последнСчёт = 0;
    }

    /**
     * Реализует col.impl.Collection.Коллекция.удалиВсе.
     * Временная ёмкость: O(n).
     * См_Также: col.impl.Collection.Коллекция.удалиВсе
    **/
    public final проц удалиВсе (T элемент)
    {
        удали_(элемент, да);
    }


    /**
     * Реализует col.impl.Collection.Коллекция.removeOneOf.
     * Временная ёмкость: O(n).
     * См_Также: col.impl.Collection.Коллекция.removeOneOf
    **/
    public final проц удали(T элемент)
    {
        удали_(элемент, нет);
    }

    /**
     * Реализует col.impl.Collection.Коллекция.replaceOneOf
     * Временная ёмкость: O(n).
     * См_Также: col.impl.Collection.Коллекция.replaceOneOf
    **/
    public final проц замени(T старЭлемент, T новЭлемент)
    {
        замени_(старЭлемент, новЭлемент, нет);
    }

    /**
     * Реализует col.impl.Collection.Коллекция.replaceAllOf.
     * Временная ёмкость: O(n).
     * См_Также: col.impl.Collection.Коллекция.replaceAllOf
    **/
    public final проц замениВсе(T старЭлемент, T новЭлемент)
    {
        замени_(старЭлемент, новЭлемент, да);
    }

    /**
     * Реализует col.impl.Collection.Коллекция.возьми.
     * Временная ёмкость: O(1).
     * Takes the least элемент.
     * См_Также: col.impl.Collection.Коллекция.возьми
    **/
    public final T возьми()
    {
        if (счёт !is 0)
        {
            T[] buff = хвост.элемент();
            T знач = buff[последнСчёт -1];
            buff[последнСчёт -1] = T.init;
            сожми_();
            return знач;
        }
        проверьИндекс(0);
        return T.init; // not reached
    }



    // MutableBag methods

    /**
     * Реализует col.MutableBag.добавьIfAbsent.
     * Временная ёмкость: O(n).
     * См_Также: col.MutableBag.добавьIfAbsent
    **/
    public final проц добавьЕсли(T элемент)
    {
        if (!содержит(элемент))
            добавь (элемент);
    }


    /**
     * Реализует col.MutableBag.добавь.
     * Временная ёмкость: O(1).
     * См_Также: col.MutableBag.добавь
    **/
    public final проц добавь (T элемент)
    {
        проверьЭлемент(элемент);

        incCount();
        if (хвост is пусто)
        {
            хвост = new ЯчейкаЦСТ(new T[размерЧанка_]);
            последнСчёт = 0;
        }

        T[] buff = хвост.элемент();
        if (последнСчёт is buff.length)
        {
            buff = new T[размерЧанка_];
            хвост.добавьСледщ(buff);
            хвост = хвост.следщ();
            последнСчёт = 0;
        }

        buff[последнСчёт++] = элемент;
    }

    /**
     * Ассистент-метод для удали/exclude
    **/

    private final проц удали_(T элемент, бул всеСлучаи)
    {
        if (!действительныйАргумент(элемент) || счёт is 0)
            return ;

        ЯчейкаЦСТ p = хвост;

        for (;;)
        {
            T[] buff = p.элемент();
            цел i = (p is хвост) ? последнСчёт - 1 : buff.length - 1;

            while (i >= 0)
            {
                if (buff[i] == (элемент))
                {
                    T[] lastBuff = хвост.элемент();
                    buff[i] = lastBuff[последнСчёт -1];
                    lastBuff[последнСчёт -1] = T.init;
                    сожми_();

                    if (!всеСлучаи || счёт is 0)
                        return ;

                    if (p is хвост && i >= последнСчёт)
                        i = последнСчёт -1;
                }
                else
                    --i;
            }

            if (p is хвост.следщ())
                break;
            else
                p = p.предш();
        }
    }

    private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
    {
        if (!действительныйАргумент(старЭлемент) || счёт is 0 || старЭлемент == (новЭлемент))
            return ;

        ЯчейкаЦСТ p = хвост.следщ();

        for (;;)
        {
            T[] buff = p.элемент();
            бул isLast = p is хвост;

            цел n;
            if (isLast)
                n = последнСчёт;
            else
                n = buff.length;

            for (цел i = 0; i < n; ++i)
            {
                if (buff[i] == (старЭлемент))
                {
                    проверьЭлемент(новЭлемент);
                    инкрВерсию();
                    buff[i] = новЭлемент;
                    if (!всеСлучаи)
                        return ;
                }
            }

            if (isLast)
                break;
            else
                p = p.следщ();
        }
    }

    private final проц сьсожми_()
    {
        декрСчёт();
        последнСчёт--;
        if (последнСчёт is 0)
        {
            if (счёт is 0)
                очисть();
            else
            {
                ЯчейкаЦСТ врем = хвост;
                хвост = хвост.предш();
                врем.отвяжи();
                T[] buff = хвост.элемент();
                последнСчёт = buff.length;
            }
        }
    }

    // ImplementationCheckable methods

    /**
     * Реализует col.model.View.Обзор.проверьРеализацию.
     * См_Также: col.model.View.Обзор.проверьРеализацию
    **/
    public override проц проверьРеализацию()
    {

        super.проверьРеализацию();
        assert(размерЧанка_ >= 0);
        assert(последнСчёт >= 0);
        assert(((счёт is 0) is (хвост is пусто)));

        if (хвост is пусто)
            return ;

        цел c = 0;
        ЯчейкаЦСТ p = хвост.следщ();

        for (;;)
        {
            T[] buff = p.элемент();
            бул isLast = p is хвост;

            цел n;
            if (isLast)
                n = последнСчёт;
            else
                n = buff.length;

            c += n;
            for (цел i = 0; i < n; ++i)
            {
                auto знач = buff[i];
                assert(допускается(знач) && содержит(знач));
            }

            if (isLast)
                break;
            else
                p = p.следщ();
        }

        assert(c is счёт);

    }



    /***********************************************************************

            opApply() имеется migrated here в_ mitigate the virtual вызов
            on метод получи()

    ************************************************************************/

    static class ОбходчикМассива(T) : АбстрактныйОбходчик!(T)
    {
        private ЯчейкаЦСТ ячейка;
        private T[]     buff;
        private цел     индекс;

        public this (РюкзакМассив bag)
        {
            super(bag);
            ячейка = bag.хвост;

            if (ячейка)
                buff = ячейка.элемент();
        }

        public final T получи()
        {
            декрементируйОстаток();
            if (индекс >= buff.length)
            {
                ячейка = ячейка.следщ();
                buff = ячейка.элемент();
                индекс = 0;
            }
            return buff[индекс++];
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
        auto bag = new РюкзакМассив!(ткст);
        bag.добавь ("foo");
        bag.добавь ("bar");
        bag.добавь ("wumpus");

        foreach (значение; bag.элементы) {}

        auto элементы = bag.элементы();
        while (элементы.ещё)
            auto знач = элементы.получи();

        foreach (значение; bag)
        Квывод (значение).нс;

        bag.проверьРеализацию();

        Квывод (bag).нс;
    }
}
