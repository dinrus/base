﻿module col.impl.Collection;

private import  exception;
private import  col.model.View,
        col.model.IteratorX,
        col.model.Dispenser;

/*******************************************************************************

        Коллекция служит удобным классом-основой для реализаций
        изменяемых контейнеров. Он поддерживает номер версии и счёт элементов.
        Также предоставляет дефолтные реализации многих операций с коллекциями.

********************************************************************************/

public abstract class Коллекция(T) : Расходчик!(T)
{
    alias Обзор!(T)          ОбзорТ;

    alias бул delegate(T)  Предикат;


    // переменные экземпляра

    /***********************************************************************

            Представляет собой текущий номер версии.

    ************************************************************************/

    protected бцел версия;

    /***********************************************************************

           Переменная скринер содержит предоставляенный элемент скринер.

    ************************************************************************/

    protected Предикат скринер;

    /***********************************************************************

          Переменная  счёт содержит число элементов.

    ************************************************************************/

    protected бцел счёт;

    // constructors

    /***********************************************************************

            Инициализует при версии 0 пустой счёт и предоставленный скринер.

    ************************************************************************/

    protected this (Предикат скринер = пусто)
    {
        this.скринер = скринер;
    }


    /***********************************************************************

    ************************************************************************/

    protected final static бул действительныйАргумент (T элемент)
    {
        static if (is (T : Объект))
        {
            if (элемент is пусто)
                return нет;
        }
        return да;
    }

    // Дефолтные реализации методов класса Коллекция

    /***********************************************************************

            Представить контент коллекции как Массив.

    ************************************************************************/

    public T[] вМассив ()
    {
        auto результат = new T[this.размер];

        цел i = 0;
        foreach (e; this)
        результат[i++] = e;

        return результат;
    }

    /***********************************************************************

            Временная ёмкость: O(1).
            См_Также: col.impl.Collection.Коллекция.дренирован_ли

    ************************************************************************/

    public final бул дренирован_ли()
    {
        return счёт is 0;
    }

    /***********************************************************************

            Временная ёмкость: O(1).
            Возвращает: счёт элементов, находящихся в данный момент в коллекции.
            См_Также: col.impl.Collection.Коллекция.размер

    ************************************************************************/

    public final бцел размер()
    {
        return счёт;
    }

    /***********************************************************************

            Проверяет, допустим ли элемент для этой коллекции.
            Он не выводит исключение, но любая другая попытка добавить
            непригодный элемент будет выводить его.

            Временная ёмкость: O(1) + время скринера, если таковой имеется.

            См_Также: col.impl.Collection.Коллекция.допускается

    ************************************************************************/

    public final бул допускается (T элемент)
    {
        return действительныйАргумент(элемент) &&
               (скринер is пусто || скринер(элемент));
    }


    /***********************************************************************

            Временная ёмкость: O(n).
            Дефолтная реализация. Fairly sleazy approach.
            (Defensible only when you remember that it is just a default impl.)
            Пытается преобразовать в один из известных типов интерфейса коллекции
            и затем применить соответствующие правила сравнения.
            Этого достаточно для всех, на данный момент, поддерживаемых типов коллекций,
            но должно быть переписано, если определяются новые подинтерфейсы Коллекция
            и/или её реализации.

            См_Также: col.impl.Collection.Коллекция.совпадает

    ************************************************************************/

    public бул совпадает(ОбзорТ другой)
    {
        /+
        if (другой is пусто)
            return нет;
        else if (другой is this)
            return да;
        else if (cast(СортированныеКлючи) this)
        {
            if (!(cast(Карта) другой))
                return нет;
            else
                return одинаковыеУпорядоченныеПары(cast(Карта)this, cast(Карта)другой);
        }
        else if (cast(Карта) this)
        {
            if (!(cast(Карта) другой))
                return нет;
            else
                return одинаковыеПары(cast(Карта)(this), cast(Карта)(другой));
        }
        else if ((cast(Сек) this) || (cast(СортированныеЗначения) this))
            return одинаковыеУпорядоченныеЭлементы(this, другой);
        else if (cast(Рюкзак) this)
            return одинаковыеСлучаи(this, другой);
        else if (cast(Набор) this)
            return одинаковыеВключения(this, cast(Обзор)(другой));
        else
            return нет;
        +/
        return нет;
    }

    // Дефолтные реализации методов MutableCollection

    /***********************************************************************

            Временная ёмкость: O(1).
            См_Также: col.impl.Collection.Коллекция.версия

    ************************************************************************/

    public final бцел изменение()
    {
        return версия;
    }

    // Методы Объекта.

    /***********************************************************************

            Дефолтная реализация вТкст для коллекций. Не слишком опрятная,
            но взятие в кавычки каждого элемента означает, что
            для большинства видов элементов, it's conceivable that the
            strings could be разобрано и использован в_ build другой col.

            Not a very pretty implementation either. Casts are использован
            в_ получи at элементы/ключи

    ************************************************************************/

    public override ткст вТкст()
    {
        сим[16] врем;

        return "<" ~ this.classinfo.имя ~ ", размер:" ~ itoa(врем, размер()) ~ ">";
    }


    /***********************************************************************

    ************************************************************************/

    protected final ткст itoa(ткст буф, бцел i)
    {
        auto j = буф.length;

        do
        {
            буф[--j] = cast(сим) (i % 10 + '0');
        }
        while (i /= 10);
        return буф [j..$];
    }

    // Защищённые операции над версией и счётом

    /***********************************************************************

            Изменяет номер версии.

    ************************************************************************/

    protected final проц инкрВерсию()
    {
        ++версия;
    }


    /***********************************************************************

            Увеличивает на единицу счёт элемента и обновляет версию.

    ************************************************************************/

    protected final проц инкрСчёт()
    {
        счёт++;
        инкрВерсию();
    }

    /***********************************************************************

           Уменьшает на единицу счёт элемента и обновляет версию.

    ************************************************************************/

    protected final проц декрСчёт()
    {
        счёт--;
        инкрВерсию();
    }


    /***********************************************************************

            добавь в_ the элемент счёт и обнови version if изменён

    ************************************************************************/

    protected final проц добавьВСчёт(бцел c)
    {
        if (c !is 0)
        {
            счёт += c;
            инкрВерсию();
        }
    }


    /***********************************************************************

            Устанавливает элемент счёт и обнови version if изменён

    ************************************************************************/

    protected final проц устСчёт(бцел c)
    {
        if (c !is счёт)
        {
            счёт = c;
            инкрВерсию();
        }
    }


    /***********************************************************************

            Вспомогательный метод, оставленный публичным, так как может пригодиться.

    ************************************************************************/

    public final static бул одинаковыеВключения(ОбзорТ s, ОбзорТ t)
    {
        if (s.размер !is t.размер)
            return нет;

        try   // установи up в_ return нет on collection exceptions
        {
            auto ts = t.элементы();
            while (ts.ещё)
            {
                if (!s.содержит(ts.получи))
                    return нет;
            }
            return да;
        }
        catch (НетЭлементаИскл ex)
        {
            return нет;
        }
    }

    /***********************************************************************

            Вспомогательный метод, оставленный публичным, так как может пригодиться.

    ************************************************************************/

    public final static бул одинаковыеСлучаи(ОбзорТ s, ОбзорТ t)
    {
        if (s.размер !is t.размер)
            return нет;

        auto ts = t.элементы();
        T последний = T.init; // minor optimization -- пропусти two successive if same

        try   // настроено на возврат нет при исключениях коллекции
        {
            while (ts.ещё)
            {
                T m = ts.получи;
                if (m !is последний)
                {
                    if (s.экземпляры(m) !is t.экземпляры(m))
                        return нет;
                }
                последний = m;
            }
            return да;
        }
        catch (НетЭлементаИскл ex)
        {
            return нет;
        }
    }


    /***********************************************************************

            Вспомогательный метод, оставленный публичным, так как может пригодиться.

    ************************************************************************/

    public final static бул одинаковыеУпорядоченныеЭлементы(ОбзорТ s, ОбзорТ t)
    {
        if (s.размер !is t.размер)
            return нет;

        auto ts = t.элементы();
        auto ss = s.элементы();

        try   // настроено на возврат нет при исключениях коллекци
        {
            while (ts.ещё)
            {
                T m = ts.получи;
                T o = ss.получи;
                if (m != o)
                    return нет;
            }
            return да;
        }
        catch (НетЭлементаИскл ex)
        {
            return нет;
        }
    }

    // misc common Вспомогательные методы

    /***********************************************************************

            PrincИПal метод в_ throw a НетЭлементаИскл.
            Besопрes индекс проверьs in Seqs, you can use it в_ проверь for
            operations on пустой собериions via проверьИндекс(0)

    ************************************************************************/

    protected final проц проверьИндекс(цел индекс)
    {
        if (индекс < 0 || индекс >= счёт)
        {
            ткст сооб;

            if (счёт is 0)
                сооб = "Доступ к элементу в пустой коллекции";
            else
            {
                сим[16] индкс, cnt;
                сооб = "Индекс " ~ itoa (индкс, индекс) ~ " вне диапазона размера коллекции " ~ itoa (cnt, счёт);
            }
            throw new НетЭлементаИскл(сооб);
        }
    }


    /***********************************************************************

            PrincИПal метод в_ throw a НевернЭлемИскл

    ************************************************************************/

    protected final проц проверьЭлемент(T элемент)
    {
        if (! допускается(элемент))
        {
            throw new НевернЭлемИскл("Попытка включить непригодный элемент в Коллекцию");
        }
    }

    /***********************************************************************

            См_Также: col.model.View.Обзор.проверьРеализацию

    ************************************************************************/

    public проц проверьРеализацию()
    {
        assert(счёт >= 0);
    }
    //public override проц проверьРеализацию() //Doesn't компилируй with the override атрибут

    /***********************************************************************

            Cause the collection в_ become пустой.

    ************************************************************************/

    abstract проц очисть();

    /***********************************************************************

            Exclude все occurrences of the indicated элемент из_ the collection.
            No effect if элемент not present.
            Параметры:
                элемент = the элемент в_ exclude.
            ---
            !имеется(элемент) &&
            размер() == PREV(this).размер() - PREV(this).экземпляры(элемент) &&
            no другой элемент changes &&
            Версия change iff PREV(this).имеется(элемент)
            ---

    ************************************************************************/

    abstract проц удалиВсе(T элемент);

    /***********************************************************************

            Удали an экземпляр of the indicated элемент из_ the collection.
            No effect if !имеется(элемент)
            Параметры:
                элемент = the элемент в_ удали
            ---
            let occ = max(1, экземпляры(элемент)) in
             размер() == PREV(this).размер() - occ &&
             экземпляры(элемент) == PREV(this).экземпляры(элемент) - occ &&
             no другой элемент changes &&
             version change iff occ == 1
            ---

    ************************************************************************/

    abstract проц удали (T элемент);

    /***********************************************************************

            Замени an occurrence of старЭлемент with новЭлемент.
            No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
            The operation имеется a consistent, but slightly special interpretation
            when applied в_ Sets. For Sets, because элементы occur at
            most once, if новЭлемент is already included, replacing старЭлемент with
            with новЭлемент имеется the same effect as just removing старЭлемент.
            ---
            let цел дельта = старЭлемент.равно(новЭлемент)? 0 :
                          max(1, PREV(this).экземпляры(старЭлемент) in
             экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - дельта &&
             экземпляры(новЭлемент) ==  (this instanceof Набор) ?
                    max(1, PREV(this).экземпляры(старЭлемент) + дельта):
                           PREV(this).экземпляры(старЭлемент) + дельта) &&
             no другой элемент changes &&
             Версия change iff дельта != 0
            ---
            Выводит исключение: НевернЭлемИскл if имеется(старЭлемент) и !допускается(новЭлемент)

    ************************************************************************/

    abstract проц замени (T старЭлемент, T новЭлемент);

    /***********************************************************************

            Замени все occurrences of старЭлемент with новЭлемент.
            No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
            The operation имеется a consistent, but slightly special interpretation
            when applied в_ Sets. For Sets, because элементы occur at
            most once, if новЭлемент is already included, replacing старЭлемент with
            with новЭлемент имеется the same effect as just removing старЭлемент.
            ---
            let цел дельта = старЭлемент.равно(новЭлемент)? 0 :
                       PREV(this).экземпляры(старЭлемент) in
             экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - дельта &&
             экземпляры(новЭлемент) ==  (this instanceof Набор) ?
                    max(1, PREV(this).экземпляры(старЭлемент) + дельта):
                           PREV(this).экземпляры(старЭлемент) + дельта) &&
             no другой элемент changes &&
             Версия change iff дельта != 0
            ---
            Выводит исключение: НевернЭлемИскл if имеется(старЭлемент) и !допускается(новЭлемент)

    ************************************************************************/

    abstract проц замениВсе(T старЭлемент, T новЭлемент);

    /***********************************************************************

            Exclude все occurrences of each элемент of the Обходчик.
            По поведению равнозначно
            ---
            while (e.ещё())
              удалиВсе(e.получи());
            ---
            Param :
                e = the enumeration of элементы в_ exclude.

            Выводит исключение: ИсклПовреждённыйОбходчик is propagated if thrown

            См_Также: col.impl.Collection.Коллекция.удалиВсе

    ************************************************************************/

    abstract проц удалиВсе (Обходчик!(T) e);

    /***********************************************************************

             Удали an occurrence of each элемент of the Обходчик.
             По поведению равнозначно

             ---
             while (e.ещё())
                удали (e.получи());
             ---

             Param:
                e = the enumeration of элементы в_ удали.

             Выводит исключение: ИсклПовреждённыйОбходчик is propagated if thrown

    ************************************************************************/

    abstract проц удали (Обходчик!(T) e);

    /***********************************************************************

            Удали и return an элемент.  Implementations
            may strengthen the guarantee about the nature of this элемент.
            but in general it is the most convenient or efficient элемент в_ удали.

            Примеры:
            One way в_ перемести все элементы из_
            MutableCollection a в_ MutableBag b is:
            ---
            while (!a.пустой())
                b.добавь(a.возьми());
            ---

            Возвращает:
                an элемент знач such that PREV(this).имеется(знач)
                и the postconditions of removeOneOf(знач) hold.

            Выводит исключение: НетЭлементаИскл iff дренирован_ли.

    ************************************************************************/

    abstract T возьми();
}


