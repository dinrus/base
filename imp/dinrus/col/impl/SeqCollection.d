module col.impl.SeqCollection;

private import  col.model.Seq,
        col.model.IteratorX;
private import  col.impl.Collection;



/**
 *
 * КоллекцияСек extends MutableImpl в_ предоставляет
 * default implementations of some Сек operations.
**/

public abstract class КоллекцияСек(T) : Коллекция!(T), Сек!(T)
{
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


    // Default implementations of Сек methods

    version (VERBOSE)
    {
        /**
         * Реализует col.model.Seq.Сек.вставкаПо.
         * См_Также: col.model.Seq.Сек.вставкаПо
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
         * Реализует col.model.Seq.Сек.удалениеПо.
         * См_Также: col.model.Seq.Сек.удалениеПо
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
         * Реализует col.model.Seq.Сек.заменаПо
         * См_Также: col.model.Seq.Сек.заменаПо
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

    /***********************************************************************

            Реализует col.model.Seq.opIndexAssign
            См_Также: col.model.Seq.замениПо

            Calls замениПо(индекс, элемент);

    ************************************************************************/
    public final проц opIndexAssign (T элемент, цел индекс)
    {
        замениПо(индекс, элемент);
    }

    /***********************************************************************

            Реализует col.model.SeqView.opSlice
            См_Также: col.model.SeqView.поднабор

            Calls поднабор(начало, (конец - начало));

    ************************************************************************/
    public КоллекцияСек opSlice(цел начало, цел конец)
    {
        return поднабор(начало, (конец - начало));
    }

}

