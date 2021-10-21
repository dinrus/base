module col.model.SortedKeys;

private import  col.model.View,
                col.model.Comparator;

/**
 *
 *
 * KeySorted is a mixin interface for Collections that
 * are always in sorted order with respect в_ a Сравнитель
 * held by the Коллекция.
 * <P>
 * KeySorted Collections guarantee that enumerations
 * appear in sorted order;  that is if a и b are two Keys
 * obtained in succession из_ ключи().nextElement(), that
 * <PRE>
 * сравнитель(a, b) <= 0.
 * </PRE>
**/

public interface СортированныеКлючи(К, З) : Обзор!(З)
{

        /**
         * Report the Сравнитель использован for ordering
        **/

        public Сравнитель!(К) сравнитель();
}
