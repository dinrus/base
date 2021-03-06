﻿/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.DefaultAllocator;


        private import cidrus;

    /**
     * Allocate a блок of элементы at once, then use the блок to return
     * элементы.  This makes allocating individual элементы more efficient
     * because the GC isn't используется for allocating every элемент, only every
     * блок of элементы.
     *
     * The only requirement is that the размер of V is >= размер of a pointer.
     * This is because the data V содержит is используется as a pointer when freeing
     * the элемент.
     *
     * If an entire блок of элементы is freed, that блок is then returned to
     * the GC.
     */
    struct БлокРазместитель(V, бцел элтовНаБлок)
    {
        /**
         * Free is needed to рециклируй узелs for another allocation.
         */
        const бул нужноСвоб = true;
        static if(V.sizeof < (ук).sizeof)
        {
            static assert(false, "Ошибка, Разместитель для " ~ V.stringof ~ " не инстанциирован");
        }

        /**
         * This is the form используется to link recyclable элементы together.
         */
        struct элемент
        {
            элемент *следщ;
        }

        /**
         * A блок of элементы
         */
        struct блок
        {
            /**
             * The следщ блок in the цепь
             */
            блок *следщ;

            /**
             * The previous блок in the цепь.  Required for O(1) removal
             * from the цепь.
             */
            блок *предш;

            /**
             * The linked list of освободи элементы in the блок.  This list is
             * amended each time an элемент in this блок is freed.
             */
            элемент *списокОсвобождения;

            /**
             * The number of освободи элементы in the списокОсвобождения.  Used to determine
             * whether this блок can be given тыл to the GC
             */
            бцел члоОсвоб;

            /**
             * The элементы in the блок.
             */
            V[элтовНаБлок] элты;

            /**
             * Allocate a V* from the освободи list.
             */
            V *разместиИзОсвоб()
            {
                элемент *x = списокОсвобождения;
                списокОсвобождения = x.следщ;
                //
                // очисти the pointer, this clears the элемент as if обх was
                // newly allocated
                //
                x.следщ = пусто;
                члоОсвоб--;
                return cast(V*)x;
            }

            /**
             * вымести a V*, send обх to the освободи list
             *
             * returns true if this блок no longer имеется any используется элементы.
             */
            бул вымести(V *v)
            {
                //
                // очисти the элемент so the GC does not interpret the элемент
                // as pointing to anything else.
                //
                memset(v, 0, (V).sizeof);
                элемент *x = cast(элемент *)v;
                x.следщ = списокОсвобождения;
                списокОсвобождения = x;
                return (++члоОсвоб == элтовНаБлок);
            }
        }

        /**
         * The цепь of используется чанки.  Used чанки have had all their элементы
         * allocated at least once.
         */
        блок *используется;

        /**
         * The свеж блок.  This is only используется if no элементы are available in
         * the используется цепь.
         */
        блок *свеж;

        /**
         * The следщ элемент in the свеж блок.  Because we don't worry about
         * the освободи list in the свеж блок, we need to keep track of the следщ
         * свеж элемент to use.
         */
        бцел следщСвеж;

        /**
         * Allocate a V*
         */
        V* размести()
        {
            if(используется !is пусто && используется.члоОсвоб > 0)
            {
                //
                // размести one элемент of the используется list
                //
                V* рез = используется.разместиИзОсвоб();
                if(используется.члоОсвоб == 0)
                    //
                    // move используется to the конец of the list
                    //
                    используется = используется.следщ;
                return рез;
            }

            //
            // no используется элементы are available, размести out of the свеж
            // элементы
            //
            if(свеж is пусто)
            {
                свеж = new блок;
                следщСвеж = 0;
            }

            V* рез = &свеж.элты[следщСвеж];
            if(++следщСвеж == элтовНаБлок)
            {
                if(используется is пусто)
                {
                    используется = свеж;
                    свеж.следщ = свеж;
                    свеж.предш = свеж;
                }
                else
                {
                    //
                    // вставь свеж into the используется цепь
                    //
                    свеж.предш = используется.предш;
                    свеж.следщ = используется;
                    свеж.предш.следщ = свеж;
                    свеж.следщ.предш = свеж;
                    if(свеж.члоОсвоб != 0)
                    {
                        //
                        // can рециклируй элементы from свеж
                        //
                        используется = свеж;
                    }
                }
                свеж = пусто;
            }
            return рез;
        }

        /**
         * освободи a V*
         */
        проц освободи(V* v)
        {
            //
            // need to figure out which блок v is in
            //
            блок *тек = cast(блок *)смАдрес(v);

            if(тек !is свеж && тек.члоОсвоб == 0)
            {
                //
                // move тек to the фронт of the используется list, обх имеется освободи узелs
                // to be используется.
                //
                if(тек !is используется)
                {
                    if(используется.члоОсвоб != 0)
                    {
                        //
                        // первый, открепи тек from its текущ location
                        //
                        тек.предш.следщ = тек.следщ;
                        тек.следщ.предш = тек.предш;

                        //
                        // now, вставь тек перед используется.
                        //
                        тек.предш = используется.предш;
                        тек.следщ = используется;
                        используется.предш = тек;
                        тек.предш.следщ = тек;
                    }
                    используется = тек;
                }
            }

            if(тек.вымести(v))
            {
                //
                // тек no longer имеется any элементы in use, обх can be deleted.
                //
                if(тек.следщ is тек)
                {
                    //
                    // only one элемент, don't освободи обх.
                    //
                }
                else
                {
                    //
                    // удали тек from list
                    //
                    if(используется is тек)
                    {
                        //
                        // update используется pointer
                        //
                        используется = используется.следщ;
                    }
                    тек.следщ.предш = тек.предш;
                    тек.предш.следщ = тек.следщ;
                    delete тек;
                }
            }
        }

        /**
         * Deallocate all чанки используется by this Разместитель.
         */
        проц освободиВсе()
        {
            используется = пусто;

            //
            // keep свеж around
            //
            if(свеж !is пусто)
            {
                следщСвеж = 0;
                свеж.списокОсвобождения = пусто;
            }
        }
    }


/**
 * Simple Разместитель uses new to размести each элемент
 */
struct ПростойРазместитель(V)
{
    /**
     * new doesn't require освободи
     */
    const бул нужноСвоб = false;

    /**
     * equivalent to new V;
     */
    V* размести()
    {
        return new V;
    }
}

/**
 * Default Разместитель selects the correct Разместитель depending on the размер of V.
 */
template ДефолтныйРазместитель(V)
{
    //
    // if there will be more than one V per page, use the блок Разместитель,
    // otherwise, use the simple Разместитель.  Note we can only support
    // БлокРазместитель on Tango.
    //
    version(Динрус)
    {
        static if((V).sizeof + ((ук).sizeof * 3) + бцел.sizeof >= 4095 / 2)
        {
            alias ПростойРазместитель!(V) ДефолтныйРазместитель;
        }
        else
        {
            alias БлокРазместитель!(V, (4095 - ((ук ).sizeof * 3) - бцел.sizeof) / (V).sizeof) ДефолтныйРазместитель;
        }
    }
    else
    {
        alias ПростойРазместитель!(V) ДефолтныйРазместитель;
    }
}
