module col.impl.MapCollection;

private import  exception;
private import  col.impl.Collection;
private import  col.model.MapX,
                col.model.View,
                col.model.MapView,
                col.model.IteratorX,
                col.model.SortedKeys;


/*******************************************************************************

        КоллекцияКарт extends Коллекция в_ предоставляет default implementations of
        some Карта operations. 

 ********************************************************************************/

public abstract class КоллекцияКарт(К, T) : Коллекция!(T), Карта!(К, T)
{
        alias ОбзорКарты!(К, T)            ОбзорКартыТ;
        alias Коллекция!(T).удали     удали;
        alias Коллекция!(T).удалиВсе  удалиВсе;


        /***********************************************************************

                Инициализует при версии 0, an пустой счёт, и пусто скринер

        ************************************************************************/

        protected this ()
        {
                super();
        }

        /***********************************************************************

                Инициализует при версии 0, an пустой счёт, и supplied скринер

        ************************************************************************/

        protected this (Предикат скринер)
        {
                super(скринер);
        }

        /***********************************************************************

                Реализует col.Map.допускаетсяКлюч.
                Default ключ-screen. Just проверьs for пусто.
                
                См_Также: col.Map.допускаетсяКлюч

        ************************************************************************/

        public final бул допускаетсяКлюч(К ключ)
        {
                return (ключ !is К.init);
        }

        protected final бул действительныйКлюч(К ключ)
        {
                static if (is (К /*: Объект*/))
                          {
                          if (ключ is пусто)
                              return нет;
                          }
                return да;
        }

        /***********************************************************************

                PrincИПal метод в_ throw a IllegalElementException for ключи

        ************************************************************************/

        protected final проц проверьКлюч(К ключ)
        {
                if (!действительныйКлюч(ключ))
                   {
                   throw new IllegalElementException("Попытка включить в коллекцию непригодный ключ");
                   }
        }

        /***********************************************************************

                Реализует col.impl.MapCollection.КоллекцияКарт.opIndexAssign
                Just calls добавь(ключ, элемент).

                См_Также: col.impl.MapCollection.КоллекцияКарт.добавь

        ************************************************************************/

        public final проц opIndexAssign (T элемент, К ключ)
        {
                добавь (ключ, элемент);
        }

        /***********************************************************************

                Реализует col.impl.Collection.Коллекция.совпадает
                Временная ёмкость: O(n).
                Default implementation. Fairly sleazy approach.
                (Defensible only when you remember that it is just a default impl.)
                It tries в_ cast в_ one of the known collection interface типы
                и then applies the corresponding сравнение rules.
                This suffices for все currently supported collection типы,
                but must be overrопрden if you define new Коллекция subinterfaces
                и/or implementations.
                
                См_Также: col.impl.Collection.Коллекция.совпадает

        ************************************************************************/

        public override бул совпадает(Обзор!(T) другой)
        {
                if (другой is пусто)
                   {}
                else
                   if (другой is this)
                       return да;
                   else
                      {
                      auto врем = cast (ОбзорКартыТ) другой;
                      if (врем)
                          if (cast(СортированныеКлючи!(К, T)) this)
                              return одинаковыеУпорядоченныеПары(this, врем);
                          else
                             return одинаковыеПары(this, врем);
                      }
                return нет;
        }


        public final static бул одинаковыеПары(ОбзорКартыТ s, ОбзорКартыТ t)
        {
                if (s.размер !is t.размер)
                    return нет;

                try { // установи up в_ return нет on collection exceptions
                    foreach (ключ, значение; t.ключи)
                             if (! s.содержитПару (ключ, значение))
                                   return нет;
                    } catch (НетЭлементаИскл ex)
                            {
                            return нет;
                            }
                return да;
        }

        public final static бул одинаковыеУпорядоченныеПары(ОбзорКартыТ s, ОбзорКартыТ t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ss = s.ключи();
                try { // установи up в_ return нет on collection exceptions
                    foreach (ключ, значение; t.ключи)
                            {
                            К sk;
                            auto sv = ss.получи (sk);
                            if (sk != ключ || sv != значение)
                                return нет;
                            }
                    } catch (НетЭлементаИскл ex)
                            {
                            return нет;
                            }
                return да;
        }


        // Объект methods

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

