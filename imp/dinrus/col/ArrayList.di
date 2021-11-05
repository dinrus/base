﻿module col.ArrayList;
public import col.model.List,
       col.model.Keyed;
	   
/+ ИНТЕРФЕЙС:

class МассивСписок(З) : СКлючом!(бцел, З), Список!(З) 
{
    private З[] _массив;
    private бцел _изменение;
    private МассивСписок!(З) _родитель;
    private МассивСписок!(З) _предок;

    final цел очистить(цел delegate(ref бул удалить_ли, ref З значение) дг);
    final цел чисть_ключ(цел delegate(ref бул удалить_ли, ref бцел ключ, ref З значение) дг);
    struct курсор
		{
			private З *укз;		alias укз ptr;

			З значение();
			З значение(З з);
			курсор opPostInc();
			курсор opPostDec();
			курсор opAddAssign(цел прир);
			курсор opSubAssign(цел прир);
			курсор opAdd(цел прир);
			курсор opSub(цел прир);
			цел opSub(курсор обх);
			цел opCmp(курсор обх);
			бул opEquals(курсор обх);
		}
	
    this();
    this(З[] хранилище);
    МассивСписок!(З) зачисть();
    бцел длина();
    курсор начало();
    курсор конец();;
    курсор удали(курсор старт, курсор последн);
    курсор удали(курсор элт);
    МассивСписок!(З) удали(З з, ref бул былУдалён);
    МассивСписок!(З) удали(З з);
    курсор найди(курсор обх, З з);
    курсор найди(З з);
    бул содержит(З з);
    МассивСписок!(З) удалиПо(бцел ключ, ref бул былУдалён);
    МассивСписок!(З) удалиПо(бцел ключ);
    З opIndex(бцел ключ);
    З opIndexAssign(З значение, бцел ключ);
    МассивСписок!(З) установи(бцел ключ, З значение, ref бул былДобавлен);
    МассивСписок!(З) установи(бцел ключ, З значение);
    цел opApply(цел delegate(ref З значение) дг);
    цел opApply(цел delegate(ref бцел ключ, ref З значение) дг);
    бул имеетКлюч(бцел ключ);
    МассивСписок!(З) добавь(З з, ref бул былДобавлен);
    МассивСписок!(З) добавь(З з);
    МассивСписок!(З) добавь(Обходчик!(З) колл);
    МассивСписок!(З) добавь(Обходчик!(З) колл, ref бцел члоДобавленных);
    МассивСписок!(З) добавь(З[] массив);
    МассивСписок!(З) добавь(З[] массив, ref бцел члоДобавленных);
    МассивСписок!(З) opCatAssign(Список!(З) правткт);
    МассивСписок!(З) opCatAssign(З[] массив);
    МассивСписок!(З) opCat(Список!(З) правткт);
    МассивСписок!(З) opCat(З[] массив);
    МассивСписок!(З) opCat_r(З[] массив); 
    бцел счёт(З з);
    МассивСписок!(З) удалиВсе(З з, ref бцел члоУдалённых);
    МассивСписок!(З) удалиВсе(З з);
    МассивСписок!(З) opSlice(бцел b, бцел e);
    МассивСписок!(З) opSlice(курсор b, курсор e);
    МассивСписок!(З) dup();
    З[] какМассив();
    цел opEquals(Объект o);
    цел opEquals(З[] массив);
    З фронт();
    З тыл();
    З возьмиФронт();
    З возьмиТыл();
    бцел индексУ(З з);

    class ОсобоеИнфОТипе(бул использоватьФункцию) : ИнфОТипе
    {
        static if(использоватьФункцию)
            alias цел function(ref З v1, ref З v2) ФункцСравнения;
        else
            alias цел delegate(ref З v1, ref З v2) ФункцСравнения;
        private ФункцСравнения cf;
        private ИнфОТипе производныйОт;
		
        this(ИнфОТипе производныйОт, ФункцСравнения comp);
        override hash_t дайХэш(ук p);
        override цел equals(ук p1, ук p2);
        override цел сравни(ук p1, ук p2);
        override т_мера tsize();
        override проц swap(ук p1, ук p2);
        override ИнфОТипе следщ();
        override проц[] init();
        override бцел flags();
        override OffsetTypeInfo[] offTi();
	}
	МассивСписок сортируй(цел delegate(ref З v1, ref З v2) comp);
	МассивСписок сортируй(цел function(ref З v1, ref З v2) comp);
	МассивСписок сортируй();
	
}
+/
//=================================================================

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
    // _родитель не устанавливается в пусто, так как обх нужен каждому срезу,
    // которые были подсрезами этого среза. Их не следует инвалидировать,
    // они должны иметь цепь к своему предку.  Поэтому, при добавлении в срез данных,
    // обх превращается в пустую ссылку на исходную цепь линейки.
    //
    private МассивСписок!(З) _родитель;
    private МассивСписок!(З) _предок;

    /**
     * Итерирует по элементам в МассивСписок, сообщая обху, какие из них
     * следует удалить.
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
     * Итерирует по элементам в МассивСписок, сообщая обху, какие из них
     * следует удалить.
     *
     * Пример использования:
     * -------------
     * //удалить все нечётные элементы
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
     * Курсор массива аналогичен указателю на этот массив.  Единственное
     * отличие между курсором МассивСписок и указателем - в том, что
     * курсор МассивСписок предоставляет свойство значение, общее
     * по всему пакету col.
     *
     * Все операции над курсором являются O(1)
     */
    struct курсор
    {
        private З *укз;		alias укз ptr;
        
        /**
         * Даёт указываемое значение.
         */
        З значение()
        {
            return *укз;
        }

        /**
         * Устанавливает указываемое значение.
         */
        З значение(З з)
        {
            return (*укз = з);
        }

        /**
         * Увеличивает this курсор на один, возвращает указатель курсора перед этим
         * увеличением.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз++;
            return врм;
        }

        /**
         * Уменьшает this курсор на один, возвращает указатель курсора перед перед
         * уменьшением.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз--;
            return врм;
        }

        /**
         * Увеличивает курсор на заданное количество.
         */
        курсор opAddAssign(цел прир)
        {
            укз += прир;
            return *this;
        }

        /**
         * Уменьшает курсор на заданное количество.
         */
        курсор opSubAssign(цел прир)
        {
            укз -= прир;
            return *this;
        }

        /**
         * Возвращает курсор, that is прир элементы beyond this курсор.
         */
        курсор opAdd(цел прир)
        {
            курсор рез = *this;
            рез.ptr += прир;
            return рез;
        }

        /**
         * Возвращает курсор, that is прир элементы перед this курсор.
         */
        курсор opSub(цел прир)
        {
            курсор рез = *this;
            рез.ptr -= прир;
            return рез;
        }

        /**
         * Возвращает число элементов между this курсор и заданным
         * курсором.  Если обх указывает на элемент позднее, рез отрицателен.
         */
        цел opSub(курсор обх)
        {
            return укз - обх.ptr;
        }

        /**
         * Сравнивает два курсора.
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
         * Сравнивает два курсора на равенство.
         */
        бул opEquals(курсор обх)
        {
            return укз is обх.ptr;
        }
    }

    /**
     * Создаёт новый пустой МассивСписок.
     */
    this()
    {
        _предок = this;
        _родитель = пусто;
    }

    /**
     * Использовать массив в качестве фонового хранилища. Сам массив не дублируется.
     * Чтобы сделать отдельную копию, используется new МассивСписок(хранилище.dup).
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
     * Очистить этот контейнер от всех значений.
     */
    МассивСписок!(З) зачисть()
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
     * Возвращает число элементов в коллекции.
     */
    бцел длина()
    {
        проверьИзменение();
        return _массив.length;
    }

	alias длина length;
    /**
     * Возвращает курсор, указывающий на первый элемент в этом списке.
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
     * Возвращает курсор, указывающий сразу после последнего элемента в
     * этом списке.
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
            // цикл перед удалением
            //
            for(; возврдг == 0 && i != последн; i++, следщХор++)
            {
                удалить_ли = нет;
                бцел ключ = i - ссылка;
                if((возврдг = дг(удалить_ли, ключ, *i.ptr)) == 0)
                {
                    if(удалить_ли)
                    {
                        //
                        // первое удаление
                        //
                        _изменение++;
                        i++;
                        break;
                    }
                }
            }

            //
            // цикл после первого удаления
            //
            if(следщХор != i)
            {
                for(; i < конссыл; i++, следщХор++)
                {
                    удалить_ли = нет;
                    бцел ключ = i - ссылка;
                    if(i >= последн || возврдг != 0 || (возврдг = дг(удалить_ли, ключ, *i.ptr)) != 0)
                    {
                        //
                        // дг больше не вызывается
                        //
                        следщХор.значение = i.значение;
                    }
                    else if(удалить_ли)
                    {
                        //
                        // дг запросил удаление
                        //
                        следщХор--;
                    }
                    else
                    {
                        //
                        // дг не запрашивал удаления
                        //
                        следщХор.значение = i.значение;
                    }
                }
            }

            //
            // укоротить длину
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
            // использовать потомка для выполнения применения apply, затем отрегулировать массив
            // соответственно.
            //
            проверьИзменение();
            auto p = следщРодитель;
            auto оригДлина = p._массив.length;
            возврдг = p._примени(дг, старт, последн, _начало);
            auto члоУдалённых = оригДлина - p._массив.length;
            if(члоУдалённых > 0)
            {
                _массив = _массив[0..$-члоУдалённых];
                _изменение = _предок._изменение;
            }
        }
        return возврдг;
    }

    private цел _примени(цел delegate(ref бул, ref З) дг, курсор старт, курсор последн)
    {
        цел _дг(ref бул b, ref бцел к, ref З з)
        {
            return дг(b, з);
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
    // Получает следщ родителя в линейке. Пропускает любых предков, которые
    // не разделяют нашего потомка, они более не являются частью линейки.
    //
    private МассивСписок!(З) следщРодитель()
    {
        auto возврзнач = _родитель;
        while(возврзнач._предок !is _предок)
            возврзнач = возврзнач._родитель;
        return возврзнач;
    }

    /**
     * Удаляет все элементы от старта до последн, не включая элемент,
     * на который указывает последн. Возвращает действительный курсор,
     * указывающий на элемент, на который указывает последн.
     *
     * Выполняется за время O(n).
     */
    курсор удали(курсор старт, курсор последн)
    {
        if(предок_ли)
        {
            цел проверь(ref бул b, ref З)
            {
                b = да;
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
     * Удаляет элемент, на который указывает элт. Равнозначно удали(элт, элт
     * + 1).
     *
     * Выполняется за время O(n).
     */
    курсор удали(курсор элт)
    {
        return удали(элт, элт + 1);
    }

    /**
     * Удаляет элемент с определённым значением. Это операция O(n).
     * Если в коллекции есть экземпляры-дубликаты, удаляется первый
     * элемент, который подходит.
     *
     * Возвращает this.
     *
     * Устанавливает былУдалён в да, если элемент существовал и был удалён.
     */
    МассивСписок!(З) удали(З з, ref бул былУдалён)
    {
        auto обх = найди(з);
        if(обх == _конец)
            былУдалён = нет;
        else
        {
            удали(обх);
            былУдалён = да;
        }
        return this;
    }

    /**
     * Удаляет элемент с определённым значение. Это операция O(n).
     * Если в коллекции есть экземпляры-дубликаты, удаляется первый
     * элемент, который подходит.
     *
     * Возвращает this.
     */
    МассивСписок!(З) удали(З з)
    {
        бул пропущен;
        return удали(з, пропущен);
    }

    /**
     * То же, что и найди(з), но старт с заданной позиции.
     */
    курсор найди(курсор обх, З з)
    {
        return _найди(обх, _конец, з);
    }

    // То же, что и найди(з), но ищет только в заданном диапазоне по заданной позиции.
    private курсор _найди(курсор обх, курсор последн,  З з)
    {
        проверьИзменение();
        while(обх < последн && обх.значение != з)
            обх++;
        return обх;
    }

    /**
     * Ищет первый случай элемента в списке. Выполняется за время O(n).
     */
    курсор найди(З з)
    {
        return _найди(_начало, _конец, з);
    }

    /**
     * Возвращает да, если в этой коллекции есть это значение.  Выполняется за время O(n).
     */
    бул содержит(З з)
    {
        return найди(з) < _конец;
    }

    /**
     * Удаляет элемент по заданному индексу. Выполняется за время O(n).
     */
    МассивСписок!(З) удалиПо(бцел ключ, ref бул былУдалён)
    {
        if(ключ > длина)
        {
            былУдалён = нет;
        }
        else
        {
            удали(_начало + ключ);
            былУдалён = да;
        }
        return this;
    }

    /**
     * Удаляет элемент по заданному индексу.  Выполняется за время O(n).
     */
    МассивСписок!(З) удалиПо(бцел ключ)
    {
        бул пропущен;
        return удалиПо(ключ, пропущен);
    }

    /**
     * Даёт значение по заданному индексу.
     */
    З opIndex(бцел ключ)
    {
        проверьИзменение();
        return _массив[ключ];
    }

    /**
     * Устанавливает значение по заданному индексу.
     */
    З opIndexAssign(З значение, бцел ключ)
    {
        проверьИзменение();
        return _массив[ключ] = значение;
    }

    /**
     * Устанавливает значение по заданному индексу.
     */
    МассивСписок!(З) установи(бцел ключ, З значение, ref бул былДобавлен)
    {
        this[ключ] = значение;
        былДобавлен = нет;
        return this;
    }

    /**
     * Устанавливает значение по заданному индексу.
     */
    МассивСписок!(З) установи(бцел ключ, З значение)
    {
        this[ключ] = значение;
        return this;
    }

    /**
     * Итерирует по коллекции.
     */
    цел opApply(цел delegate(ref З значение) дг)
    {
        цел возврзнач;
        курсор конссыл = конец;
        for(курсор i = _начало; i != конссыл; i++)
        {
            if((возврзнач = дг(*i.ptr)) != 0)
                break;
        }
        return возврзнач;
    }

    /**
     * Итерирует по коллекции с ключом и значением.
     */
    цел opApply(цел delegate(ref бцел ключ, ref З значение) дг)
    {
        цел возврзнач = 0;
        auto ссылка = начало;
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
     * Возвращает да, если данный индекс действителен.
     *
     * Выполняется за время O(1).
     */
    бул имеетКлюч(бцел ключ)
    {
        return ключ < длина;
    }

    /**
     * Добавляет данное значение в конец этого списка. Всегда возвращает да.
     */
    МассивСписок!(З) добавь(З з, ref бул былДобавлен)
    {
        //
        // Поставим в this массив.  Сбросим потомка this, так как
        // теперь имеем дело с новым массивом.
        //
        if(предок_ли)
        {
            _массив ~= з;
            _изменение++;
        }
        else
        {
            _предок = this;
            //
            // ensure that we don'т just do an подставь.
            //
            _массив = _массив ~ з;

            //
            // no need to change the изменение, we are a new ancestor.
            //
        }

        // всегда удаётся
        былДобавлен = да;
        return this;
    }

    /**
     * Добавляет данное значение в конец этого списка.
     */
    МассивСписок!(З) добавь(З з)
    {
        бул пропущен;
        return добавь(з, пропущен);
    }

    /**
     * Добавляет все элементы из данного обходчика в конец этого списка.
     */
    МассивСписок!(З) добавь(Обходчик!(З) колл)
    {
        бцел пропущен;
        return добавь(колл, пропущен);
    }

    /**
     * Добавляет все элементы из данного обходчика в конец этого списка.
     */
    МассивСписок!(З) добавь(Обходчик!(З) колл, ref бцел члоДобавленных)
    {
        auto al = cast(МассивСписок!(З))колл;
        if(al)
        {
            //
            // оптимизированный случай
            //
            return добавь(al._массив, члоДобавленных);
        }

        //
        // генерный случай
        //
        проверьИзменение();
        члоДобавленных = колл.length;
        if(члоДобавленных != cast(бцел)-1)
        {
            if(члоДобавленных > 0)
            {
                цел i = _массив.length;
                if(предок_ли)
                {
                    _массив.length = _массив.length + члоДобавленных;
                }
                else
                {
                    _предок = this;
                    auto нов_массив = new З[_массив.length + члоДобавленных];
                    нов_массив[0.._массив.length] = _массив[];

                }
                foreach(з; колл)
                    _массив [i++] = з;
                _изменение++;
            }
        }
        else
        {
            auto исхдлина = _массив.length;
            бул firstdone = нет;
            foreach(з; колл)
            {
                if(!firstdone)
                {
                    //
                    // Трюк для установки firstdone в да, так как былДобавлен
                    // всегда установлен в да.
                    //
                    добавь(з, firstdone);
                }
                else
                    _массив ~= з;
            }
            члоДобавленных = _массив.length - исхдлина;
        }
        return this;
    }


    /**
     * Приставляет этот массив в конец этого списка.
     */
    МассивСписок!(З) добавь(З[] массив)
    {
        бцел пропущен;
        return добавь(массив, пропущен);
    }

    /**
     * Приставляет этот массив в конец этого списка.
     */
    МассивСписок!(З) добавь(З[] массив, ref бцел члоДобавленных)
    {
        проверьИзменение();
        члоДобавленных = массив.length;
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
     * Ставит другой список в конец этого списка.
     */
    МассивСписок!(З) opCatAssign(Список!(З) правткт)
    {
        return добавь(правткт);
    }

    /**
     * Ставит массив в конец этого  списка.
     */
    МассивСписок!(З) opCatAssign(З[] массив)
    {
        return добавь(массив);
    }

    /**
     * Возвращает конкатенацию списка-массива и другого списка.
     */
    МассивСписок!(З) opCat(Список!(З) правткт)
    {
        return dup.добавь(правткт);
    }

    /**
     * Возвращает конкатенацию списка-массива и массива.
     */
    МассивСписок!(З) opCat(З[] массив)
    {
        проверьИзменение();
        return new МассивСписок!(З)(_массив ~ массив);
    }

    /**
     * Возвращает конкатенацию списка-массива и массива.
     */
    МассивСписок!(З) opCat_r(З[] массив)
    {
        проверьИзменение();
        return new МассивСписок!(З)(массив ~ _массив);
    }

    /**
     * Возвращает число экземпляров указанного значения элемента.
     *
     * Выполняется за время O(n).
     */
    бцел счёт(З з)
    {
        бцел экземпляры = 0;
        foreach(x; this)
            if(з == x)
                экземпляры++;
        return экземпляры;
    }

    /**
     * Удаляет все экземпляры указанного значения элемента.
     *
     * Выполняется за время O(n).
     */
    МассивСписок!(З) удалиВсе(З з, ref бцел члоУдалённых)
    {
        auto оригДлина = длина;
        foreach(ref b, x; &очистить)
        {
            b = cast(бул)(x == з);
        }
        члоУдалённых = длина - оригДлина;
        return this;
    }

    /**
     * Удаляет все экземпляры указанного значения элемента.
     *
     * Выполняется за время O(n).
     */
    МассивСписок!(З) удалиВсе(З з)
    {
        бцел пропущен;
        return удалиВсе(з, пропущен);
    }

    /**
     * Возвращает срез списка-массива. Срез может использоваться для обзора
     * элементов, удаления элементов, но не может использоваться для добавления элементов.
     *
     * Возвращённый срез начинается с индекса b и заканчивается, но не включает его,
     * на индексе e.
     */
    МассивСписок!(З) opSlice(бцел b, бцел e)
    {
        return opSlice(_начало + b, _начало + e);
    }

    /**
     * Делает срез массива по заданным курсорам.
     */
    МассивСписок!(З) opSlice(курсор b, курсор e)
    {
        if(e > конец || b < _начало) // call проверьИзменение once
            throw new Искл("значение среза вне диапазона");

        //
        // сделать список-массив, являющийся срезом этого списка-массива.
        //
        return new МассивСписок!(З)(this, b, e);
    }

    /**
     * Возвращает копию списка массива.
     */
    МассивСписок!(З) dup()
    {
        return new МассивСписок!(З)(_массив.dup);
    }

    /**
     * Возвращает массив, который представляет этот массив. Это НЕ копия данных,
     * изменение элементов этого массива приведёт к изменению элементов
     * исходного МассивСписок.  Приставление элементов из этого массива не повлияет
     * на исходный список-массив, как и приставление к любому массиву не влияет на
     * оригинал.
     */
    З[] какМассив()
    {
        return _массив;
    }

    /**
     * Оператор для сравнения двух объектов.
     *
     * Если o есть Список!(З), то выполняется сравнение списков.
     * Если o есть пусто или не есть МассивСписок, то возвращается значение 0.
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
                    // равны
                    //
                    return 1;
                }
            }

        }
        //
        // сравнение невозможно.
        //
        return 0;
    }

    /**
     * Сравнивает с З массивом.
     *
     * Равнозначно какМассив == массив.
     */
    цел opEquals(З[] массив)
    {
        return _массив == массив;
    }

    /**
     *  Ищет элемент во фронте этого МассивСписка.
     */
    З фронт()
    {
        return начало.значение;
    }

    /**
     * Ищет элемент в конце этого  МассивСписок.
     */
    З тыл()
    {
        return (конец - 1).значение;
    }

    /**
     * Удаляет элемент во фронте этого МассивСписок и возвращает его значение.
     * Это операция O(n).
     */
    З возьмиФронт()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }

    /**
     * Удаляет элемент в конце этого МассивСписок и возвращает его значение.
     * Возможно, это операция O(n).
     */
    З возьмиТыл()
    {
        auto c = конец - 1;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }

    /**
     * Получить индекс определённого значения. Равнозначно найди(з) - начало.
     *
     * Если значения нет в этой коллекции, возвращается длина.
     */
    бцел индексУ(З з)
    {
        return найди(з) - начало;
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

        /// Возвращает хэш экземпляра этого типа.
        override hash_t дайХэш(ук p) { return производныйОт.дайХэш(p); }

        /// Сравнивает два экземпляра на равенство.
        override цел equals(ук p1, ук p2) { return производныйОт.equals(p1, p2); }

        /// Сравнивает два экземпляра на &lt;, ==, или &gt;.
        override цел сравни(ук p1, ук p2)
        {
            return cf(*cast(З *)p1, *cast(З *)p2);
        }

        /// Возвращает размер этого типа.
        override т_мера tsize() { return производныйОт.tsize(); }

        /// Swaps два экземпляра этого типа.
        override проц swap(ук p1, ук p2)
        {
            return производныйОт.swap(p1, p2);
        }

        /// Получает ИнфОТипе для 'следщ' типа, as defined by что kind of type this is,
        /// пусто if none.
        override ИнфОТипе следщ() { return производныйОт; }

        /// Return default initializer, пусто if default initialize to 0
        override проц[] init() { return производныйОт.init(); }

        /// Get flags for type: 1 means GC should scan for pointers
        override бцел flags() { return производныйОт.flags(); }

        /// Get type information on the contents of the type; пусто if not available
        override OffsetTypeInfo[] offTi() { return производныйОт.offTi(); }
    }

    /**
     * Сортирует, согласно заданной функции сравнения.
     */
    МассивСписок сортируй(цел delegate(ref З v1, ref З v2) comp)
    {
        //
        // can'т really do this without extra library помощь.  Luckily, the
        // function to сортируй an массив is always defined by the runtime.  We
        // just need to доступ обх.  However, обх требует that we pass in a
        // ИнфОТипе structure to do all the dirty work.  What we need is a
        // derivative of the real ИнфОТипе structure with the сравни function
        // overridden to call the comp function.
        //
        //scope ОсобоеИнфОТипе!(typeof(typeid(З))) sti = new ОсобоеИнфОТипе(comp);
        scope sti = new ОсобоеИнфОТипе!(нет)(typeid(З), comp);
        цел x;
        Array ar;
        ar.length = _массив.length;
        ar.ptr = _массив.ptr;
        _adSort(ar, sti);
        return this;
    }

    /**
     * Сортирует, согласно заданной функции сравнения.
     */
    МассивСписок сортируй(цел function(ref З v1, ref З v2) comp)
    {
        //
        // can'т really do this without extra library помощь.  Luckily, the
        // function to сортируй an массив is always defined by the runtime.  We
        // just need to доступ обх.  However, обх требует that we pass in a
        // ИнфОТипе structure to do all the dirty work.  What we need is a
        // derivative of the real ИнфОТипе structure with the сравни function
        // overridden to call the comp function.
        //
        //scope ОсобоеИнфОТипе!(typeof(typeid(З))) sti = new ОсобоеИнфОТипе(comp);
        scope sti = new ОсобоеИнфОТипе!(да)(typeid(З), comp);
        цел x;
        Array ar;
        ar.length = _массив.length;
        ar.ptr = _массив.ptr;
        _adSort(ar, sti);
        return this;
    }

    /**
     * Сортирует, согласно дефолтной процедуре сравнения для З.
     */
    МассивСписок сортируй()
    {
        _массив.sort;
        return this;
    }
}

version(UnitTest)
{
    void main()
    {
        auto al = new МассивСписок!(бцел);
        al.добавь([0U, 1, 2, 3, 4, 5]);
        assert(al.length == 6);
        al.добавь(al[0..3]);
        assert(al.length == 9);
        foreach(ref бул dp, бцел инд, бцел знач; &al.чисть_ключ)
            dp = (знач % 2 == 1);
        assert(al.length == 5);
        assert(al == [0U, 2, 4, 0, 2]);
        assert(al == new МассивСписок!(бцел)([0U, 2, 4, 0, 2].dup));
        assert(al.начало.ptr is al.какМассив.ptr);
        assert(al.конец.ptr is al.какМассив.ptr + al.length);
    }
}
