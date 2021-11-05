﻿module col.LinkSeq;

private import  col.model.IteratorX,
                col.model.Sortable,
                col.model.Comparator,
                col.model.GuardIterator;

private import  col.impl.LLCell,
                col.impl.SeqCollection,
                col.impl.AbstractIterator;

/**
 *
 * СвязныйСписок implementation.
 * Publically реализует only those methods defined in its interfaces.
 *
**/

deprecated public class СекСвязка(T) : КоллекцияСек!(T), Сортируемый!(T)
{
        alias ЯчейкаСС!(T) ЯчейкаССТ;

        alias КоллекцияСек!(T).удали     удали;
        alias КоллекцияСек!(T).удалиВсе  удалиВсе;

        // экземпляр variables

        /**
         * The голова of the список. Пусто iff счёт == 0
        **/

        package ЯчейкаССТ список;

        // constructors

        /**
         * Созд a new пустой список
        **/

        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Созд a список with a given элемент скринер
        **/

        public this (Предикат скринер)
        {
                this(скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/

        protected this (Предикат s, ЯчейкаССТ l, цел c)
        {
                super(s);
                список = l;
                счёт = c;
        }

        /**
         * Build an independent копируй of the список.
         * The элементы themselves are not cloned
        **/

        //  protected Объект клонируй() {
        public СекСвязка!(T) дубликат()
        {
                if (список is пусто)
                    return new СекСвязка!(T)(скринер, пусто, 0);
                else
                   return new СекСвязка!(T)(скринер, список.копируйСписок(), счёт);
        }


        // Коллекция methods

        /**
         * Implements col.impl.Collection.Коллекция.содержит
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                      return нет;

                return список.найди(элемент) !is пусто;
        }

        /**
         * Implements col.impl.Collection.Коллекция.экземпляры
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return 0;

                return список.счёт(элемент);
        }

        /**
         * Implements col.impl.Collection.Коллекция.элементы
         * Временная ёмкость: O(1).
         * See_Also: col.impl.Collection.Коллекция.элементы
        **/
        public final СтражОбходчик!(T) элементы()
        {
                return new ОбходчикЯчейки!(T)(this);
        }

        /**
         * Implements col.model.View.Обзор.opApply
         * Временная ёмкость: O(n).
         * See_Also: col.model.View.Обзор.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикЯчейки!(T)(this);
                return обходчик.opApply (дг);
        }


        // Сек Methods

        /**
         * Implements col.model.Seq.Сек.голова.
         * Временная ёмкость: O(1).
         * See_Also: col.model.Seq.Сек.голова
        **/
        public final T голова()
        {
                return перваяЯчейка().элемент();
        }

        /**
         * Implements col.model.Seq.Сек.хвост.
         * Временная ёмкость: O(n).
         * See_Also: col.model.Seq.Сек.хвост
        **/
        public final T хвост()
        {
                return последняяЯчейка().элемент();
        }

        /**
         * Implements col.model.Seq.Сек.получи.
         * Временная ёмкость: O(n).
         * See_Also: col.model.Seq.Сек.получи
        **/
        public final T получи(цел индекс)
        {
                return ячейкаПо(индекс).элемент();
        }

        /**
         * Implements col.model.Seq.Сек.первый.
         * Временная ёмкость: O(n).
         * See_Also: col.model.Seq.Сек.первый
        **/
        public final цел первый(T элемент, цел стартовыйИндекс = 0)
        {
                if (!действительныйАргумент(элемент) || список is пусто || стартовыйИндекс >= счёт)
                      return -1;

                if (стартовыйИндекс < 0)
                    стартовыйИндекс = 0;

                ЯчейкаССТ p = список.н_ый(стартовыйИндекс);
                if (p !is пусто)
                   {
                   цел i = p.индекс(элемент);
                   if (i >= 0)
                       return i + стартовыйИндекс;
                   }
                return -1;
        }

        /**
         * Implements col.model.Seq.Сек.последний.
         * Временная ёмкость: O(n).
         * See_Also: col.model.Seq.Сек.последний
        **/
        public final цел последний(T элемент, цел стартовыйИндекс = 0)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                     return -1;

                цел i = 0;
                if (стартовыйИндекс >= размер())
                    стартовыйИндекс = размер() - 1;

                цел индекс = -1;
                ЯчейкаССТ p = список;
                while (i <= стартовыйИндекс && p !is пусто)
                      {
                      if (p.элемент() == (элемент))
                          индекс = i;
                      ++i;
                      p = p.следщ();
                      }
                return индекс;
        }



        /**
         * Implements col.model.Seq.Сек.subseq.
         * Временная ёмкость: O(length).
         * See_Also: col.model.Seq.Сек.subseq
        **/
        public final СекСвязка поднабор(цел из_, цел длина)
        {
                if (длина > 0)
                   {
                   ЯчейкаССТ p = ячейкаПо(из_);
                   ЯчейкаССТ новый_список = new ЯчейкаССТ(p.элемент(), пусто);
                   ЯчейкаССТ текущ = новый_список;
         
                   for (цел i = 1; i < длина; ++i)
                       {
                       p = p.следщ();
                       if (p is пусто)
                           проверьИндекс(из_ + i); // force исключение

                       текущ.вяжиСледщ(new ЯчейкаССТ(p.элемент(), пусто));
                       текущ = текущ.следщ();
                       }
                   return new СекСвязка!(T)(скринер, новый_список, длина);
                   }
                else
                   return new СекСвязка!(T)(скринер, пусто, 0);
        }


        // MutableCollection methods

        /**
         * Implements col.impl.Collection.Коллекция.очисть.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                if (список !is пусто)
                   {
                   список = пусто;
                   устСчёт(0);
                   }
        }

        /**
         * Implements col.impl.Collection.Коллекция.exclude.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.exclude
        **/
        public final проц удалиВсе (T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements col.impl.Collection.Коллекция.removeOneOf.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали (T элемент)
        {
                удали_(элемент, нет);
        }

        /**
         * Implements col.impl.Collection.Коллекция.replaceOneOf
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени (T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /**
         * Implements col.impl.Collection.Коллекция.replaceAllOf.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }


        /**
         * Implements col.impl.Collection.Коллекция.возьми.
         * Временная ёмкость: O(1).
         * takes the первый элемент on the список
         * See_Also: col.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                T знач = голова();
                удалиГолову();
                return знач;
        }

        // Сортируемый methods

        /**
         * Implements col.Сортируемый.сортируй.
         * Временная ёмкость: O(n лог n).
         * Uses a совмести-сортируй-based algorithm.
         * See_Also: col.SortableCollection.сортируй
        **/
        public final проц сортируй(Сравнитель!(T) cmp)
        {
                if (список !is пусто)
                   {
                   список = ЯчейкаССТ.mergeSort(список, cmp);
                   инкрВерсию();
                   }
        }


        // MutableSeq methods

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.приставь.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.приставь
        **/
        public final проц приставь(T элемент)
        {
                проверьЭлемент(элемент);
                список = new ЯчейкаССТ(элемент, список);
                incCount();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениГолову.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениГолову
        **/
        public final проц замениГолову(T элемент)
        {
                проверьЭлемент(элемент);
                перваяЯчейка().элемент(элемент);
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удалиГолову.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиГолову
        **/
        public final проц удалиГолову()
        {
                список = перваяЯчейка().следщ();
                декрСчёт();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавь.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавь
        **/
        public final проц добавь(T элемент)
        {
                проверьЭлемент(элемент);
                if (список is пусто)
                    приставь(элемент);
                else
                   {
                   список.хвост().следщ(new ЯчейкаССТ(элемент));
                   incCount();
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениХвост.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениХвост
        **/
        public final проц замениХвост(T элемент)
        {
                проверьЭлемент(элемент);
                последняяЯчейка().элемент(элемент);
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удалиХвост.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиХвост
        **/
        public final проц удалиХвост()
        {
                if (перваяЯчейка().следщ() is пусто)
                    удалиГолову();
                else
                   {
                   ЯчейкаССТ trail = список;
                   ЯчейкаССТ p = trail.следщ();

                   while (p.следщ() !is пусто)
                         {
                         trail = p;
                         p = p.следщ();
                         }
                   trail.следщ(пусто);
                   декрСчёт();
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавьПо.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавьПо
        **/
        public final проц добавьПо(цел индекс, T элемент)
        {
                if (индекс is 0)
                    приставь(элемент);
                else
                   {
                   проверьЭлемент(элемент);
                   ячейкаПо(индекс - 1).вяжиСледщ(new ЯчейкаССТ(элемент));
                   incCount();
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удалиПо.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиПо
        **/
        public final проц удалиПо(цел индекс)
        {
                if (индекс is 0)
                    удалиГолову();
                else
                   {
                   ячейкаПо(индекс - 1).отвяжиСледщ();
                   декрСчёт();
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениПо.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениПо
        **/
        public final проц замениПо(цел индекс, T элемент)
        {
                ячейкаПо(индекс).элемент(элемент);
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.приставь.
         * Временная ёмкость: O(число of элементы in e).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                splice_(e, пусто, список);
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавь.
         * Временная ёмкость: O(n + число of элементы in e).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                if (список is пусто)
                    splice_(e, пусто, пусто);
                else
                   splice_(e, список.хвост(), пусто);
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавьПо.
         * Временная ёмкость: O(n + число of элементы in e).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавьПо
        **/
        public final проц добавьПо(цел индекс, Обходчик!(T) e)
        {
                if (индекс is 0)
                    splice_(e, пусто, список);
                else
                   {
                   ЯчейкаССТ p = ячейкаПо(индекс - 1);
                   splice_(e, p, p.следщ());
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.removeFromTo.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.removeFromTo
        **/
        public final проц удалиДиапазон (цел отИндекса, цел доИндекса)
        {
                проверьИндекс(доИндекса);

                if (отИндекса <= доИндекса)
                   {
                   if (отИндекса is 0)
                      {
                      ЯчейкаССТ p = перваяЯчейка();
                      for (цел i = отИндекса; i <= доИндекса; ++i)
                           p = p.следщ();
                      список = p;
                      }
                   else
                      {
                      ЯчейкаССТ f = ячейкаПо(отИндекса - 1);
                      ЯчейкаССТ p = f;
                      for (цел i = отИндекса; i <= доИндекса; ++i)
                           p = p.следщ();
                      f.следщ(p.следщ());
                      }
                  добавьВСчёт( -(доИндекса - отИндекса + 1));
                  }
        }



        // helper methods

        private final ЯчейкаССТ перваяЯчейка()
        {
                if (список !is пусто)
                    return список;

                проверьИндекс(0);
                return пусто; // not reached!
        }

        private final ЯчейкаССТ последняяЯчейка()
        {
                if (список !is пусто)
                    return список.хвост();

                проверьИндекс(0);
                return пусто; // not reached!
        }

        private final ЯчейкаССТ ячейкаПо(цел индекс)
        {
                проверьИндекс(индекс);
                return список.н_ый(индекс);
        }

        /**
         * Helper метод for removeOneOf()
        **/

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return ;

                ЯчейкаССТ p = список;
                ЯчейкаССТ trail = p;

                while (p !is пусто)
                      {
                      ЯчейкаССТ n = p.следщ();
                      if (p.элемент() == (элемент))
                         {
                         декрСчёт();
                         if (p is список)
                            {
                            список = n;
                            trail = n;
                            }
                         else
                            trail.следщ(n);

                         if (!всеСлучаи || счёт is 0)
                             return ;
                         else
                            p = n;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }


        /**
         * Helper for замени
        **/

        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (счёт is 0 || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return ;

                ЯчейкаССТ p = список.найди(старЭлемент);
                while (p !is пусто)
                      {
                      проверьЭлемент(новЭлемент);
                      p.элемент(новЭлемент);
                      инкрВерсию();
                      if (!всеСлучаи)
                           return ;
                      p = p.найди(старЭлемент);
                      }
        }

        /**
         * Splice элементы of e between hd и tl. if hd is пусто return new hd
        **/

        private final проц splice_(Обходчик!(T) e, ЯчейкаССТ hd, ЯчейкаССТ tl)
        {
                if (e.ещё())
                   {
                   ЯчейкаССТ новый_список = пусто;
                   ЯчейкаССТ текущ = пусто;

                   while (e.ещё())
                        {
                        T знач = e.получи();
                        проверьЭлемент(знач);
                        incCount();

                        ЯчейкаССТ p = new ЯчейкаССТ(знач, пусто);
                        if (новый_список is пусто)
                            новый_список = p;
                        else
                           текущ.следщ(p);
                        текущ = p;
                        }

                   if (текущ !is пусто)
                       текущ.следщ(tl);

                   if (hd is пусто)
                       список = новый_список;
                   else
                      hd.следщ(новый_список);
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

                assert(((счёт is 0) is (список is пусто)));
                assert((список is пусто || список.длина() is счёт));

                цел c = 0;
                for (ЯчейкаССТ p = список; p !is пусто; p = p.следщ())
                    {
                    assert(допускается(p.элемент()));
                    assert(экземпляры(p.элемент()) > 0);
                    assert(содержит(p.элемент()));
                    ++c;
                    }
                assert(c is счёт);

        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class ОбходчикЯчейки(T) : АбстрактныйОбходчик!(T)
        {
                private ЯчейкаССТ ячейка;

                public this (СекСвязка пследвтн)
                {
                        super (пследвтн);
                        ячейка = пследвтн.список;
                }

                public final T получи()
                {
                        декрементируйОстаток();
                        auto знач = ячейка.элемент();
                        ячейка = ячейка.следщ();
                        return знач;
                }

                цел opApply (цел delegate (inout T значение) дг)
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
        }
}




debug (Test)
{
        import io.Console;
        
        проц main()
        {
                auto пследвтн = new СекСвязка!(ткст);
                пследвтн.добавь ("foo");
                пследвтн.добавь ("wumpus");
                пследвтн.добавь ("bar");

                foreach (значение; пследвтн.элементы) {}

                auto элементы = пследвтн.элементы();
                while (элементы.ещё)
                       auto знач = элементы.получи();

                foreach (значение; пследвтн)
                         Квывод (значение).нс;

                пследвтн.проверьРеализацию();
        }
}
                
