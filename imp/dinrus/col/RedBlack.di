/*******************************************************************************
        Based upon Doug Lea's Java collection package
*******************************************************************************/

module col.RedBlack;

private import col.model.IContainer;

private typedef цел АтрибутНаобум;

/*******************************************************************************

        КрасноЧёрное реализует basic capabilities of Red-Black trees,
        an efficient kind of balanced binary дерево. The particular
        algorithms использован are adaptations of those in Corman,
        Lieserson, и Rivest's <EM>Introduction в_ Algorithms</EM>.
        This class was inspired by (и код cross-проверьed with) a
        similar class by Chuck McManis. The implementations of
        rebalancings during insertion и deletion are
        a little trickier than those versions since they
        don't обменяй Cell contents or use special dummy nilузелs.

        Doug Lea

*******************************************************************************/

struct КрасноЧёрное (З, A = АтрибутНаобум)
{
    alias КрасноЧёрное!(З, A) Тип;
    alias Тип            *Реф;

    enum : бул {КРАСНЫЙ = нет, ЧЁРНЫЙ = да}

    /**
     * Pointer в_ лево ветвь
    **/

    package Реф     лево;

    /**
     * Pointer в_ право ветвь
    **/

    package Реф     право;

    /**
     * Pointer в_ родитель (пусто if корень)
    **/

    package Реф     родитель;

    package З       значение;

    static if (!is(typeof(A) == АтрибутНаобум))
    {
        A        атрибут;
    }

    /**
     * The узел цвет (КРАСНЫЙ, ЧЁРНЫЙ)
    **/

    package бул    цвет;

    static if (!is(typeof(A) == АтрибутНаобум))
    {
        final Реф установи (З знач, A a)
        {
            атрибут = a;
            return установи (знач);
        }
    }

    /**
     * Создаёт new Cell with given значение, пусто линки, и ЧЁРНЫЙ цвет.
     * Normally only called в_ establish a new корень.
    **/

    final Реф установи (З знач)
    {
        значение = знач;
        лево = пусто;
        право = пусто;
        родитель = пусто;
        цвет = ЧЁРНЫЙ;
        return this;
    }

    /**
     * Возвращает new Реф with same значение и цвет as сам,
     * but with пусто линки. (Since it is never ОК в_ have
     * Несколько опрentical линки in a RB дерево.)
    **/

    protected Реф dup (Реф delegate() размести)
    {
        static if (is(typeof(A) == АтрибутНаобум))
            auto t = размести().установи (значение);
        else
            auto t = размести().установи (значение, атрибут);

        t.цвет = цвет;
        return t;
    }


    /**
     * См_Также: col.model.View.Обзор.проверьРеализацию.
    **/
    public проц проверьРеализацию ()
    {

        // It's too hard в_ проверь the property that every simple
        // путь из_ узел в_ leaf имеется same число of black узлы.
        // So ограничь в_ the following

        assert(родитель is пусто ||
               this is родитель.лево ||
               this is родитель.право);

        assert(лево is пусто ||
               this is лево.родитель);

        assert(право is пусто ||
               this is право.родитель);

        assert(цвет is ЧЁРНЫЙ ||
               (цветУ(лево) is ЧЁРНЫЙ) && (цветУ(право) is ЧЁРНЫЙ));

        if (лево !is пусто)
            лево.проверьРеализацию();
        if (право !is пусто)
            право.проверьРеализацию();
    }

    /**
     * Возвращает the minimum значение of the текущ (подст)дерево
    **/

    Реф левейший ()
    {
        auto p = this;
        for ( ; p.лево; p = p.лево) {}
        return p;
    }

    /**
     * Возвращает the maximum значение of the текущ (подст)дерево
    **/
    Реф правейший ()
    {
        auto p = this;
        for ( ; p.право; p = p.право) {}
        return p;
    }

    /**
     * Возвращает the корень (parentless узел) of the дерево
    **/
    Реф корень ()
    {
        auto p = this;
        for ( ; p.родитель; p = p.родитель) {}
        return p;
    }

    /**
     * Возвращает да, если узел is a корень (т.е., имеется a пусто родитель)
    **/

    бул корень_ли ()
    {
        return родитель is пусто;
    }


    /**
     * Возвращает the inorder потомок, либо пусто, если такового нет
    **/

    Реф потомок ()
    {
        if (право)
            return право.левейший;

        auto p = родитель;
        auto ch = this;
        while (p && ch is p.право)
        {
            ch = p;
            p = p.родитель;
        }
        return p;
    }

    /**
     * Возвращает the inorder предок, либо пусто, если такового нет
    **/

    Реф предок ()
    {
        if (лево)
            return лево.правейший;

        auto p = родитель;
        auto ch = this;
        while (p && ch is p.лево)
        {
            ch = p;
            p = p.родитель;
        }
        return p;
    }

    /**
     * Возвращает the число of узлы in the subtree
    **/
    цел размер ()
    {
        auto c = 1;
        if (лево)
            c += лево.размер;
        if (право)
            c += право.размер;
        return c;
    }


    /**
     * Возвращает узел of текущ subtree containing значение as значение(),
     * if it есть_ли, else пусто.
     * Uses Сравнитель cmp в_ найди и в_ проверь equality.
    **/

    Реф найди (З значение, Сравни!(З) cmp)
    {
        auto t = this;
        for (;;)
        {
            auto рознь = cmp (значение, t.значение);
            if (рознь is 0)
                return t;
            else if (рознь < 0)
                t = t.лево;
            else
                t = t.право;
            if (t is пусто)
                break;
        }
        return пусто;
    }


    /**
     * Возвращает узел of subtree совпадают "значение"
     * or, if Неук найдено, the one just после or перед
     * if it doesn't есть_ли, return пусто
     * Uses Сравнитель cmp в_ найди и в_ проверь equality.
    **/
    Реф найдиПервый (З значение, Сравни!(З) cmp, бул после = да)
    {
        auto t = this;
        auto tLower = this;
        auto tGreater  = this;

        for (;;)
        {
            auto рознь = cmp (значение, t.значение);
            if (рознь is 0)
                return t;
            else if (рознь < 0)
            {
                tGreater = t;
                t = t.лево;
            }
            else
            {
                tLower = t;
                t = t.право;
            }
            if (t is пусто)
                break;
        }

        if (после)
        {
            if (cmp (значение, tGreater.значение) <= 0)
                if (cmp (значение, tGreater.значение) < 0)
                    return tGreater;
        }
        else
        {
            if (cmp (значение, tLower.значение) >= 0)
                if (cmp (значение, tLower.значение) > 0)
                    return tLower;
        }

        return пусто;
    }

    /**
     * Возвращает число of узлы of текущ subtree containing значение.
     * Uses Сравнитель cmp в_ найди и в_ проверь equality.
    **/
    цел счёт (З значение, Сравни!(З) cmp)
    {
        auto c = 0;
        auto t = this;
        while (t)
        {
            цел рознь = cmp (значение, t.значение);
            if (рознь is 0)
            {
                ++c;
                if (t.лево is пусто)
                    t = t.право;
                else if (t.право is пусто)
                    t = t.лево;
                else
                {
                    c += t.право.счёт (значение, cmp);
                    t = t.лево;
                }
            }
            else if (рознь < 0)
                t = t.лево;
            else
                t = t.право;
        }
        return c;
    }

    static if (!is(typeof(A) == АтрибутНаобум))
    {
        Реф найдиАтрибут (A атрибут, Сравни!(A) cmp)
        {
            auto t = this;

            while (t)
            {
                if (t.атрибут == атрибут)
                    return t;
                else if (t.право is пусто)
                    t = t.лево;
                else if (t.лево is пусто)
                    t = t.право;
                else
                {
                    auto p = t.лево.найдиАтрибут (атрибут, cmp);

                    if (p !is пусто)
                        return p;
                    else
                        t = t.право;
                }
            }
            return пусто; // not reached
        }

        цел учтиАтрибут (A атриб, Сравни!(A) cmp)
        {
            цел c = 0;
            auto t = this;

            while (t)
            {
                if (t.атрибут == атрибут)
                    ++c;

                if (t.право is пусто)
                    t = t.лево;
                else if (t.лево is пусто)
                    t = t.право;
                else
                {
                    c += t.лево.учтиАтрибут (атрибут, cmp);
                    t = t.право;
                }
            }
            return c;
        }

        /**
         * найди и return a ячейка holding (ключ, элемент), либо пусто, если такового нет
        **/
        Реф найди (З значение, A атрибут, Сравни!(З) cmp)
        {
            auto t = this;

            for (;;)
            {
                цел рознь = cmp (значение, t.значение);
                if (рознь is 0 && t.атрибут == атрибут)
                    return t;
                else if (рознь <= 0)
                    t = t.лево;
                else
                    t = t.право;

                if (t is пусто)
                    break;
            }
            return пусто;
        }

    }



    /**
     * Возвращает new subtree containing each значение of текущ subtree
    **/

    Реф копируйДерево (Реф delegate() размести)
    {
        auto t = dup (размести);

        if (лево)
        {
            t.лево = лево.копируйДерево (размести);
            t.лево.родитель = t;
        }

        if (право)
        {
            t.право = право.копируйДерево (размести);
            t.право.родитель = t;
        }

        return t;
    }


    /**
     * There's no генерный значение insertion. Instead найди the
     * place you want в_ добавь a узел и then invoke вставьЛевый
     * or вставьПравый.
     * <P>
     * Insert Cell as the лево ветвь of текущ узел, и then
     * rebalance the дерево it is in.
     * @param Cell the Cell в_ добавь
     * @param корень, the корень of the текущ дерево
     * Возвращает: the new корень of the текущ дерево. (Rebalancing
     * can change the корень!)
    **/


    Реф вставьЛевый (Реф ячейка, Реф корень)
    {
        лево = ячейка;
        ячейка.родитель = this;
        return ячейка.исправьПослеВставки (корень);
    }

    /**
     * Insert Cell as the право ветвь of текущ узел, и then
     * rebalance the дерево it is in.
     * @param Cell the Cell в_ добавь
     * @param корень, the корень of the текущ дерево
     * Возвращает: the new корень of the текущ дерево. (Rebalancing
     * can change the корень!)
    **/

    Реф вставьПравый (Реф ячейка, Реф корень)
    {
        право = ячейка;
        ячейка.родитель = this;
        return ячейка.исправьПослеВставки (корень);
    }


    /**
     * Delete the текущ узел, и then rebalance the дерево it is in
     * @param корень the корень of the текущ дерево
     * Возвращает: the new корень of the текущ дерево. (Rebalancing
     * can change the корень!)
    **/


    Реф удали (Реф корень)
    {
        // укз case where we are only узел
        if (лево is пусто && право is пусто && родитель is пусто)
            return пусто;

        // if strictly internal, обменяй places with a потомок
        if (лево && право)
        {
            auto s = потомок;

            // To work nicely with arbitrary subclasses of Реф, we don't want в_
            // just копируй потомок's fields. since we don't know что
            // they are.  Instead we обменяй positions _in the дерево.
            корень = поменяйПозиции (this, s, корень);
        }

        // Start fixup at замена узел (normally a ветвь).
        // But if no ветви, fake it by using сам

        if (лево is пусто && право is пусто)
        {
            if (цвет is ЧЁРНЫЙ)
                корень = this.исправьПослеУдаления (корень);

            // Unlink  (Couldn't перед since исправьПослеУдаления needs родитель ptr)
            if (родитель)
            {
                if (this is родитель.лево)
                    родитель.лево = пусто;
                else if (this is родитель.право)
                    родитель.право = пусто;
                родитель = пусто;
            }
        }
        else
        {
            auto замена = лево;
            if (замена is пусто)
                замена = право;

            // link замена в_ родитель
            замена.родитель = родитель;

            if (родитель is пусто)
                корень = замена;
            else if (this is родитель.лево)
                родитель.лево = замена;
            else
                родитель.право = замена;

            лево = пусто;
            право = пусто;
            родитель = пусто;

            // fix замена
            if (цвет is ЧЁРНЫЙ)
                корень = замена.исправьПослеУдаления (корень);
        }
        return корень;
    }

    /**
     * Swap the linkages of two узлы in a дерево.
     * Возвращает new корень, in case it изменён.
    **/

    static Реф поменяйПозиции (Реф x, Реф y, Реф корень)
    {
        /* Too messy. TODO: найди sequence of assigments that are всегда ОК */

        auto px = x.родитель;
        бул xpl = px !is пусто && x is px.лево;
        auto lx = x.лево;
        auto rx = x.право;

        auto py = y.родитель;
        бул ypl = py !is пусто && y is py.лево;
        auto ly = y.лево;
        auto ry = y.право;

        if (x is py)
        {
            y.родитель = px;
            if (px !is пусто)
                if (xpl)
                    px.лево = y;
                else
                    px.право = y;

            x.родитель = y;
            if (ypl)
            {
                y.лево = x;
                y.право = rx;
                if (rx !is пусто)
                    rx.родитель = y;
            }
            else
            {
                y.право = x;
                y.лево = lx;
                if (lx !is пусто)
                    lx.родитель = y;
            }

            x.лево = ly;
            if (ly !is пусто)
                ly.родитель = x;

            x.право = ry;
            if (ry !is пусто)
                ry.родитель = x;
        }
        else if (y is px)
        {
            x.родитель = py;
            if (py !is пусто)
                if (ypl)
                    py.лево = x;
                else
                    py.право = x;

            y.родитель = x;
            if (xpl)
            {
                x.лево = y;
                x.право = ry;
                if (ry !is пусто)
                    ry.родитель = x;
            }
            else
            {
                x.право = y;
                x.лево = ly;
                if (ly !is пусто)
                    ly.родитель = x;
            }

            y.лево = lx;
            if (lx !is пусто)
                lx.родитель = y;

            y.право = rx;
            if (rx !is пусто)
                rx.родитель = y;
        }
        else
        {
            x.родитель = py;
            if (py !is пусто)
                if (ypl)
                    py.лево = x;
                else
                    py.право = x;

            x.лево = ly;
            if (ly !is пусто)
                ly.родитель = x;

            x.право = ry;
            if (ry !is пусто)
                ry.родитель = x;

            y.родитель = px;
            if (px !is пусто)
                if (xpl)
                    px.лево = y;
                else
                    px.право = y;

            y.лево = lx;
            if (lx !is пусто)
                lx.родитель = y;

            y.право = rx;
            if (rx !is пусто)
                rx.родитель = y;
        }

        бул c = x.цвет;
        x.цвет = y.цвет;
        y.цвет = c;

        if (корень is x)
            корень = y;
        else if (корень is y)
            корень = x;
        return корень;
    }



    /**
     * Возвращает цвет of узел p, либо ЧЁРНЫЙ if p is пусто
     * (In the CLR version, they use
     * a special dummy `nil' узел for such purposes, but that doesn't
     * work well here, since it could lead в_ creating one such special
     * узел per реал узел.)
     *
    **/

    static бул цветУ (Реф p)
    {
        return (p is пусто) ? ЧЁРНЫЙ : p.цвет;
    }

    /**
     * return родитель of узел p, либо пусто if p is пусто
    **/
    static Реф родительУ (Реф p)
    {
        return (p is пусто) ? пусто : p.родитель;
    }

    /**
     * Устанавливает цвет of узел p, либо do nothing if p is пусто
    **/

    static проц установиЦвет (Реф p, бул c)
    {
        if (p !is пусто)
            p.цвет = c;
    }

    /**
     * return лево ветвь of узел p, либо пусто if p is пусто
    **/

    static Реф левыйУ (Реф p)
    {
        return (p is пусто) ? пусто : p.лево;
    }

    /**
     * return право ветвь of узел p, либо пусто if p is пусто
    **/

    static Реф правыйУ (Реф p)
    {
        return (p is пусто) ? пусто : p.право;
    }


    /** ОтКого CLR **/
    package Реф вращайВлево (Реф корень)
    {
        auto r = право;
        право = r.лево;

        if (r.лево)
            r.лево.родитель = this;

        r.родитель = родитель;
        if (родитель is пусто)
            корень = r;
        else if (родитель.лево is this)
            родитель.лево = r;
        else
            родитель.право = r;

        r.лево = this;
        родитель = r;
        return корень;
    }

    /** ОтКого CLR **/
    package Реф вращайВправо (Реф корень)
    {
        auto l = лево;
        лево = l.право;

        if (l.право !is пусто)
            l.право.родитель = this;

        l.родитель = родитель;
        if (родитель is пусто)
            корень = l;
        else if (родитель.право is this)
            родитель.право = l;
        else
            родитель.лево = l;

        l.право = this;
        родитель = l;
        return корень;
    }


    /** ОтКого CLR **/
    package Реф исправьПослеВставки (Реф корень)
    {
        цвет = КРАСНЫЙ;
        auto x = this;

        while (x && x !is корень && x.родитель.цвет is КРАСНЫЙ)
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
        корень.цвет = ЧЁРНЫЙ;
        return корень;
    }



    /** ОтКого CLR **/
    package Реф исправьПослеУдаления(Реф корень)
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
