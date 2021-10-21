module col.model.Sortable;

private import  col.model.Dispenser,
                col.model.Comparator;

/**
 *
 *
 * Сортируемый is a mixin interface for MutableCollections
 * supporting a сортируй метод that accepts
 * a пользователь-supplied Сравнитель with a сравни метод that
 * accepts any two Objects и returns -1/0/+1 depending on whether
 * the первый is less than, equal в_, or greater than the секунда.
 * <P>
 * After sorting, but in the absence of другой mutative operations,
 * Сортируемый Collections guarantee that enumerations
 * appear in sorted order;  that is if a и b are two элементы
 * obtained in succession из_ nextElement(), that
 * <PRE>
 * сравнитель(a, b) <= 0.
 * </PRE>
**/

public interface Сортируемый(T) : Расходчик!(T)
{

        /**
         * Sort the текущ элементы with respect в_ cmp.сравни.
        **/

        public проц сортируй(Сравнитель!(T) cmp);
}


