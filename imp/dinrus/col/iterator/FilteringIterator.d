module col.iterator.FilteringIterator;

private import exception;
private import col.model.IteratorX;

/**
 *
 * FilteringIterators allow you в_ фильтр out элементы из_
 * другой enumerations before they are seen by their `consumers'
 * (i.e., the callers of `получи').
 *
 * FilteringIterators work as wrappers around другой Iterators.
 * To build one, you need an existing Обходчик (perhaps one
 * из_ coll.элементы(), for some Коллекция coll), и a Предикат
 * объект (i.e., implementing interface Предикат). 
 * Например, if you want в_ screen out everything but Panel
 * objects из_ a collection coll that might hold things другой than Panels,
 * пиши something of the form:
 * ---
 * Обходчик e = coll.элементы();
 * Обходчик panels = ФильтрОбходчик(e, IsPanel);
 * while (panels.ещё())
 *  doSomethingWith(cast(Panel)(panels.получи()));
 * ---
 * To use this, you will also need в_ пиши a little class of the form:
 * ---
 * class IsPanel : Предикат {
 *  бул predicate(Объект знач) { return cast(Panel) знач !is пусто; }
 * }
 * ---
 * See_Also: col.Предикат.predicate
 * author: Doug Lea
 *
**/

public class ФильтрОбходчик(T) : Обходчик!(T)
{
        alias бул delegate(T) Предикат;
        
        // экземпляр variables

        /**
         * The enumeration we are wrapping
        **/

        private Обходчик!(T) ист_;

        /**
         * The screening predicate
        **/

        private Предикат пред_;

        /**
         * The sense of the predicate. Нет means в_ invert
        **/

        private бул знак_;

        /**
         * The следщ элемент в_ hand out
        **/

        private T добыча_;

        /**
         * Да if we have a следщ элемент 
        **/

        private бул естьСледщ_;

        /**
         * Make a Фильтр using ист for the элементы, и p as the скринер,
         * selecting only those элементы of ист for which p is да
        **/

        public this (Обходчик!(T) ист, Предикат p)
        {
                this(ист, p, да);
        }

        /**
         * Make a Фильтр using ист for the элементы, и p as the скринер,
         * selecting only those элементы of ист for which p.predicate(знач) == sense.
         * A значение of да for sense selects only значения for which p.predicate
         * is да. A значение of нет selects only those for which it is нет.
        **/
        public this (Обходчик!(T) ист, Предикат p, бул sense)
        {
                ист_ = ист;
                пред_ = p;
                знак_ = sense;
                найдиСледщ();
        }

        /**
         * Implements col.model.IteratorX.ещё
        **/

        public final бул ещё()
        {
                return естьСледщ_;
        }

        /**
         * Implements col.model.IteratorX.получи.
        **/
        public final T получи()
        {
                if (! естьСледщ_)
                      throw new НетЭлементаИскл("перечисление завершилось");
                else
                   {
                   auto результат = добыча_;
                   найдиСледщ();
                   return результат;
                   }
        }


        цел opApply (цел delegate (inout T значение) дг)
        {
                цел результат;

                while (естьСледщ_)
                      {
                      auto значение = получи();
                      if ((результат = дг(значение)) != 0)
                           break;
                      }
                return результат;
        }


        /**
         * Traverse through ист_ элементы finding one passing predicate
        **/
        private final проц найдиСледщ()
        {
                естьСледщ_ = нет;

                for (;;)
                    {
                    if (! ист_.ещё())
                          return ;
                    else
                       {
                       try {
                           auto знач = ист_.получи();
                           if (пред_(знач) is знак_)
                              {
                              естьСледщ_ = да;
                              добыча_ = знач;
                              return;
                              }
                           } catch (НетЭлементаИскл ex)
                                   {
                                   return;
                                   }
                       }
                    }
        }
}

