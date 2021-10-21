module col.model.MapX;

private import  col.model.MapView,
        col.model.Dispenser;

/**
 *
 * MutableMap supports стандарт обнови operations on maps.
 *
**/

public interface Карта(К, T) : ОбзорКарты!(К, T), Расходчик!(T)
{
    public override Карта!(К,T) дубликат();
    public alias дубликат dup;
    /**
     * Include the indicated пара in the Карта
     * If a different пара
     * with the same ключ was previously held, it is replaced by the
     * new пара.
     *
     * @param ключ the ключ for элемент в_ include
     * @param элемент the элемент в_ include
     * Возвращает: condition:
     * <PRE>
     * имеется(ключ, элемент) &&
     * no spurious effects &&
     * Версия change iff !PREV(this).содержит(ключ, элемент))
     * </PRE>
    **/

    public проц добавь (К ключ, T элемент);

    /**
     * Include the indicated пара in the Карта
     * If a different пара
     * with the same ключ was previously held, it is replaced by the
     * new пара.
     *
     * @param элемент the элемент в_ include
     * @param ключ the ключ for элемент в_ include
     * Возвращает: condition:
     * <PRE>
     * имеется(ключ, элемент) &&
     * no spurious effects &&
     * Версия change iff !PREV(this).содержит(ключ, элемент))
     * </PRE>
    **/

    public проц opIndexAssign (T элемент, К ключ);


    /**
     * Удали the пара with the given ключ
     * @param  ключ the ключ
     * Возвращает: condition:
     * <PRE>
     * !содержитКлюч(ключ)
     * foreach (ключ in ключи()) at(ключ).равно(PREV(this).at(ключ)) &&
     * foreach (ключ in PREV(this).ключи()) (!ключ.равно(ключ)) --> at(ключ).равно(PREV(this).at(ключ))
     * (version() != PREV(this).version()) ==
     * содержитКлюч(ключ) !=  PREV(this).содержитКлюч(ключ))
     * </PRE>
    **/

    public проц удалиКлюч (К ключ);


    /**
     * Замени old пара with new пара with same ключ.
     * No effect if пара not held. (This имеется the case of
     * having no effect if the ключ есть_ли but is bound в_ a different значение.)
     * @param ключ the ключ for the пара в_ удали
     * @param старЭлемент the existing элемент
     * @param новЭлемент the значение в_ замени it with
     * Возвращает: condition:
     * <PRE>
     * !содержит(ключ, старЭлемент) || содержит(ключ, новЭлемент);
     * no spurious effects &&
     * Версия change iff PREV(this).содержит(ключ, старЭлемент))
     * </PRE>
    **/

    public проц замениПару (К ключ, T старЭлемент, T новЭлемент);
}

