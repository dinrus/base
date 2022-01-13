﻿module io.device.ThreadPipe;
private import exception, sync;
private import io.device.Conduit;

export class ПайпНить : Провод
{
    private бул _закрыто;
    private т_мера _индксЧтен, _остаток;
    private проц[] _буф;
    private Мютекс _мютекс;
    private Условие _условие;

export:
    /**
     * Создаёт новый ПайпНить с заданным размером буфера.
     *
     * Парамы:
     * размерБуфера = Размер выделяемой под буфер памяти.
     */
    this(т_мера размерБуфера=(1024*16))
    {
        _буф = new ббайт[размерБуфера];
        _закрыто = нет;
        _индксЧтен = _остаток = 0;
        _мютекс = new Мютекс;
        _условие = new Условие(_мютекс);
    }

    /**
     * Реализует IConduit.размерБуфера.
     *
     * Возвращает соответствующего размера буфер, который следует
     * использовать для буферирования ПайпНити. 
     * Заметьте, что это просто передаваемый размер буфера, и
     * поскольку все данные ПайпНить находятся в памяти,
     * буферирование не имеет никакого смысла.
     */
    т_мера размерБуфера()
    {
        return _буф.length;
    }

    /**
     * Реализует IConduit.вТкст
     *
     * Возвращает "&lt;thread conduit&gt;"
     */
    ткст вТкст()
    {
        return "<io.device.ThreadPipe.ПайпНить>";
    }

    /**
     * Возвращает да, если ещё есть данные для чтения,
     * и конец записи не закрыт.
     */
    override бул жив_ли()
    {
        synchronized(_мютекс)
        {
            return !_закрыто || _остаток != 0;
        }
    }

    /**
     * Возвращает the число of байты остаток to be читай in the circular buffer.
     */
    т_мера остаток()
    {
        synchronized(_мютекс)
            return _остаток;
    }

    /**
     * Возвращает the число of байты that can be written to the circular buffer.
     */
    т_мера записываемо()
    {
        synchronized(_мютекс)
            return _буф.length - _остаток;
    }

    /**
     * Close the пиши end of the conduit.  Writing to the conduit после it is
     * закрыт will return Кф.
     *
     * The читай end is not закрыт until the buffer is empty.
     */
    проц стоп()
    {
        //
        // закрой пиши end.  The читай end can stay открой until the остаток
        // байты are читай.
        //
        synchronized(_мютекс)
        {
            _закрыто = да;
            _условие.уведомиВсе();
        }
    }

    /**
     * This does nothing because we have no clue whether the members have been
     * собериed, и открепи is run in the destructor.  To стоп communications,
     * use стоп().
     *
     * TODO: move стоп() functionality to открепи when it becomes possible to
     * have fully-owned members
     */
    проц открепи()
    {
    }

    /**
     * Реализует ИПотокВвода.читай.
     *
     * Чит from the conduit преобр_в a target массив.  The предоставленный приёмник will be
     * populated with контент from the Поток.
     *
     * Возвращает the число of байты читай, which may be less than requested in
     * приёмник. Кф is returned whenever an end-of-flow condition arises.
     */
    т_мера читай(проц[] приёмник)
    {
        //
        // don't блок for empty читай
        //
        if(приёмник.length == 0)
            return 0;
        synchronized(_мютекс)
        {
            //
            // see if any остаток data is present
            //
            т_мера r;
            while((r = _остаток) == 0 && !_закрыто)
                _условие.жди();

            //
            // читай all data that is available
            //
            if(r == 0)
                return Кф;
            if(r > приёмник.length)
                r = приёмник.length;

            auto рез = r;

            //
            // укз wrapping
            //
            if(_индксЧтен + r >= _буф.length)
            {
                т_мера x = _буф.length - _индксЧтен;
                приёмник[0..x] = _буф[_индксЧтен..$];
                _индксЧтен = 0;
                _остаток -= x;
                r -= x;
                приёмник = приёмник[x..$];
            }

            приёмник[0..r] = _буф[_индксЧтен..(_индксЧтен + r)];
            _индксЧтен = (_индксЧтен + r) % _буф.length;
            _остаток -= r;
            _условие.уведомиВсе();
            return рез;
        }
    }

    /**
     * Реализует ИПотокВвода.очисть().
     *
     * Clear any buffered контент.
     */
    ПайпНить очисть()
    {
        synchronized(_мютекс)
        {
            if(_остаток != 0)
            {
                /*
                 * this isn't technically necessary, but we do it because it
                 * preserves the most recent data первый
                 */
                _индксЧтен = (_индксЧтен + _остаток) % _буф.length;
                _остаток = 0;
                _условие.уведомиВсе();
            }
        }
        return this;
    }

    /**
     * Реализует OutputПоток.пиши.
     *
     * Зап to Поток from a исток массив. The предоставленный src контент will be
     * written to the Поток.
     *
     * Возвращает the число of байты written from src, which may be less than
     * the quantity предоставленный. Кф is returned when an end-of-flow condition
     * arises.
     */
    т_мера пиши(проц[] src)
    {
        //
        // don't блок for empty пиши
        //
        if(src.length == 0)
            return 0;
        synchronized(_мютекс)
        {
            т_мера w;
            while((w = _буф.length - _остаток) == 0 && !_закрыто)
                _условие.жди();

            if(_закрыто)
                return Кф;

            if(w > src.length)
                w = src.length;

            auto writeIdx = (_индксЧтен + _остаток) % _буф.length;

            auto рез = w;

            if(w + writeIdx >= _буф.length)
            {
                auto x = _буф.length - writeIdx;
                _буф[writeIdx..$] = src[0..x];
                writeIdx = 0;
                w -= x;
                _остаток += x;
                src = src[x..$];
            }
            _буф[writeIdx..(writeIdx + w)] = src[0..w];
            _остаток += w;
            _условие.уведомиВсе();
            return рез;
        }
    }
}

debug(UnitTest)
{
    import thread;

    проц main()
    {
        бцел[] исток = new бцел[1000];
        foreach(i, ref x; исток)
            x = i;

        ПайпНить пн = new ПайпНить(16);
        проц нитьА()
        {
            проц[] исхБуф = исток;
            while(исхБуф.length > 0)
            {
                исхБуф = исхБуф[пн.пиши(исхБуф)..$];
            }
            пн.стоп();
        }
        Нить a = new Нить(&нитьА);
        a.старт();
        цел значчтен;
        цел последн = -1;
        т_мера члочтен;
        while((члочтен = пн.читай((&значчтен)[0..1])) == значчтен.sizeof)
        {
            assert(значчтен == последн + 1);
            последн = значчтен;
        }
        assert(члочтен == пн.Кф);
        a.присоедини();
    }
}
