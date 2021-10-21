module col.impl.MapCollection;

private import  exception;
private import  col.impl.Collection;
private import  col.model.MapX,
                col.model.View,
                col.model.MapView,
                col.model.IteratorX,
                col.model.SortedKeys;


/*******************************************************************************

        КоллекцияКарт extends Коллекция в_ provопрe default implementations of
        some Карта operations. 
                
        author: Doug Lea
                @version 0.93

        <P> For an introduction в_ this package see <A HREF="индекс.html"
        > Overview </A>.

 ********************************************************************************/

public abstract class КоллекцияКарт(К, T) : Коллекция!(T), Карта!(К, T)
{
        alias ОбзорКарты!(К, T)            MapViewT;
        alias Коллекция!(T).удали     удали;
        alias Коллекция!(T).удалиВсе  удалиВсе;


        /***********************************************************************

                Initialize at version 0, an пустой счёт, и пусто скринер

        ************************************************************************/

        protected this ()
        {
                super();
        }

        /***********************************************************************

                Initialize at version 0, an пустой счёт, и supplied скринер

        ************************************************************************/

        protected this (Предикат скринер)
        {
                super(скринер);
        }

        /***********************************************************************

                Implements col.Map.допускаетсяКлюч.
                Default ключ-screen. Just проверьs for пусто.
                
                See_Also: col.Map.допускаетсяКлюч

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
                   throw new IllegalElementException("Attempt в_ include не_годится ключ _in Коллекция");
                   }
        }

        /***********************************************************************

                Implements col.impl.MapCollection.КоллекцияКарт.opIndexAssign
                Just calls добавь(ключ, элемент).

                See_Also: col.impl.MapCollection.КоллекцияКарт.добавь

        ************************************************************************/

        public final проц opIndexAssign (T элемент, К ключ)
        {
                добавь (ключ, элемент);
        }

        /***********************************************************************

                Implements col.impl.Collection.Коллекция.совпадает
                Время complexity: O(n).
                Default implementation. Fairly sleazy approach.
                (Defensible only when you remember that it is just a default impl.)
                It tries в_ cast в_ one of the known collection interface типы
                и then applies the corresponding сравнение rules.
                This suffices for все currently supported collection типы,
                but must be overrопрden if you define new Коллекция subinterfaces
                и/or implementations.
                
                See_Also: col.impl.Collection.Коллекция.совпадает

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
                      auto врем = cast (MapViewT) другой;
                      if (врем)
                          if (cast(СортированныеКлючи!(К, T)) this)
                              return sameOrderedPairs(this, врем);
                          else
                             return samePairs(this, врем);
                      }
                return нет;
        }


        public final static бул samePairs(MapViewT s, MapViewT t)
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

        public final static бул sameOrderedPairs(MapViewT s, MapViewT t)
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
}

