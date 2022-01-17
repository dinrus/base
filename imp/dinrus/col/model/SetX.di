module col.model.SetX;

private import  col.model.SetView,
        col.model.IteratorX,
        col.model.Dispenser;

/**
 *
 * MutableSets support an include operations в_ добавь
 * an элемент only if it not present.
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface Набор(T) : ОбзорНабора!(T), Расходчик!(T)
{
    public override Набор!(T) дубликат();
    public alias дубликат dup;

    /**
     * Include the indicated элемент in the collection.
     * No effect if the элемент is already present.
     * @param элемент the элемент в_ добавь
     * Возвращает: condition:
     * <PRE>
     * имеется(элемент) &&
     * no spurious effects &&
     * Версия change iff !PREV(this).имеется(элемент)
     * </PRE>
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
    **/

    public проц добавь (T элемент);


    /**
     * Include все элементы of the enumeration in the collection.
     * По поведению равнозначно
     * <PRE>
     * while (e.ещё()) include(e.получи());
     * </PRE>
     * @param e the элементы в_ include
     * Выводит исключение: IllegalElementException if !canInclude(элемент)
     * Выводит исключение: ИсклПовреждённыйОбходчик propagated if thrown
    **/

    public проц добавь (Обходчик!(T) e);
    public alias добавь opCatAssign;
}

