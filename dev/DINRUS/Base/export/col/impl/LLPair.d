module col.impl.LLPair;

private import col.impl.LLCell;
private import col.model.IteratorX;

/**
 * LLPairs are LLCells with ключи, и operations that deal with them.
 * As with LLCells, the are  implementation tools.
**/

public class ПараСС(К, T) : ЯчейкаСС!(T)
{
    alias ЯчейкаСС!(T).найди найди;
    alias ЯчейкаСС!(T).счёт счёт;
    alias ЯчейкаСС!(T).элемент элемент;


    // переменные экземпляра

    private К ключ_;

    /**
     * Создаёт ячейка with given ключ, elment, и следщ link
    **/

    public this (К ключ, T знач, ПараСС n)
    {
        super(знач, n);
        ключ_ = ключ;
    }

    /**
     * Создаёт пара with given ключ и элемент, и пусто следщ link
    **/

    public this (К ключ, T знач)
    {
        super(знач, пусто);
        ключ_ = ключ;
    }

    /**
     * Создаёт пара with пусто ключ, elment, и следщ link
    **/

    public this ()
    {
        super(T.init, пусто);
        ключ_ = К.init;
    }

    /**
     * Возвращает ключ
    **/

    public final К ключ()
    {
        return ключ_;
    }

    /**
     * Устанавливает ключ
    **/

    public final проц ключ(К ключ)
    {
        ключ_ = ключ;
    }


    /**
     * Устанавливает ключ
    **/

    public final цел хэшКлюча()
    {
        return typeid(К).дайХэш(&ключ_);
    }


    /**
     * return a ячейка with ключ() ключ or пусто if no such
    **/

    public final ПараСС найдиКлюч(К ключ)
    {
        for (auto p=this; p; p = cast(ПараСС)cast(ук) p.следщ_)
            if (p.ключ() == ключ)
                return p;
        return пусто;
    }

    /**
     * return a ячейка holding the indicated пара or пусто if no such
    **/

    public final ПараСС найди(К ключ, T элемент)
    {
        for (auto p=this; p; p = cast(ПараСС)cast(ук) p.следщ_)
            if (p.ключ() == ключ && p.элемент() == элемент)
                return p;
        return пусто;
    }

    /**
     * Возвращает the число ячеек traversed в_ найди a ячейка with ключ() ключ,
     * or -1 if not present
    **/

    public final цел индексируйКлюч(К ключ)
    {
        цел i = 0;
        for (auto p=this; p; p = cast(ПараСС)cast(ук) p.следщ_)
        {
            if (p.ключ() == ключ)
                return i;
            else
                ++i;
        }
        return -1;
    }

    /**
     * Возвращает the число ячеек traversed в_ найди a ячейка with indicated пара
     * or -1 if not present
    **/
    public final цел индекс(К ключ, T элемент)
    {
        цел i = 0;
        for (auto p=this; p; p = cast(ПараСС)cast(ук) p.следщ_)
        {
            if (p.ключ() == ключ && p.элемент() == элемент)
                return i;
            else
                ++i;
        }
        return -1;
    }

    /**
     * Возвращает the число ячеек with ключ() ключ.
    **/
    public final цел учтиКлюч(К ключ)
    {
        цел c = 0;
        for (auto p=this; p; p = cast(ПараСС)cast(ук) p.следщ_)
            if (p.ключ() == ключ)
                ++c;
        return c;
    }

    /**
     * Возвращает the число ячеек with indicated пара
    **/
    public final цел счёт(К ключ, T элемент)
    {
        цел c = 0;
        for (auto p=this; p; p = cast(ПараСС)cast(ук) p.следщ_)
            if (p.ключ() == ключ && p.элемент() == элемент)
                ++c;
        return c;
    }

    protected final ПараСС дубликат()
    {
        return new ПараСС(ключ(), элемент(), cast(ПараСС)cast(ук)(следщ()));
    }
}
