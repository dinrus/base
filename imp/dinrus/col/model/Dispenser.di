﻿module col.model.Dispenser;

private import  col.model.View,
        col.model.IteratorX;

/**
 *
 * Расходчик is the корень interface of все изменяемый собериions; т.е.,
 * собериions that may have элементы dynamically добавьed, removed,
 * и/or replaced in accord with their collection semantics.
 *
**/

public interface Расходчик(T) : Обзор!(T)
{
    public override Расходчик!(T) дубликат ();
    public alias дубликат dup;
    /**
     * Cause the collection в_ become пустой.
     * Возвращает: condition:
     * <PRE>
     * пуст_ли() &&
     * Версия change iff !PREV(this).пуст_ли();
     * </PRE>
    **/

    public проц очисть ();

    /**
     * Замени an occurrence of старЭлемент with новЭлемент.
     * No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
     * The operation имеется a consistent, but slightly special interpretation
     * when applied в_ Sets. For Sets, because элементы occur at
     * most once, if новЭлемент is already included, replacing старЭлемент with
     * with новЭлемент имеется the same effect as just removing старЭлемент.
     * Возвращает: condition:
     * <PRE>
     * let цел дельта = старЭлемент.равно(новЭлемент)? 0 :
     *               max(1, PREV(this).экземпляры(старЭлемент) in
     *  экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - дельта &&
     *  экземпляры(новЭлемент) ==  (this instanceof Набор) ?
     *         max(1, PREV(this).экземпляры(старЭлемент) + дельта):
     *                PREV(this).экземпляры(старЭлемент) + дельта) &&
     *  no другой элемент changes &&
     *  Версия change iff дельта != 0
     * </PRE>
     * Выводит исключение: IllegalElementException if имеется(старЭлемент) и !допускается(новЭлемент)
    **/

    public проц замени (T старЭлемент, T новЭлемент);

    /**
     * Замени все occurrences of старЭлемент with новЭлемент.
     * No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
     * The operation имеется a consistent, but slightly special interpretation
     * when applied в_ Sets. For Sets, because элементы occur at
     * most once, if новЭлемент is already included, replacing старЭлемент with
     * with новЭлемент имеется the same effect as just removing старЭлемент.
     * Возвращает: condition:
     * <PRE>
     * let цел дельта = старЭлемент.равно(новЭлемент)? 0 :
                       PREV(this).экземпляры(старЭлемент) in
     *  экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - дельта &&
     *  экземпляры(новЭлемент) ==  (this instanceof Набор) ?
     *         max(1, PREV(this).экземпляры(старЭлемент) + дельта):
     *                PREV(this).экземпляры(старЭлемент) + дельта) &&
     *  no другой элемент changes &&
     *  Версия change iff дельта != 0
     * </PRE>
     * Выводит исключение: IllegalElementException if имеется(старЭлемент) и !допускается(новЭлемент)
    **/

    public проц замениВсе(T старЭлемент, T новЭлемент);

    /**
     * Удали и return an элемент.  Implementations
     * may strengthen the guarantee about the nature of this элемент.
     * but in general it is the most convenient or efficient элемент в_ удали.
     * <P>
     * Пример usage. One way в_ перемести все элементы из_
     * Расходчик a в_ MutableBag b is:
     * <PRE>
     * while (!a.пустой()) b.добавь(a.возьми());
     * </PRE>
     * Возвращает: an элемент знач such that PREV(this).имеется(знач)
     * и the postconditions of removeOneOf(знач) hold.
     * Выводит исключение: НетЭлементаИскл iff пуст_ли.
    **/

    public T возьми ();


    /**
     * Exclude все occurrences of each элемент of the Обходчик.
     * По поведению равнозначно
     * <PRE>
     * while (e.ещё()) удалиВсе(e.значение());
     * @param e the enumeration of элементы в_ exclude.
     * Выводит исключение: ИсклПовреждённыйОбходчик is propagated if thrown
    **/

    public проц удалиВсе (Обходчик!(T) e);

    /**
     * Удали an occurrence of each элемент of the Обходчик.
     * По поведению равнозначно
     * <PRE>
     * while (e.ещё()) удали (e.значение());
     * @param e the enumeration of элементы в_ удали.
     * Выводит исключение: ИсклПовреждённыйОбходчик is propagated if thrown
    **/

    public проц удали (Обходчик!(T) e);

    /**
     * Exclude все occurrences of the indicated элемент из_ the collection.
     * No effect if элемент not present.
     * @param элемент the элемент в_ exclude.
     * Возвращает: condition:
     * <PRE>
     * !имеется(элемент) &&
     * размер() == PREV(this).размер() - PREV(this).экземпляры(элемент) &&
     * no другой элемент changes &&
     * Версия change iff PREV(this).имеется(элемент)
     * </PRE>
    **/

    public проц удалиВсе (T элемент);


    /**
     * Удали an экземпляр of the indicated элемент из_ the collection.
     * No effect if !имеется(элемент)
     * @param элемент the элемент в_ удали
     * Возвращает: condition:
     * <PRE>
     * let occ = max(1, экземпляры(элемент)) in
     *  размер() == PREV(this).размер() - occ &&
     *  экземпляры(элемент) == PREV(this).экземпляры(элемент) - occ &&
     *  no другой элемент changes &&
     *  version change iff occ == 1
     * </PRE>
    **/

    public проц удали (T элемент);
}


