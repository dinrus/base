﻿module col.StackMap;

private import cidrus;
private import col.HashMapY;
public  import col.Container;

/******************************************************************************

        СтэкКарта extends the basic hashmap тип by добавим a предел в_ 
        the число of items contained at any given время. In добавьition, 
        СтэкКарта retains the order in which элементы were добавьed, и
        employs that during foreach() traversal. добавьitions в_ the карта
        beyond the ёмкость will результат in an исключение being thrown.

        You can push и вынь things just like an typical стэк, и/or
        traverse the записи in the order they were добавьed, though with 
        the добавьitional capability of retrieving и/or removing by ключ.

        Note also that a push/добавь operation will замени an existing 
        Запись with the same ключ, exposing a twist on the стэк notion.

******************************************************************************/

class СтэкКарта (К, З, alias Хэш = Контейнер.хэш, 
                      alias Извл = Контейнер.извлеки, 
                      alias Куча = Контейнер.Сбор) 
{
        private alias ЗаписьВОчереди       Тип;
        private alias Тип              *Реф;
        private alias ХэшКарта!(К, Реф, Хэш, рипер, куча) Карта;
        private Карта                     хэш;
        private Тип[]                  линки;

        // extents of queue
        private Реф                     голова,
                                        хвост,
                                        старт;
        // дименсия of queue
        private бцел                    ёмкость;

       /**********************************************************************

                Construct a кэш with the specified maximum число of 
                записи. добавьitions в_ the кэш beyond this число will
                throw an исключение

        **********************************************************************/

        this (бцел ёмкость)
        {
                хэш = new Карта;
                this.ёмкость = ёмкость;
                хэш.корзины (ёмкость, 0.75);
                //линки = (cast(Реф) calloc(ёмкость, Тип.sizeof))[0..ёмкость];
                линки.length = ёмкость;

                // создай пустой список
                голова = хвост = &линки[0];
                foreach (ref link; линки[1..$])
                        {
                        link.предш = хвост;
                        хвост.следщ = &link;
                        хвост = &link;
                        }
        }

        /***********************************************************************

                clean up when готово
                
        ***********************************************************************/

        ~this ()
        {
                //free (линки.ptr);
        }

        /***********************************************************************

                Извлing обрвызов for the hashmap, acting as a trampoline

        ***********************************************************************/

        static проц рипер(К, R) (К ключ, R r) 
        {
                Извл (ключ, r.значение);
        }

        /***********************************************************************


        ***********************************************************************/

        final бцел размер ()
        {
                return хэш.размер;
        }

        /***********************************************************************


        ***********************************************************************/

        final проц очисть ()
        {
                хэш.очисть;
                старт = пусто;
        }

        /**********************************************************************

                Place an Запись преобр_в the кэш и associate it with the
                предоставленный ключ. Note that there can be only one Запись for
                any particular ключ. If two записи are добавьed with the 
                same ключ, the секунда effectively overwrites the первый.

                Возвращает да if we добавьed a new Запись; нет if we just
                replaced an existing one. A замена does not change
                the order of the ключи, и thus does not change стэк
                ordering.

        **********************************************************************/

        final бул сунь (К ключ, З значение)
        {
                return добавь (ключ, значение);
        }

        /**********************************************************************

                Удали и return the ещё recent добавьition в_ the стэк

        **********************************************************************/

        бул выньГолову (ref К ключ, ref З значение)
        {
                if (старт)
                   {
                   ключ = голова.ключ;
                   return возьми (ключ, значение);
                   }
                return нет;
        }

        /**********************************************************************

                Удали и return the oldest добавьition в_ the стэк

        **********************************************************************/

        бул выньХвост (ref К ключ, ref З значение)
        {
                if (старт)
                   {
                   ключ = старт.ключ;
                   return возьми (ключ, значение);
                   }
                return нет;
        }

        /***********************************************************************

                Iterate из_ the oldest в_ the most recent добавьitions

        ***********************************************************************/

        final цел opApply (цел delegate(ref К ключ, ref З значение) дг)
        {
                        К   ключ;
                        З   значение;
                        цел результат;

                        auto узел = старт;
                        while (узел)
                              {
                              ключ = узел.ключ;
                              значение = узел.значение;
                              if ((результат = дг(ключ, значение)) != 0)
                                   break;
                              узел = узел.предш;
                              }
                        return результат;
        }

        /**********************************************************************

                Place an Запись преобр_в the кэш и associate it with the
                предоставленный ключ. Note that there can be only one Запись for
                any particular ключ. If two записи are добавьed with the 
                same ключ, the секунда effectively overwrites the первый.

                Возвращает да if we добавьed a new Запись; нет if we just
                replaced an existing one. A замена does not change
                the order of the ключи, и thus does not change стэк
                ordering.

        **********************************************************************/

        final бул добавь (К ключ, З значение)
        {
                Реф Запись = пусто;

                // already in the список? -- замени Запись
                if (хэш.получи (ключ, Запись))
                   {
                   Запись.установи (ключ, значение);
                   return нет;
                   }

                // создай a new Запись at the список голова 
                Запись = добавьЗапись (ключ, значение);
                if (старт is пусто)
                    старт = Запись;
                return да;
        }

        /**********************************************************************

                Get the кэш Запись опрentified by the given ключ

        **********************************************************************/

        бул получи (К ключ, ref З значение)
        {
                Реф Запись = пусто;

                if (хэш.получи (ключ, Запись))
                   {
                   значение = Запись.значение;
                   return да;
                   }
                return нет;
        }

        /**********************************************************************

                Удали (и return) the кэш Запись associated with the 
                предоставленный ключ. Возвращает нет if there is no such Запись.

        **********************************************************************/

        final бул возьми (К ключ, ref З значение)
        {
                Реф Запись = пусто;
                if (хэш.получи (ключ, Запись))
                   {
                   значение = Запись.значение;

                   if (Запись is старт)
                       старт = Запись.предш;
                
                   // don't actually затуши the список Запись -- just place
                   // it at the список 'хвост' ready for subsequent reuse
                   разРеферируй (Запись);

                   // удали the Запись из_ хэш
                   хэш.удалиКлюч (ключ);
                   return да;
                   }
                return нет;
        }

        /**********************************************************************

                Place a кэш Запись at the хвост of the queue. This makes
                it the least-recently referenced.

        **********************************************************************/

        private Реф разРеферируй (Реф Запись)
        {
                if (Запись !is хвост)
                   {
                   // исправь голова
                   if (Запись is голова)
                       голова = Запись.следщ;

                   // перемести в_ хвост
                   Запись.выкинь;
                   хвост = Запись.добавь (хвост);
                   }
                return Запись;
        }

        /**********************************************************************

                Move a кэш Запись в_ the голова of the queue. This makes
                it the most-recently referenced.

        **********************************************************************/

        private Реф переРеферируй (Реф Запись)
        {
                if (Запись !is голова)
                   {
                   // исправь хвост
                   if (Запись is хвост)
                       хвост = Запись.предш;

                   // перемести в_ голова
                   Запись.выкинь;
                   голова = Запись.приставь (голова);
                   }
                return Запись;
        }

        /**********************************************************************

                Добавь an Запись преобр_в the queue. An исключение is thrown if 
                the queue is full

        **********************************************************************/

        private Реф добавьЗапись (К ключ, З значение)
        {
                if (хэш.размер < ёмкость)
                   {
                   хэш.добавь (ключ, хвост);
                   return переРеферируй (хвост.установи (ключ, значение));
                   }

                throw new Исключение ("Full");
        }

        /**********************************************************************
        
                A doubly-linked список Запись, использован as a wrapper for queued 
                кэш записи. 
        
        **********************************************************************/
        
        private struct ЗаписьВОчереди
        {
                private К               ключ;
                private Реф             предш,
                                        следщ;
                private З               значение;
        
                /**************************************************************
        
                        Набор this linked-список Запись with the given аргументы. 

                **************************************************************/
        
                Реф установи (К ключ, З значение)
                {
                        this.значение = значение;
                        this.ключ = ключ;
                        return this;
                }
        
                /**************************************************************
        
                        Insert this Запись преобр_в the linked-список just in 
                        front of the given Запись.
        
                **************************************************************/
        
                Реф приставь (Реф before)
                {
                        if (before)
                           {
                           предш = before.предш;
        
                           // патч 'предш' в_ точка at me
                           if (предш)
                               предш.следщ = this;
        
                           //патч 'before' в_ точка at me
                           следщ = before;
                           before.предш = this;
                           }
                        return this;
                }
        
                /**************************************************************
                        
                        Добавь this Запись преобр_в the linked-список just после 
                        the given Запись.
        
                **************************************************************/
        
                Реф добавь (Реф после)
                {
                        if (после)
                           {
                           следщ = после.следщ;
        
                           // патч 'следщ' в_ точка at me
                           if (следщ)
                               следщ.предш = this;
        
                           //патч 'после' в_ точка at me
                           предш = после;
                           после.следщ = this;
                           }
                        return this;
                }
        
                /**************************************************************
        
                        Удали this Запись из_ the linked-список. The 
                        previous и следщ записи are patched together 
                        appropriately.
        
                **************************************************************/
        
                Реф выкинь ()
                {
                        // сделай 'предш' и 'следщ' записи see each другой
                        if (предш)
                            предш.следщ = следщ;
        
                        if (следщ)
                            следщ.предш = предш;
        
                        // Murphy's law 
                        следщ = предш = пусто;
                        return this;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (СтэкКарта)
{
        import io.Stdout;
        import time.StopWatch;

        проц main()
        {
                цел знач;
                auto карта = new СтэкКарта!(ткст, цел)(3);
                карта.добавь ("foo", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);
                foreach (ключ, знач; карта)
                         Стдвыв.форматнс ("{} {}", ключ, знач);

                Стдвыв.нс;
                карта.получи ("bar", знач);
                foreach (ключ, знач; карта)
                         Стдвыв.форматнс ("{} {}", ключ, знач);

                Стдвыв.нс;
                карта.получи ("bar", знач);
                foreach (ключ, знач; карта)
                         Стдвыв.форматнс ("{} {}", ключ, знач);

                Стдвыв.нс;
                карта.получи ("foo", знач);
                foreach (ключ, знач; карта)
                         Стдвыв.форматнс ("{} {}", ключ, знач);

                Стдвыв.нс;
                карта.получи ("wumpus", знач);
                foreach (ключ, знач; карта)
                         Стдвыв.форматнс ("{} {}", ключ, знач);


                // установи for benchmark, with a кэш of целыйs
                auto тест = new СтэкКарта!(цел, цел, Контейнер.хэш, Контейнер.извлеки, Контейнер.Чанк) (1000000);
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавим
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь (i, i);
                Стдвыв.форматнс ("{} добавьs: {}/s", счёт, счёт/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.получи (i, знач);
                Стдвыв.форматнс ("{} lookups: {}/s", счёт, счёт/w.stop);

                // benchmark iteration
                w.старт;
                foreach (ключ, значение; тест) {}
                Стдвыв.форматнс ("{} элемент iteration: {}/s", тест.размер, тест.размер/w.stop);
        }
}
        
