module col.impl.CLCell;

private import col.impl.Cell;

/**
 *
 *
 * CLCells are cells that are always arranged in circular списки
 * They are  implementation tools
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class ЯчейкаЦС(T) : Ячейка!(T)
{
    // экземпляр variables

    private ЯчейкаЦС следщ_;
    private ЯчейкаЦС предш_;

    // constructors

    /**
     * Make a ячейка with contents знач, previous ячейка p, следщ ячейка n
    **/

    public this (T знач, ЯчейкаЦС p, ЯчейкаЦС n)
    {
        super(знач);
        предш_ = p;
        следщ_ = n;
    }

    /**
     * Make a singular ячейка
    **/

    public this (T знач)
    {
        super(знач);
        предш_ = this;
        следщ_ = this;
    }

    /**
     * Make a singular ячейка with пусто contents
    **/

    public this ()
    {
        super(T.init);
        предш_ = this;
        следщ_ = this;
    }

    /**
     * return следщ ячейка
    **/

    public final ЯчейкаЦС следщ()
    {
        return следщ_;
    }

    /**
     * Набор следщ ячейка. You probably don't want в_ вызов this
    **/

    public final проц следщ(ЯчейкаЦС n)
    {
        следщ_ = n;
    }


    /**
     * return previous ячейка
    **/
    public final ЯчейкаЦС предш()
    {
        return предш_;
    }

    /**
     * Набор previous ячейка. You probably don't want в_ вызов this
    **/
    public final проц предш(ЯчейкаЦС n)
    {
        предш_ = n;
    }


    /**
     * Return да if текущ ячейка is the only one on the список
    **/

    public final бул синглтон_ли()
    {
        return следщ_ is this;
    }

    public final проц вяжиСледщ(ЯчейкаЦС p)
    {
        if (p !is пусто)
        {
            следщ_.предш_ = p;
            p.следщ_ = следщ_;
            p.предш_ = this;
            следщ_ = p;
        }
    }

    /**
     * Make a ячейка holding знач и link it immediately после текущ ячейка
    **/

    public final проц добавьСледщ(T знач)
    {
        ЯчейкаЦС p = new ЯчейкаЦС(знач, this, следщ_);
        следщ_.предш_ = p;
        следщ_ = p;
    }

    /**
     * сделай a узел holding знач, link it before the текущ ячейка, и return it
    **/

    public final ЯчейкаЦС добавьПредш(T знач)
    {
        ЯчейкаЦС p = предш_;
        ЯчейкаЦС c = new ЯчейкаЦС(знач, p, this);
        p.следщ_ = c;
        предш_ = c;
        return c;
    }

    /**
     * link p before текущ ячейка
    **/

    public final проц вяжиПредш(ЯчейкаЦС p)
    {
        if (p !is пусто)
        {
            предш_.следщ_ = p;
            p.предш_ = предш_;
            p.следщ_ = this;
            предш_ = p;
        }
    }

    /**
     * return the число of cells in the список
    **/

    public final цел длина()
    {
        цел c = 0;
        ЯчейкаЦС p = this;
        do
        {
            ++c;
            p = p.следщ();
        }
        while (p !is this);
        return c;
    }

    /**
     * return the первый ячейка holding элемент найдено in a circular traversal starting
     * at текущ ячейка, or пусто if no such
    **/

    public final ЯчейкаЦС найди(T элемент)
    {
        ЯчейкаЦС p = this;
        do
        {
            if (p.элемент() == (элемент))
                return p;
            p = p.следщ();
        }
        while (p !is this);
        return пусто;
    }

    /**
     * return the число of cells holding элемент найдено in a circular
     * traversal
    **/

    public final цел счёт(T элемент)
    {
        цел c = 0;
        ЯчейкаЦС p = this;
        do
        {
            if (p.элемент() == (элемент))
                ++c;
            p = p.следщ();
        }
        while (p !is this);
        return c;
    }

    /**
     * return the н_ый ячейка traversed из_ here. It may wrap around.
    **/

    public final ЯчейкаЦС н_ый(цел n)
    {
        ЯчейкаЦС p = this;
        for (цел i = 0; i < n; ++i)
            p = p.следщ_;
        return p;
    }


    /**
     * Unlink the следщ ячейка.
     * This имеется no effect on the список if синглтон_ли()
    **/

    public final проц отвяжиСледщ()
    {
        ЯчейкаЦС nn = следщ_.следщ_;
        nn.предш_ = this;
        следщ_ = nn;
    }

    /**
     * Unlink the previous ячейка.
     * This имеется no effect on the список if синглтон_ли()
    **/

    public final проц отвяжиПредш()
    {
        ЯчейкаЦС pp = предш_.предш_;
        pp.следщ_ = this;
        предш_ = pp;
    }


    /**
     * Unlink сам из_ список it is in.
     * Causes it в_ be a синглтон
    **/

    public final проц отвяжи()
    {
        ЯчейкаЦС p = предш_;
        ЯчейкаЦС n = следщ_;
        p.следщ_ = n;
        n.предш_ = p;
        предш_ = this;
        следщ_ = this;
    }

    /**
     * Make a копируй of the список и return new голова.
    **/

    public final ЯчейкаЦС копируйСписок()
    {
        ЯчейкаЦС hd = this;

        ЯчейкаЦС новый_список = new ЯчейкаЦС(hd.элемент(), пусто, пусто);
        ЯчейкаЦС текущ = новый_список;

        for (ЯчейкаЦС p = следщ_; p !is hd; p = p.следщ_)
        {
            текущ.следщ_ = new ЯчейкаЦС(p.элемент(), текущ, пусто);
            текущ = текущ.следщ_;
        }
        новый_список.предш_ = текущ;
        текущ.следщ_ = новый_список;
        return новый_список;
    }
}

