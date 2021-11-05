﻿module col.HashMapX;

private import  exception;

/+
private import  io.protocol.model,
                io.protocol.model;
+/
private import  col.model.HashParams,
                col.model.GuardIterator;

private import  col.impl.LLCell,
                col.impl.LLPair,
                col.impl.MapCollection,
                col.impl.AbstractIterator;

/*******************************************************************************

         Хэш таблица implementation of Карта
                

********************************************************************************/


deprecated public class ХэшКарта(К, З) : КоллекцияКарт!(К, З), ПараметрыХэш
{
        alias ЯчейкаСС!(З)                ЯчейкаССТ;
        alias ПараСС!(К, З)             ПараССТ;

        alias КоллекцияКарт!(К, З).удали     удали;
        alias КоллекцияКарт!(К, З).удалиВсе  удалиВсе;

        // экземпляр variables

        /***********************************************************************

                The таблица. Each Запись is a список. Пусто if no таблица allocated

        ************************************************************************/
  
        private ПараССТ таблица[];

        /***********************************************************************

                The порог загрузи фактор

        ************************************************************************/

        private плав факторЗагрузки;


        // constructors

        /***********************************************************************

                Make a new пустой карта в_ use given элемент скринер.
        
        ************************************************************************/

        public this (Предикат скринер = пусто)
        {
                this(скринер, дефФакторЗагрузки);
        }

        /***********************************************************************

                Special version of constructor needed by клонируй()
        
        ************************************************************************/

        protected this (Предикат s, плав f)
        {
                super(s);
                таблица = пусто;
                факторЗагрузки = f;
        }

        /***********************************************************************

                Make an independent копируй of the таблица. Elements themselves
                are not cloned.
        
        ************************************************************************/

        public final ХэшКарта!(К, З) дубликат()
        {
                auto c = new ХэшКарта!(К, З) (скринер, факторЗагрузки);

                if (счёт !is 0)
                   {
                   цел cap = 2 * cast(цел)((счёт / факторЗагрузки)) + 1;
                   if (cap < дефНачКорзины)
                       cap = дефНачКорзины;

                   c.корзины(cap);

                   for (цел i = 0; i < таблица.length; ++i)
                        for (ПараССТ p = таблица[i]; p !is пусто; p = cast(ПараССТ)(p.следщ()))
                             c.добавь (p.ключ(), p.элемент());
                   }
                return c;
        }


        // ПараметрыХэш methods

        /***********************************************************************

                Implements col.ПараметрыХэш.корзины.
                Временная ёмкость: O(1).
                
                See_Also: col.ПараметрыХэш.корзины.
        
        ************************************************************************/

        public final цел корзины()
        {
                return (таблица is пусто) ? 0 : таблица.length;
        }

        /***********************************************************************

                Implements col.ПараметрыХэш.корзины.
                Временная ёмкость: O(n).
                
                See_Also: col.ПараметрыХэш.корзины.
        
        ************************************************************************/

        public final проц корзины(цел newCap)
        {
                if (newCap is корзины())
                    return ;
                else
                   if (newCap >= 1)
                       перемерь(newCap);
                   else
                      throw new ИсклНелегальногоАргумента("Неверный Хэш таблица размер");
        }

        /***********************************************************************

                Implements col.ПараметрыХэш.thresholdLoadfactor
                Временная ёмкость: O(1).
                
                See_Also: col.ПараметрыХэш.thresholdLoadfactor
        
        ************************************************************************/

        public final плав пороговыйФакторЗагрузки()
        {
                return факторЗагрузки;
        }

        /***********************************************************************

                Implements col.ПараметрыХэш.thresholdLoadfactor
                Временная ёмкость: O(n).
                
                See_Also: col.ПараметрыХэш.thresholdLoadfactor
        
        ************************************************************************/

        public final проц пороговыйФакторЗагрузки(плав desired)
        {
                if (desired > 0.0)
                   {
                   факторЗагрузки = desired;
                   проверьФакторЗагрузки();
                   }
                else
                   throw new ИсклНелегальногоАргумента("Неверный фактор загрузки хэш-таблицы");
        }



        // Обзор methods

        /***********************************************************************

                Implements col.model.View.Обзор.содержит.
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.model.View.Обзор.содержит
        
        ************************************************************************/
        
        public final бул содержит(З элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return нет;

                for (цел i = 0; i < таблица.length; ++i)
                    {
                    ПараССТ hd = таблица[i];
                    if (hd !is пусто && hd.найди(элемент) !is пусто)
                        return да;
                    }
                return нет;
        }

        /***********************************************************************

                Implements col.model.View.Обзор.экземпляры.
                Временная ёмкость: O(n).
                
                See_Also: col.model.View.Обзор.экземпляры
        
        ************************************************************************/
        
        public final бцел экземпляры(З элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return 0;
    
                бцел c = 0;
                for (бцел i = 0; i < таблица.length; ++i)
                    {
                    ПараССТ hd = таблица[i];
                    if (hd !is пусто)
                        c += hd.счёт(элемент);
                    }
                return c;
        }

        /***********************************************************************

                Implements col.model.View.Обзор.элементы.
                Временная ёмкость: O(1).
                
                See_Also: col.model.View.Обзор.элементы
        
        ************************************************************************/
        
        public final СтражОбходчик!(З) элементы()
        {
                return ключи();
        }

        /***********************************************************************

                Implements col.model.View.Обзор.opApply
                Временная ёмкость: O(n)
                
                See_Also: col.model.View.Обзор.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout З значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(К, З)(this);
                return обходчик.opApply (дг);
        }


        /***********************************************************************

                Implements col.ОбзорКарты.opApply
                Временная ёмкость: O(n)
                
                See_Also: col.ОбзорКарты.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout К ключ, inout З значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(К, З)(this);
                return обходчик.opApply (дг);
        }


        // Карта methods

        /***********************************************************************

                Implements col.Map.содержитКлюч.
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.Map.содержитКлюч
        
        ************************************************************************/
        
        public final бул содержитКлюч(К ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                    return нет;

                ПараССТ p = таблица[хэшУ(ключ)];
                if (p !is пусто)
                    return p.найдиКлюч(ключ) !is пусто;
                else
                   return нет;
        }

        /***********************************************************************

                Implements col.Map.содержитПару
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.Map.содержитПару
        
        ************************************************************************/
        
        public final бул содержитПару(К ключ, З элемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(элемент) || счёт is 0)
                    return нет;

                ПараССТ p = таблица[хэшУ(ключ)];
                if (p !is пусто)
                    return p.найди(ключ, элемент) !is пусто;
                else
                   return нет;
        }

        /***********************************************************************

                Implements col.Map.ключи.
                Временная ёмкость: O(1).
                
                See_Also: col.Map.ключи
        
        ************************************************************************/
        
        public final ОбходчикПар!(К, З) ключи()
        {
                return new ОбходчикКарты!(К, З)(this);
        }

        /***********************************************************************

                Implements col.Map.получи.
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.Map.at
        
        ************************************************************************/
        
        public final З получи(К ключ)
        {
                проверьКлюч(ключ);
                if (счёт !is 0)
                   {
                   ПараССТ p = таблица[хэшУ(ключ)];
                   if (p !is пусто)
                      {
                      ПараССТ c = p.найдиКлюч(ключ);
                      if (c !is пусто)
                          return c.элемент();
                      }
                   }
                throw new НетЭлементаИскл("не совпадает ключ");
        }


        /***********************************************************************

                Return the элемент associated with Key ключ. 
                @param ключ a ключ
                Возвращает: whether the ключ is contained or not
        
        ************************************************************************/

        public бул получи(К ключ, inout З элемент)
        {
                проверьКлюч(ключ);
                if (счёт !is 0)
                   {
                   ПараССТ p = таблица[хэшУ(ключ)];
                   if (p !is пусто)
                      {
                      ПараССТ c = p.найдиКлюч(ключ);
                      if (c !is пусто)
                         {
                         элемент = c.элемент();
                         return да;
                         }
                      }
                   }
                return нет;
        }



        /***********************************************************************

                Implements col.Map.ключК.
                Временная ёмкость: O(n).
                
                See_Also: col.Map.akyOf
        
        ************************************************************************/
        
        public final бул ключК(inout К ключ, З значение)
        {
                if (!действительныйАргумент(значение) || счёт is 0)
                    return нет;

                for (цел i = 0; i < таблица.length; ++i)
                    { 
                    ПараССТ hd = таблица[i];
                    if (hd !is пусто)
                       {
                       auto p = (cast(ПараССТ)(hd.найди(значение)));
                       if (p !is пусто)
                          {
                          ключ = p.ключ();
                          return да;
                          }
                       }
                    }
                return нет;
        }


        // Коллекция methods

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.очисть.
                Временная ёмкость: O(1).
                
                See_Also: col.impl.Collection.Коллекция.очисть
        
        ************************************************************************/
        
        public final проц очисть()
        {
                устСчёт(0);
                таблица = пусто;
        }

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.удалиВсе.
                Временная ёмкость: O(n).
                
                See_Also: col.impl.Collection.Коллекция.удалиВсе
        
        ************************************************************************/
        
        public final проц удалиВсе (З элемент)
        {
                удали_(элемент, да);
        }


        /***********************************************************************

                Implements col.impl.Collection.Коллекция.removeOneOf.
                Временная ёмкость: O(n).
                
                See_Also: col.impl.Collection.Коллекция.removeOneOf
        
        ************************************************************************/
        
        public final проц удали (З элемент)
        {
                удали_(элемент, нет);
        }


        /***********************************************************************

                Implements col.impl.Collection.Коллекция.replaceOneOf.
                Временная ёмкость: O(n).
                
                See_Also: col.impl.Collection.Коллекция.replaceOneOf
        
        ************************************************************************/

        public final проц замени (З старЭлемент, З новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.replaceOneOf.
                Временная ёмкость: O(n).
                
                See_Also: col.impl.Collection.Коллекция.replaceOneOf
        
        ************************************************************************/

        public final проц замениВсе (З старЭлемент, З новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.возьми.
                Временная ёмкость: O(число of корзины).
                
                See_Also: col.impl.Collection.Коллекция.возьми
        
        ************************************************************************/
        
        public final З возьми()
        {
                if (счёт !is 0)
                   {
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       if (таблица[i] !is пусто)
                          {
                          декрСчёт();
                          auto знач = таблица[i].элемент();
                          таблица[i] = cast(ПараССТ)(таблица[i].следщ());
                          return знач;
                          }
                       }
                   }
                проверьИндекс(0);
                return З.init; // not reached
        }

        // Карта methods

        /***********************************************************************

                Implements col.Map.добавь.
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.Map.добавь
        
        ************************************************************************/
        
        public final проц добавь (К ключ, З элемент)
        {
                проверьКлюч(ключ);
                проверьЭлемент(элемент);

                if (таблица is пусто)
                    перемерь (дефНачКорзины);

                цел h = хэшУ(ключ);
                ПараССТ hd = таблица[h];
                if (hd is пусто)
                   {
                   таблица[h] = new ПараССТ(ключ, элемент, hd);
                   incCount();
                   return;
                   }
                else
                   {
                   ПараССТ p = hd.найдиКлюч(ключ);
                   if (p !is пусто)
                      {
                      if (p.элемент() != (элемент))
                         {
                         p.элемент(элемент);
                         инкрВерсию();
                         }
                      }
                   else
                      {
                      таблица[h] = new ПараССТ(ключ, элемент, hd);
                      incCount();
                      проверьФакторЗагрузки(); // we only проверь загрузи фактор on добавь в_ Неукmpty bin
                      }
                   }
        }


        /***********************************************************************

                Implements col.Map.удали.
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.Map.удали
        
        ************************************************************************/
        
        public final проц удалиКлюч (К ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                    return;

                цел h = хэшУ(ключ);
                ПараССТ hd = таблица[h];
                ПараССТ p = hd;
                ПараССТ trail = p;

                while (p !is пусто)
                      {
                      ПараССТ n = cast(ПараССТ)(p.следщ());
                      if (p.ключ() == (ключ))
                         {
                         декрСчёт();
                         if (p is hd)
                             таблица[h] = n;
                         else
                            trail.отвяжиСледщ();
                         return;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        /***********************************************************************

                Implements col.Map.replaceElement.
                Временная ёмкость: O(1) average; O(n) worst.
                
                See_Also: col.Map.replaceElement
        
        ************************************************************************/
        
        public final проц замениПару (К ключ, З старЭлемент, З новЭлемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(старЭлемент) || счёт is 0)
                    return;

                ПараССТ p = таблица[хэшУ(ключ)];
                if (p !is пусто)
                   {
                   ПараССТ c = p.найди(ключ, старЭлемент);
                   if (c !is пусто)
                      {
                      проверьЭлемент(новЭлемент);
                      c.элемент(новЭлемент);
                      инкрВерсию();
                      }
                   }
        }

        // Helper methods

        /***********************************************************************

                Check в_ see if we are past загрузи фактор порог. If so,
                перемерь so that we are at half of the desired порог.
                Also while at it, проверь в_ see if we are пустой so can just
                отвяжи таблица.
        
        ************************************************************************/
        
        protected final проц проверьФакторЗагрузки()
        {
                if (таблица is пусто)
                   {
                   if (счёт !is 0)
                       перемерь(дефНачКорзины);
                   }
                else
                   {
                   плав fc = cast(плав) (счёт);
                   плав ft = таблица.length;

                   if (fc / ft > факторЗагрузки)
                      {
                      цел newCap = 2 * cast(цел)(fc / факторЗагрузки) + 1;
                      перемерь(newCap);
                      }
                   }
        }

        /***********************************************************************

                маска off и остаток the hashCode for элемент
                so it can be использован as таблица индекс
        
        ************************************************************************/

        protected final цел хэшУ(К ключ)
        {
                return (typeid(К).дайХэш(&ключ) & 0x7FFFFFFF) % таблица.length;
        }


        /***********************************************************************

        ************************************************************************/

        protected final проц перемерь(цел newCap)
        {
                ПараССТ newtab[] = new ПараССТ[newCap];

                if (таблица !is пусто)
                   {
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       ПараССТ p = таблица[i];
                       while (p !is пусто)
                             {
                             ПараССТ n = cast(ПараССТ)(p.следщ());
                             цел h = (p.хэшКлюча() & 0x7FFFFFFF) % newCap;
                             p.следщ(newtab[h]);
                             newtab[h] = p;
                             p = n;
                             }
                       }
                   }
                таблица = newtab;
                инкрВерсию();
        }

        // helpers

        /***********************************************************************

        ************************************************************************/

        private final проц удали_(З элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return;

                for (цел h = 0; h < таблица.length; ++h)
                    {
                    ЯчейкаССТ hd = таблица[h];
                    ЯчейкаССТ p = hd;
                    ЯчейкаССТ trail = p;
                    while (p !is пусто)
                          {
                          ПараССТ n = cast(ПараССТ)(p.следщ());
                          if (p.элемент() == (элемент))
                             {
                             декрСчёт();
                             if (p is таблица[h])
                                {
                                таблица[h] = n;
                                trail = n;
                                }
                             else
                                trail.следщ(n);
                             if (! всеСлучаи)
                                   return;
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
        }

        /***********************************************************************

        ************************************************************************/

        private final проц замени_(З старЭлемент, З новЭлемент, бул всеСлучаи)
        {
                if (счёт is 0 || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return;

                for (цел h = 0; h < таблица.length; ++h)
                    {
                    ЯчейкаССТ hd = таблица[h];
                    ЯчейкаССТ p = hd;
                    ЯчейкаССТ trail = p;
                    while (p !is пусто)
                          {
                          ПараССТ n = cast(ПараССТ)(p.следщ());
                          if (p.элемент() == (старЭлемент))
                             {
                             проверьЭлемент(новЭлемент);
                             инкрВерсию();
                             p.элемент(новЭлемент);
                             if (! всеСлучаи)
                                   return ;
                             }
                          trail = p;
                          p = n;
                          }
                    }
        }

/+
        // ИЧитатель & ИПисатель methods

        /***********************************************************************

        ************************************************************************/

        public override проц читай (ИЧитатель ввод)
        {
                цел     длин;
                К       ключ;
                З       элемент;
                
                ввод (длин) (факторЗагрузки) (счёт);
                таблица = (длин > 0) ? new ПараССТ[длин] : пусто;

                for (длин=счёт; длин-- > 0;)
                    {
                    ввод (ключ) (элемент);
                    
                    цел h = хэшУ (ключ);
                    таблица[h] = new ПараССТ (ключ, элемент, таблица[h]);
                    }
        }
                        
        /***********************************************************************

        ************************************************************************/

        public override проц пиши (ИПисатель вывод)
        {
                вывод (таблица.length) (факторЗагрузки) (счёт);

                if (таблица.length > 0)
                    foreach (ключ, значение; ключи)
                             вывод (ключ) (значение);
        }
        
+/
        // ImplementationCheckable methods

        /***********************************************************************

                Implements col.model.View.Обзор.проверьРеализацию.
                
                See_Also: col.model.View.Обзор.проверьРеализацию
        
        ************************************************************************/
                        
        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();

                assert(!(таблица is пусто && счёт !is 0));
                assert((таблица is пусто || таблица.length > 0));
                assert(факторЗагрузки > 0.0f);

                if (таблица is пусто)
                    return;

                цел c = 0;
                for (цел i = 0; i < таблица.length; ++i)
                    {
                    for (ПараССТ p = таблица[i]; p !is пусто; p = cast(ПараССТ)(p.следщ()))
                        {
                        ++c;
                        assert(допускается(p.элемент()));
                        assert(допускаетсяКлюч(p.ключ()));
                        assert(содержитКлюч(p.ключ()));
                        assert(содержит(p.элемент()));
                        assert(экземпляры(p.элемент()) >= 1);
                        assert(содержитПару(p.ключ(), p.элемент()));
                        assert(хэшУ(p.ключ()) is i);
                        }
                    }
                assert(c is счёт);


        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class ОбходчикКарты(К, З) : АбстрактныйОбходчикКарты!(К, З)
        {
                private цел             ряд;
                private ПараССТ         пара;
                private ПараССТ[]       таблица;

                public this (ХэшКарта карта)
                {
                        super (карта);
                        таблица = карта.таблица;
                }

                public final З получи(inout К ключ)
                {
                        auto знач = получи();
                        ключ = пара.ключ;
                        return знач;
                }

                public final З получи()
                {
                        декрементируйОстаток();

                        if (пара)
                            пара = cast(ПараССТ) пара.следщ();

                        while (пара is пусто)
                               пара = таблица [ряд++];

                        return пара.элемент();
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
        import io.Console;
                        
        проц main()
        {
                auto карта = new ХэшКарта!(ткст, дво);
                карта.добавь ("foo", 3.14);
                карта.добавь ("bar", 6.28);

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

                Квывод (карта).нс;
        }
}
