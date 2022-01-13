module col.impl.Cell;

/**
 * Ячейка is the основа of a bunch of implementation classes
 * for списки и the like.
 * The основа version just holds an Объект as its элемент значение
**/

public class Ячейка (T)
{
        // экземпляр variables
        private T элемент_;

        /**
         * Make a ячейка with элемент значение знач
        **/

        public this (T знач)
        {
                элемент_ = знач;
        }

        /**
         * Make A ячейка with пусто элемент значение
        **/

        public this ()
        {
//                элемент_ = пусто;
        }

        /**
         * return the элемент значение
        **/

        public final T элемент()
        {
                return элемент_;
        }

        /**
         * установи the элемент значение
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
