﻿module col.CircularSeq;

private import  col.model.IteratorX,
                col.model.GuardIterator;

private import  col.impl.CLCell,
                col.impl.SeqCollection,
                col.impl.AbstractIterator;


/**
 * Circular linked списки. Publically Implement only those
 * methods defined in interfaces.
 * author: Doug Lea
**/
deprecated public class ЦиркулярСек(T) : КоллекцияСек!(T)
{
        alias ЯчейкаЦС!(T) ЯчейкаЦСТ;

        alias КоллекцияСек!(T).удали     удали;
        alias КоллекцияСек!(T).удалиВсе  удалиВсе;

        // экземпляр variables

        /**
         * The голова of the список. Пусто if пустой
        **/
        package ЯчейкаЦСТ список;

        // constructors

        /**
         * Make an пустой список with no элемент скринер
        **/
        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Make an пустой список with supplied элемент скринер
        **/
        public this (Предикат скринер)
        {
                this(скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        protected this (Предикат s, ЯчейкаЦСТ h, цел c)
        {
                super(s);
                список = h;
                счёт = c;
        }

        /**
         * Make an independent копируй of the список. Elements themselves are not cloned
        **/
        public final ЦиркулярСек!(T) дубликат()
        {
                if (список is пусто)
                    return new ЦиркулярСек!(T) (скринер, пусто, 0);
                else
                   return new ЦиркулярСек!(T) (скринер, список.копируйСписок(), счёт);
        }


        // Коллекция methods

        /**
         * Implements col.impl.Collection.Коллекция.содержит
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                    return нет;
                return список.найди(элемент) !is пусто;
        }

        /**
         * Implements col.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                    return 0;
                return список.счёт(элемент);
        }

        /**
         * Implements col.impl.Collection.Коллекция.элементы
         * Время complexity: O(1).
         * See_Also: col.impl.Collection.Коллекция.элементы
        **/
        public final СтражОбходчик!(T) элементы()
        {
                return new ОбходчикЯчейки!(T)(this);
        }

        /**
         * Implements col.model.View.Обзор.opApply
         * Время complexity: O(n).
         * See_Also: col.model.View.Обзор.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикЯчейки!(T)(this);
                return обходчик.opApply (дг);
        }


        // Сек methods

        /**
         * Implements col.model.Seq.Сек.голова.
         * Время complexity: O(1).
         * See_Also: col.model.Seq.Сек.голова
        **/
        public final T голова()
        {
                return перваяЯчейка().элемент();
        }

        /**
         * Implements col.model.Seq.Сек.хвост.
         * Время complexity: O(1).
         * See_Also: col.model.Seq.Сек.хвост
        **/
        public final T хвост()
        {
                return последняяЯчейка().элемент();
        }

        /**
         * Implements col.model.Seq.Сек.получи.
         * Время complexity: O(n).
         * See_Also: col.model.Seq.Сек.получи
        **/
        public final T получи(цел индекс)
        {
                return ячейкаПо(индекс).элемент();
        }

        /**
         * Implements col.model.Seq.Сек.первый.
         * Время complexity: O(n).
         * See_Also: col.model.Seq.Сек.первый
        **/
        public final цел первый(T элемент, цел стартовыйИндекс = 0)
        {
                if (стартовыйИндекс < 0)
                    стартовыйИндекс = 0;

                ЯчейкаЦСТ p = список;
                if (p is пусто || !действительныйАргумент(элемент))
                    return -1;

                for (цел i = 0; да; ++i)
                    {
                    if (i >= стартовыйИндекс && p.элемент() == (элемент))
                        return i;

                    p = p.следщ();
                    if (p is список)
                        break;
                    }
                return -1;
        }


        /**
         * Implements col.model.Seq.Сек.последний.
         * Время complexity: O(n).
         * See_Also: col.model.Seq.Сек.последний
        **/
        public final цел последний(T элемент, цел стартовыйИндекс = 0)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return -1;

                if (стартовыйИндекс >= размер())
                    стартовыйИндекс = размер() - 1;

                if (стартовыйИндекс < 0)
                    стартовыйИндекс = 0;

                ЯчейкаЦСТ p = ячейкаПо(стартовыйИндекс);
                цел i = стартовыйИндекс;
                for (;;)
                    {
                    if (p.элемент() == (элемент))
                        return i;
                    else
                       if (p is список)
                           break;
                       else
                          {
                          p = p.предш();
                          --i;
                          }
                    }
                return -1;
        }

        /**
         * Implements col.model.Seq.Сек.subseq.
         * Время complexity: O(length).
         * See_Also: col.model.Seq.Сек.subseq
        **/
        public final ЦиркулярСек поднабор (цел из_, цел длина)
        {
                if (длина > 0)
                   {
                   проверьИндекс(из_);
                   ЯчейкаЦСТ p = ячейкаПо(из_);
                   ЯчейкаЦСТ новый_список = new ЯчейкаЦСТ(p.элемент());
                   ЯчейкаЦСТ текущ = новый_список;

                   for (цел i = 1; i < длина; ++i)
                       {
                       p = p.следщ();
                       if (p is пусто)
                           проверьИндекс(из_ + i); // force исключение

                       текущ.добавьСледщ(p.элемент());
                       текущ = текущ.следщ();
                       }
                   return new ЦиркулярСек (скринер, новый_список, длина);
                   }
                else
                   return new ЦиркулярСек ();
        }

        // MutableCollection methods

        /**
         * Implements col.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: col.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                список = пусто;
                устСчёт(0);
        }

        /**
         * Implements col.impl.Collection.Коллекция.exclude.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.exclude
        **/
        public final проц удалиВсе (T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements col.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали (T элемент)
        {
                удали_(элемент, нет);
        }

        /**
         * Implements col.impl.Collection.Коллекция.replaceOneOf
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени (T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /**
         * Implements col.impl.Collection.Коллекция.replaceAllOf.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе (T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }


        /**
         * Implements col.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * takes the последний элемент on the список.
         * See_Also: col.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                auto знач = хвост();
                удалиХвост();
                return знач;
        }



        // MutableSeq methods

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.приставь.
         * Время complexity: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.приставь
        **/
        public final проц приставь(T элемент)
        {
                проверьЭлемент(элемент);
                if (список is пусто)
                    список = new ЯчейкаЦСТ(элемент);
                else
                   список = список.добавьПредш(элемент);
                incCount();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениГолову.
         * Время complexity: O(1).
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
         * Время complexity: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиГолову
        **/
        public final проц удалиГолову()
        {
                if (перваяЯчейка().синглтон_ли())
                   список = пусто;
                else
                   {
                   auto n = список.следщ();
                   список.отвяжи();
                   список = n;
                   }
                декрСчёт();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавь.
         * Время complexity: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавь
        **/
        public final проц добавь(T элемент)
        {
                if (список is пусто)
                    приставь(элемент);
                else
                   {
                   проверьЭлемент(элемент);
                   список.предш().добавьСледщ(элемент);
                   incCount();
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениХвост.
         * Время complexity: O(1).
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
         * Время complexity: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиХвост
        **/
        public final проц удалиХвост()
        {
                auto l = последняяЯчейка();
                if (l is список)
                    список = пусто;
                else
                   l.отвяжи();
                декрСчёт();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавьПо.
         * Время complexity: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавьПо
        **/
        public final проц добавьПо(цел индекс, T элемент)
        {
                if (индекс is 0)
                    приставь(элемент);
                else
                   {
                   проверьЭлемент(элемент);
                   ячейкаПо(индекс - 1).добавьСледщ(элемент);
                   incCount();
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениПо.
         * Время complexity: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениПо
        **/
        public final проц замениПо(цел индекс, T элемент)
        {
                проверьЭлемент(элемент);
                ячейкаПо(индекс).элемент(элемент);
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удалиПо.
         * Время complexity: O(n).
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
         * Implements col.impl.SeqCollection.КоллекцияСек.приставь.
         * Время complexity: O(число of элементы in e).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                ЯчейкаЦСТ hd = пусто;
                ЯчейкаЦСТ текущ = пусто;
      
                while (e.ещё())
                      {
                      auto элемент = e.получи();
                      проверьЭлемент(элемент);
                      incCount();

                      if (hd is пусто)
                         {
                         hd = new ЯчейкаЦСТ(элемент);
                         текущ = hd;
                         }
                      else
                         {
                         текущ.добавьСледщ(элемент);
                         текущ = текущ.следщ();
                         }
                      }

                if (список is пусто)
                    список = hd;
                else
                   if (hd !is пусто)
                      {
                      auto tl = список.предш();
                      текущ.следщ(список);
                      список.предш(текущ);
                      tl.следщ(hd);
                      hd.предш(tl);
                      список = hd;
                      }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавь.
         * Время complexity: O(число of элементы in e).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                if (список is пусто)
                    приставь(e);
                else
                   {
                   ЯчейкаЦСТ текущ = список.предш();
                   while (e.ещё())
                         {
                         T элемент = e.получи();
                         проверьЭлемент(элемент);
                         incCount();
                         текущ.добавьСледщ(элемент);
                         текущ = текущ.следщ();
                         }
                   }
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавьПо.
         * Время complexity: O(размер() + число of элементы in e).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавьПо
        **/
        public final проц добавьПо(цел индекс, Обходчик!(T) e)
        {
                if (список is пусто || индекс is 0)
                    приставь(e);
                else
                   {
                   ЯчейкаЦСТ текущ = ячейкаПо(индекс - 1);
                   while (e.ещё())
                         {
                         T элемент = e.получи();
                         проверьЭлемент(элемент);
                         incCount();
                         текущ.добавьСледщ(элемент);
                         текущ = текущ.следщ();
                         }
                   }
        }


        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.removeFromTo.
         * Время complexity: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.removeFromTo
        **/
        public final проц удалиДиапазон (цел отИндекса, цел доИндекса)
        {
                проверьИндекс(доИндекса);
                ЯчейкаЦСТ p = ячейкаПо(отИндекса);
                ЯчейкаЦСТ последний = список.предш();
                for (цел i = отИндекса; i <= доИндекса; ++i)
                    {
                    декрСчёт();
                    ЯчейкаЦСТ n = p.следщ();
                    p.отвяжи();
                    if (p is список)
                       {
                       if (p is последний)
                          {
                          список = пусто;
                          return ;
                          }
                       else
                          список = n;
                       }
                    p = n;
                    }
        }


        // helper methods

        /**
         * return the первый ячейка, or throw исключение if пустой
        **/
        private final ЯчейкаЦСТ перваяЯчейка()
        {
                if (список !is пусто)
                    return список;

                проверьИндекс(0);
                return пусто; // not reached!
        }

        /**
         * return the последний ячейка, or throw исключение if пустой
        **/
        private final ЯчейкаЦСТ последняяЯчейка()
        {
                if (список !is пусто)
                    return список.предш();

                проверьИндекс(0);
                return пусто; // not reached!
        }

        /**
         * return the индекс'th ячейка, or throw исключение if bad индекс
        **/
        private final ЯчейкаЦСТ ячейкаПо(цел индекс)
        {
                проверьИндекс(индекс);
                return список.н_ый(индекс);
        }

        /**
         * helper for удали/exclude
        **/
        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                    return;

                ЯчейкаЦСТ p = список;
                for (;;)
                    {
                    ЯчейкаЦСТ n = p.следщ();
                    if (p.элемент() == (элемент))
                       {
                       декрСчёт();
                       p.отвяжи();
                       if (p is список)
                          {
                          if (p is n)
                             {
                             список = пусто;
                             break;
                             }
                          else
                             список = n;
                          }

                       if (! всеСлучаи)
                             break;
                       else
                          p = n;
                       }
                    else
                       if (n is список)
                           break;
                       else
                          p = n;
                    }
        }


        /**
         * helper for замени *
        **/
        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(старЭлемент) || список is пусто)
                    return;

                ЯчейкаЦСТ p = список;
                do {
                   if (p.элемент() == (старЭлемент))
                      {
                      проверьЭлемент(новЭлемент);
                      инкрВерсию();
                      p.элемент(новЭлемент);
                      if (! всеСлучаи)
                            return;
                      }
                   p = p.следщ();
                } while (p !is список);
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

                if (список is пусто)
                    return;

                цел c = 0;
                ЯчейкаЦСТ p = список;
                do {
                   assert(p.предш().следщ() is p);
                   assert(p.следщ().предш() is p);
                   assert(допускается(p.элемент()));
                   assert(экземпляры(p.элемент()) > 0);
                   assert(содержит(p.элемент()));
                   p = p.следщ();
                   ++c;
                   } while (p !is список);

                assert(c is счёт);
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class ОбходчикЯчейки(T) : АбстрактныйОбходчик!(T)
        {
                private ЯчейкаЦСТ ячейка;

                public this (ЦиркулярСек пследвтн)
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
                auto Массив = new ЦиркулярСек!(ткст);
                Массив.добавь ("foo");
                Массив.добавь ("bar");
                Массив.добавь ("wumpus");

                foreach (значение; Массив.элементы) {}

                auto элементы = Массив.элементы();
                while (элементы.ещё)
                       auto знач = элементы.получи();

                foreach (значение; Массив)
                         Квывод (значение).нс;

                Массив.проверьРеализацию();
        }
}