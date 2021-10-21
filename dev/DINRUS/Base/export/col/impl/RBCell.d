module col.impl.RBCell;

private import  col.impl.Cell;
private import  col.model.IteratorX,
        col.model.Comparator;

/**
 * КЧЯчейка реализует basic capabilities of Red-Black trees,
 * an efficient kind of balanced binary дерево. The particular
 * algorithms использован are adaptations of those in Corman,
 * Lieserson, и Rivest's <EM>Introduction в_ Algorithms</EM>.
 * This class was inspired by (и код cross-проверьed with) a
 * similar class by Chuck McManis. The implementations of
 * rebalancings during insertion и deletion are
 * a little trickier than those versions since they
 * don't обменяй Ячейка contents or use special dummy nilузелs.
 * <P>
 * It is a  implementation class. For harnesses, see:
 * See_Also: RBTree
 * Authors: Doug Lea
**/

public class КЧЯчейка(T) : Ячейка!(T)
{
    static бул КРАСНЫЙ = нет;
    static бул ЧЁРНЫЙ = да;

    /**
     * The узел цвет (КРАСНЫЙ, ЧЁРНЫЙ)
    **/

    package бул цвет_;

    /**
     * Pointer в_ лево ветвь
    **/

    package КЧЯчейка лево_;

    /**
     * Pointer в_ право ветвь
    **/

    package КЧЯчейка право_;

    /**
     * Pointer в_ родитель (пусто if корень)
    **/

    private КЧЯчейка родитель_;

    /**
     * Make a new Ячейка with given элемент, пусто линки, и ЧЁРНЫЙ цвет.
     * Normally only called в_ establish a new корень.
    **/

    public this (T элемент)
    {
        super(элемент);
        лево_ = пусто;
        право_ = пусто;
        родитель_ = пусто;
        цвет_ = ЧЁРНЫЙ;
    }

    /**
     * Return a new КЧЯчейка with same элемент и цвет as сам,
     * but with пусто линки. (Since it is never ОК в_ have
     * multИПle опрentical линки in a RB дерево.)
    **/

    protected КЧЯчейка дубликат()
    {
        КЧЯчейка t = new КЧЯчейка(элемент());
        t.цвет_ = цвет_;
        return t;
    }


    /**
     * Return лево ветвь (or пусто)
    **/

    public final КЧЯчейка лево()
    {
        return лево_;
    }

    /**
     * Return право ветвь (or пусто)
    **/

    public final КЧЯчейка право()
    {
        return право_;
    }

    /**
     * Return родитель (or пусто)
    **/
    public final КЧЯчейка родитель()
    {
        return родитель_;
    }


    /**
     * See_Also: col.model.View.Обзор.проверьРеализацию.
    **/
    public проц проверьРеализацию()
    {

        // It's too hard в_ проверь the property that every simple
        // путь из_ узел в_ leaf имеется same число of black узелs.
        // So ограничь в_ the following

        assert(родитель_ is пусто ||
               this is родитель_.лево_ ||
               this is родитель_.право_);

        assert(лево_ is пусто ||
               this is лево_.родитель_);

        assert(право_ is пусто ||
               this is право_.родитель_);

        assert(цвет_ is ЧЁРНЫЙ ||
               (цветУ(лево_) is ЧЁРНЫЙ) && (цветУ(право_) is ЧЁРНЫЙ));

        if (лево_ !is пусто)
            лево_.проверьРеализацию();
        if (право_ !is пусто)
            право_.проверьРеализацию();
    }

    /+
    public final проц assert(бул пред)
    {
        ImplementationError.assert(this, пред);
    }
    +/

    /**
     * Return the minimum элемент of the текущ (подст)дерево
    **/

    public final КЧЯчейка левейший()
    {
        auto p = this;
        for ( ; p.лево_ !is пусто; p = p.лево_)
        {}
        return p;
    }

    /**
     * Return the maximum элемент of the текущ (подст)дерево
    **/
    public final КЧЯчейка правейший()
    {
        auto p = this;
        for ( ; p.право_ !is пусто; p = p.право_)
        {}
        return p;
    }

    /**
     * Return the корень (parentless узел) of the дерево
    **/
    public final КЧЯчейка корень()
    {
        auto p = this;
        for ( ; p.родитель_ !is пусто; p = p.родитель_)
        {}
        return p;
    }

    /**
     * Return да if узел is a корень (i.e., имеется a пусто родитель)
    **/

    public final бул корень_ли()
    {
        return родитель_ is пусто;
    }


    /**
     * Return the inorder потомок, or пусто if no such
    **/

    public final КЧЯчейка потомок()
    {
        if (право_ !is пусто)
            return право_.левейший();
        else
        {
            auto p = родитель_;
            auto ch = this;
            while (p !is пусто && ch is p.право_)
            {
                ch = p;
                p = p.родитель_;
            }
            return p;
        }
    }

    /**
     * Return the inorder предок, or пусто if no such
    **/

    public final КЧЯчейка предок()
    {
        if (лево_ !is пусто)
            return лево_.правейший();
        else
        {
            auto p = родитель_;
            auto ch = this;
            while (p !is пусто && ch is p.лево_)
            {
                ch = p;
                p = p.родитель_;
            }
            return p;
        }
    }

    /**
     * Return the число of узелs in the subtree
    **/
    public final цел размер()
    {
        цел c = 1;
        if (лево_ !is пусто)
            c += лево_.размер();
        if (право_ !is пусто)
            c += право_.размер();
        return c;
    }


    /**
     * Return узел of текущ subtree containing элемент as элемент(),
     * if it есть_ли, else пусто.
     * Uses Сравнитель cmp в_ найди и в_ проверь equality.
    **/

    public КЧЯчейка найди(T элемент, Сравнитель!(T) cmp)
    {
        auto t = this;
        for (;;)
        {
            цел рознь = cmp(элемент, t.элемент());
            if (рознь is 0)
                return t;
            else if (рознь < 0)
                t = t.лево_;
            else
                t = t.право_;
            if (t is пусто)
                break;
        }
        return пусто;
    }


    /**
     * Return число of узелs of текущ subtree containing элемент.
     * Uses Сравнитель cmp в_ найди и в_ проверь equality.
    **/
    public цел счёт(T элемент, Сравнитель!(T) cmp)
    {
        цел c = 0;
        auto t = this;
        while (t !is пусто)
        {
            цел рознь = cmp(элемент, t.элемент());
            if (рознь is 0)
            {
                ++c;
                if (t.лево_ is пусто)
                    t = t.право_;
                else if (t.право_ is пусто)
                    t = t.лево_;
                else
                {
                    c += t.право_.счёт(элемент, cmp);
                    t = t.лево_;
                }
            }
            else if (рознь < 0)
                t = t.лево_;
            else
                t = t.право_;
        }
        return c;
    }




    /**
     * Return a new subtree containing each элемент of текущ subtree
    **/

    public final КЧЯчейка копируйДерево()
    {
        auto t = cast(КЧЯчейка)(дубликат());

        if (лево_ !is пусто)
        {
            t.лево_ = лево_.копируйДерево();
            t.лево_.родитель_ = t;
        }
        if (право_ !is пусто)
        {
            t.право_ = право_.копируйДерево();
            t.право_.родитель_ = t;
        }
        return t;
    }


    /**
     * There's no генерный элемент insertion. Instead найди the
     * place you want в_ добавь a узел и then invoke вставьЛевый
     * or вставьПравый.
     * <P>
     * Insert Ячейка as the лево ветвь of текущ узел, и then
     * rebalance the дерево it is in.
     * @param Ячейка the Ячейка в_ добавь
     * @param корень, the корень of the текущ дерево
     * Возвращает: the new корень of the текущ дерево. (Rebalancing
     * can change the корень!)
    **/


    public final КЧЯчейка вставьЛевый(КЧЯчейка Ячейка, КЧЯчейка корень)
    {
        лево_ = Ячейка;
        Ячейка.родитель_ = this;
        return Ячейка.исправьПослеВставки(корень);
    }

    /**
     * Insert Ячейка as the право ветвь of текущ узел, и then
     * rebalance the дерево it is in.
     * @param Ячейка the Ячейка в_ добавь
     * @param корень, the корень of the текущ дерево
     * Возвращает: the new корень of the текущ дерево. (Rebalancing
     * can change the корень!)
    **/

    public final КЧЯчейка вставьПравый(КЧЯчейка Ячейка, КЧЯчейка корень)
    {
        право_ = Ячейка;
        Ячейка.родитель_ = this;
        return Ячейка.исправьПослеВставки(корень);
    }


    /**
     * Delete the текущ узел, и then rebalance the дерево it is in
     * @param корень the корень of the текущ дерево
     * Возвращает: the new корень of the текущ дерево. (Rebalancing
     * can change the корень!)
    **/


    public final КЧЯчейка удали (КЧЯчейка корень)
    {

        // укз case where we are only узел
        if (лево_ is пусто && право_ is пусто && родитель_ is пусто)
            return пусто;

        // if strictly internal, обменяй places with a потомок
        if (лево_ !is пусто && право_ !is пусто)
        {
            auto s = потомок();
            // To work nicely with arbitrary subclasses of КЧЯчейка, we don't want в_
            // just копируй потомок's fields. since we don't know что
            // they are.  Instead we обменяй positions _in the дерево.
            корень = поменяйПозиции(this, s, корень);
        }

        // Start fixup at замена узел (normally a ветвь).
        // But if no ветви, fake it by using сам

        if (лево_ is пусто && право_ is пусто)
        {

            if (цвет_ is ЧЁРНЫЙ)
                корень = this.исправьПослеУдаления(корень);

            // Unlink  (Couldn't before since исправьПослеУдаления needs родитель ptr)

            if (родитель_ !is пусто)
            {
                if (this is родитель_.лево_)
                    родитель_.лево_ = пусто;
                else if (this is родитель_.право_)
                    родитель_.право_ = пусто;
                родитель_ = пусто;
            }

        }
        else
        {
            auto замена = лево_;
            if (замена is пусто)
                замена = право_;

            // link замена в_ родитель
            замена.родитель_ = родитель_;

            if (родитель_ is пусто)
                корень = замена;
            else if (this is родитель_.лево_)
                родитель_.лево_ = замена;
            else
                родитель_.право_ = замена;

            лево_ = пусто;
            право_ = пусто;
            родитель_ = пусто;

            // fix замена
            if (цвет_ is ЧЁРНЫЙ)
                корень = замена.исправьПослеУдаления(корень);

        }

        return корень;
    }

    /**
     * Swap the linkages of two узелs in a дерево.
     * Return new корень, in case it изменён.
    **/

    static final КЧЯчейка поменяйПозиции(КЧЯчейка x, КЧЯчейка y, КЧЯчейка корень)
    {

        /* Too messy. TODO: найди sequence of assigments that are always ОК */

        auto px = x.родитель_;
        бул xpl = px !is пусто && x is px.лево_;
        auto lx = x.лево_;
        auto rx = x.право_;

        auto py = y.родитель_;
        бул ypl = py !is пусто && y is py.лево_;
        auto ly = y.лево_;
        auto ry = y.право_;

        if (x is py)
        {
            y.родитель_ = px;
            if (px !is пусто)
                if (xpl)
                    px.лево_ = y;
                else
                    px.право_ = y;
            x.родитель_ = y;
            if (ypl)
            {
                y.лево_ = x;
                y.право_ = rx;
                if (rx !is пусто)
                    rx.родитель_ = y;
            }
            else
            {
                y.право_ = x;
                y.лево_ = lx;
                if (lx !is пусто)
                    lx.родитель_ = y;
            }
            x.лево_ = ly;
            if (ly !is пусто)
                ly.родитель_ = x;
            x.право_ = ry;
            if (ry !is пусто)
                ry.родитель_ = x;
        }
        else if (y is px)
        {
            x.родитель_ = py;
            if (py !is пусто)
                if (ypl)
                    py.лево_ = x;
                else
                    py.право_ = x;
            y.родитель_ = x;
            if (xpl)
            {
                x.лево_ = y;
                x.право_ = ry;
                if (ry !is пусто)
                    ry.родитель_ = x;
            }
            else
            {
                x.право_ = y;
                x.лево_ = ly;
                if (ly !is пусто)
                    ly.родитель_ = x;
            }
            y.лево_ = lx;
            if (lx !is пусто)
                lx.родитель_ = y;
            y.право_ = rx;
            if (rx !is пусто)
                rx.родитель_ = y;
        }
        else
        {
            x.родитель_ = py;
            if (py !is пусто)
                if (ypl)
                    py.лево_ = x;
                else
                    py.право_ = x;
            x.лево_ = ly;
            if (ly !is пусто)
                ly.родитель_ = x;
            x.право_ = ry;
            if (ry !is пусто)
                ry.родитель_ = x;

            y.родитель_ = px;
            if (px !is пусто)
                if (xpl)
                    px.лево_ = y;
                else
                    px.право_ = y;
            y.лево_ = lx;
            if (lx !is пусто)
                lx.родитель_ = y;
            y.право_ = rx;
            if (rx !is пусто)
                rx.родитель_ = y;
        }

        бул c = x.цвет_;
        x.цвет_ = y.цвет_;
        y.цвет_ = c;

        if (корень is x)
            корень = y;
        else if (корень is y)
            корень = x;
        return корень;
    }



    /**
     * Return цвет of узел p, or ЧЁРНЫЙ if p is пусто
     * (In the CLR version, they use
     * a special dummy `nil' узел for such purposes, but that doesn't
     * work well here, since it could lead в_ creating one such special
     * узел per реал узел.)
     *
    **/

    static final бул цветУ(КЧЯчейка p)
    {
        return (p is пусто) ? ЧЁРНЫЙ : p.цвет_;
    }

    /**
     * return родитель of узел p, or пусто if p is пусто
    **/
    static final КЧЯчейка родительУ(КЧЯчейка p)
    {
        return (p is пусто) ? пусто : p.родитель_;
    }

    /**
     * Набор the цвет of узел p, or do nothing if p is пусто
    **/

    static final проц установиЦвет(КЧЯчейка p, бул c)
    {
        if (p !is пусто)
            p.цвет_ = c;
    }

    /**
     * return лево ветвь of узел p, or пусто if p is пусто
    **/

    static final КЧЯчейка левыйУ(КЧЯчейка p)
    {
        return (p is пусто) ? пусто : p.лево_;
    }

    /**
     * return право ветвь of узел p, or пусто if p is пусто
    **/

    static final КЧЯчейка правыйУ(КЧЯчейка p)
    {
        return (p is пусто) ? пусто : p.право_;
    }


    /** ОтКого CLR **/
    protected final КЧЯчейка вращайВлево(КЧЯчейка корень)
    {
        auto r = право_;
        право_ = r.лево_;
        if (r.лево_ !is пусто)
            r.лево_.родитель_ = this;
        r.родитель_ = родитель_;
        if (родитель_ is пусто)
            корень = r;
        else if (родитель_.лево_ is this)
            родитель_.лево_ = r;
        else
            родитель_.право_ = r;
        r.лево_ = this;
        родитель_ = r;
        return корень;
    }

    /** ОтКого CLR **/
    protected final КЧЯчейка вращайВправо(КЧЯчейка корень)
    {
        auto l = лево_;
        лево_ = l.право_;
        if (l.право_ !is пусто)
            l.право_.родитель_ = this;
        l.родитель_ = родитель_;
        if (родитель_ is пусто)
            корень = l;
        else if (родитель_.право_ is this)
            родитель_.право_ = l;
        else
            родитель_.лево_ = l;
        l.право_ = this;
        родитель_ = l;
        return корень;
    }


    /** ОтКого CLR **/
    protected final КЧЯчейка исправьПослеВставки(КЧЯчейка корень)
    {
        цвет_ = КРАСНЫЙ;
        auto x = this;

        while (x !is пусто && x !is корень && x.родитель_.цвет_ is КРАСНЫЙ)
        {
            if (родительУ(x) is левыйУ(родительУ(родительУ(x))))
            {
                auto y = правыйУ(родительУ(родительУ(x)));
                if (цветУ(y) is КРАСНЫЙ)
                {
                    установиЦвет(родительУ(x), ЧЁРНЫЙ);
                    установиЦвет(y, ЧЁРНЫЙ);
                    установиЦвет(родительУ(родительУ(x)), КРАСНЫЙ);
                    x = родительУ(родительУ(x));
                }
                else
                {
                    if (x is правыйУ(родительУ(x)))
                    {
                        x = родительУ(x);
                        корень = x.вращайВлево(корень);
                    }
                    установиЦвет(родительУ(x), ЧЁРНЫЙ);
                    установиЦвет(родительУ(родительУ(x)), КРАСНЫЙ);
                    if (родительУ(родительУ(x)) !is пусто)
                        корень = родительУ(родительУ(x)).вращайВправо(корень);
                }
            }
            else
            {
                auto y = левыйУ(родительУ(родительУ(x)));
                if (цветУ(y) is КРАСНЫЙ)
                {
                    установиЦвет(родительУ(x), ЧЁРНЫЙ);
                    установиЦвет(y, ЧЁРНЫЙ);
                    установиЦвет(родительУ(родительУ(x)), КРАСНЫЙ);
                    x = родительУ(родительУ(x));
                }
                else
                {
                    if (x is левыйУ(родительУ(x)))
                    {
                        x = родительУ(x);
                        корень = x.вращайВправо(корень);
                    }
                    установиЦвет(родительУ(x), ЧЁРНЫЙ);
                    установиЦвет(родительУ(родительУ(x)), КРАСНЫЙ);
                    if (родительУ(родительУ(x)) !is пусто)
                        корень = родительУ(родительУ(x)).вращайВлево(корень);
                }
            }
        }
        корень.цвет_ = ЧЁРНЫЙ;
        return корень;
    }



    /** ОтКого CLR **/
    protected final КЧЯчейка исправьПослеУдаления(КЧЯчейка корень)
    {
        auto x = this;
        while (x !is корень && цветУ(x) is ЧЁРНЫЙ)
        {
            if (x is левыйУ(родительУ(x)))
            {
                auto sib = правыйУ(родительУ(x));
                if (цветУ(sib) is КРАСНЫЙ)
                {
                    установиЦвет(sib, ЧЁРНЫЙ);
                    установиЦвет(родительУ(x), КРАСНЫЙ);
                    корень = родительУ(x).вращайВлево(корень);
                    sib = правыйУ(родительУ(x));
                }
                if (цветУ(левыйУ(sib)) is ЧЁРНЫЙ && цветУ(правыйУ(sib)) is ЧЁРНЫЙ)
                {
                    установиЦвет(sib, КРАСНЫЙ);
                    x = родительУ(x);
                }
                else
                {
                    if (цветУ(правыйУ(sib)) is ЧЁРНЫЙ)
                    {
                        установиЦвет(левыйУ(sib), ЧЁРНЫЙ);
                        установиЦвет(sib, КРАСНЫЙ);
                        корень = sib.вращайВправо(корень);
                        sib = правыйУ(родительУ(x));
                    }
                    установиЦвет(sib, цветУ(родительУ(x)));
                    установиЦвет(родительУ(x), ЧЁРНЫЙ);
                    установиЦвет(правыйУ(sib), ЧЁРНЫЙ);
                    корень = родительУ(x).вращайВлево(корень);
                    x = корень;
                }
            }
            else
            {
                auto sib = левыйУ(родительУ(x));
                if (цветУ(sib) is КРАСНЫЙ)
                {
                    установиЦвет(sib, ЧЁРНЫЙ);
                    установиЦвет(родительУ(x), КРАСНЫЙ);
                    корень = родительУ(x).вращайВправо(корень);
                    sib = левыйУ(родительУ(x));
                }
                if (цветУ(правыйУ(sib)) is ЧЁРНЫЙ && цветУ(левыйУ(sib)) is ЧЁРНЫЙ)
                {
                    установиЦвет(sib, КРАСНЫЙ);
                    x = родительУ(x);
                }
                else
                {
                    if (цветУ(левыйУ(sib)) is ЧЁРНЫЙ)
                    {
                        установиЦвет(правыйУ(sib), ЧЁРНЫЙ);
                        установиЦвет(sib, КРАСНЫЙ);
                        корень = sib.вращайВлево(корень);
                        sib = левыйУ(родительУ(x));
                    }
                    установиЦвет(sib, цветУ(родительУ(x)));
                    установиЦвет(родительУ(x), ЧЁРНЫЙ);
                    установиЦвет(левыйУ(sib), ЧЁРНЫЙ);
                    корень = родительУ(x).вращайВправо(корень);
                    x = корень;
                }
            }
        }
        установиЦвет(x, ЧЁРНЫЙ);
        return корень;
    }
}

