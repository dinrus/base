module col.model.SeqView;

private import col.model.View;

/**
 * 
 *
 * Seqs are indexed, sequentially ordered собериions.
 * Индексы are always in the range 0 .. размер() -1. все accesses by индекс
 * are проверьed, raising exceptions if the индекс falls out of range.
 * <P>
 * The элементы() enumeration for все seqs is guaranteed в_ be
 * traversed (via nextElement) in sequential order.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface ОбзорСека(T) : Обзор!(T)
{
        public override ОбзорСека!(T) дубликат();
        public alias дубликат dup;
        /**
         * Return the элемент at the indicated индекс
         * @param индекс 
         * Возвращает: the элемент at the индекс
         * Throws: НетЭлементаИскл if индекс is not in range 0..размер()-1
        **/

        public T получи(цел индекс);
        public alias получи opIndex;


        /**
         * Return the первый элемент, if it есть_ли.
         * Behaviorally equivalent в_ at(0)
         * Throws: НетЭлементаИскл if пуст_ли
        **/

        public T голова();


        /**
         * Return the последний элемент, if it есть_ли.
         * Behaviorally equivalent в_ at(размер()-1)
         * Throws: НетЭлементаИскл if пуст_ли
        **/

        public T хвост();


        /**
         * Report the индекс of левейший occurrence of an элемент из_ a 
         * given starting точка, or -1 if there is no such индекс.
         * @param элемент the элемент в_ look for
         * @param стартовыйИндекс the индекс в_ старт looking из_. The стартовыйИндекс
         * need not be a действителен индекс. If less than zero it is treated as 0.
         * If greater than or equal в_ размер(), the результат will always be -1.
         * Возвращает: индекс such that
         * <PRE> 
         * let цел si = max(0, стартовыйИндекс) in
         *  индекс == -1 &&
         *   foreach (цел i in si .. размер()-1) !at(индекс).равно(элемент)
         *  ||
         *  at(индекс).равно(элемент) &&
         *   foreach (цел i in si .. индекс-1) !at(индекс).равно(элемент)
         * </PRE>
        **/

        public цел первый(T элемент, цел стартовыйИндекс = 0);

        /**
         * Report the индекс of righttmost occurrence of an элемент из_ a 
         * given starting точка, or -1 if there is no such индекс.
         * @param элемент the элемент в_ look for
         * @param стартовыйИндекс the индекс в_ старт looking из_. The стартовыйИндекс
         * need not be a действителен индекс. If less than zero the результат
         * will always be -1.
         * If greater than or equal в_ размер(), it is treated as размер()-1.
         * Возвращает: индекс such that
         * <PRE> 
         * let цел si = min(размер()-1, стартовыйИндекс) in
         *  индекс == -1 &&
         *   foreach (цел i in 0 .. si) !at(индекс).равно(элемент)
         *  ||
         *  at(индекс).равно(элемент) &&
         *   foreach (цел i in индекс+1 .. si) !at(индекс).равно(элемент)
         * </PRE>
         *
        **/
        public цел последний(T элемент, цел стартовыйИндекс = 0);


        /**
         * Construct a new ОбзорСека that is a клонируй of сам except
         * that it does not contain the элементы before индекс or
         * после индекс+length. If length is less than or equal в_ zero,
         * return an пустой ОбзорСека.
         * @param индекс of the элемент that will be the 0th индекс in new ОбзорСека
         * @param length the число of элементы in the new ОбзорСека
         * Возвращает: new пследвтн such that
         * <PRE>
         * s.размер() == max(0, length) &&
         * foreach (цел i in 0 .. s.размер()-1) s.at(i).равно(at(i+индекс)); 
         * </PRE>
         * Throws: НетЭлементаИскл if индекс is not in range 0..размер()-1
        **/
        public ОбзорСека поднабор(цел индекс, цел length);

        /**
         * Construct a new ОбзорСека that is a клонируй of сам except
         * that it does not contain the элементы before начало or
         * после конец-1. If length is less than or equal в_ zero,
         * return an пустой ОбзорСека.
         * @param индекс of the элемент that will be the 0th индекс in new ОбзорСека
         * @param индекс of the последний элемент in the ОбзорСека plus 1
         * Возвращает: new пследвтн such that
         * <PRE>
         * s.размер() == max(0, length) &&
         * foreach (цел i in 0 .. s.размер()-1) s.at(i).равно(at(i+индекс)); 
         * </PRE>
         * Throws: НетЭлементаИскл if индекс is not in range 0..размер()-1
        **/
        public ОбзорСека opSlice(цел начало, цел конец);


version (VERBOSE)
{
        /**
         * Construct a new ОбзорСека that is a клонируй of сам except
         * that it добавьs (inserts) the indicated элемент at the
         * indicated индекс.
         * @param индекс the индекс at which the new элемент will be placed
         * @param элемент The элемент в_ вставь in the new collection
         * Возвращает: new пследвтн s, such that
         * <PRE>
         *  s.at(индекс) == элемент &&
         *  foreach (цел i in 1 .. s.размер()-1) s.at(i).равно(at(i-1));
         * </PRE>
         * Throws: НетЭлементаИскл if индекс is not in range 0..размер()-1
        **/

        public ОбзорСека вставкаПо(цел индекс, T элемент);


        /**
         * Construct a new ОбзорСека that is a клонируй of сам except
         * that the indicated элемент is placed at the indicated индекс.
         * @param индекс the индекс at which в_ замени the элемент
         * @param элемент The new значение of at(индекс)
         * Возвращает: new пследвтн, s, such that
         * <PRE>
         *  s.at(индекс) == элемент &&
         *  foreach (цел i in 0 .. s.размер()-1) 
         *     (i != индекс) --&gt; s.at(i).равно(at(i));
         * </PRE>
         * Throws: НетЭлементаИскл if индекс is not in range 0..размер()-1
        **/

        public ОбзорСека заменаПо(цел индекс, T элемент);


        /**
         * Construct a new ОбзорСека that is a клонируй of сам except
         * that it does not contain the элемент at the indeicated индекс; все
         * элементы в_ its право are slопрed лево by one.
         *
         * @param индекс the индекс at which в_ удали an элемент
         * Возвращает: new пследвтн such that
         * <PRE>
         *  foreach (цел i in 0.. индекс-1) s.at(i).равно(at(i)); &&
         *  foreach (цел i in индекс .. s.размер()-1) s.at(i).равно(at(i+1));
         * </PRE>
         * Throws: НетЭлементаИскл if индекс is not in range 0..размер()-1
        **/
        public ОбзорСека удалениеПо(цел индекс);
} // version
}

