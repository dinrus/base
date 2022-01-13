module col.impl.SetCollection;

private import  col.model.SetX,
                col.model.IteratorX;
private import  col.impl.Collection;

/**
 *
 * КоллекцияНаборов extends MutableImpl в_ предоставляет
 * default implementations of some Набор operations. 
 * 
**/

public abstract class КоллекцияНаборов(T) : Коллекция!(T), Набор!(T)
{
        alias Набор!(T).добавь               добавь;
        alias Коллекция!(T).удали     удали;
        alias Коллекция!(T).удалиВсе  удалиВсе;


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
         * Реализует col.impl.SetCollection.КоллекцияНаборов.includeElements
         * См_Также: col.impl.SetCollection.КоллекцияНаборов.includeElements
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
         * Реализует col.Набор.включая
         * См_Также: col.Набор.включая
        **/
        public final Набор включая (T элемент)
        {
                auto c = cast(MutableSet) дубликат();
                c.include(элемент);
                return c;
        }
        } // version

        /***********************************************************************

                Реализует col.impl.Collection.Коллекция.удалиВсе
                См_Также: col.impl.Collection.Коллекция.удалиВсе

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удалиВсе (Обходчик!(T) e)
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

        public проц удали (Обходчик!(T) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}


