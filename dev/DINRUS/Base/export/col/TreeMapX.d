module col.TreeMapX;

private import  exception;

private import  col.model.Comparator,
                col.model.SortedKeys,
                col.model.GuardIterator;

private import  col.impl.RBPair,
                col.impl.RBCell,
                col.impl.MapCollection,
                col.impl.AbstractIterator;


/**
 *
 *
 * КрасноЧёрное Trees of (ключ, элемент) pairs
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


deprecated public class КартаДерево(К, T) : КоллекцияКарт!(К, T), СортированныеКлючи!(К, T)
{
        alias КЧЯчейка!(T)                КЧЯчейкаТ;
        alias КЧПара!(К, T)             RBPairT;
        alias Сравнитель!(К)            КомпараторТ;
        alias СтражОбходчик!(T)         GuardIteratorT;

        alias КоллекцияКарт!(К, T).удали     удали;
        alias КоллекцияКарт!(К, T).удалиВсе  удалиВсе;


        // экземпляр variables

        /**
         * The корень of the дерево. Пусто if пустой.
        **/

        package RBPairT дерево;

        /**
         * The Сравнитель в_ use for ordering
        **/

        protected КомпараторТ           cmp;
        protected Сравнитель!(T)        cmpElem;

        /**
         * Make an пустой дерево, using DefaultComparator for ordering
        **/

        public this ()
        {
                this (пусто, пусто, пусто, 0);
        }


        /**
         * Make an пустой дерево, using given скринер for screening элементы (not ключи)
        **/
        public this (Предикат скринер)
        {
                this(скринер, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using given Сравнитель for ordering
        **/
        public this (КомпараторТ c)
        {
                this(пусто, c, пусто, 0);
        }

        /**
         * Make an пустой дерево, using given скринер и Сравнитель.
        **/
        public this (Предикат s, КомпараторТ c)
        {
                this(s, c, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/

        protected this (Предикат s, КомпараторТ c, RBPairT t, цел n)
        {
                super(s);
                счёт = n;
                дерево = t;
                cmp = (c is пусто) ? &сравниКлюч : c;
                cmpElem = &сравниЭлем;
        }

        /**
         * The default ключ сравнитель
         *
         * @param перв первый аргумент
         * @param втор секунда аргумент
         * Возвращает: a негатив число if перв is less than втор; a
         * positive число if перв is greater than втор; else 0
        **/

        private final цел сравниКлюч(К перв, К втор)
        {
                if (перв is втор)
                    return 0;

                return typeid(К).сравни (&перв, &втор);
        }


        /**
         * The default элемент сравнитель
         *
         * @param перв первый аргумент
         * @param втор секунда аргумент
         * Возвращает: a негатив число if перв is less than втор; a
         * positive число if перв is greater than втор; else 0
        **/

        private final цел сравниЭлем(T перв, T втор)
        {
                if (перв is втор)
                    return 0;

                return typeid(T).сравни (&перв, &втор);
        }


        /**
         * Созд an independent копируй. Does not клонируй элементы.
        **/

        public КартаДерево!(К, T) дубликат()
        {
                if (счёт is 0)
                    return new КартаДерево!(К, T)(скринер, cmp);
                else
                   return new КартаДерево!(К, T)(скринер, cmp, cast(RBPairT)(дерево.копируйДерево()), счёт);
        }


        // Коллекция methods

        /**
         * Implements col.impl.Collection.Коллекция.содержит
         * Время complexity: O(лог n).
         * See_Also: col.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return нет;
                return дерево.найди(элемент, cmpElem) !is пусто;
        }

        /**
         * Implements col.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(лог n).
         * See_Also: col.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return 0;
                return дерево.счёт(элемент, cmpElem);
        }

        /**
         * Implements col.impl.Collection.Коллекция.элементы
         * Время complexity: O(1).
         * See_Also: col.impl.Collection.Коллекция.элементы
        **/
        public final СтражОбходчик!(T) элементы()
        {
                return ключи();
        }

        /***********************************************************************

                Implements col.model.View.Обзор.opApply
                Время complexity: O(n)

                See_Also: col.model.View.Обзор.opApply

        ************************************************************************/

        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(К, T)(this);
                return обходчик.opApply (дг);
        }


        /***********************************************************************

                Implements col.ОбзорКарты.opApply
                Время complexity: O(n)

                See_Also: col.ОбзорКарты.opApply

        ************************************************************************/

        цел opApply (цел delegate (inout К ключ, inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(К, T)(this);
                return обходчик.opApply (дг);
        }

        // KeySortedCollection methods

        /**
         * Implements col.KeySortedCollection.сравнитель
         * Время complexity: O(1).
         * See_Also: col.KeySortedCollection.сравнитель
        **/
        public final КомпараторТ сравнитель()
        {
                return cmp;
        }

        /**
         * Use a new Сравнитель. Causes a reorganization
        **/

        public final проц сравнитель (КомпараторТ c)
        {
                if (cmp !is c)
                   {
                   cmp = (c is пусто) ? &сравниКлюч : c;

                   if (счёт !is 0)
                      {
                      // must rebuild дерево!
                      инкрВерсию();
                      auto t = cast(RBPairT) (дерево.левейший());
                      дерево = пусто;
                      счёт = 0;

                      while (t !is пусто)
                            {
                            добавь_(t.ключ(), t.элемент(), нет);
                            t = cast(RBPairT)(t.потомок());
                            }
                      }
                   }
        }

        // Карта methods

        /**
         * Implements col.Map.содержитКлюч.
         * Время complexity: O(лог n).
         * See_Also: col.Map.содержитКлюч
        **/
        public final бул содержитКлюч(К ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                    return нет;
                return дерево.найдиКлюч(ключ, cmp) !is пусто;
        }

        /**
         * Implements col.Map.содержитПару.
         * Время complexity: O(n).
         * See_Also: col.Map.содержитПару
        **/
        public final бул содержитПару(К ключ, T элемент)
        {
                if (счёт is 0 || !действительныйКлюч(ключ) || !действительныйАргумент(элемент))
                    return нет;
                return дерево.найди(ключ, элемент, cmp) !is пусто;
        }

        /**
         * Implements col.Map.ключи.
         * Время complexity: O(1).
         * See_Also: col.Map.ключи
        **/
        public final ОбходчикПар!(К, T) ключи()
        {
                return new ОбходчикКарты!(К, T)(this);
        }

        /**
         * Implements col.Map.получи.
         * Время complexity: O(лог n).
         * See_Also: col.Map.получи
        **/
        public final T получи(К ключ)
        {
                if (счёт !is 0)
                   {
                   RBPairT p = дерево.найдиКлюч(ключ, cmp);
                   if (p !is пусто)
                       return p.элемент();
                   }
                throw new НетЭлементаИскл("no совпадают Key ");
        }

        /**
         * Return the элемент associated with Key ключ.
         * @param ключ a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public final бул получи(К ключ, inout T значение)
        {
                if (счёт !is 0)
                   {
                   RBPairT p = дерево.найдиКлюч(ключ, cmp);
                   if (p !is пусто)
                      {
                      значение = p.элемент();
                      return да;
                      }
                   }
                return нет;
        }



        /**
         * Implements col.Map.ключК.
         * Время complexity: O(n).
         * See_Also: col.Map.ключК
        **/
        public final бул ключК(inout К ключ, T значение)
        {
                if (!действительныйАргумент(значение) || счёт is 0)
                     return нет;

                auto p = (cast(RBPairT)( дерево.найди(значение, cmpElem)));
                if (p is пусто)
                    return нет;

                ключ = p.ключ();
                return да;
        }


        // MutableCollection methods

        /**
         * Implements col.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: col.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                устСчёт(0);
                дерево = пусто;
        }


        /**
         * Implements col.impl.Collection.Коллекция.удалиВсе.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.удалиВсе
        **/
        public final проц удалиВсе(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                      return ;

                RBPairT p = cast(RBPairT)(дерево.найди(элемент, cmpElem));
                while (p !is пусто)
                      {
                      дерево = cast(RBPairT)(p.удали(дерево));
                      декрСчёт();
                      if (счёт is 0)
                          return ;
                      p = cast(RBPairT)(дерево.найди(элемент, cmpElem));
                      }
        }

        /**
         * Implements col.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали (T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                      return ;

                RBPairT p = cast(RBPairT)(дерево.найди(элемент, cmpElem));
                if (p !is пусто)
                   {
                   дерево = cast(RBPairT)(p.удали(дерево));
                   декрСчёт();
                   }
        }


        /**
         * Implements col.impl.Collection.Коллекция.replaceOneOf.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени(T старЭлемент, T новЭлемент)
        {
                if (счёт is 0 || !действительныйАргумент(старЭлемент) || !действительныйАргумент(старЭлемент))
                    return ;

                RBPairT p = cast(RBPairT)(дерево.найди(старЭлемент, cmpElem));
                if (p !is пусто)
                   {
                   проверьЭлемент(новЭлемент);
                   инкрВерсию();
                   p.элемент(новЭлемент);
                   }
        }

        /**
         * Implements col.impl.Collection.Коллекция.replaceAllOf.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                RBPairT p = cast(RBPairT)(дерево.найди(старЭлемент, cmpElem));
                while (p !is пусто)
                      {
                      проверьЭлемент(новЭлемент);
                      инкрВерсию();
                      p.элемент(новЭлемент);
                      p = cast(RBPairT)(дерево.найди(старЭлемент, cmpElem));
                      }
        }

        /**
         * Implements col.impl.Collection.Коллекция.возьми.
         * Время complexity: O(лог n).
         * Takes the элемент associated with the least ключ.
         * See_Also: col.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (счёт !is 0)
                   {
                   RBPairT p = cast(RBPairT)(дерево.левейший());
                   T знач = p.элемент();
                   дерево = cast(RBPairT)(p.удали(дерево));
                   декрСчёт();
                   return знач;
                   }

                проверьИндекс(0);
                return T.init; // not reached
        }


        // MutableMap methods

        /**
         * Implements col.impl.MapCollection.КоллекцияКарт.добавь.
         * Время complexity: O(лог n).
         * See_Also: col.impl.MapCollection.КоллекцияКарт.добавь
        **/
        public final проц добавь(К ключ, T элемент)
        {
                добавь_(ключ, элемент, да);
        }


        /**
         * Implements col.impl.MapCollection.КоллекцияКарт.удали.
         * Время complexity: O(лог n).
         * See_Also: col.impl.MapCollection.КоллекцияКарт.удали
        **/
        public final проц удалиКлюч (К ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                      return ;

                КЧЯчейкаТ p = дерево.найдиКлюч(ключ, cmp);
                if (p !is пусто)
                   {
                   дерево = cast(RBPairT)(p.удали(дерево));
                   декрСчёт();
                   }
        }


        /**
         * Implements col.impl.MapCollection.КоллекцияКарт.replaceElement.
         * Время complexity: O(лог n).
         * See_Also: col.impl.MapCollection.КоллекцияКарт.replaceElement
        **/
        public final проц замениПару (К ключ, T старЭлемент,
                                              T новЭлемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(старЭлемент) || счёт is 0)
                    return ;

                RBPairT p = дерево.найди(ключ, старЭлемент, cmp);
                if (p !is пусто)
                   {
                   проверьЭлемент(новЭлемент);
                   p.элемент(новЭлемент);
                   инкрВерсию();
                   }
        }


        // helper methods


        private final проц добавь_(К ключ, T элемент, бул проверьOccurrence)
        {
                проверьКлюч(ключ);
                проверьЭлемент(элемент);

                if (дерево is пусто)
                   {
                   дерево = new RBPairT(ключ, элемент);
                   incCount();
                   }
                else
                   {
                   RBPairT t = дерево;
                   for (;;)
                       {
                       цел рознь = cmp(ключ, t.ключ());
                       if (рознь is 0 && проверьOccurrence)
                          {
                          if (t.элемент() != элемент)
                             {
                             t.элемент(элемент);
                             инкрВерсию();
                             }
                          return ;
                          }
                       else
                          if (рознь <= 0)
                             {
                             if (t.лево() !is пусто)
                                 t = cast(RBPairT)(t.лево());
                             else
                                {
                                дерево = cast(RBPairT)(t.вставьЛевый(new RBPairT(ключ, элемент), дерево));
                                incCount();
                                return ;
                                }
                             }
                          else
                             {
                             if (t.право() !is пусто)
                                 t = cast(RBPairT)(t.право());
                             else
                                {
                                дерево = cast(RBPairT)(t.вставьПравый(new RBPairT(ключ, элемент), дерево));
                                incCount();
                                return ;
                                }
                             }
                       }
                   }
        }

        // ImplementationCheckable methods

        /**
         * Implements col.model.View.Обзор.проверьРеализацию.
         * See_Also: col.model.View.Обзор.проверьРеализацию
        **/
        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();
                assert(cmp !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево !is пусто)
                   {
                   дерево.проверьРеализацию();
                   К последний = К.init;
                   RBPairT t = cast(RBPairT)(дерево.левейший());

                   while (t !is пусто)
                         {
                         К знач = t.ключ();
                         assert((последний is К.init || cmp(последний, знач) <= 0));
                         последний = знач;
                         t = cast(RBPairT)(t.потомок());
                         }
                   }
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()

        ************************************************************************/

        private static class ОбходчикКарты(К, З) : АбстрактныйОбходчикКарты!(К, З)
        {
                private RBPairT пара;

                public this (КартаДерево карта)
                {
                        super (карта);

                        if (карта.дерево)
                            пара = cast(RBPairT) карта.дерево.левейший;
                }

                public final З получи(inout К ключ)
                {
                        if (пара)
                            ключ = пара.ключ;
                        return получи();
                }

                public final З получи()
                {
                        декрементируйОстаток();
                        auto знач = пара.элемент();
                        пара = cast(RBPairT) пара.потомок();
                        return знач;
                }

                цел opApply (цел delegate (inout З значение) дг)
                {
                        цел результат;

                        for (auto i=остаток(); i--;)
                            {
                            auto значение = получи();
                            if ((результат = дг(значение)) != 0)
                                 break;
                            }
                        return результат;
                }

                цел opApply (цел delegate (inout К ключ, inout З значение) дг)
                {
                        К   ключ;
                        цел результат;

                        for (auto i=остаток(); i--;)
                            {
                            auto значение = получи(ключ);
                            if ((результат = дг(ключ, значение)) != 0)
                                 break;
                            }
                        return результат;
                }
        }
}



debug (Test)
{
        import io.Console;

        проц main()
        {
                auto карта = new КартаДерево!(ткст, дво);
                карта.добавь ("foo", 1);
                карта.добавь ("baz", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);

                foreach (ключ, значение; карта.ключи) {typeof(ключ) x; x = ключ;}

                foreach (значение; карта.ключи) {}

                foreach (значение; карта.элементы) {}

                auto ключи = карта.ключи();
                while (ключи.ещё)
                       auto знач = ключи.получи();

                foreach (значение; карта) {}

                foreach (ключ, значение; карта)
                         Квывод (ключ).нс;

                карта.проверьРеализацию();
        }
}
