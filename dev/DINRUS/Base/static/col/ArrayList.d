/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.ArrayList;
public import col.model.List,
       col.model.Keyed;

private struct Array
{
    цел length;
    ук ptr;
}

private extern (C) дол _adSort(Array arr, ИнфОТипе иот);

/***
 * Как обёртка массиву, этот класс обеспечивает необходимую реализацию
 * интерфейса Список (Список)
 *
 * Добавление или удаление любого элемента нарушает соответствие всех курсоров.
 *
 * Класс служит шлюзом между встроенными массивами и классами коллекций.
 * Можно строить МассивСписок с помощью встроенного массива, в качестве
 * средства сохранения, и получать доступ к этому МассивСписку  с помощью функции какМассив.
 * Копии массива не делается, поэтому можно продолжать использовать
 * массив в обеих формах.
 */
class МассивСписок(З) : СКлючом!(бцел, З), Список!(З)
{
    private З[] _массив;
    private бцел _изменение;
    //
    // Примечание о родителе и предке.  Родитель - это массив, список
    // является срезом которого.Предок - наиверхний родитель в линейке.
    // Если срез прибавлен, обх в этом случае создает свой собственный массив, и
    // становится его собственным предком. Он уже не в линейке. Однако
    // _родитель не укстанавливается в пусто, так как обх нужен каждому срезу,
    // которые были подсрезами этого среза. Those should not be invalidated, и they
    // need to have a цепь to their ancestor.  Поэтому, при добавлении в срез данных,
    // обх превращается в пустую ссылку на исходную цепь линейки.
    //
    private МассивСписок!(З) _родитель;
    private МассивСписок!(З) _предок;

    /**
     * Итерирует по элементам в МассивСписок, сообщая обху, какие из них
     * следует удалить
     *
     * Пример использования:
     *
     * -------------
     * // удалить все нечётные элементы
     * foreach(ref удалить_ли, знач; &массивСписок.очистить)
     * {
     *   удалить_ли = (знач & 1) != 0;
     * }
     * ------------
     */
    final цел очистить(цел delegate(ref бул удалить_ли, ref З значение) дг)
    {
        return _примени(дг, _начало, _конец);
    }

    /**
     * Iterate over the элементы in the МассивСписок, telling обх which ones
     * should be removed.
     *
     * Пример использования:
     * -------------
     * // удали all odd indexes
     * foreach(ref удалить_ли, ключ, знач; &arrayList.очистить)
     * {
     *   удалить_ли = (ключ & 1) != 0;
     * }
     * ------------
     */
    final цел чисть_ключ(цел delegate(ref бул удалить_ли, ref бцел ключ, ref З значение) дг)
    {
        return _примени(дг, _начало, _конец);
    }

    /**
     * The массив курсор is exactly like a pointer into the массив.  The only
     * difference between an МассивСписок курсор и a pointer is that the
     * МассивСписок курсор provides the значение property which is common
     * throughout the collection package.
     *
     * All operations on the курсор are O(1)
     */
    struct курсор
    {
        private З *укз;
        alias укз ptr;

        /**
         * дай the значение pointed to
         */
        З значение()
        {
            return *укз;
        }

        /**
         * установи the значение pointed to
         */
        З значение(З знач)
        {
            return (*укз = знач);
        }

        /**
         * increment this курсор, returns что the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз++;
            return врм;
        }

        /**
         * decrement this курсор, returns что the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз--;
            return врм;
        }

        /**
         * increment the курсор by the given amount.
         */
        курсор opAddAssign(цел прир)
        {
            укз += прир;
            return *this;
        }

        /**
         * decrement the курсор by the given amount.
         */
        курсор opSubAssign(цел прир)
        {
            укз -= прир;
            return *this;
        }

        /**
         * return a курсор that is прир элементы beyond this курсор.
         */
        курсор opAdd(цел прир)
        {
            курсор рез = *this;
            рез.ptr += прир;
            return рез;
        }

        /**
         * return a курсор that is прир элементы перед this курсор.
         */
        курсор opSub(цел прир)
        {
            курсор рез = *this;
            рез.ptr -= прир;
            return рез;
        }

        /**
         * return the number of элементы between this курсор и the given
         * курсор.  If обх points to a later элемент, the рез is negative.
         */
        цел opSub(курсор обх)
        {
            return укз - обх.ptr;
        }

        /**
         * сравни two cursors.
         */
        цел opCmp(курсор обх)
        {
            if(укз < обх.ptr)
                return -1;
            if(укз > обх.ptr)
                return 1;
            return 0;
        }

        /**
         * сравни two cursors for equality.
         */
        бул opEquals(курсор обх)
        {
            return укз is обх.ptr;
        }
    }

    /**
     * create a new empty МассивСписок
     */
    this()
    {
        _предок = this;
        _родитель = пусто;
    }

    /**
     * Use an массив as the backing хранилище.  This does not дубликат the
     * массив.  Use new МассивСписок(хранилище.dup) to make a distinct копируй.
     */
    this(З[] хранилище)
    {
        this();
        _массив = хранилище;
    }

    private this(МассивСписок!(З) родитель, курсор s, курсор e)
    {
        _родитель = родитель;
        _предок = родитель._предок;
        _изменение = родитель._изменение;
        проверьИзменение();
        бцел ib = s - родитель._начало;
        бцел ie = e - родитель._начало;
        _массив = родитель._массив[ib..ie];
    }

    /**
     * очисти the container of all значения
     */
    МассивСписок!(З) очисти()
    {
        if(предок_ли)
        {
            _массив = пусто;
            _изменение++;
        }
        else
        {
            удали(_начало, _конец);
        }
        return this;
    }

    /**
     * return the number of элементы in the collection
     */
    бцел длина()
    {
        проверьИзменение();
        return _массив.length;
    }

    alias длина length;
    /**
     * return a курсор that points to the первый элемент in the list.
     */
    курсор начало()
    {
        проверьИзменение();
        return _начало;
    }

    private курсор _начало()
    {
        курсор обх;
        обх.ptr = _массив.ptr;
        return обх;
    }

    /**
     * return a курсор that points to just beyond the последн элемент in the
     * list.
     */
    курсор конец()
    {
        проверьИзменение();
        return _конец;
    }

    private курсор _конец()
    {
        курсор обх;
        обх.ptr = _массив.ptr + _массив.length;
        return обх;
    }


    private цел _примени(цел delegate(ref бул, ref бцел, ref З) дг, курсор старт, курсор последн)
    {
        return _примени(дг, старт, последн, _начало);
    }

    private цел _примени(цел delegate(ref бул, ref бцел, ref З) дг, курсор старт, курсор последн, курсор ссылка)
    {
        цел возврдг;
        if(предок_ли)
        {
            курсор i = старт;
            курсор следщХор = старт;
            курсор конссыл = _конец;

            бул удалить_ли;

            //
            // loop перед removal
            //
            for(; возврдг == 0 && i != последн; i++, следщХор++)
            {
                удалить_ли = false;
                бцел ключ = i - ссылка;
                if((возврдг = дг(удалить_ли, ключ, *i.ptr)) == 0)
                {
                    if(удалить_ли)
                    {
                        //
                        // первый removal
                        //
                        _изменение++;
                        i++;
                        break;
                    }
                }
            }

            //
            // loop after первый removal
            //
            if(следщХор != i)
            {
                for(; i < конссыл; i++, следщХор++)
                {
                    удалить_ли = false;
                    бцел ключ = i - ссылка;
                    if(i >= последн || возврдг != 0 || (возврдг = дг(удалить_ли, ключ, *i.ptr)) != 0)
                    {
                        //
                        // not calling дг any more
                        //
                        следщХор.значение = i.значение;
                    }
                    else if(удалить_ли)
                    {
                        //
                        // дг requested a removal
                        //
                        следщХор--;
                    }
                    else
                    {
                        //
                        // дг did not request a removal
                        //
                        следщХор.значение = i.значение;
                    }
                }
            }

            //
            // shorten the длина
            //
            if(следщХор != конссыл)
            {
                _массив.length = следщХор - _начало;
                return конссыл - следщХор;
            }
        }
        else
        {
            //
            // use the ancestor to perform the apply, then adjust the массив
            // accordingly.
            //
            проверьИзменение();
            auto p = следщРодитель;
            auto оригДлина = p._массив.length;
            возврдг = p._примени(дг, старт, последн, _начало);
            auto чло_Удалённых = оригДлина - p._массив.length;
            if(чло_Удалённых > 0)
            {
                _массив = _массив[0..$-чло_Удалённых];
                _изменение = _предок._изменение;
            }
        }
        return возврдг;
    }

    private цел _примени(цел delegate(ref бул, ref З) дг, курсор старт, курсор последн)
    {
        цел _дг(ref бул b, ref бцел ключ, ref З знач)
        {
            return дг(b, знач);
        }
        return _примени(&_дг, старт, последн);
    }

    private проц проверьИзменение()
    {
        if(_изменение != _предок._изменение)
            throw new Искл("лежащий в основании МассивСписок был изменён");
    }

    private бул предок_ли()
    {
        return _предок is this;
    }

    //
    // Get the следщ родитель in the lineage.  Skip over any parents that do not
    // совместно our ancestor, they are not part of the lineage any more.
    //
    private МассивСписок!(З) следщРодитель()
    {
        auto возврзнач = _родитель;
        while(возврзнач._предок !is _предок)
            возврзнач = возврзнач._родитель;
        return возврзнач;
    }

    /**
     * удали all the элементы from старт to последн, not including the элемент
     * pointed to by последн.  Returns a действителен курсор that points to the
     * элемент последн pointed to.
     *
     * Runs in O(n) time.
     */
    курсор удали(курсор старт, курсор последн)
    {
        if(предок_ли)
        {
            цел проверь(ref бул b, ref З)
            {
                b = true;
                return 0;
            }
            _примени(&проверь, старт, последн);
        }
        else
        {
            проверьИзменение();
            следщРодитель.удали(старт, последн);
            _массив = _массив[0..($ - (последн - старт))];
            _изменение = _предок._изменение;
        }
        return старт;
    }

    /**
     * удали the элемент pointed to by элт.  Equivalent to удали(элт, элт
     * + 1).
     *
     * Runs in O(n) time
     */
    курсор удали(курсор элт)
    {
        return удали(элт, элт + 1);
    }

    /**
     * удали an элемент with the specific значение.  This is an O(n)
     * operation.  If the collection имеется дубликат экземпляры, the первый
     * элемент that совпадает is removed.
     *
     * returns this.
     *
     * Sets удалён_ли to true if the элемент existed и was removed.
     */
    МассивСписок!(З) удали(З знач, ref бул удалён_ли)
    {
        auto обх = найди(знач);
        if(обх == _конец)
            удалён_ли = false;
        else
        {
            удали(обх);
            удалён_ли = true;
        }
        return this;
    }

    /**
     * удали an элемент with the specific значение.  This is an O(n)
     * operation.  If the collection имеется дубликат экземпляры, the первый
     * элемент that совпадает is removed.
     *
     * returns this.
     */
    МассивСписок!(З) удали(З знач)
    {
        бул пропущен;
        return удали(знач, пропущен);
    }

    /**
     * same as найди(знач), but старт at given позиция.
     */
    курсор найди(курсор обх, З знач)
    {
        return _найди(обх, _конец, знач);
    }

    // same as найди(знач), but ищи only a given range at given позиция.
    private курсор _найди(курсор обх, курсор последн,  З знач)
    {
        проверьИзменение();
        while(обх < последн && обх.значение != знач)
            обх++;
        return обх;
    }

    /**
     * найди the первый occurrence of an элемент in the list.  Runs in O(n)
     * time.
     */
    курсор найди(З знач)
    {
        return _найди(_начало, _конец, знач);
    }

    /**
     * returns true if the collection содержит the значение.  Runs in O(n) time.
     */
    бул содержит(З знач)
    {
        return найди(знач) < _конец;
    }

    /**
     * удали the элемент at the given index.  Runs in O(n) time.
     */
    МассивСписок!(З) удалиПо(бцел ключ, ref бул удалён_ли)
    {
        if(ключ > длина)
        {
            удалён_ли = false;
        }
        else
        {
            удали(_начало + ключ);
            удалён_ли = true;
        }
        return this;
    }

    /**
     * удали the элемент at the given index.  Runs in O(n) time.
     */
    МассивСписок!(З) удалиПо(бцел ключ)
    {
        бул пропущен;
        return удалиПо(ключ, пропущен);
    }

    /**
     * дай the значение at the given index.
     */
    З opIndex(бцел ключ)
    {
        проверьИзменение();
        return _массив[ключ];
    }

    /**
     * установи the значение at the given index.
     */
    З opIndexAssign(З значение, бцел ключ)
    {
        проверьИзменение();
        //
        // does not change мутация because
        return _массив[ключ] = значение;
    }

    /**
     * установи the значение at the given index
     */
    МассивСписок!(З) установи(бцел ключ, З значение, ref бул был_добавлен)
    {
        this[ключ] = значение;
        был_добавлен = false;
        return this;
    }

    /**
     * установи the значение at the given index
     */
    МассивСписок!(З) установи(бцел ключ, З значение)
    {
        this[ключ] = значение;
        return this;
    }

    /**
     * iterate over the collection
     */
    цел opApply(цел delegate(ref З значение) дг)
    {
        цел возврзнач;
        курсор конссыл = конец; // call проверьmutation
        for(курсор i = _начало; i != конссыл; i++)
        {
            if((возврзнач = дг(*i.ptr)) != 0)
                break;
        }
        return возврзнач;
    }

    /**
     * iterate over the collection with ключ и значение
     */
    цел opApply(цел delegate(ref бцел ключ, ref З значение) дг)
    {
        цел возврзнач = 0;
        auto ссылка = начало; // call проверьmutation
        auto конссыл = _конец;
        for(курсор i = ссылка; i != конссыл; i++)
        {
            бцел ключ = i - ссылка;
            if((возврзнач = дг(ключ, *i.ptr)) != 0)
                break;
        }
        return возврзнач;
    }

    /**
     * returns true if the given index is действителен
     *
     * Runs in O(1) time
     */
    бул имеетКлюч(бцел ключ)
    {
        return ключ < длина;
    }

    /**
     * добавь the given значение to the конец of the list.  Always returns true.
     */
    МассивСписок!(З) добавь(З знач, ref бул был_добавлен)
    {
        //
        // поставь to this массив.  Reset the ancestor to this, because now we
        // are dealing with a new массив.
        //
        if(предок_ли)
        {
            _массив ~= знач;
            _изменение++;
        }
        else
        {
            _предок = this;
            //
            // ensure that we don't just do an поставь.
            //
            _массив = _массив ~ знач;

            //
            // no need to change the мутация, we are a new ancestor.
            //
        }

        // always succeeds
        был_добавлен = true;
        return this;
    }

    /**
     * добавь the given значение to the конец of the list.
     */
    МассивСписок!(З) добавь(З знач)
    {
        бул пропущен;
        return добавь(знач, пропущен);
    }

    /**
     * adds all элементы from the given обходчик to the конец of the list.
     */
    МассивСписок!(З) добавь(Обходчик!(З) колл)
    {
        бцел пропущен;
        return добавь(колл, пропущен);
    }

    /**
     * adds all элементы from the given обходчик to the конец of the list.
     */
    МассивСписок!(З) добавь(Обходчик!(З) колл, ref бцел чло_добавленных)
    {
        auto al = cast(МассивСписок!(З))колл;
        if(al)
        {
            //
            // optimized case
            //
            return добавь(al._массив, чло_добавленных);
        }

        //
        // генерный case
        //
        проверьИзменение();
        чло_добавленных = колл.length;
        if(чло_добавленных != cast(бцел)-1)
        {
            if(чло_добавленных > 0)
            {
                цел i = _массив.length;
                if(предок_ли)
                {
                    _массив.length = _массив.length + чло_добавленных;
                }
                else
                {
                    _предок = this;
                    auto нов_массив = new З[_массив.length + чло_добавленных];
                    нов_массив[0.._массив.length] = _массив[];

                }
                foreach(знач; колл)
                _массив [i++] = знач;
                _изменение++;
            }
        }
        else
        {
            auto исхдлина = _массив.length;
            бул firstdone = false;
            foreach(знач; колл)
            {
                if(!firstdone)
                {
                    //
                    // trick to дай firstdone установи to true, because был_добавлен is
                    // always установи to true.
                    //
                    добавь(знач, firstdone);
                }
                else
                    _массив ~= знач;
            }
            чло_добавленных = _массив.length - исхдлина;
        }
        return this;
    }


    /**
     * appends the массив to the конец of the list
     */
    МассивСписок!(З) добавь(З[] массив)
    {
        бцел пропущен;
        return добавь(массив, пропущен);
    }

    /**
     * appends the массив to the конец of the list
     */
    МассивСписок!(З) добавь(З[] массив, ref бцел чло_добавленных)
    {
        проверьИзменение();
        чло_добавленных = массив.length;
        if(массив.length)
        {
            if(предок_ли)
            {
                _массив ~= массив;
                _изменение++;
            }
            else
            {
                _предок = this;
                _массив = _массив ~ массив;
            }
        }
        return this;
    }

    /**
     * поставь another list to the конец of this list
     */
    МассивСписок!(З) opCatAssign(Список!(З) rhs)
    {
        return добавь(rhs);
    }

    /**
     * поставь an массив to the конец of this list
     */
    МассивСписок!(З) opCatAssign(З[] массив)
    {
        return добавь(массив);
    }

    /**
     * returns a concatenation of the массив list и another list.
     */
    МассивСписок!(З) opCat(Список!(З) rhs)
    {
        return dup.добавь(rhs);
    }

    /**
     * returns a concatenation of the массив list и an массив.
     */
    МассивСписок!(З) opCat(З[] массив)
    {
        проверьИзменение();
        return new МассивСписок!(З)(_массив ~ массив);
    }

    /**
     * returns a concatenation of the массив list и an массив.
     */
    МассивСписок!(З) opCat_r(З[] массив)
    {
        проверьИзменение();
        return new МассивСписок!(З)(массив ~ _массив);
    }

    /**
     * returns the number of экземпляры of the given элемент значение
     *
     * Runs in O(n) time.
     */
    бцел счёт(З знач)
    {
        бцел экземпляры = 0;
        foreach(x; this)
        if(знач == x)
            экземпляры++;
        return экземпляры;
    }

    /**
     * removes all the экземпляры of the given элемент значение
     *
     * Runs in O(n) time.
     */
    МассивСписок!(З) удалиВсе(З знач, ref бцел чло_Удалённых)
    {
        auto оригДлина = длина;
        foreach(ref b, x; &очистить)
        {
            b = cast(бул)(x == знач);
        }
        чло_Удалённых = длина - оригДлина;
        return this;
    }

    /**
     * removes all the экземпляры of the given элемент значение
     *
     * Runs in O(n) time.
     */
    МассивСписок!(З) удалиВсе(З знач)
    {
        бцел пропущен;
        return удалиВсе(знач, пропущен);
    }

    /**
     * Returns a slice of an массив list.  A slice can be используется to view
     * элементы, удали элементы, but cannot be используется to добавь элементы.
     *
     * The returned slice begins at index b и ends at, but does not include,
     * index e.
     */
    МассивСписок!(З) opSlice(бцел b, бцел e)
    {
        return opSlice(_начало + b, _начало + e);
    }

    /**
     * Slice an массив given the cursors
     */
    МассивСписок!(З) opSlice(курсор b, курсор e)
    {
        if(e > конец || b < _начало) // call проверьИзменение once
            throw new Искл("значение среза вне диапазона");

        //
        // make an массив list that is a slice of this массив list
        //
        return new МассивСписок!(З)(this, b, e);
    }

    /**
     * Returns a копируй of an массив list
     */
    МассивСписок!(З) dup()
    {
        return new МассивСписок!(З)(_массив.dup);
    }

    /**
     * дай the массив that this массив represents.  This is NOT a копируй of the
     * data, so modifying элементы of this массив will modify элементы of the
     * original МассивСписок.  Appending элементы from this массив will not affect
     * the original массив list just like appending to an массив will not affect
     * the original.
     */
    З[] какМассив()
    {
        return _массив;
    }

    /**
     * operator to сравни two objects.
     *
     * If o is a Список!(З), then this does a list сравни.
     * If o is пусто or not an МассивСписок, then the return значение is 0.
     */
    цел opEquals(Объект o)
    {
        if(o !is пусто)
        {
            auto li = cast(Список!(З))o;
            if(li !is пусто && li.length == длина)
            {
                auto al = cast(МассивСписок!(З))o;
                if(al !is пусто)
                    return _массив == al._массив;
                else
                {
                    цел i = 0;
                    foreach(элт; li)
                    {
                        if(элт != _массив[i++])
                            return 0;
                    }

                    //
                    // equal
                    //
                    return 1;
                }
            }

        }
        //
        // no comparison possible.
        //
        return 0;
    }

    /**
     * Сравни to a З массив.
     *
     * equivalent to какМассив == массив.
     */
    цел opEquals(З[] массив)
    {
        return _массив == массив;
    }

    /**
     *  Look at the элемент at the фронт of the МассивСписок.
     */
    З фронт()
    {
        return начало.значение;
    }

    /**
     * Look at the элемент at the конец of the МассивСписок.
     */
    З тыл()
    {
        return (конец - 1).значение;
    }

    /**
     * Remove the элемент at the фронт of the МассивСписок и return its значение.
     * This is an O(n) operation.
     */
    З возьмиФронт()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }

    /**
     * Remove the элемент at the конец of the МассивСписок и return its значение.
     * This can be an O(n) operation.
     */
    З возьмиТыл()
    {
        auto c = конец - 1;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }

    /**
     * Get the index of a particular значение.  Equivalent to найди(знач) - начало.
     *
     * If the значение isn't in the collection, returns длина.
     */
    бцел индексУ(З знач)
    {
        return найди(знач) - начало;
    }

    class ОсобоеИнфОТипе(бул использоватьФункцию) : ИнфОТипе
    {
        static if(использоватьФункцию)
            alias цел function(ref З v1, ref З v2) ФункцСравнения;
        else
            alias цел delegate(ref З v1, ref З v2) ФункцСравнения;
        private ФункцСравнения cf;
        private ИнфОТипе производныйОт;
        this(ИнфОТипе производныйОт, ФункцСравнения comp)
        {
            this.производныйОт = производныйОт;
            this.cf = comp;
        }

        /// Returns a хэш of the instance of a type.
        override hash_t дайХэш(ук p)
        {
            return производныйОт.дайХэш(p);
        }

        /// Compares two экземпляры for equality.
        override цел equals(ук p1, ук p2)
        {
            return производныйОт.equals(p1, p2);
        }

        /// Compares two экземпляры for &lt;, ==, or &gt;.
        override цел сравни(ук p1, ук p2)
        {
            return cf(*cast(З *)p1, *cast(З *)p2);
        }

        /// Returns размер of the type.
        override size_t tsize()
        {
            return производныйОт.tsize();
        }

        /// Swaps two экземпляры of the type.
        override проц swap(ук p1, ук p2)
        {
            return производныйОт.swap(p1, p2);
        }

        /// Get ИнфОТипе for 'следщ' type, as defined by что kind of type this is,
        /// пусто if none.
        override ИнфОТипе следщ()
        {
            return производныйОт;
        }

        /// Return default initializer, пусто if default initialize to 0
        override проц[] init()
        {
            return производныйОт.init();
        }

        /// Get flags for type: 1 means GC should scan for pointers
        override бцел flags()
        {
            return производныйОт.flags();
        }

        /// Get type information on the contents of the type; пусто if not available
        override OffsetTypeInfo[] offTi()
        {
            return производныйОт.offTi();
        }
    }

    /**
     * Sort according to a given comparison function
     */
    МассивСписок сортируй(цел delegate(ref З v1, ref З v2) comp)
    {
        //
        // can't really do this without extra library помощь.  Luckily, the
        // function to сортируй an массив is always defined by the runtime.  We
        // just need to доступ обх.  However, обх требует that we pass in a
        // ИнфОТипе structure to do all the dirty work.  What we need is a
        // derivative of the real ИнфОТипе structure with the сравни function
        // overridden to call the comp function.
        //
        //scope ОсобоеИнфОТипе!(typeof(typeid(З))) sti = new ОсобоеИнфОТипе(comp);
        scope sti = new ОсобоеИнфОТипе!(false)(typeid(З), comp);
        цел x;
        Array ar;
        ar.length = _массив.length;
        ar.ptr = _массив.ptr;
        _adSort(ar, sti);
        return this;
    }

    /**
     * Sort according to a given comparison function
     */
    МассивСписок сортируй(цел function(ref З v1, ref З v2) comp)
    {
        //
        // can't really do this without extra library помощь.  Luckily, the
        // function to сортируй an массив is always defined by the runtime.  We
        // just need to доступ обх.  However, обх требует that we pass in a
        // ИнфОТипе structure to do all the dirty work.  What we need is a
        // derivative of the real ИнфОТипе structure with the сравни function
        // overridden to call the comp function.
        //
        //scope ОсобоеИнфОТипе!(typeof(typeid(З))) sti = new ОсобоеИнфОТипе(comp);
        scope sti = new ОсобоеИнфОТипе!(true)(typeid(З), comp);
        цел x;
        Array ar;
        ar.length = _массив.length;
        ar.ptr = _массив.ptr;
        _adSort(ar, sti);
        return this;
    }

    /**
     * Sort according to the default comparison routine for З
     */
    МассивСписок сортируй()
    {
        _массив.sort;
        return this;
    }
}

version(UnitTest)
{
    unittest
    {
        auto al = new МассивСписок!(бцел);
        al.добавь([0U, 1, 2, 3, 4, 5]);
        assert(al.length == 6);
        al.добавь(al[0..3]);
        assert(al.length == 9);
        foreach(ref dp, бцел инд, бцел знач; &al.чисть_ключ)
        dp = (знач % 2 == 1);
        assert(al.length == 5);
        assert(al == [0U, 2, 4, 0, 2]);
        assert(al == new МассивСписок!(бцел)([0U, 2, 4, 0, 2].dup));
        assert(al.начало.ptr is al.какМассив.ptr);
        assert(al.конец.ptr is al.какМассив.ptr + al.length);
    }
}
