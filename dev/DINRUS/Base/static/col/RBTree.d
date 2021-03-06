﻿/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.RBTree;

private import col.model.Iterator;
private import col.DefaultAllocator;

    version(КЧПроверять)
    {
	
	import stdrus;
	
	}

/**
 * Реализация Красно-Чёрного Узла для использования в Красно-Чёрном Дереве (см. ниже)
 *
 * Реализация предполагает наличие Узла-маркера, - родителя корневого Узла.
 * Этот Узел-маркер не есть действительный Узел, а метка конца коллекции.
 * Корень - это левый отпрыск Узла-маркера, поэтому обх всегда является последним
 * в коллекции. Узлу-маркеру передаётся функция установиЦвет,
 * а также Узел, для которого он является родителем, который принимается за
 * корневой Узел.
 *
 * A Красный Чёрный tree should have O(lg(n)) insertion, removal, и ищи time.
 */
struct КЧУзел(V)
{
    /**
     * Convenience alias
     */
    alias КЧУзел!(V)* Узел;

    private Узел _лево;
    private Узел _право;
    private Узел _родитель;

    /**
     * The значение held by this Узел
     */
    V значение;

    /**
     * Enumeration determining что цвет the Узел is.  Null узелs are assumed
     * to be black.
     */
    enum Цвет : byte
    {
        Красный,
        Чёрный
    }

    /**
     * The цвет of the Узел.
     */
    Цвет цвет;

    /**
     * Get the лево child
     */
    Узел лево()
    {
        return _лево;
    }

    /**
     * Get the право child
     */
    Узел право()
    {
        return _право;
    }

    /**
     * Get the родитель
     */
    Узел родитель()
    {
        return _родитель;
    }

    /**
     * Набор the лево child.  Also updates the new child's родитель Узел.  This
     * does not update the previous child.
     *
     * Returns новУзел
     */
    Узел лево(Узел новУзел)
    {
        _лево = новУзел;
        if(новУзел !is пусто)
            новУзел._родитель = this;
        return новУзел;
    }

    /**
     * Набор the право child.  Also updates the new child's родитель Узел.  This
     * does not update the previous child.
     *
     * Returns новУзел
     */
    Узел право(Узел новУзел)
    {
        _право = новУзел;
        if(новУзел !is пусто)
            новУзел._родитель = this;
        return новУзел;
    }

    // assume _лево is not пусто
    //
    // performs rotate-право operation, where this is T, _право is R, _лево is
    // L, _родитель is P:
    //
    //      P         P
    //      |   ->    |
    //      T         L
    //     / \       / \
    //    L   R     a   T
    //   / \           / \ 
    //  a   b         b   R 
    //
    /**
     * Rotate право.  This performs the following operations:
     *  - The лево child becomes the родитель of this Узел.
     *  - This Узел becomes the new родитель's право child.
     *  - The old право child of the new родитель becomes the лево child of this
     *    Узел.
     */
    Узел вращайП()
    in
    {
        assert(_лево !is пусто);
    }
    body
    {
        // sets _лево._родитель also
        if(левый_лиУзел)
            родитель.лево = _лево;
        else
            родитель.право = _лево;
        Узел врм = _лево._право;

        // sets _родитель also
        _лево.право = this;

        // sets врм._родитель also
        лево = врм;

        return this;
    }

    // assumes _право is non пусто
    //
    // performs rotate-лево operation, where this is T, _право is R, _лево is
    // L, _родитель is P:
    //
    //      P           P
    //      |    ->     |
    //      T           R
    //     / \         / \
    //    L   R       T   b
    //       / \     / \ 
    //      a   b   L   a 
    //
    /**
     * Rotate лево.  This performs the following operations:
     *  - The право child becomes the родитель of this Узел.
     *  - This Узел becomes the new родитель's лево child.
     *  - The old лево child of the new родитель becomes the право child of this
     *    Узел.
     */
    Узел вращайЛ()
    in
    {
        assert(_право !is пусто);
    }
    body
    {
        // sets _право._родитель also
        if(левый_лиУзел)
            родитель.лево = _право;
        else
            родитель.право = _право;
        Узел врм = _право._лево;

        // sets _родитель also
        _право.лево = this;

        // sets врм._родитель also
        право = врм;
        return this;
    }


    /**
     * Returns true if this Узел is a лево child.
     *
     * Note that this should always return a значение because the root имеется a
     * родитель which is the marker Узел.
     */
    бул левый_лиУзел()
    in
    {
        assert(_родитель !is пусто);
    }
    body
    {
        return _родитель._лево is this;
    }

    /**
     * Набор the цвет of the Узел after обх is inserted.  This performs an
     * update to the whole tree, possibly rotating узелs to keep the Красный-Чёрный
     * properties correct.  This is an O(lg(n)) operation, where n is the
     * number of узелs in the tree.
     */
    проц установиЦвет(Узел конец)
    {
        // test against the marker Узел
        if(_родитель !is конец)
        {
            if(_родитель.цвет == Цвет.Красный)
            {
                Узел тек = this;
                while(true)
                {
                    // because root is always black, _родитель._родитель always exists
                    if(тек._родитель.левый_лиУзел)
                    {
                        // родитель is лево Узел, y is 'uncle', could be пусто
                        Узел y = тек._родитель._родитель._право;
                        if(y !is пусто && y.цвет == Цвет.Красный)
                        {
                            тек._родитель.цвет = Цвет.Чёрный;
                            y.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель;
                            if(тек._родитель is конец)
                            {
                                // root Узел
                                тек.цвет = Цвет.Чёрный;
                                break;
                            }
                            else
                            {
                                // not root Узел
                                тек.цвет = Цвет.Красный;
                                if(тек._родитель.цвет == Цвет.Чёрный)
                                    // satisfied, exit the loop
                                    break;
                            }
                        }
                        else
                        {
                            if(!тек.левый_лиУзел)
                                тек = тек._родитель.вращайЛ();
                            тек._родитель.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель.вращайП();
                            тек.цвет = Цвет.Красный;
                            // tree should be satisfied now
                            break;
                        }
                    }
                    else
                    {
                        // родитель is право Узел, y is 'uncle'
                        Узел y = тек._родитель._родитель._лево;
                        if(y !is пусто && y.цвет == Цвет.Красный)
                        {
                            тек._родитель.цвет = Цвет.Чёрный;
                            y.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель;
                            if(тек._родитель is конец)
                            {
                                // root Узел
                                тек.цвет = Цвет.Чёрный;
                                break;
                            }
                            else
                            {
                                // not root Узел
                                тек.цвет = Цвет.Красный;
                                if(тек._родитель.цвет == Цвет.Чёрный)
                                    // satisfied, exit the loop
                                    break;
                            }
                        }
                        else
                        {
                            if(тек.левый_лиУзел)
                                тек = тек._родитель.вращайП();
                            тек._родитель.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель.вращайЛ();
                            тек.цвет = Цвет.Красный;
                            // tree should be satisfied now
                            break;
                        }
                    }
                }

            }
        }
        else
        {
            //
            // this is the root Узел, цвет обх black
            //
            цвет = Цвет.Чёрный;
        }
    }

    /**
     * Remove this Узел from the tree.  The 'конец' Узел is используется as the marker
     * which is root's родитель.  Note that this cannot be пусто!
     *
     * Returns the следщ highest valued Узел in the tree after this one, or конец
     * if this was the highest-valued Узел.
     */
    Узел удали(Узел конец)
    {
        //
        // удали this Узел from the tree, fixing the цвет if necessary.
        //
        Узел x;
        Узел возвр;
        if(_лево is пусто || _право is пусто)
        {
            возвр = следщ;
        }
        else
        {
            //
            // normally, we can just swap this Узел's и y's значение, but
            // because an обходчик could be pointing to y и we don't want to
            // disturb обх, we swap this Узел и y's structure instead.  This
            // can also be a benefit if the значение of the tree is a large
            // struct, which takes a дол time to копируй.
            //
            Узел yp, yl, yr;
            Узел y = следщ;
            yp = y._родитель;
            yl = y._лево;
            yr = y._право;
            auto yc = y.цвет;
            auto isyleft = y.левый_лиУзел;

            //
            // replace y's structure with structure of this Узел.
            //
            if(левый_лиУзел)
                _родитель.лево = y;
            else
                _родитель.право = y;
            //
            // need special case so y doesn't point тыл to itself
            //
            y.лево = _лево;
            if(_право is y)
                y.право = this;
            else
                y.право = _право;
            y.цвет = цвет;

            //
            // replace this Узел's structure with structure of y.
            //
            лево = yl;
            право = yr;
            if(_родитель !is y)
            {
                if(isyleft)
                    yp.лево = this;
                else
                    yp.право = this;
            }
            цвет = yc;

            //
            // установи return значение
            //
            возвр = y;
        }

        // if this имеется less than 2 children, удали обх
        if(_лево !is пусто)
            x = _лево;
        else
            x = _право;

        // удали this from the tree at the конец of the procedure
        бул удалить_лиЭтот = false;
        if(x is пусто)
        {
            // pretend this is a пусто Узел, удали this on finishing
            x = this;
            удалить_лиЭтот = true;
        }
        else if(левый_лиУзел)
            _родитель.лево = x;
        else
            _родитель.право = x;

        // if the цвет of this is black, then обх needs to be fixed
        if(цвет == цвет.Чёрный)
        {
            // need to recolor the tree.
            while(x._родитель !is конец && x.цвет == Узел.Цвет.Чёрный)
            {
                if(x.левый_лиУзел)
                {
                    // лево Узел
                    Узел w = x._родитель._право;
                    if(w.цвет == Узел.Цвет.Красный)
                    {
                        w.цвет = Узел.Цвет.Чёрный;
                        x._родитель.цвет = Узел.Цвет.Красный;
                        x._родитель.вращайЛ();
                        w = x._родитель._право;
                    }
                    Узел wl = w.лево;
                    Узел wr = w.право;
                    if((wl is пусто || wl.цвет == Узел.Цвет.Чёрный) &&
                            (wr is пусто || wr.цвет == Узел.Цвет.Чёрный))
                    {
                        w.цвет = Узел.Цвет.Красный;
                        x = x._родитель;
                    }
                    else
                    {
                        if(wr is пусто || wr.цвет == Узел.Цвет.Чёрный)
                        {
                            // wl cannot be пусто here
                            wl.цвет = Узел.Цвет.Чёрный;
                            w.цвет = Узел.Цвет.Красный;
                            w.вращайП();
                            w = x._родитель._право;
                        }

                        w.цвет = x._родитель.цвет;
                        x._родитель.цвет = Узел.Цвет.Чёрный;
                        w._право.цвет = Узел.Цвет.Чёрный;
                        x._родитель.вращайЛ();
                        x = конец.лево; // x = root
                    }
                }
                else
                {
                    // право Узел
                    Узел w = x._родитель._лево;
                    if(w.цвет == Узел.Цвет.Красный)
                    {
                        w.цвет = Узел.Цвет.Чёрный;
                        x._родитель.цвет = Узел.Цвет.Красный;
                        x._родитель.вращайП();
                        w = x._родитель._лево;
                    }
                    Узел wl = w.лево;
                    Узел wr = w.право;
                    if((wl is пусто || wl.цвет == Узел.Цвет.Чёрный) &&
                            (wr is пусто || wr.цвет == Узел.Цвет.Чёрный))
                    {
                        w.цвет = Узел.Цвет.Красный;
                        x = x._родитель;
                    }
                    else
                    {
                        if(wl is пусто || wl.цвет == Узел.Цвет.Чёрный)
                        {
                            // wr cannot be пусто here
                            wr.цвет = Узел.Цвет.Чёрный;
                            w.цвет = Узел.Цвет.Красный;
                            w.вращайЛ();
                            w = x._родитель._лево;
                        }

                        w.цвет = x._родитель.цвет;
                        x._родитель.цвет = Узел.Цвет.Чёрный;
                        w._лево.цвет = Узел.Цвет.Чёрный;
                        x._родитель.вращайП();
                        x = конец.лево; // x = root
                    }
                }
            }
            x.цвет = Узел.Цвет.Чёрный;
        }

        if(удалить_лиЭтот)
        {
            //
            // очисти this Узел out of the tree
            //
            if(левый_лиУзел)
                _родитель.лево = пусто;
            else
                _родитель.право = пусто;
        }

        return возвр;
    }

    /**
     * Return the самый_левый descendant of this Узел.
     */
    Узел самый_левый()
    {
        Узел рез = this;
        while(рез._лево !is пусто)
            рез = рез._лево;
        return рез;
    }

    /**
     * Return the самый_правый descendant of this Узел
     */
    Узел самый_правый()
    {
        Узел рез = this;
        while(рез._право !is пусто)
            рез = рез._право;
        return рез;
    }

    /**
     * Returns the следщ valued Узел in the tree.
     *
     * You should never call this on the marker Узел, as обх is assumed that
     * there is a действителен следщ Узел.
     */
    Узел следщ()
    {
        Узел n = this;
        if(n.право is пусто)
        {
            while(!n.левый_лиУзел)
                n = n._родитель;
            return n._родитель;
        }
        else
            return n.право.самый_левый;
    }

    /**
     * Returns the previous valued Узел in the tree.
     *
     * You should never call this on the самый_левый Узел of the tree as обх is
     * assumed that there is a действителен previous Узел.
     */
    Узел предш()
    {
        Узел n = this;
        if(n.лево is пусто)
        {
            while(n.левый_лиУзел)
                n = n._родитель;
            return n._родитель;
        }
        else
            return n.лево.самый_правый;
    }

    Узел dup(Узел delegate(V v) разм)
    {
        //
        // дубликат this и all child узелs
        //
        // The recursion should be lg(n), so we shouldn't have to worry about
        // стэк размер.
        //
        Узел копируй = разм(значение);
        копируй.цвет = цвет;
        if(_лево !is пусто)
            копируй.лево = _лево.dup(разм);
        if(_право !is пусто)
            копируй.право = _право.dup(разм);
        return копируй;
    }

    Узел dup()
    {
        Узел _дг(V v)
        {
            auto рез = new КЧУзел!(V);
            рез.значение = v;
            return рез;
        }
        return dup(&_дг);
    }
}

/**
 * Implementation of a red black tree.
 *
 * This uses КЧУзел to implement the tree.
 *
 * Набор допускатьДубликаты to true to allow дубликат значения to be inserted.
 */
struct КЧДерево(V, alias функСравнить, alias обновлФункц, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=false, бул обновлять_ли=true)
{
    /**
     * Convenience alias
     */
    alias КЧУзел!(V).Узел Узел;

    /**
     * alias for the Разместитель
     */
    alias Разместитель!(КЧУзел!(V)) разместитель;

    /**
     * The разместитель
     */
    разместитель разм;

    /**
     * The number of узелs in the tree
     */
    бцел счёт;

    /**
     * The marker Узел.  This is the родитель of the root Узел.
     */
    Узел конец;

    /**
     * Setup this КЧДерево.
     */
    проц установка()
    {
        конец = размести();
    }

    /**
     * Add a Узел to the КЧДерево.  Runs in O(lg(n)) time.
     *
     * Returns true if a new Узел was добавленный, false if обх was not.
     *
     * This can also be используется to update a значение if обх is already in the tree.
     */
    бул добавь(V v)
    {
        Узел добавленный;
        if(конец.лево is пусто)
            конец.лево = добавленный = размести(v);
        else
        {
            Узел новРодитель = конец.лево;
            while(true)
            {
                цел значсравн = функСравнить(новРодитель.значение, v);
                if(значсравн == 0)
                {
                    //
                    // found the значение already in the tree.  If duplicates are
                    // allowed, pretend the new значение is greater than this значение.
                    //
                    static if(допускатьДубликаты)
                    {
                        значсравн = -1;
                    }
                    else
                    {
                        static if(обновлять_ли)
                            обновлФункц(новРодитель.значение, v);
                        return false;
                    }
                }
                if(значсравн < 0)
                {
                    Узел nxt = новРодитель.право;
                    if(nxt is пусто)
                    {
                        //
                        // добавь to право of new родитель
                        //
                        новРодитель.право = добавленный = размести(v);
                        break;
                    }
                    else
                        новРодитель = nxt;
                }
                else
                {
                    Узел nxt = новРодитель.лево;
                    if(nxt is пусто)
                    {
                        //
                        // добавь to лево of new родитель
                        //
                        новРодитель.лево = добавленный = размести(v);
                        break;
                    }
                    else
                        новРодитель = nxt;
                }
            }
        }

        //
        // update the tree colors
        //
        добавленный.установиЦвет(конец);

        //
        // did добавь a Узел
        //
        счёт++;
        version(КЧПроверять)
            проверь();
        return true;
    }

    /**
     * Return the lowest-valued Узел in the tree
     */
    Узел начало()
    {
        return конец.самый_левый;
    }

    /**
     * Remove the Узел from the tree.  Returns the следщ Узел in the tree.
     *
     * Do not call this with the marker (конец) Узел.
     */
    Узел удали(Узел z)
    in
    {
        assert(z !is конец);
    }
    body
    {
        счёт--;
        //выведиДерево(конец.лево);
        Узел рез = z.удали(конец);
        static if(разместитель.нужноСвоб)
            разм.освободи(z);
        //выведиДерево(конец.лево);
        version(КЧПроверять)
            проверь();
        return рез;
    }

    /**
     * Find a Узел in the tree with a given значение.  Returns конец if no such
     * Узел exists.
     */
    Узел найди(V v)
    {
        static if(допускатьДубликаты)
        {
            //
            // найди the лево-most v, this allows the pointer to traverse
            // through all the v's.
            //
            Узел тек = конец;
            Узел n = конец.лево;
            while(n !is пусто)
            {
                цел резсравн = функСравнить(n.значение, v);
                if(резсравн < 0)
                {
                    n = n.право;
                }
                else
                {
                    if(резсравн == 0)
                        тек = n;
                    n = n.лево;
                }
            }
            return тек;
        }
        else
        {
            Узел n = конец.лево;
            цел резсравн;
            while(n !is пусто && (резсравн = функСравнить(n.значение, v)) != 0)
            {
                if(резсравн < 0)
                    n = n.право;
                else
                    n = n.лево;
            }
            if(n is пусто)
                return конец;
            return n;
        }
    }

    /**
     * очисти all the узелs from the tree.
     */
    проц очисти()
    {
        static if(разместитель.нужноСвоб)
        {
            разм.освободиВсе();
            конец = размести();
        }
        else
            конец.лево = пусто;
        счёт = 0;
    }

    version(КЧПроверять)
    {
        /**
         * Print the tree.  This prints a sideways view of the tree in ASCII form,
         * with the number of indentations representing the level of the узелs.
         * It does not print значения, only the tree structure и цвет of узелs.
         */
        проц выведиДерево(Узел n, цел отступ = 0)
        {
            if(n !is пусто)
            {
                выведиДерево(n.право, отступ + 2);
                for(цел i = 0; i < отступ; i++)
                    _скажи(".");
                _скажинс(n.цвет == n.цвет.Чёрный ? "Ч" : "К");
                выведиДерево(n.лево, отступ + 2);
            }
            else
            {
                for(цел i = 0; i < отступ; i++)
                    _скажи(".");
                _скажинс("N");
            }
            if(отступ is 0)
                _нс();
        }

        /**
         * Check the tree for validity.  This is called after every добавь or удали.
         * This should only be enabled to debug the implementation of the RB Tree.
         */
        проц проверь()
        {
            //
            // проверь implementation of the tree
            //
            цел recurse(Узел n, ткст путь)
            {
                if(n is пусто)
                    return 1;
                if(n.родитель.лево !is n && n.родитель.право !is n)
                    throw new Искл("Узел на пути " ~ путь ~ " имеет неконсистентные указатели");
                Узел следщ = n.следщ;
                static if(допускатьДубликаты)
                {
                    if(следщ !is конец && функСравнить(n.значение, следщ.значение) > 0)
                        throw new Искл("неверный порядок на пути " ~ путь);
                }
                else
                {
                    if(следщ !is конец && функСравнить(n.значение, следщ.значение) >= 0)
                        throw new Искл("неверный порядок на пути " ~ путь);
                }
                if(n.цвет == n.цвет.Красный)
                {
                    if((n.лево !is пусто && n.лево.цвет == n.цвет.Красный) ||
                            (n.право !is пусто && n.право.цвет == n.цвет.Красный))
                        throw new Искл("Узел на пути " ~ путь ~ " красный с красным отпрыском");
                }

                цел l = recurse(n.лево, путь ~ "Л");
                цел r = recurse(n.право, путь ~ "П");
                if(l != r)
                {
                    _скажнс("Ошибочное дерево на:");
                    выведиДерево(n);
                    throw new Искл("Узел на пути " ~ путь ~ "имеет разное число чёрных узлов по левой и правой тропе");
                }
                return l + (n.цвет == n.цвет.Чёрный ? 1 : 0);
            }

            try
            {
                recurse(конец.лево, "");
            }
            catch(Искл e)
            {
                выведиДерево(конец.лево, 0);
                throw e;
            }
        }
    }

    static if(допускатьДубликаты)
    {
        /**
         * счёт all the times v appears in the collection.
         *
         * Runs in O(m * lg(n)) where m is the number of v экземпляры in the
         * collection, и n is the счёт of the collection.
         */
        бцел считайВсе(V v)
        {
            Узел n = найди(v);
            бцел возврзнач = 0;
            while(n !is конец && функСравнить(n.значение, v) == 0)
            {
                возврзнач++;
                n = n.следщ;
            }
            return возврзнач;
        }

        /**
         * удали all the узелs that сверь v
         *
         * Runs in O(m * lg(n)) where m is the number of v экземпляры in the
         * collection, и n is the счёт of the collection.
         */
        бцел удалиВсе(V v)
        {
            Узел n = найди(v);
            бцел возврзнач = 0;
            while(n !is конец && функСравнить(n.значение, v) == 0)
            {
                n = удали(n);
                возврзнач++;
            }
            return возврзнач;
        }
    }

    
    бцел накладка(Обходчик!(V) поднабор)
    {
        // build a new КЧДерево, only inserting узелs that we already have.
        КЧУзел!(V) новконец;
        auto исхсчёт = счёт;
        счёт = 0;
        foreach(v; поднабор)
        {
            //
            // найди if the Узел is in the текущ tree
            //
            auto z = найди(v);
            if(z !is конец)
            {
                //
                // удали the элемент from the tree, but don't worry about satisfing
                // the Красный-black rules.  we don't care because this tree is
                // going away.
                //
                if(z.лево is пусто)
                {
                    //
                    // no лево Узел, so this is a single parentage line,
                    // move the право Узел to be where we are
                    //
                    if(z.левый_лиУзел)
                        z.родитель.лево = z.право;
                    else
                        z.родитель.право = z.право;
                }
                else if(z.право is пусто)
                {
                    //
                    // no право Узел, single parentage line.
                    //
                    if(z.левый_лиУзел)
                        z.родитель.лево = z.лево;
                    else
                        z.родитель.право = z.лево;
                }
                else
                {
                    //
                    // z имеется both лево и право узелs, swap обх with the следщ
                    // Узел.  Next Узел's лево is guaranteed to be пусто
                    // because обх must be a право child of z, и if обх had a
                    // лево Узел, then обх would not be the следщ Узел.
                    //
                    Узел n = z.следщ;
                    if(n.родитель !is z)
                    {
                        //
                        // n is a descendant of z, but not the immediate
                        // child, we need to link n's родитель to n's право
                        // child.  Note that n must be a лево child or else
                        // n's родитель would have been the следщ Узел.
                        //
                        n.родитель.лево = n.право;
                        n.право = z.право;
                    }
                    // else, n is the direct child of z, which means there is
                    // no need to update n's родитель, or n's право Узел (as n
                    // is the право Узел of z).

                    if(z.левый_лиУзел)
                        z.родитель.лево = n;
                    else
                        z.родитель.право = n;
                    n.лево = z.лево;
                }
                //
                // reinitialize z
                //
                z.цвет = z.цвет.init;
                z.лево = z.право = пусто;

                //
                // put обх into the new tree.
                //
                if(новконец.лево is пусто)
                    новконец.лево = z;
                else
                {
                    //
                    // got to найди the право place for z
                    //
                    Узел новРодитель = новконец.лево;
                    while(true)
                    {
                        auto значсравн = функСравнить(новРодитель.значение, z.значение);

                        // <= handles all cases, including when
                        // допускатьДубликаты is true.
                        if(значсравн <= 0)
                        {
                            Узел nxt = новРодитель.право;
                            if(nxt is пусто)
                            {
                                новРодитель.право = z;
                                break;
                            }
                            else
                                новРодитель = nxt;
                        }
                        else
                        {
                            Узел nxt = новРодитель.лево;
                            if(nxt is пусто)
                            {
                                новРодитель.лево = z;
                                break;
                            }
                            else
                                новРодитель = nxt;
                        }
                    }
                }

                z.установиЦвет(&новконец);
                счёт++;
            }
        }
        static if(разместитель.нужноСвоб)
        {
            //
            // need to освободи all the узелs we are no longer using
            //
            освободиУзел(конец.лево);
        }
        //
        // replace новконец with конец.  If we don't do this, cursors pointing
        // to конец will be invalidated.
        //
        конец.лево = новконец.лево;
        return исхсчёт - счёт;
    }

    static if(разместитель.нужноСвоб)
    {
        private проц освободиУзел(Узел n)
        {
            if(n !is пусто)
            {
                освободиУзел(n.лево);
                освободиУзел(n.право);
                разм.освободи(n);
            }
        }
    }

    проц копируйВ(ref КЧДерево цель)
    {
        цель = *this;

        // make shallow копируй of RBNodes
        цель.конец = конец.dup(&цель.размести);
    }

    Узел размести()
    {
        return разм.размести();
    }

    Узел размести(V v)
    {
        auto рез = размести();
        рез.значение = v;
        return рез;
    }
}

/**
 * используется to define a RB tree that does not require updates.
 */
template КЧДеревоБезОбнова(V, alias функСравнить, alias Разместитель=ДефолтныйРазместитель)
{
    alias КЧДерево!(V, функСравнить, функСравнить, Разместитель, false, false) КЧДеревоБезОбнова;
}
/**
 * используется to define a RB tree that takes duplicates
 */
template КЧДеревоДуб(V, alias функСравнить, alias Разместитель=ДефолтныйРазместитель)
{
    alias КЧДерево!(V, функСравнить, функСравнить, Разместитель, true, false) КЧДеревоДуб;
}
