module col.impl.SeqCollection;

private import  col.model.Seq,
        col.model.IteratorX;
private import  col.impl.Collection;



/**
 *
 * КоллекцияСек extends MutableImpl в_ provопрe
 * default implementations of some Сек operations.
**/

public abstract class КоллекцияСек(T) : Коллекция!(T), Сек!(T)
{
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


    // Default implementations of Сек methods

    version (VERBOSE)
    {
        /**
         * Implements col.model.Seq.Сек.вставкаПо.
         * See_Also: col.model.Seq.Сек.вставкаПо
        **/
        public final Сек вставкаПо(цел индекс, T элемент)
        {
            MutableSeq c = пусто;
            //      c = (cast(MutableSeq)клонируй());
            c = (cast(MutableSeq)дубликат());
            c.вставь(индекс, элемент);
            return c;
        }

        /**
         * Implements col.model.Seq.Сек.удалениеПо.
         * See_Also: col.model.Seq.Сек.удалениеПо
        **/
        public final Сек удалениеПо(цел индекс)
        {
            MutableSeq c = пусто;
            //      c = (cast(MutableSeq)клонируй());
            c = (cast(MutableSeq)дубликат());
            c.удали(индекс);
            return c;
        }


        /**
         * Implements col.model.Seq.Сек.заменаПо
         * See_Also: col.model.Seq.Сек.заменаПо
        **/
        public final Сек заменаПо(цел индекс, T элемент)
        {
            MutableSeq c = пусто;
            //      c = (cast(MutableSeq)клонируй());
            c = (cast(MutableSeq)дубликат());
            c.замени(индекс, элемент);
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

    /***********************************************************************

            Implements col.model.Seq.opIndexAssign
            See_Also: col.model.Seq.замениПо

            Calls замениПо(индекс, элемент);

    ************************************************************************/
    public final проц opIndexAssign (T элемент, цел индекс)
    {
        замениПо(индекс, элемент);
    }

    /***********************************************************************

            Implements col.model.SeqView.opSlice
            See_Also: col.model.SeqView.поднабор

            Calls поднабор(начало, (конец - начало));

    ************************************************************************/
    public КоллекцияСек opSlice(цел начало, цел конец)
    {
        return поднабор(начало, (конец - начало));
    }

}

