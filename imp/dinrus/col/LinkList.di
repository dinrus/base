﻿module col.LinkList;

public import col.model.List;
private import col.Link;
private import col.Functions;

/+ ИНТЕРФЕЙС:

class СвязкаСписок(З, alias ШаблРеализац = ГоловаСвязки) : Список!(З)
{

    alias ГоловаСвязки!(З) Реализ;
    alias СвязкаСписок!(З, ШаблРеализац) ТипСвязкаСписок;

    struct курсор
    {

        З значение();
        З значение(З з);
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        бул opEquals(курсор обх);
    }


    this();
    private this(ref Реализ дубИз, бул копироватьУзлы);
    ТипСвязкаСписок зачисть();
    бцел длина();
	alias длина length;
    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор удали(курсор первый, курсор последн);
    ТипСвязкаСписок удали(З з);
    ТипСвязкаСписок удали(З з, ref бул былУдалён);
    курсор найди(курсор обх, З з);
    курсор найди(З з);
    бул содержит(З з);
    цел opApply(цел delegate(ref З значение) дг);
    final цел очистить(цел delegate(ref бул удалить_ли, ref З значение) дг);
    ТипСвязкаСписок добавь(З з);
    ТипСвязкаСписок добавь(З з, ref бул былДобавлен);
    ТипСвязкаСписок добавь(Обходчик!(З) колл);
    ТипСвязкаСписок добавь(Обходчик!(З) колл, ref бцел члоДобавленных);
    ТипСвязкаСписок добавь(З[] массив);
    ТипСвязкаСписок добавь(З[] массив, ref бцел члоДобавленных);
    бцел счёт(З з);
    ТипСвязкаСписок удалиВсе(З з);
    ТипСвязкаСписок удалиВсе(З з, ref бцел члоУдалённых);
    курсор вставь(курсор обх, З з);
    курсор надставь(З з);
    курсор подставь(З з);
    З тыл();
    З фронт();
    З возьмиФронт();
    З возьмиТыл();
    ТипСвязкаСписок opCat(Список!(З) правткт);
    ТипСвязкаСписок opCat(З[] массив);
    ТипСвязкаСписок opCat_r(З[] массив);
    ТипСвязкаСписок opCatAssign(Список!(З) правткт);
    ТипСвязкаСписок opCatAssign(З[] массив);
    ТипСвязкаСписок dup();
    цел opEquals(Объект o);
    СвязкаСписок сортируй(цел delegate(ref З, ref З) comp);
    СвязкаСписок сортируй(цел function(ref З, ref З) comp);
    СвязкаСписок сортируй();
    СвязкаСписок сортируйИкс(Сравниватель)(Сравниватель comp);
}

+/

/**
 * Этот класс реализует интерфейс списка, используя узлы Связка. Это даёт
 * преимущества добавления и удаления O(1), но не случайный доступ.
 *
 * Добавление элементов не влияет ни на какой курсор.
 *
 * Удаление элементов не влияет ни на какой курсор, кроме курсора, указывающего на
 * удалённый элемент, в случае чего обходчик становится неверным.
 *
 * Эту реализацию можно включить в другую реализацию двойного линкованного списка.
 * Эта реализация должна быть структурой, использующей единственный шаблонный
 * аргумент З со следующими членами (если ничего не указано, члены могут быть
 * реализованы как свойства):
 *
 * параметры -> тип данных, передаваемый в набор для настройки Узла.
 * К нему нет особых требований.
 *
 * Узел -> тип данных, представляющий Узел в этом списке. Должен быть
 * ссылочного типа. Каждый Узел должен определять следующие члены:
 *   З значение -> значение, находящееся в этом Узел.  Не может быть свойством.
 *   Узел предш -> (только получаемый) предыдущий Узел в этом списке
 *   Узел следщ -> (только получаемый)  следующий Узел в этом списке
 *
 * Узел конец -> (только получаемый) Недействительный Узел, который указывает сразу
 * после последнего действительного
 * Узел.  конец.предш должен быть последним действительным Узлом.  конец.следщ неопределён.
 *
 * Узел начало -> (только получаемый) Первый действительный Узел.  начало.предш неопределён.
 *
 * бцел счёт -> (только получаемый)  Число узлов в этом списке. Может быть
 * вычислено за время O(n), что позволяет выполнять более эффективное удаление
 * нескольких узлов.
 *
 * проц установка(параметры p) -> установить список. Подобно конструктору.
 *
 * Узел удали(Узел n) -> удаляет указанный Узел из этого списка. Возвращает
 * следщ Узел в этом списке.
 *
 * Узел удали(Узел первый, Узел последн) -> удаляет узлы от первого до последнего,
 * не включая последний.  Возвращает последн. Может выполняться за время O(n), если счёт равен
 * O(1), или за время O(1), если счёт равен O(n).
 *
 * Узел вставь(Узел перед, З з) -> добавить новый Узел перед  Узлом 'перед',
 * возвращает указатель на новый Узел.
 *
 * проц зачисть() -> удалить все узлы из этого списка.
 * 
 * проц сортируй(ФункцСравнения!(З) comp) -> сортирует список, согласно
 * функции сравнения
 *
 */
class СвязкаСписок(З, alias ШаблРеализац = ГоловаСвязки) : Список!(З)
{
    /**
     * Удобный псевдоним.
     */
    alias ГоловаСвязки!(З) Реализ;

    /**
     * Удобный псевдоним.
     */
    alias СвязкаСписок!(З, ШаблРеализац) ТипСвязкаСписок;

    private Реализ _связка;

    /**
     * Курсор для списка-связки.
     */
    struct курсор
    {
        private Реализ.Узел укз; alias укз ptr;

        /**
         * Даёт значение, на которое указывает этот курсор.
         */
        З значение()
        {
            return укз.значение;
        }

        /**
         * Устанавливает значение, на которое указывает этот курсор.
         */
        З значение(З з)
        {
            return (укз.значение = з);
        }

        /**
         * Инкрементирует этот курсор, возвращает курсор, который был до
         * инкрементации.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз = укз.следщ;
            return врм;
        }

        /**
         * Декрементирует этот курсор, возвращает курсор, который был до
         * декрементации.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз = укз.предш;
            return врм;
        }

        /**
         * Инкрементирует курсор на заданное количество.
         *
         * Это операция O(прир)! Его следует использовать только в форме:
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
         * Декрементирует курсор на заданное количество.
         *
         * Это операция O(прир)! Его следует использовать только в форме:
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
         * Сравнивает два курсора на равенство.
         */
        бул opEquals(курсор обх)
        {
            return укз is обх.ptr;
        }
    }

    /**
     * Конструктор.
     */
    this()
    {
        _связка.установка();
    }

    //
    // private constructor for dup
    //
    private this(ref Реализ дубИз, бул копироватьУзлы)
    {
      дубИз.копируйВ(_связка, копироватьУзлы);
    }

    /**
     * Очистить коллекцию от всех элементов.
     */
    ТипСвязкаСписок зачисть()
    {
        _связка.зачисть();
        return this;
    }

    /**
     * Возвращает число элементов в коллекции.
     */
    бцел длина()
    {
        return _связка.счёт;
    }
	alias длина length;

    /**
     * Возвращает курсор на первый элемент в коллекции.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _связка.начало;
        return обх;
    }

    /**
     * Возвращает курсор, который указывает сразу после последнего элемента
     * в этой коллекции.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _связка.конец;
        return обх;
    }

    /**
     * Удаляет элемент, на который указывает данный курсор, возвращая
     * курсор, который указывает на следующий элемент в этой коллекции.
     *
     * Выполняется за время O(1).
     */
    курсор удали(курсор обх)
    {
        обх.ptr = _связка.удали(обх.ptr);
        return обх;
    }

    /**
     * Удаляет элементы, на которые указывает заданный курсорный диапазон, возвращая
     * курсор, указывающий на элемент, на который указывал последн.
     *
     * Выполняется за время O(последн-первый).
     */
    курсор удали(курсор первый, курсор последн)
    {
        последн.ptr = _связка.удали(первый.ptr, последн.ptr);
        return последн;
    }

    /**
     * Удаляет первый элемент со значением з. Возвращает да, если
     * значение имелось и было удалено.
     *
     * Выполняется за время O(n).
     */
    ТипСвязкаСписок удали(З з)
    {
        бул пропущен;
        return удали(з, пропущен);
    }

    /**
     * Удаляет первый элемент со значением з. Возвращает да, если
     * значение имелось и было удалено.
     *
     * Выполняется за время O(n).
     */
    ТипСвязкаСписок удали(З з, ref бул былУдалён)
    {
        auto обх = найди(з);
        if(обх == конец)
        {
            былУдалён = false;
        }
        else
        {
            былУдалён = true;
            удали(обх);
        }
        return this;
    }

    /**
     * Находит указанное значение в коллекции, начиная с заданного курсора.
     * Применяется для итерации по всем элементам с одинаковым значением.
     *
     * Выполняется за время O(n).
     */
    курсор найди(курсор обх, З з)
    {
        return _найди(обх, конец, з);
    }

    /**
     * Находит экземпляр значения в коллекции. Эквивалентно
     * найди(начало, з);
     *
     * Выполняется за время O(n).
     */
    курсор найди(З з)
    {
        return _найди(начало, конец, з);
    }

    private курсор _найди(курсор обх, курсор последн, З з)
    {
        while(обх != последн && обх.значение != з)
            обх++;
        return обх;
    }

    /**
     * Возвращает да, если заданное значение существует в коллекции.
     *
     * Выполняется за время O(n).
     */
    бул содержит(З з)
    {
        return найди(з) != конец;
    }

    private цел _примени(цел delegate(ref бул, ref З) дг, курсор старт, курсор последн)
    {
        курсор i = старт;
        цел возврдг = 0;
        бул удалить_ли;

        while(i != последн && i.ptr !is _связка.конец)
        {
            удалить_ли = false;
            if((возврдг = дг(удалить_ли, i.ptr.значение)) != 0)
                break;
            if(удалить_ли)
                удали(i++);
            else
                i++;
        }
        return возврдг;
    }

    private цел _примени(цел delegate(ref З значение) дг, курсор первый, курсор последн)
    {
        цел возврзнач = 0;
        for(курсор i = первый; i != последн; i++)
            if((возврзнач = дг(i.ptr.значение)) != 0)
                break;
        return возврзнач;
    }

    /**
     * Итерирует по значениям коллекции.
     */
    цел opApply(цел delegate(ref З значение) дг)
    {
        return _примени(дг, начало, конец);
    }

    /**
     * Итерирует по значениям коллекции, определяя те, которые нужно 
     * удалить.
     *
     * Используется так:
     *
     * -----------
     * // удалить все нечётные значения
     * foreach(ref чистить_ли, з; &list.очистить)
     * {
     *   чистить_ли = ((з & 1) == 1);
     * }
     * -----------
     */
    final цел очистить(цел delegate(ref бул удалить_ли, ref З значение) дг)
    {
        return _примени(дг, начало, конец);
    }

    /**
     * Добавляет элемент в этот список. Возвращает да, если этот элемент
     * до этого отсутствовал.
     *
     * Выполняется за время O(1).
     */
    ТипСвязкаСписок добавь(З з)
    {
        _связка.вставь(_связка.конец, з);
        return this;
    }

    /**
     * Добавляет элемент в этот список. Возвращает да, если этот элемент
     * до этого отсутствовал.
     *
     * Выполняется за время O(1).
     */
    ТипСвязкаСписок добавь(З з, ref бул былДобавлен)
    {
        _связка.вставь(_связка.конец, з);
        былДобавлен = true;
        return this;
    }

    /**
     * Добавляет все значения из заданного обходчика в этот список.
     *
     * Возвращает this.
     */
    ТипСвязкаСписок добавь(Обходчик!(З) колл)
    {
        foreach(з; колл)
            добавь(з);
        return this;
    }

    /**
     * Добавляет все значения из заданного обходчика в этот список.
     *
     * Возвращает число добавленных элементов.
     */
    ТипСвязкаСписок добавь(Обходчик!(З) колл, ref бцел члоДобавленных)
    {
        бцел оригДлина = длина;
        добавь(колл);
        члоДобавленных = длина - оригДлина;
        return this;
    }

    /**
     * Добавляет все значения из заданного массива в этот список.
     *
     * Возвращает число добавленных элементов.
     */
    ТипСвязкаСписок добавь(З[] массив)
    {
        foreach(з; массив)
            добавь(з);
        return this;
    }

    /**
     * Добавляет все значения из заданного массива в этот список.
     *
     * Возвращает число добавленных элементов.
     */
    ТипСвязкаСписок добавь(З[] массив, ref бцел члоДобавленных)
    {
        foreach(з; массив)
            добавь(з);
        члоДобавленных = массив.length;
        return this;
    }

    /**
     * Подсчитывает число случаев наличия з.
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
     * Удаляет все случаи з. Возвращает число удалённых экземпляров.
     *
     * Выполняется за время O(n).
     */
    ТипСвязкаСписок удалиВсе(З з)
    {
        foreach(ref dp, x; &очистить)
        {
            dp = cast(бул)(x == з);
        }
        return this;
    }

    /**
     * Удаляет все случаи з. Возвращает число удалённых экземпляров.
     *
     * Выполняется за время O(n).
     */
    ТипСвязкаСписок удалиВсе(З з, ref бцел члоУдалённых)
    {
        бцел оригДлина;
        удалиВсе(з);
        члоУдалённых = оригДлина - длина;
        return this;
    }

    //
    // Полезные функции для списка-связки
    //
	
//insert = вставь?
    /**
     * Вставляет элемент по заданной позиции. Возвращает курсор на
     * недавно вставленный элемент.
     */
    курсор вставь(курсор обх, З з) 
    {
        обх.ptr = _связка.вставь(обх.ptr, з);
        return обх;
    }
//prepend = надставь?
    /**
     * Надставляет элемент к первому элементу в списке. Возвращает
     * курсор на вновь надставленный элемент.
     */
    курсор надставь(З з) 
    {
        return вставь(начало, з);
    }
//append = подставь?
    /**
     * Подставляет элемент к последнему элементу в списке. Возвращает курсор
     * на вновь подставленный элемент.
     */
    курсор подставь(З з) 
    {
        return вставь(конец, з);
    }

    /**
     * Возвращает последний элемент в списке. Неопределенно, если список пуст.
     */
    З тыл()
    {
        return _связка.конец.предш.значение;
    }
    
    /**
     * Возвращает первый элемент в списке. Неопределенно, если список пуст.
     */
    З фронт()
    {
        return _связка.начало.значение;
    }

    /**
     * Удаляет первый элемент в списке и возвращает его значение.
     *
     * Не вызывайте при пустом списке.
     */
    З возьмиФронт()
    {
        auto возврзнач = фронт;
        _связка.удали(_связка.начало);
        return возврзнач;
    }

    /**
     * Удаляет последний элемент в списке и возвращает его значение.
     *
     * Не вызывайте при пустом списке.
     */
    З возьмиТыл()
    {
        auto возврзнач = тыл;
        _связка.удали(_связка.конец.предш);
        return возврзнач;
    }

    /**
     * Создаёт новый список, в котором этот и правткт конкатенированы вместе.
     */
    ТипСвязкаСписок opCat(Список!(З) правткт)
    {
        return dup.добавь(правткт);
    }

    /**
     * Создаёт новый список, в котором этот и массив конкатенированы вместе.
     */
    ТипСвязкаСписок opCat(З[] массив)
    {
        return dup.добавь(массив);
    }

    /**
     * Создаёт новый список, в котором массив and этот список конкатенированы вместе.
     */
    ТипСвязкаСписок opCat_r(З[] массив)
    {
        auto рез = new ТипСвязкаСписок(_связка, false);
        return рез.добавь(массив).добавь(this);
    }

    /**
     * Подставляет указанный список в конец этого списка.
     */
    ТипСвязкаСписок opCatAssign(Список!(З) правткт)
    {
        return добавь(правткт);
    }

    /**
     * Подставляет указанный массив в конец этого списка.
     */
    ТипСвязкаСписок opCatAssign(З[] массив)
    {
        return добавь(массив);
    }

    /**
     * Создаёт дубликат этого списка.
     */
    ТипСвязкаСписок dup()
    {
        return new ТипСвязкаСписок(_связка, true);
    }

    /**
     * Сравнивает этот список с другим списком. Возвращает да, если оба списка
     * одинаковой длины и все их элементы одинаковы.
     *
     * Если o = пусто или не является Список, возвращается 0.
     */
    цел opEquals(Объект o)
    {
        if(o !is пусто)
        {
            auto li = cast(Список!(З))o;
            if(li !is пусто && li.length == длина)
            {
                auto c = начало;
                foreach(элт; li)
                {
                    if(элт != c++.значение)
                        return 0;
                }
                return 1;
            }
        }
        return 0;
    }

    /**
     * Сортирует линкованный список в соответствии с заданной функцией сравнения.
     *
     * Выполняется за время O(n lg(n)).
     *
     * Возвращает this после сортировки.
     */
    СвязкаСписок сортируй(цел delegate(ref З, ref З) comp)
    {
        _связка.сортируй(comp);
        return this;
    }

    /**
     * Сортирует линкованный список в соответствии с заданной функцией сравнения.
     *
     * Выполняется за время O(n lg(n)).
     *
     * Возвращает this после сортировки.
     */
    СвязкаСписок сортируй(цел function(ref З, ref З) comp)
    {
        _связка.сортируй(comp);
        return this;
    }

    /**
     * Сортирует линкованный список в соответствии с дефолтной функцией сравнения для З.
     *
     * Выполняется за время O(n lg(n)).
     *
     * Returns this
     */
    СвязкаСписок сортируй()
    {
        return сортируй(&ДефСравнить!(З));
    }

    /**
     * Сортирукт линокованный список в соответствии с заданным фугнктором сравнения. Это
     * шаблонизированная версия, она может использоваться с функторами, и может быть
     * инлайном в коде(inlined).
     */
    СвязкаСписок сортируйИкс(Сравниватель)(Сравниватель comp)
    {
        _связка.сортируй(comp);
        return this;
    }
}

version(UnitTest)
{
    unittest
    {
        auto ll = new СвязкаСписок!(бцел);
        Список!(бцел) l = ll;
        l.добавь([0U, 1, 2, 3, 4, 5]);
        assert(l.length == 6);
        assert(l.содержит(5));
        foreach(ref чистить_ли, i; &l.очистить)
            чистить_ли = (i % 2 == 1);
        assert(l.length == 3);
        assert(!l.содержит(5));
    }
}
