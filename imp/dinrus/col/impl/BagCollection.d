﻿module col.impl.BagCollection;

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
         * Инициализует при версии 0, an пустой счёт, и пусто скринер
        **/

        protected this ()
        {
                super();
        }

        /**
         * Инициализует при версии 0, an пустой счёт, и supplied скринер
        **/
        protected this (Предикат скринер)
        {
                super(скринер);
        }

        /**
         * Реализует col.MutableBag.добавьЭлты
         * См_Также: col.MutableBag.добавьЭлты
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
         * Реализует col.Рюкзак.добавимЕслиНет
         * См_Также: col.Рюкзак.добавимЕслиНет
        **/
        public final Рюкзак добавимЕсли(З элемент)
        {
                Рюкзак c = дубликат();
                c.добавьЕсли(элемент);
                return c;
        }


        /**
         * Реализует col.Рюкзак.добавим
         * См_Также: col.Рюкзак.добавим
        **/

        public final Рюкзак добавим(З элемент)
        {
                Рюкзак c = дубликат();
                c.добавь(элемент);
                return c;
        }
} // version


        /***********************************************************************

                Реализует col.impl.Collection.Коллекция.удалиВсе
                См_Также: col.impl.Collection.Коллекция.удалиВсе

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удалиВсе (Обходчик!(З) e)
        {
                while (e.ещё)
                       удалиВсе (e.получи);
        }

        /***********************************************************************

                Реализует col.impl.Collection.Коллекция.removeElements
                См_Также: col.impl.Collection.Коллекция.removeElements

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удали (Обходчик!(З) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}

