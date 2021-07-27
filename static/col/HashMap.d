/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.HashMap;

public import col.model.Map;
public import col.Functions;
private import col.Hash;

private import col.Iterators;

/**
 * Реализация карты, использующая Хэш для ближней вставки O(1),
 * удаления и поиска по времени.
 *
 * Добавка элемента может вывести из строя курсоры, в зависимости от реализации.
 *
 * Удаление элемента выводит из строя лишь те курсоры, которые указывали на
 * данный элемент.
 *
 * Реализацию Хэш можно заменить на адаптированную, этот
 * Хэш должен быть шаблонной структурой, инстанциируемой единственным
 * шаблонным аргументом З, и реализующей следующие члены (члены, не функции,
 * могут быть свойствами дай/установи, если иное не указано):
 *
 *
 * parameters -> must be a struct with at least the following members:
 *   хэшФункц -> the хэш function to use (should be a ХэшФунк!(З))
 *   обновлФункц -> the update function to use (should be an
 *                     ФункцОбновления!(З))
 *
 * проц установка(parameters p) -> initializes the хэш with the given parameters.
 *
 * бцел счёт -> счёт of the элементы in the хэш
 *
 * позиция -> must be a struct/class with the following member:
 *   укз -> must define the following member:
 *     значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   позиция следщ -> следщ позиция in the хэш map
 *   позиция предш -> previous позиция in the хэш map
 *
 * бул добавь(З знач) -> добавь the given значение to the хэш.  The хэш of the значение
 * will be given by хэшФункц(знач).  If the значение already exists in the хэш,
 * this should call обновлФункц(знач) и should not increment счёт.
 *
 * позиция начало -> must be a позиция that points to the very первый действителен
 * элемент in the хэш, or конец if no элементы exist.
 *
 * позиция конец -> must be a позиция that points to just past the very последн
 * действителен элемент.
 *
 * позиция найди(З знач) -> returns a позиция that points to the элемент that
 * содержит знач, or конец if the элемент doesn't exist.
 *
 * позиция удали(позиция p) -> removes the given элемент from the хэш,
 * returns the следщ действителен элемент or конец if p was последн in the хэш.
 *
 * проц очисти() -> removes all элементы from the хэш, sets счёт to 0.
 */
class ХэшКарта(К, З, alias ШаблРеализац=Хэш, alias хэшФункц=ДефХэш) : Карта!(К, З)
{
    /**
     * используется to implement the ключ/значение пара stored in the хэш implementation
     */
    struct элемент
    {
        К ключ;
        З знач;

        /**
         * сравни 2 элементы for equality.  Only compares the ключи.
         */
        цел opEquals(элемент e)
        {
            return ключ == e.ключ;
        }
    }

    private КлючОбходчик _ключи;

    /**
     * Function to дай the хэш of an элемент
     */
    static бцел _хэшФункция(ref элемент e)
    {
        return хэшФункц(e.ключ);
    }

    /**
     * Function to update an элемент according to the new элемент.
     */
    static проц _функцияОбнова(ref элемент исх, ref элемент новэлт)
    {
        //
        // only копируй the значение, leave the ключ alone
        //
        исх.знач = новэлт.знач;
    }

    /**
     * convenience alias
     */
    alias ШаблРеализац!(элемент, _хэшФункция, _функцияОбнова) Реализ;

    private Реализ _хэш;

    /**
     * A курсор for the хэш map.
     */
    struct курсор
    {
        private Реализ.позиция позиция;

        /**
         * дай the значение at this курсор
         */
        З значение()
        {
            return позиция.ptr.значение.знач;
        }

        /**
         * дай the ключ at this курсор
         */
        К ключ()
        {
            return позиция.ptr.значение.ключ;
        }

        /**
         * установи the значение at this курсор
         */
        З значение(З знач)
        {
            позиция.ptr.значение.знач = знач;
            return знач;
        }

        /**
         * increment this курсор, returns что the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            позиция = позиция.следщ;
            return врм;
        }

        /**
         * decrement this курсор, returns что the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            позиция = позиция.предш;
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
                позиция = позиция.следщ;
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
                позиция = позиция.предш;
            return *this;
        }

        /**
         * сравни two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.позиция is позиция;
        }
    }

    /**
     * Iterate over the значения of the ХэшКарта, telling обх which ones to
     * удали.
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref З знач) дг)
    {
        цел _дг(ref бул чистить_ли, ref К ключ, ref З знач)
        {
            return дг(чистить_ли, знач);
        }
        return _примени(&_дг);
    }

    /**
     * Iterate over the ключ/значение pairs of the ХэшКарта, telling обх which ones
     * to удали.
     */
    final цел чисть_ключ(цел delegate(ref бул чистить_ли, ref К ключ, ref З знач) дг)
    {
        return _примени(дг);
    }

    private class КлючОбходчик : Обходчик!(К)
    {
        final бцел длина()
        {
            return this.outer.length;
        }

        alias длина length;

        final цел opApply(цел delegate(ref К) дг)
        {
            цел _дг(ref бул чистить_ли, ref К ключ, ref З знач)
            {
                return дг(ключ);
            }
            return _примени(&_дг);
        }
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref К ключ, ref З знач) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // кэш конец so обх isn't always being generated
        while(!возврдг && обх != _конец)
        {
            //
            // don't allow user to change ключ
            //
            К врмключ = обх.ключ;
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, врмключ, обх.позиция.ptr.значение.знач)) != 0)
                break;
            if(чистить_ли)
                обх = удали(обх);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * iterate over the collection's ключ/значение pairs
     */
    цел opApply(цел delegate(ref К ключ, ref З знач) дг)
    {
        цел _дг(ref бул чистить_ли, ref К ключ, ref З знач)
        {
            return дг(ключ, знач);
        }

        return _примени(&_дг);
    }

    /**
     * iterate over the collection's значения
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел _дг(ref бул чистить_ли, ref К ключ, ref З знач)
        {
            return дг(знач);
        }
        return _примени(&_дг);
    }

    /**
     * Instantiate the хэш map
     */
    this()
    {
        // установка any хэш info that needs to be done
        _хэш.установка();
        _ключи = new КлючОбходчик;
    }

    //
    // private constructor for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_хэш);
        _ключи = new КлючОбходчик;
    }

    /**
     * Clear the collection of all элементы
     */
    ХэшКарта очисти()
    {
        _хэш.очисти();
        return this;
    }

    /**
     * returns number of элементы in the collection
     */
    бцел длина()
    {
        return _хэш.счёт;
    }
    alias длина length;

    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.позиция = _хэш.начало();
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.позиция = _хэш.конец();
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs on average in O(1) time.
     */
    курсор удали(курсор обх)
    {
        обх.позиция = _хэш.удали(обх.позиция);
        return обх;
    }

    /**
     * найди a given значение in the collection starting at a given курсор.
     * This is useful to iterate over all элементы that have the same значение.
     *
     * Runs in O(n) time.
     */
    курсор найдиЗначение(курсор обх, З знач)
    {
        return _найдиЗначение(обх, конец, знач);
    }

    /**
     * найди an instance of a значение in the collection.  Equivalent to
     * найдиЗначение(начало, знач);
     *
     * Runs in O(n) time.
     */
    курсор найдиЗначение(З знач)
    {
        return _найдиЗначение(начало, конец, знач);
    }

    private курсор _найдиЗначение(курсор обх, курсор последн, З знач)
    {
        while(обх != последн && обх.значение != знач)
            обх++;
        return обх;
    }

    /**
     * найди the instance of a ключ in the collection.  Returns конец if the ключ
     * is not present.
     *
     * Runs in average O(1) time.
     */
    курсор найди(К ключ)
    {
        курсор обх;
        элемент врм;
        врм.ключ = ключ;
        обх.позиция = _хэш.найди(врм);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(n) time.
     */
    бул содержит(З знач)
    {
        return найдиЗначение(знач) != конец;
    }

    /**
     * Removes the первый элемент that имеется the значение знач.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удали(З знач)
    {
        бул пропущен;
        return удали(знач, пропущен);
    }

    /**
     * Removes the первый элемент that имеется the значение знач.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удали(З знач, ref бул удалён_ли)
    {
        курсор обх = найдиЗначение(знач);
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
     * Removes the элемент that имеется the given ключ.  Returns true if the
     * элемент was present и was removed.
     *
     * Runs on average in O(1) time.
     */
    ХэшКарта удалиПо(К ключ)
    {
        бул пропущен;
        return удалиПо(ключ, пропущен);
    }

    /**
     * Removes the элемент that имеется the given ключ.  Returns true if the
     * элемент was present и was removed.
     *
     * Runs on average in O(1) time.
     */
    ХэшКарта удалиПо(К ключ, ref бул удалён_ли)
    {
        курсор обх = найди(ключ);
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
     * Returns the значение that is stored at the элемент which имеется the given
     * ключ.  Throws an exception if the ключ is not in the collection.
     *
     * Runs on average in O(1) time.
     */
    З opIndex(К ключ)
    {
        курсор обх = найди(ключ);
        if(обх == конец)
            throw new Искл("Индекс вне диапазона");
        return обх.значение;
    }

    /**
     * assign the given значение to the элемент with the given ключ.  If the ключ
     * does not exist, adds the ключ и значение to the collection.
     *
     * Runs on average in O(1) time.
     */
    З opIndexAssign(З значение, К ключ)
    {
        установи(ключ, значение);
        return значение;
    }

    /**
     * Набор a ключ/значение пара.  If the ключ/значение пара doesn't already exist, обх
     * is добавленный.
     */
    ХэшКарта установи(К ключ, З значение)
    {
        бул пропущен;
        return установи(ключ, значение, пропущен);
    }

    /**
     * Набор a ключ/значение пара.  If the ключ/значение пара doesn't already exist, обх
     * is добавленный, и the был_добавлен parameter is установи to true.
     */
    ХэшКарта установи(К ключ, З значение, ref бул был_добавлен)
    {
        элемент элт;
        элт.ключ = ключ;
        элт.знач = значение;
        был_добавлен = _хэш.добавь(элт);
        return this;
    }

    /**
     * Набор all the значения from the обходчик in the map.  If any элементы did
     * not previously exist, they are добавленный.
     */
    ХэшКарта установи(Ключник!(К, З) исток)
    {
        бцел пропущен;
        return установи(исток, пропущен);
    }

    /**
     * Набор all the значения from the обходчик in the map.  If any элементы did
     * not previously exist, they are добавленный.  чло_добавленных is установи to the number of
     * элементы that were добавленный in this operation.
     */
    ХэшКарта установи(Ключник!(К, З) исток, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        бул пропущен;
        foreach(ключ, знач; исток)
        {
            установи(ключ, знач, пропущен);
        }
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Remove all ключи from the map which are in поднабор.
     */
    ХэшКарта удали(Обходчик!(К) поднабор)
    {
        foreach(ключ; поднабор)
        удалиПо(ключ);
        return this;
    }

    /**
     * Remove all ключи from the map which are in поднабор.  чло_Удалённых is установи to
     * the number of ключи that were actually removed.
     */
    ХэшКарта удали(Обходчик!(К) поднабор, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        удали(поднабор);
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    ХэшКарта накладка(Обходчик!(К) поднабор)
    {
        бцел пропущен;
        return накладка(поднабор, пропущен);
    }

    /**
     * Эта функция сохраняет только элементы, наблюдаемые в поднаборе.
     */
    ХэшКарта накладка(Обходчик!(К) поднабор, ref бцел чло_Удалённых)
    {
        //
        // this one is a bit trickier than removing.  We want to найди each
        // Хэш элемент, then move обх to a new таблица.  However, we do not own
        // the implementation и cannot make assumptions about the
        // implementation.  So we defer the intersection to the хэш
        // implementation.
        //
        // If we didn't care about runtime, this could be done with:
        //
        // удали((new ХэшНабор!(К)).добавь(this.ключи).удали(поднабор));
        //

        //
        // need to create a wrapper обходчик to pass to the implementation,
        // one that wraps each ключ in the поднабор as an элемент
        //
        // scope allocates on the стэк.
        //
        scope w = new ТрансформОбходчик!(элемент, К)(поднабор, function проц(ref К ключ, ref элемент e)
        {
            e.ключ = ключ;
        });

        чло_Удалённых = _хэш.накладка(w);
        return this;
    }

    /**
     * Returns true if the given ключ is in the collection.
     *
     * Runs on average in O(1) time.
     */
    бул имеетКлюч(К ключ)
    {
        return найди(ключ) != конец;
    }

    /**
     * Returns the number of элементы that contain the значение знач
     *
     * Runs in O(n) time.
     */
    бцел счёт(З знач)
    {
        бцел экземпляры = 0;
        foreach(x; this)
        {
            if(x == знач)
                экземпляры++;
        }
        return экземпляры;
    }

    /**
     * Remove all the элементы that contain the значение знач.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удалиВсе(З знач)
    {
        бцел пропущен;
        return удалиВсе(знач, пропущен);
    }
    /**
     * Remove all the элементы that contain the значение знач.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удалиВсе(З знач, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        foreach(ref b, x; &очистить)
        {
            b = cast(бул)(x == знач);
        }
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    /**
     * return an обходчик that can be используется to read all the ключи
     */
    Обходчик!(К) ключи()
    {
        return _ключи;
    }

    /**
     * Make a shallow копируй of the хэш map.
     */
    ХэшКарта dup()
    {
        return new ХэшКарта(_хэш);
    }

    /**
     * Сравни this ХэшКарта with another Карта
     *
     * Returns 0 if o is not a Карта object, is пусто, or the ХэшКарта does not
     * contain the same ключ/значение pairs as the given map.
     * Returns 1 if exactly the ключ/значение pairs contained in the given map are
     * in this ХэшКарта.
     */
    цел opEquals(Объект o)
    {
        //
        // try casting to map, otherwise, don't сравни
        //
        auto m = cast(Карта!(К, З))o;
        if(m !is пусто && m.length == длина)
        {
            auto _конец = конец;
            foreach(К ключ, З знач; m)
            {
                auto cu = найди(ключ);
                if(cu is _конец || cu.значение != знач)
                    return 0;
            }
            return 1;
        }

        return 0;
    }

    /**
     * Набор all the элементы from the given associative массив in the map.  Any
     * ключ that already exists will be overridden.
     *
     * returns this.
     */
    ХэшКарта установи(З[К] исток)
    {
        foreach(К ключ, З знач; исток)
        this[ключ] = знач;
        return this;
    }

    /**
     * Набор all the элементы from the given associative массив in the map.  Any
     * ключ that already exists will be overridden.
     *
     * sets чло_добавленных to the number of ключ значение pairs that were добавленный.
     *
     * returns this.
     */
    ХэшКарта установи(З[К] исток, ref бцел чло_добавленных)
    {
        бцел оригДлина = длина;
        установи(исток);
        чло_добавленных = длина - оригДлина;
        return this;
    }

    /**
     * Remove all the given ключи from the map.
     *
     * return this.
     */
    ХэшКарта удали(К[] поднабор)
    {
        foreach(ключ; поднабор)
        удалиПо(ключ);
        return this;
    }

    /**
     * Remove all the given ключи from the map.
     *
     * return this.
     *
     * чло_Удалённых is установи to the number of элементы removed.
     */
    ХэшКарта удали(К[] поднабор, ref бцел чло_Удалённых)
    {
        бцел оригДлина = длина;
        удали(поднабор);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * returns this.
     */
    ХэшКарта накладка(К[] поднабор)
    {
        scope обход = new ОбходчикМассива!(К)(поднабор);
        return накладка(обход);
    }

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * sets чло_Удалённых to the number of элементы removed.
     *
     * returns this.
     */
    ХэшКарта накладка(К[] поднабор, ref бцел чло_Удалённых)
    {
        scope обход = new ОбходчикМассива!(К)(поднабор);
        return накладка(обход, чло_Удалённых);
    }
}

version(UnitTest)
{
    unittest
    {
        ХэшКарта!(бцел, бцел) hm = new ХэшКарта!(бцел, бцел);
        Карта!(бцел, бцел) m = hm;
        for(цел i = 0; i < 10; i++)
            hm[i * i + 1] = i;
        assert(hm.length == 10);
        foreach(ref чистить_ли, ключ, знач; &hm.чисть_ключ)
        {
            чистить_ли = (знач % 2 == 1);
        }
        assert(hm.length == 5);
        assert(hm.содержит(6));
        assert(hm.имеетКлюч(6 * 6 + 1));
    }
}
