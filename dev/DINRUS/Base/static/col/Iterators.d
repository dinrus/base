/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

   This is a collection of useful iterators, и обходчик
   functions.
**********************************************************/
module col.Iterators;

public import col.model.Iterator;

/**
 * This обходчик transforms every элемент from another обходчик using a
 * transformation function.
 */
class ТрансформОбходчик(З, U=З) : Обходчик!(З)
{
    private Обходчик!(U) _ист;
    private проц delegate(ref U, ref З) _дг;
    private проц function(ref U, ref З) _фн;

    /**
     * Construct a transform обходчик using a transform delegate.
     *
     * The transform function transforms a type U object into a type З object.
     */
    this(Обходчик!(U) исток, проц delegate(ref U, ref З) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a transform обходчик using a transform function pointer.
     *
     * The transform function transforms a type U object into a type З object.
     */
    this(Обходчик!(U) исток, проц function(ref U, ref З) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns the длина that the исток provides.
     */
    бцел длина()
    {
        return _ист.length;
    }
    alias длина length;
    /**
     * Iterate through the исток обходчик, working with temporary copies of a
     * transformed З элемент.
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел privateDG(ref U u)
        {
            З знач;
            _дг(u, знач);
            return дг(знач);
        }

        цел privateFN(ref U u)
        {
            З знач;
            _фн(u, знач);
            return дг(знач);
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Transform for a keyed обходчик
 */
class ТрансформКлючник(К, З, J=К, U=З) : Ключник!(К, З)
{
    private Ключник!(J, U) _ист;
    private проц delegate(ref J, ref U, ref К, ref З) _дг;
    private проц function(ref J, ref U, ref К, ref З) _фн;

    /**
     * Construct a transform обходчик using a transform delegate.
     *
     * The transform function transforms a J, U пара into a К, З пара.
     */
    this(Ключник!(J, U) исток, проц delegate(ref J, ref U, ref К, ref З) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a transform обходчик using a transform function pointer.
     *
     * The transform function transforms a J, U пара into a К, З пара.
     */
    this(Ключник!(J, U) исток, проц function(ref J, ref U, ref К, ref З) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns the длина that the исток provides.
     */
    бцел длина()
    {
        return _ист.length;
    }
    alias длина length;

    /**
     * Iterate through the исток обходчик, working with temporary copies of a
     * transformed З элемент.  Note that К can be пропущен if this is the only
     * use for the обходчик.
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            К ключ;
            З знач;
            _дг(j, u, ключ, знач);
            return дг(знач);
        }

        цел privateFN(ref J j, ref U u)
        {
            К ключ;
            З знач;
            _фн(j, u, ключ, знач);
            return дг(знач);
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток обходчик, working with temporary copies of a
     * transformed К,З пара.
     */
    цел opApply(цел delegate(ref К ключ, ref З знач) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            К ключ;
            З знач;
            _дг(j, u, ключ, знач);
            return дг(ключ, знач);
        }

        цел privateFN(ref J j, ref U u)
        {
            К ключ;
            З знач;
            _фн(j, u, ключ, знач);
            return дг(ключ, знач);
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * A Chain обходчик chains several iterators together.
 */
class ОбходчикЦепи(З) : Обходчик!(З)
{
    private Обходчик!(З)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this обходчик supports
     * длина.  If one doesn't, then the длина is not supported.
     */
    this(Обходчик!(З)[] цепь ...)
    {
        _цепь = цепь.dup;
        _поддержкаДлины = true;
        foreach(обх; _цепь)
        if(обх.length == ~0)
        {
            _поддержкаДлины = false;
            break;
        }
    }

    /**
     * Returns the sum of all the обходчик lengths in the цепь.
     *
     * returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ if a single обходчик in the цепь does not support
     * длина
     */
    бцел длина()
    {
        if(_поддержкаДлины)
        {
            бцел рез = 0;
            foreach(обх; _цепь)
            рез += обх.length;
            return рез;
        }
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
    alias длина length;
    /**
     * Iterate through the цепь of iterators.
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }
}

/**
 * A Chain обходчик chains several iterators together.
 */
class КлючникЦепи(К, З) : Ключник!(К, З)
{
    private Ключник!(К, З)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this обходчик supports
     * длина.  If one doesn't, then the длина is not supported.
     */
    this(Ключник!(К, З)[] цепь ...)
    {
        _цепь = цепь.dup;
        _поддержкаДлины = true;
        foreach(обх; _цепь)
        if(обх.length == ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
        {
            _поддержкаДлины = false;
            break;
        }
    }

    /**
     * Returns the sum of all the обходчик lengths in the цепь.
     *
     * returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ if any iterators in the цепь return -1 for длина
     */
    бцел длина()
    {
        if(_поддержкаДлины)
        {
            бцел рез = 0;
            foreach(обх; _цепь)
            рез += обх.length;
            return рез;
        }
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
    alias длина length;
    /**
     * Iterate through the цепь of iterators using значения only.
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }

    /**
     * Iterate through the цепь of iterators using ключи и значения.
     */
    цел opApply(цел delegate(ref К, ref З) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }
}

/**
 * A Filter обходчик filters out unwanted элементы based on a function or
 * delegate.
 */
class ФильтрОбходчик(З) : Обходчик!(З)
{
    private Обходчик!(З) _ист;
    private бул delegate(ref З) _дг;
    private бул function(ref З) _фн;

    /**
     * Construct a filter обходчик with the given delegate deciding whether an
     * элемент will be iterated or not.
     *
     * The delegate should return true for элементы that should be iterated.
     */
    this(Обходчик!(З) исток, бул delegate(ref З) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a filter обходчик with the given function deciding whether an
     * элемент will be iterated or not.
     *
     * the function should return true for элементы that should be iterated.
     */
    this(Обходчик!(З) исток, бул function(ref З) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ
     */
    бцел длина()
    {
        //
        // cannot know что the filter delegate/function will decide.
        //
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
    alias длина length;
    /**
     * Iterate through the исток обходчик, only accepting элементы where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел privateDG(ref З знач)
        {
            if(_дг(знач))
                return дг(знач);
            return 0;
        }

        цел privateFN(ref З знач)
        {
            if(_фн(знач))
                return дг(знач);
            return 0;
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * A Filter обходчик filters out unwanted элементы based on a function or
 * delegate.  This version filters on a keyed обходчик.
 */
class ФильтрКлючник(К, З) : Ключник!(К, З)
{
    private Ключник!(К, З) _ист;
    private бул delegate(ref К, ref З) _дг;
    private бул function(ref К, ref З) _фн;

    /**
     * Construct a filter обходчик with the given delegate deciding whether a
     * ключ/значение пара will be iterated or not.
     *
     * The delegate should return true for элементы that should be iterated.
     */
    this(Ключник!(К, З) исток, бул delegate(ref К, ref З) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a filter обходчик with the given function deciding whether a
     * ключ/значение пара will be iterated or not.
     *
     * the function should return true for элементы that should be iterated.
     */
    this(Ключник!(К, З) исток, бул function(ref К, ref З) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ
     */
    бцел длина()
    {
        //
        // cannot know что the filter delegate/function will decide.
        //
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
    alias длина length;
    /**
     * Iterate through the исток обходчик, only iterating элементы where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref З знач) дг)
    {
        цел privateDG(ref К ключ, ref З знач)
        {
            if(_дг(ключ, знач))
                return дг(знач);
            return 0;
        }

        цел privateFN(ref К ключ, ref З знач)
        {
            if(_фн(ключ, знач))
                return дг(знач);
            return 0;
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток обходчик, only iterating элементы where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref К ключ, ref З знач) дг)
    {
        цел privateDG(ref К ключ, ref З знач)
        {
            if(_дг(ключ, знач))
                return дг(ключ, знач);
            return 0;
        }

        цел privateFN(ref К ключ, ref З знач)
        {
            if(_фн(ключ, знач))
                return дг(ключ, знач);
            return 0;
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Simple обходчик wrapper for an массив.
 */
class ОбходчикМассива(З) : Обходчик!(З)
{
    private З[] _массив;

    /**
     * Wrap a given массив.  Note that this does not make a копируй.
     */
    this(З[] массив)
    {
        _массив = массив;
    }

    /**
     * Returns the массив длина
     */
    бцел длина()
    {
        return _массив.length;
    }
    alias длина length;

    /**
     * Iterate over the массив.
     */
    цел opApply(цел delegate(ref З) дг)
    {
        цел возврзнач = 0;
        foreach(ref x; _массив)
        if((возврзнач = дг(x)) != 0)
            break;
        return возврзнач;
    }
}

/**
 * Wrapper обходчик for an associative массив
 */
class ОбходчикАМ(К, З) : Ключник!(К, З)
{
    private З[К] _массив;

    /**
     * Конструирует обходчик wrapper for the given массив
     */
    this(З[К] массив)
    {
        _массив = массив;
    }

    /**
     * Returns the длина of the wrapped AA
     */
    бцел длина()
    {
        return _массив.length;// || _массив.length;
    }

    alias длина length;
    /**
     * Iterate over the AA
     */
    цел opApply(цел delegate(ref К, ref З) дг)
    {
        цел возврзнач;
        foreach(ключ, ref знач; _массив)
        if((возврзнач = дг(ключ, знач)) != 0)
            break;
        return возврзнач;
    }
}

/**
 * Function that converts an обходчик to an массив.
 *
 * More optimized for iterators that support a длина.
 */
З[] вМассив(З)(Обходчик!(З) обх)
{
    З[] рез;
    бцел длин = обх.length;
    if(длин != ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
    {
        //
        // can optimize a bit
        //
        рез.length = длин;
        цел i = 0;
        foreach(знач; обх)
        рез[i++] = знач;
    }
    else
    {
        foreach(знач; обх)
        рез ~= знач;
    }
    return рез;
}

/**
 * Convert a keyed обходчик to an associative массив.
 */
З[К] вАМ(К, З)(Ключник!(К, З) обх)
{
    З[К] рез;
    foreach(ключ, знач; обх)
    рез[ключ] = знач;
    return рез;
}
