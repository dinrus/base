module col.model.Seq;

private import  col.model.SeqView,
        col.model.IteratorX,
        col.model.Dispenser;

/**
 * Seqs are Seqs possessing стандарт modification methods
**/


public interface Сек(T) : ОбзорСека!(T), Расходчик!(T)
{
    public override Сек!(T) дубликат();
    public alias дубликат dup;
    /**
     * Insert все элементы of enumeration e at a given индекс, preserving
     * their order. The индекс can range из_
     * 0..размер() (i.e., one past the текущ последний индекс). If the индекс is
     * equal в_ размер(), the элементы are appended.
     *
     * @param индекс the индекс в_ старт добавим at
     * @param e the элементы в_ добавь
     * Возвращает: condition:
     * <PRE>
     * foreach (цел i in 0 .. индекс-1) at(i).равно(PREV(this)at(i)); &&
     * все existing элементы at индексы at or greater than индекс have their
     *  индексы incremented by the число of элементы
     *  traversable via e.получи() &&
     * The new элементы are at индексы индекс + their order in
     *   the enumeration's получи traversal.
     * !(e.ещё()) &&
     * (version() != PREV(this).version()) == PREV(e).ещё()
     * </PRE>
     * Выводит исключение: IllegalElementException if !canInclude some элемент of e;
     * this may or may not nullify the effect of insertions of другой элементы.
     * Выводит исключение: НетЭлементаИскл if индекс is not in range 0..размер()
     * Выводит исключение: ИсклПовреждённыйОбходчик is propagated if raised; this
     * may or may not nullify the effects of insertions of другой элементы.
    **/

    public проц добавьПо (цел индекс, Обходчик!(T) e);


    /**
     * Insert элемент at indicated индекс. The индекс can range из_
     * 0..размер() (i.e., one past the текущ последний индекс). If the индекс is
     * equal в_ размер(), the элемент is appended as the new последний элемент.
     * @param индекс the индекс в_ добавь at
     * @param элемент the элемент в_ добавь
     * Возвращает: condition:
     * <PRE>
     * размер() == PREV(this).размер()+1 &&
     * at(индекс).равно(элемент) &&
     * foreach (цел i in 0 .. индекс-1)      получи(i).равно(PREV(this).получи(i))
     * foreach (цел i in индекс+1..размер()-1) получи(i).равно(PREV(this).получи(i-1))
     * Версия change: always
     * </PRE>
     * Выводит исключение: НетЭлементаИскл if индекс is not in range 0..размер()
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
    **/

    public проц добавьПо (цел индекс, T элемент);

    /**
     * замени элемент at indicated индекс with new значение
     * @param индекс the индекс at which в_ замени значение
     * @param элемент the new значение
     * Возвращает: condition:
     * <PRE>
     * размер() == PREV(this).размер() &&
     * at(индекс).равно(элемент) &&
     * no spurious effects
     * Версия change <-- !элемент.равно(PREV(this).получи(индекс)
     *                    (but MAY change even if equal).
     * </PRE>
     * Выводит исключение: НетЭлементаИскл if индекс is not in range 0..размер()-1
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
    **/

    public проц замениПо (цел индекс, T элемент);

    /**
     * замени элемент at indicated индекс with new значение
     * @param элемент the new значение
     * @param индекс the индекс at which в_ замени значение
     * Возвращает: condition:
     * <PRE>
     * размер() == PREV(this).размер() &&
     * at(индекс).равно(элемент) &&
     * no spurious effects
     * Версия change <-- !элемент.равно(PREV(this).получи(индекс)
     *                    (but MAY change even if equal).
     * </PRE>
     * Выводит исключение: НетЭлементаИскл if индекс is not in range 0..размер()-1
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
    **/
    public проц opIndexAssign (T элемент, цел индекс);


    /**
     * Удали элемент at indicated индекс. все элементы в_ the право
     * have their индексы decremented by one.
     * @param индекс the индекс of the элемент в_ удали
     * Возвращает: condition:
     * <PRE>
     * размер() = PREV(this).размер()-1 &&
     * foreach (цел i in 0..индекс-1)      получи(i).равно(PREV(this).получи(i)); &&
     * foreach (цел i in индекс..размер()-1) получи(i).равно(PREV(this).получи(i+1));
     * Версия change: always
     * </PRE>
     * Выводит исключение: НетЭлементаИскл if индекс is not in range 0..размер()-1
    **/
    public проц удалиПо (цел индекс);


    /**
     * Insert элемент at front of the sequence.
     * По поведению равнозначно вставь(0, элемент)
     * @param элемент the элемент в_ добавь
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
    **/

    public проц приставь(T элемент);


    /**
     * замени элемент at front of the sequence with new значение.
     * По поведению равнозначно замени(0, элемент);
    **/
    public проц замениГолову(T элемент);

    /**
     * Удали the левейший элемент.
     * По поведению равнозначно удали(0);
    **/

    public проц удалиГолову();


    /**
     * вставь элемент at конец of the sequence
     * По поведению равнозначно вставь(размер(), элемент)
     * @param элемент the элемент в_ добавь
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
    **/

    public проц добавь(T элемент);
    public alias добавь opCatAssign;

    /**
     * замени элемент at конец of the sequence with new значение
     * По поведению равнозначно замени(размер()-1, элемент);
    **/

    public проц замениХвост(T элемент);



    /**
     * Удалить правейший элемент.
     * По поведению равнозначно удали(размер()-1);
     * Выводит исключение: НетЭлементаИскл,если пуст_ли
    **/
    public проц удалиХвост();


    /**
     * Удали the элементы из_ отИндекса в_ доИндекса, включительно.
     * No effect if отИндекса > доИндекса.
     * По поведению равнозначно
     * <PRE>
     * for (цел i = отИндекса; i &lt;= доИндекса; ++i) удали(отИндекса);
     * </PRE>
     * @param индекс the индекс of the первый элемент в_ удали
     * @param индекс the индекс of the последний элемент в_ удали
     * Возвращает: condition:
     * <PRE>
     * let n = max(0, доИндекса - отИндекса + 1 in
     *  размер() == PREV(this).размер() - 1 &&
     *  for (цел i in 0 .. отИндекса - 1)     получи(i).равно(PREV(this).получи(i)) &&
     *  for (цел i in отИндекса .. размер()- 1) получи(i).равно(PREV(this).получи(i+n)
     *  Версия change iff n > 0
     * </PRE>
     * Выводит исключение: НетЭлементаИскл if отИндекса or доИндекса is not in
     * range 0..размер()-1
    **/

    public проц удалиДиапазон(цел отИндекса, цел доИндекса);


    /**
     * Prepend все элементы of enumeration e, preserving their order.
     * По поведению равнозначно добавьЭлтыПо(0, e)
     * @param e the элементы в_ добавь
    **/

    public проц приставь(Обходчик!(T) e);


    /**
     * Доб все элементы of enumeration e, preserving their order.
     * По поведению равнозначно добавьЭлтыПо(размер(), e)
     * @param e the элементы в_ добавь
    **/
    public проц добавь(Обходчик!(T) e);
}


