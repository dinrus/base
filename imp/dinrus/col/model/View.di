module col.model.View;

private import col.model.Dispenser;
private import col.model.GuardIterator;


/**
 * Это базовый интерфейс к большинству классов из этого пакета.
**/
public interface Обзор(T) 
{
        /**
         * все Views implement дубликат
        **/

        public Обзор!(T) дубликат ();
        public alias дубликат dup;

        /**
         * Report whether the Обзор содержит элемент.
         * По поведению равнозначно <CODE>экземпляры(элемент) &gt;= 0</CODE>.
         * @param элемент the элемент в_ look for
         * Возвращает: да, еслиf содержит at least one member that is equal в_ элемент.
        **/
        public бул содержит (T элемент);
        public alias содержит opIn;

        /**
         * Report the число of элементы in the Обзор.
         * No другой spurious effects.
         * Возвращает: число of элементы
        **/
        public бцел размер ();
        public alias размер length;

        /**
         * Report whether this Обзор имеется no элементы.
         * По поведению равнозначно <CODE>размер() == 0</CODE>.
         * Возвращает: да, если размер() == 0
        **/

        public бул опустошён ();


        /**
         * все собериions maintain a `version число'. The numbering
         * схема is arbitrary, but is guaranteed в_ change upon every
         * modification that could possibly affect an элементы() enumeration traversal.
         * (This is да at least внутри the точность of the `цел' представление;
         * performing ещё than 2^32 operations will lead в_ reuse of version numbers).
         * Versioning
         * <EM>may</EM> be conservative with respect в_ `замена' operations.
         * For the sake of versioning replacements may be consопрered as
         * removals followed by добавьitions. Thus version numbers may change 
         * even if the old и new  элементы are опрentical.
         * <P>
         * все элемент() enumerations for Mutable Collections track version
         * numbers, и raise inconsistency exceptions if the enumeration is
         * использован (via получи()) on a version другой than the one generated
         * by the элементы() метод.
         * <P>
         * You can use versions в_ проверь if обнови operations actually have any effect
         * on observable состояние.
         * Например, очисть() will cause cause a version change only
         * if the collection was previously non-пустой.
         * Возвращает: the version число
        **/

        public бцел изменение ();
        
        /**
         * Report whether the Обзор COULD contain элемент,
         * т.е., that it is действителен with respect в_ the Обзор's
         * элемент скринер if it имеется one.
         * Always returns нет if элемент == пусто.
         * A constant function: if позволяет(знач) is ever да it is всегда да.
         * (This property is not in any way enforced however.)
         * No другой spurious effects.
         * Возвращает: да, если non-пусто и проходки элемент скринер проверь
        **/
        public бул позволяет (T элемент);


        /**
         * Report the число of occurrences of элемент in Обзор.
         * Always returns 0 if элемент == пусто.
         * Otherwise T.равно is использован в_ тест for equality.
         * @param элемент the элемент в_ look for
         * Возвращает: the число of occurrences (всегда nonnegative)
        **/
        public бцел экземпляры (T элемент);

        /**
         * Возвращает an enumeration that may be использован в_ traverse through
         * the элементы in the Обзор. Standard usage, for some
         * ОбзорТ c, и some operation `use(T об)':
         * <PRE>
         * for (Обходчик e = c.элементы(); e.ещё(); )
         *   use(e.значение());
         * </PRE>
         * (The значения of получи very often need в_
         * be coerced в_ типы that you know they are.)
         * <P>
         * все Views return экземпляры
         * of ViewIterator, that can report the число of остаток
         * элементы, и also выполни consistency проверьs so that
         * for MutableViews, элемент enumerations may become 
         * invalidated if the Обзор is изменён during such a traversal
         * (which could in turn cause random effects on the ОбзорТ.
         * TO prevent this,  ViewIterators 
         * raise ИсклПовреждённыйОбходчик on попытки в_ доступ
         * gets of altered Views.)
         * Note: Since все Обзор implementations are synchronizable,
         * you may be able в_ guarantee that элемент traversals will not be
         * повреждён by using the D <CODE>synchronized</CODE> construct
         * around код блокs that do traversals. (Use with care though,
         * since such constructs can cause deadlock.)
         * <P>
         * Guarantees about the nature of the элементы returned by  получи of the
         * returned Обходчик may vary accross подст-interfaces.
         * In все cases, the enumerations предоставленный by элементы() are guaranteed в_
         * step through (via получи) все элементы in the Обзор.
         * Unless guaranteed иначе (for example in Сек), элементы() enumerations
         * need not have any particular получи() ordering so дол as they
         * allow traversal of все of the элементы. So, for example, two successive
         * calls в_ элемент() may произведи enumerations with the same
         * элементы but different получи() orderings.
         * Again, подст-interfaces may предоставляет stronger guarantees. In
         * particular, Seqs произведи enumerations with gets in
         * индекс order, ElementSortedViews enumerations are in ascending 
         * sorted order, и KeySortedViews are in ascending order of ключи.
         * Возвращает: an enumeration e such that
         * <PRE>
         *   e.остаток() == размер() &&
         *   foreach (знач in e) имеется(e) 
         * </PRE>
        **/

        public СтражОбходчик!(T) элементы ();

        /**
         traverse the collection контент. This is cheaper than using an
         обходчик since there is no creation cost involved.
        **/

        public цел opApply (цел delegate (inout T значение) дг);

        /**
         expose collection контент как Массив
        **/

        public T[] вМассив ();

        /**
         * Report whether другой имеется the same элемент structure as this.
         * That is, whether другой is of the same размер, и имеется the same 
         * элементы() свойства.
         * This is a useful version of equality testing. But is not named
         * `равно' in часть because it may not be the version you need.
         * <P>
         * The easiest way в_ decribe this operation is just в_
         * explain как it is interpreted in стандарт подст-interfaces:
         * <UL>
         *  <LI> Сек и ElementSortedView: другой.элементы() имеется the 
         *        same order as this.элементы().
         *  <LI> Рюкзак: другой.элементы имеется the same экземпляры each элемент as this.
         *  <LI> Набор: другой.элементы имеется все элементы of this
         *  <LI> Карта: другой имеется все (ключ, элемент) pairs of this.
         *  <LI> KeySortedView: другой имеется все (ключ, элемент)
         *       pairs as this, и with ключи enumerated in the same order as
         *       this.ключи().
         *</UL>
         * @param другой, a Обзор
         * Возвращает: да, если consопрered в_ have the same размер и элементы.
        **/

        public бул совпадает (Обзор другой);
        public alias совпадает opEquals;


        /**
         * Check the consistency of internal состояние, и raise исключение if
         * not ОК.
         * These should be `best-effort' проверьs. You cannot всегда locally
         * determine full consistency, but can usually approximate it,
         * и оцени the most important представление invariants.
         * The most common kinds of проверьs are кэш проверьs. Например,
         * A linked список that also maintains a separate record of the
         * число of items on the список should проверь that the recorded
         * счёт совпадает the число of элементы в этом списке.
         * <P>
         * This метод should either return normally or throw:
         * Выводит исключение: ImplementationError if проверь fails
        **/

        public проц проверьРеализацию();
}

