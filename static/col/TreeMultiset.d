/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.TreeMultiset;

public import col.model.Multiset;
public import col.Functions;

private import col.RBTree;

/**
 * Implementation of the Мультинабор interface using Красный-Чёрный trees.  this
 * allows for O(lg(n)) insertion, removal, и lookup times.  It also creates
 * a sorted установи of элементы.  З must be comparable.
 *
 * Adding an элемент does not invalidate any cursors.
 *
 * Removing an элемент only invalidates the cursors that were pointing at
 * that элемент.
 *
 * You can replace the Tree implementation with a custom implementation, the
 * implementation must be a struct template which can be instantiated with a
 * single template аргумент З, и must implement the following members
 * (non-function members can be properties unless otherwise specified):
 *
 * parameters -> must be a struct with at least the following members:
 *   функцСравнения -> the сравни function to use (should be a
 *                      ФункцСравнения!(З))
 *
 * проц установка(parameters p) -> initializes the tree with the given parameters.
 *
 * бцел счёт -> счёт of the элементы in the tree
 *
 * Узел -> must be a struct/class with the following members:
 *   З значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   Узел следщ -> the следщ Узел in the tree as defined by the сравни
 *                function, or конец if no other узелs exist.
 *   Узел предш -> the previous Узел in the tree as defined by the сравни
 *                function.
 *
 * бул добавь(З знач) -> добавь the given значение to the tree according to the order
 * defined by the сравни function.  If the элемент already exists in the
 * tree, the function should добавь обх after all equivalent элементы.
 *
 * Узел начало -> must be a Узел that points to the very первый действителен
 * элемент in the tree, or конец if no элементы exist.
 *
 * Узел конец -> must be a Узел that points to just past the very последн
 * действителен элемент.
 *
 * Узел найди(З знач) -> returns a Узел that points to the первый элемент in the
 * tree that содержит знач, or конец if the элемент doesn't exist.
 *
 * Узел удали(Узел p) -> removes the given элемент from the tree,
 * returns the следщ действителен элемент or конец if p was последн in the tree.
 *
 * проц очисти() -> removes all элементы from the tree, sets счёт to 0.
 *
 * бцел считайВсе(З знач) -> returns the number of элементы with the given значение.
 *
 * Узел удалиВсе(З знач) -> removes all the given значения from the tree.
 */
class ДеревоМультинабор(З, alias ШаблРеализац = КЧДеревоДуб, alias функцСравнения=ДефСравнить) : Мультинабор!(З)
{
    /**
     * convenience alias
     */
    alias ШаблРеализац!(З, функцСравнения) Реализ;

    private Реализ _дерево;

    /**
     * курсор for the tree multiset
     */
    struct курсор
    {
        private Реализ.Узел укз;
        alias укз ptr;

        /**
         * дай the значение in this элемент
         */
        З значение()
        {
            return укз.значение;
        }

        /**
         * increment this курсор, returns что the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз = укз.следщ;
            return врм;
        }

        /**
         * decrement this курсор, returns что the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз = укз.предш;
            return врм;
        }

        /**
         * increment the курсор by the given amount.
         *
         * This is an O(прир) operation!  You should only use this operator in
         * the form:
         *
         * ++i;
         */
        курсор opAddAssign(цел прир)
        {
            if(прир < 0)
                return opSubAssign(-прир);
            while(прир--)
                укз = укз.следщ;
            return *this;
        }

        /**
         * decrement the курсор by the given amount.
         *
         * This is an O(прир) operation!  You should only use this operator in
         * the form:
         *
         * --i;
         */
        курсор opSubAssign(цел прир)
        {
            if(прир < 0)
                return opAddAssign(-прир);
            while(прир--)
                укз = укз.предш;
            return *this;
        }

        /**
         * сравни two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.ptr is укз;
        }
    }

    /**
     * Iterate through the элементы of the collection, specifying which ones
     * should be removed.
     *
     * Use like this:
     * -------------
     * // удали all odd элементы
     * foreach(ref чистить_ли, знач; &treeMultiset.очистить)
     * {
     *   чистить_ли = ((знач % 1) == 1);
     * }
     * -------------
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref З знач) дг)
    {
        return _примени(дг);
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref З знач) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // кэш конец so обх isn't always being generated
        while(!возврдг && обх != _конец)
        {
            //
            // don't allow user to change значение
            //
            З врмзначение = обх.значение;
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, врмзначение)) != 0)
                break;
            if(чистить_ли)
                обх = удали(обх);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * iterate over the collection's значения
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел _дг(ref бул чистить_ли, ref З знач)
        {
            return дг(знач);
        }
        return _примени(&_дг);
    }

    /**
     * Instantiate the tree multiset
     */
    this()
    {
        _дерево.установка();
    }

    //
    // for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_дерево);
    }

    /**
     * Clear the collection of all элементы
     */
    ДеревоМультинабор очисти()
    {
        _дерево.очисти();
        return this;
    }

    /**
     * returns number of элементы in the collection
     */
    бцел длина()
    {
        return _дерево.счёт;
    }
    alias длина length;

    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _дерево.начало;
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _дерево.конец;
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    курсор удали(курсор обх)
    {
        обх.ptr = _дерево.удали(обх.ptr);
        return обх;
    }

    /**
     * найди the первый instance of a given значение in the collection.  Returns
     * конец if the значение is not present.
     *
     * Runs in O(lg(n)) time.
     */
    курсор найди(З знач)
    {
        курсор обх;
        обх.ptr = _дерево.найди(знач);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    бул содержит(З знач)
    {
        return найди(знач) != конец;
    }

    /**
     * Removes the первый элемент that имеется the значение знач.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(З знач)
    {
        курсор обх = найди(знач);
        if(обх != конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the первый элемент that имеется the значение знач.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(З знач, ref бул удалён_ли)
    {
        курсор обх = найди(знач);
        if(обх == конец)
        {
            удалён_ли = false;
        }
        else
        {
            удали(обх);
            удалён_ли = true;
        }
        return this;
    }

    /**
     * Adds a значение to the collection.
     * Returns this.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор добавь(З знач)
    {
        _дерево.добавь(знач);
        return this;
    }

    /**
     * Adds a значение to the collection. Sets был_добавлен to true if the значение was
     * добавленный.
     *
     * Returns this.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор добавь(З знач, ref бул был_добавлен)
    {
        был_добавлен = _дерево.добавь(знач);
        return this;
    }

    /**
     * Adds all the значения from the обходчик to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * the обходчик.
     */
    ДеревоМультинабор добавь(Обходчик!(З) обх)
    {
        foreach(знач; обх)
        _дерево.добавь(знач);
        return this;
    }

    /**
     * Adds all the значения from the обходчик to the collection. Sets чло_добавленных
     * to the number of значения добавленный from the обходчик.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * the обходчик.
     */
    ДеревоМультинабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(обх);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Adds all the значения from массив to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * массив.
     */
    ДеревоМультинабор добавь(З[] массив)
    {
        foreach(знач; массив)
        _дерево.добавь(знач);
        return this;
    }

    /**
     * Adds all the значения from массив to the collection.  Sets чло_добавленных to the
     * number of элементы добавленный from the массив.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * массив.
     */
    ДеревоМультинабор добавь(З[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(массив);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Returns the number of элементы in the collection that are equal to знач.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы that are знач.
     */
    бцел счёт(З знач)
    {
        return _дерево.считайВсе(знач);
    }

    /**
     * Removes all the элементы that are equal to знач.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы that are знач.
     */
    ДеревоМультинабор удалиВсе(З знач)
    {
        _дерево.удалиВсе(знач);
        return this;
    }

    /**
     * Removes all the элементы that are equal to знач.  Sets чло_Удалённых to the
     * number of элементы removed from the multiset.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы that are знач.
     */
    ДеревоМультинабор удалиВсе(З знач, ref бцел чло_Удалённых)
    {
        чло_Удалённых = _дерево.удалиВсе(знач);
        return this;
    }

    /**
     * дубликат this tree multiset
     */
    ДеревоМультинабор dup()
    {
        return new ДеревоМультинабор(_дерево);
    }

    /**
     * дай the most convenient элемент in the установи.  This is the элемент that
     * would be iterated первый.  Therefore, calling удали(дай()) is
     * guaranteed to be less than an O(n) operation.
     */
    З дай()
    {
        return начало.значение;
    }

    /**
     * Remove the most convenient элемент from the установи, и return its значение.
     * This is equivalent to удали(дай()), except that only one lookup is
     * performed.
     */
    З изыми()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }
}

version(UnitTest)
{
    unittest
    {
        auto tms = new ДеревоМультинабор!(бцел);
        Мультинабор!(бцел) мс = tms;
        мс.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(мс.length == 7);
        assert(мс.счёт(5U) == 2);
        foreach(ref чистить_ли, i; &мс.очистить)
        чистить_ли = (i % 2 == 1);
        assert(мс.счёт(5U) == 0);
        assert(мс.length == 3);
    }
}
