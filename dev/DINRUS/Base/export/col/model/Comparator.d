module col.model.Comparator;


/**
 *
 * Сравнитель - это интерфейс ля любого класса, у которого есть
 * метод сравнения элементов.
 * 
        author: Doug Lea
 * @version 0.93
 *
**/

template Сравнитель(T)
{
        alias цел delegate(T, T) Сравнитель;
}

alias Сравнитель Comparator;
/+
public interface Сравнитель(T)
{
        /**
         * @param перв первый аргумент
         * @param втор секунда аргумент
         * Возвращает: отрицательное число if перв is less than втор; a
         * positive число if перв is greater than втор; else 0
        **/
        public цел сравни(T перв, T втор);
}
+/
