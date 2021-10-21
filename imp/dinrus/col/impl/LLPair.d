module col.impl.LLPair;

private import col.impl.LLCell;
private import col.model.IteratorX;

/**
 *
 *
 * LLPairs are LLCells with ключи, и operations that deal with them.
 * As with LLCells, the are  implementation tools.
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class ПараСС(К, T) : ЯчейкаСС!(T)
{
    alias ЯчейкаСС!(T).найди найди;
    alias ЯчейкаСС!(T).счёт счёт;
    alias ЯчейкаСС!(T).элемент элемент;


    // экземпляр variables

    private К ключ_;

    /**
     * Make a ячейка with given ключ, elment, и следщ link
    **/

    public this (К ключ, T знач, ПараСС n)
    {
        super(знач, n);
        ключ_ = ключ;
    }

    /**
     * Make a пара with given ключ и элемент, и пусто следщ link
    **/

    public this (К ключ, T знач)
    {
        super(знач, пусто);
        ключ_ = ключ;
    }

    /**
     * Make a пара with пусто ключ, elment, и следщ link
    **/

    public this ()
    {
        super(T.init, пусто);
        ключ_ = К.init;
    }

    /**
     * return the ключ
    **/

    public final К ключ()
    {
        return ключ_;
    }

    /**
     * установи the ключ
    **/

    public final проц ключ(К ключ)
    {
        ключ_ = ключ;
    }


    /**
     * установи the ключ
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
     * Return the число of cells traversed в_ найди a ячейка with ключ() ключ,
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
     * Return the число of cells traversed в_ найди a ячейка with indicated пара
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
     * Return the число of cells with ключ() ключ.
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
     * Return the число of cells with indicated пара
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
