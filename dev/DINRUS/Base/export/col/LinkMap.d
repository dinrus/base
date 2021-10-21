module col.LinkMap;

private import exception;

private import  io.protocol.model,
                io.protocol.model;

private import  col.model.View,
                col.model.GuardIterator;

private import  col.impl.LLCell,
                col.impl.LLPair,
                col.impl.MapCollection,
                col.impl.AbstractIterator;

/**
 * Linked списки of (ключ, элемент) pairs
 * author: Doug Lea
**/
deprecated public class КартаСвязка(К, T) : КоллекцияКарт!(К, T) // , ИЧитаемое, ИЗаписываемое
{
        alias ЯчейкаСС!(T)               ЯчейкаССТ;
        alias ПараСС!(К, T)            ПараССТ;

        alias КоллекцияКарт!(К, T).удали     удали;
        alias КоллекцияКарт!(К, T) .удалиВсе  удалиВсе;

        // экземпляр variables

        /**
         * The голова of the список. Пусто if пустой
        **/

        package ПараССТ список;

        // constructors

        /**
         * Make an пустой список
        **/

        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Make an пустой список with the supplied элемент скринер
        **/

        public this (Предикат скринер)
        {
                this(скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        protected this (Предикат s, ПараССТ l, цел c)
        {
                super(s);
                список = l;
                счёт = c;
        }

        /**
         * Make an independent копируй of the список. Does not клонируй элементы
        **/

        public КартаСвязка!(К, T) дубликат()
        {
                if (список is пусто)
                    return new КартаСвязка!(К, T) (скринер, пусто, 0);
                else
                   return new КартаСвязка!(К, T) (скринер, cast(ПараССТ)(список.копируйСписок()), счёт);
        }


        // Коллекция methods

        /**
         * Implements col.impl.Collection.Коллекция.содержит.
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
         * Implements col.impl.Collection.Коллекция.экземпляры.
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
         * Implements col.impl.Collection.Коллекция.элементы.
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


        // Карта methods


        /**
         * Implements col.Map.содержитКлюч.
         * Время complexity: O(n).
         * See_Also: col.Map.содержитКлюч
        **/
        public final бул содержитКлюч(К ключ)
        {
                if (!действительныйКлюч(ключ) || список is пусто)
                     return нет;

                return список.найдиКлюч(ключ) !is пусто;
        }

        /**
         * Implements col.Map.содержитПару
         * Время complexity: O(n).
         * See_Also: col.Map.содержитПару
        **/
        public final бул содержитПару(К ключ, T элемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(элемент) || список is пусто)
                    return нет;
                return список.найди(ключ, элемент) !is пусто;
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
         * Время complexity: O(n).
         * See_Also: col.Map.получи
        **/
        public final T получи(К ключ)
        {
                проверьКлюч(ключ);
                if (список !is пусто)
                   {
                   auto p = список.найдиКлюч(ключ);
                   if (p !is пусто)
                       return p.элемент();
                   }
                throw new НетЭлементаИскл("no совпадают Key");
        }

        /**
         * Return the элемент associated with Key ключ. 
         * Параметры:
         *   ключ = a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public final бул получи(К ключ, inout T элемент)
        {
                проверьКлюч(ключ);
                if (список !is пусто)
                   {
                   auto p = список.найдиКлюч(ключ);
                   if (p !is пусто)
                      {
                      элемент = p.элемент();
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

                auto p = (cast(ПараССТ)(список.найди(значение)));
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
                список = пусто;
                устСчёт(0);
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
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /**
         * Implements col.impl.Collection.Коллекция.удалиВсе.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.удалиВсе
        **/
        public final проц удалиВсе(T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements col.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: col.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали(T элемент)
        {
                удали_(элемент, нет);
        }

        /**
         * Implements col.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * takes the первый элемент on the список
         * See_Also: col.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (список !is пусто)
                   {
                   auto знач = список.элемент();
                   список = cast(ПараССТ)(список.следщ());
                   декрСчёт();
                   return знач;
                   }
                проверьИндекс(0);
                return T.init; // not reached
        }


        // MutableMap methods

        /**
         * Implements col.impl.MapCollection.КоллекцияКарт.добавь.
         * Время complexity: O(n).
         * See_Also: col.impl.MapCollection.КоллекцияКарт.добавь
        **/
        public final проц добавь (К ключ, T элемент)
        {
                проверьКлюч(ключ);
                проверьЭлемент(элемент);

                if (список !is пусто)
                   {
                   auto p = список.найдиКлюч(ключ);
                   if (p !is пусто)
                      {
                      if (p.элемент() != (элемент))
                         {
                         p.элемент(элемент);
                         инкрВерсию();
                         }
                      return ;
                      }
                   }
                список = new ПараССТ(ключ, элемент, список);
                incCount();
        }


        /**
         * Implements col.impl.MapCollection.КоллекцияКарт.удали.
         * Время complexity: O(n).
         * See_Also: col.impl.MapCollection.КоллекцияКарт.удали
        **/
        public final проц удалиКлюч (К ключ)
        {
                if (!действительныйКлюч(ключ) || список is пусто)
                    return ;

                auto p = список;
                auto trail = p;

                while (p !is пусто)
                      {
                      auto n = cast(ПараССТ)(p.следщ());
                      if (p.ключ() == (ключ))
                         {
                         декрСчёт();
                         if (p is список)
                             список = n;
                         else
                            trail.отвяжиСледщ();
                         return ;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        /**
         * Implements col.impl.MapCollection.КоллекцияКарт.replaceElement.
         * Время complexity: O(n).
         * See_Also: col.impl.MapCollection.КоллекцияКарт.replaceElement
        **/
        public final проц замениПару (К ключ, T старЭлемент, T новЭлемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(старЭлемент) || список is пусто)
                     return ;

                auto p = список.найди(ключ, старЭлемент);
                if (p !is пусто)
                   {
                   проверьЭлемент(новЭлемент);
                   p.элемент(новЭлемент);
                   инкрВерсию();
                   }
        }

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return ;

                auto p = список;
                auto trail = p;

                while (p !is пусто)
                      {
                      auto n = cast(ПараССТ)(p.следщ());
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
                if (список is пусто || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return ;

                auto p = список.найди(старЭлемент);
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

                for (auto p = список; p !is пусто; p = cast(ПараССТ)(p.следщ()))
                    {
                    assert(допускается(p.элемент()));
                    assert(допускаетсяКлюч(p.ключ()));
                    assert(содержитКлюч(p.ключ()));
                    assert(содержит(p.элемент()));
                    assert(экземпляры(p.элемент()) >= 1);
                    assert(содержитПару(p.ключ(), p.элемент()));
                    }
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class ОбходчикКарты(К, З) : АбстрактныйОбходчикКарты!(К, З)
        {
                private ПараССТ пара;
                
                public this (КартаСвязка карта)
                {
                        super (карта);
                        пара = карта.список;
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
                        пара = cast(ПараССТ) пара.следщ();
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


         
debug(Test)
{
        проц main()
        {
                auto карта = new КартаСвязка!(Объект, дво);

                foreach (ключ, значение; карта.ключи) {typeof(ключ) x; x = ключ;}

                foreach (значение; карта.ключи) {}

                foreach (значение; карта.элементы) {}

                auto ключи = карта.ключи();
                while (ключи.ещё)
                       auto знач = ключи.получи();

                foreach (значение; карта) {}
                foreach (ключ, значение; карта) {}

                карта.проверьРеализацию();
        }
}
