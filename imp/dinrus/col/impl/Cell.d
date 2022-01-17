module col.impl.Cell;

/**
 * Ячейка is the основа of a bunch of implementation classes
 * for списки и the like.
 * The основа version just holds an Объект as its значение элемента
**/

public class Ячейка (T)
{
        // переменные экземпляра
        private T элемент_;

        /**
         * Создаёт ячейку со значением элемента знач.
        **/

        public this (T знач)
        {
                элемент_ = знач;
        }

        /**
         * Создаёт ячейку со значением элемента пусто.
        **/

        public this ()
        {
//                элемент_ = пусто;
        }

        /**
         * /Возвращает значение элемента.
        **/

        public final T элемент()
        {
                return элемент_;
        }

        /**
         * Устанавливает значение элемента.
        **/

        public final проц элемент (T знач)
        {
                элемент_ = знач;
        }

        public final цел хэшЭлемента ()
        {
                return typeid(T).дайХэш(&элемент_);
        }

        protected Ячейка дубликат()
        {
                return new Ячейка (элемент_);
        }
}
