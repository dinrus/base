module col.model.GuardIterator;

private import col.model.IteratorX;

/**
 *
 * CollectionIterator extends the стандарт
 * col.model.IteratorX interface with two добавьitional methods.
 * 
**/

public interface СтражОбходчик(З) : Обходчик!(З)
{
        /**
         * Возвращает да, если the collection that constructed this enumeration
         * имеется been detectably изменён since construction of this enumeration.
         * Ability и точность of detection of this condition can vary
         * across collection class implementations.
         * ещё() is нет whenever повреждён is да.
         *
         * Возвращает: да, если detectably повреждён.
        **/

        public бул повреждён();

        /**
         * Возвращает the число of элементы in the enumeration that have
         * not yet been traversed. When повреждён() is да, this 
         * число may (or may not) be greater than zero even if ещё() 
         * is нет. Исключение recovery mechanics may be able в_
         * use this as an indication that recovery of some сортируй is
         * warranted. However, it is not necessarily a foolproof indication.
         * <P>
         * You can also use it в_ pack enumerations преобр_в массивы. For example:
         * <PRE>
         * Объект масс[] = new Объект[e.numberOfRemainingElement()]
         * цел i = 0;
         * while (e.ещё()) масс[i++] = e.значение();
         * </PRE>
         * <P>
         * For the converse case, 
         * См_Также: col.iterator.ArrayIterator.ОбходчикМассива
         * Возвращает: the число of untraversed элементы
        **/

        public бцел остаток();
}


public interface ОбходчикПар(К, З) : СтражОбходчик!(З)
{
        alias СтражОбходчик!(З).получи     получи;
        alias СтражОбходчик!(З).opApply opApply;
        
        public З получи (inout К ключ);

        цел opApply (цел delegate (inout К ключ, inout З значение) дг);        
}

