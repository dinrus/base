module col.impl.SetCollection;

private import  col.model.SetX,
                col.model.IteratorX;
private import  col.impl.Collection;

/**
 *
 * КоллекцияНаборов extends MutableImpl в_ provопрe
 * default implementations of some Набор operations. 
 * 
**/

public abstract class КоллекцияНаборов(T) : Коллекция!(T), Набор!(T)
{
        alias Набор!(T).добавь               добавь;
        alias Коллекция!(T).удали     удали;
        alias Коллекция!(T).удалиВсе  удалиВсе;


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
         * Implements col.impl.SetCollection.КоллекцияНаборов.includeElements
         * See_Also: col.impl.SetCollection.КоллекцияНаборов.includeElements
        **/

        public проц добавь (Обходчик!(T) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }


        version (VERBOSE)
        {
        // Default implementations of Набор methods

        /**
         * Implements col.Набор.включая
         * See_Also: col.Набор.включая
        **/
        public final Набор включая (T элемент)
        {
                auto c = cast(MutableSet) дубликат();
                c.include(элемент);
                return c;
        }
        } // version

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.удалиВсе
                See_Also: col.impl.Collection.Коллекция.удалиВсе

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удалиВсе (Обходчик!(T) e)
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

        public проц удали (Обходчик!(T) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}


