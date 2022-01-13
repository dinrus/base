module col.impl.BagCollection;

private import  col.model.Bag,
                col.model.IteratorX;

private import  col.impl.Collection;

/**
 *
 * MutableBagImpl наследует MutableImpl, предоставляя
 * дефолтные реализации некоторых операции для класса Рюкзак. 
 * 
**/

public abstract class КоллекцияРюкзак(З) : Коллекция!(З), Рюкзак!(З)
{
        alias Рюкзак!(З).добавь               добавь;
        alias Коллекция!(З).удали     удали;
        alias Коллекция!(З).удалиВсе  удалиВсе;

        
        /**
         * Initialize at version 0, an пустой счёт, и пусто скринер
        **/

        protected this ()
        {
                super();
        }

        /**
         * Initialize at version 0, an пустой счёт, и supplied скринер
        **/
        protected this (Предикат скринер)
        {
                super(скринер);
        }

        /**
         * Implements col.MutableBag.добавьElements
         * See_Also: col.MutableBag.добавьElements
        **/

        public final проц добавь(Обходчик!(З) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }


        // Default implementations of Рюкзак methods

version (VERBOSE)
{
        /**
         * Implements col.Рюкзак.добавимЕслиНет
         * See_Also: col.Рюкзак.добавимЕслиНет
        **/
        public final Рюкзак добавимЕсли(З элемент)
        {
                Рюкзак c = дубликат();
                c.добавьЕсли(элемент);
                return c;
        }


        /**
         * Implements col.Рюкзак.добавим
         * See_Also: col.Рюкзак.добавим
        **/

        public final Рюкзак добавим(З элемент)
        {
                Рюкзак c = дубликат();
                c.добавь(элемент);
                return c;
        }
} // version


        /***********************************************************************

                Implements col.impl.Collection.Коллекция.удалиВсе
                See_Also: col.impl.Collection.Коллекция.удалиВсе

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удалиВсе (Обходчик!(З) e)
        {
                while (e.ещё)
                       удалиВсе (e.получи);
        }

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.removeElements
                See_Also: col.impl.Collection.Коллекция.removeElements

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удали (Обходчик!(З) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}

