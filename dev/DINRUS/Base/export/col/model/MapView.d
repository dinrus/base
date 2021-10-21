module col.model.MapView;

private import  col.model.View,
                col.model.GuardIterator;

/**
 * Maps maintain keyed элементы. Any kind of Объект 
 * may serve as a ключ for an элемент.
**/

public interface ОбзорКарты(К, З) : Обзор!(З)
{
        public override ОбзорКарты!(К,З) дубликат();
        public alias дубликат dup;
        /**
         * Report whether the MapT COULD include ключ as a ключ
         * Always returns нет if ключ is пусто
        **/

        public бул допускаетсяКлюч(К ключ);

        /**
         * Report whether there есть_ли any элемент with Key ключ.
         * Возвращает: да if there is such an элемент
        **/

        public бул содержитКлюч(К ключ);

        /**
         * Report whether there есть_ли a (ключ, значение) пара
         * Возвращает: да if there is such an элемент
        **/

        public бул содержитПару(К ключ, З значение);


        /**
         * Return an enumeration that may be использован в_ traverse through
         * the ключи (not элементы) of the collection. The corresponding
         * элементы can be looked at by using at(ключ) for each ключ ключ. For example:
         * <PRE>
         * Обходчик ключи = amap.ключи();
         * while (ключи.ещё()) {
         *   К ключ = ключи.получи();
         *   T значение = amap.получи(ключ)
         * // ...
         * }
         * </PRE>
         * Возвращает: the enumeration
        **/

        public ОбходчикПар!(К, З) ключи();

        /**
         traverse the collection контент. This is cheaper than using an
         обходчик since there is no creation cost involved.
        **/

        цел opApply (цел delegate (inout К ключ, inout З значение) дг);
        
        /**
         * Return the элемент associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: элемент such that содержит(ключ, элемент)
         * Throws: НетЭлементаИскл if !содержитКлюч(ключ)
        **/

        public З получи(К ключ);
        public alias получи opIndex;

        /**
         * Return the элемент associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public бул получи(К ключ, inout З элемент); 


        /**
         * Return a ключ associated with элемент. There may be any
         * число of ключи associated with any элемент, but this returns only
         * one of them (any arbitrary one), or нет if no such ключ есть_ли.
         * @param ключ, a place в_ return a located ключ
         * @param элемент, a значение в_ try в_ найди a ключ for.
         * Возвращает: да where значение is найдено; нет иначе
        **/

        public бул ключК(inout К ключ, З значение);
}

