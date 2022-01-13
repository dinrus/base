module col.model.Comparator;


/**
 *
 * Сравнитель is an interface for any class possessing an элемент
 * сравнение метод.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

template Сравнитель(T)
{
        alias цел delegate(T, T) Сравнитель;
}

/+
public interface Сравнитель(T)
{
        /**
         * @param перв первый аргумент
         * @param втор секунда аргумент
         * Возвращает: a негатив число if перв is less than втор; a
         * positive число if перв is greater than втор; else 0
        **/
        public цел сравни(T перв, T втор);
}
+/
