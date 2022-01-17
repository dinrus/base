module col.impl.LLCell;

private import col.impl.Cell;
private import col.model.Comparator;

/**
 *
 * ЯчейкиСС расширяют Ячейки стандартными следующими полями линкованного списка,
 * и предоставляют стандартные операции над ними.
 * <P>
 * ЯчейкиСС - это инструменты реализации. Они выполняют проверку
 * no аргументу, без скрининга результата и синхронизации.
 * Они полагаются на классы пользовательского уровня (см., напр., СвязныйСписок).
 * Этот класс объявлен `public', чтобы его можно было применить для
 * построения иного рода коллекций или ещё чего-либо, помимо тех, которые
 * поддерживаются на данный момент.
**/

public class ЯчейкаСС(T) : Ячейка!(T)
{
        alias Сравнитель!(T) КомпараторТ;


        protected ЯчейкаСС следщ_;

        /**
         * Возвращает следующую ячейку (или пусто, если Неук).
        **/

        public ЯчейкаСС следщ()
        {
                return следщ_;
        }

        /**
         * Устанавливает на точку в n как следщ ячейку.
         * @param n, эта новая следщ ячейка.
        **/

        public проц следщ(ЯчейкаСС n)
        {
                следщ_ = n;
        }

        public this (T знач, ЯчейкаСС n)
        {
                super(знач);
                следщ_ = n;
        }

        public this (T знач)
        {
                this(знач, пусто);
        }

        public this ()
        {
                this(T.init, пусто);
        }


        /**
         * Splice in p between текущ ячейка и whatever it was previously
         * pointing в_
         * @param p, the ячейка в_ splice
        **/

        public final проц вяжиСледщ(ЯчейкаСС p)
        {
                if (p !is пусто)
                    p.следщ_ = следщ_;
                следщ_ = p;
        }

        /**
         * Cause текущ ячейка в_ пропусти over the текущ следщ() one,
         * effectively removing the следщ элемент из_ the список
        **/

        public final проц отвяжиСледщ()
        {
                if (следщ_ !is пусто)
                    следщ_ = следщ_.следщ_;
        }

        /**
         * Linear ищи down the список looking for элемент (using T.равно)
         * @param элемент в_ look for
         * Возвращает: the ячейка containing элемент, либо пусто if no such
        **/

        public final ЯчейкаСС найди(T элемент)
        {
                for (ЯчейкаСС p = this; p !is пусто; p = p.следщ_)
                     if (p.элемент() == элемент)
                         return p;
                return пусто;
        }

        /**
         * Возвращает число ячеек traversed в_ найди первый occurrence
         * of a ячейка with элемент() элемент, либо -1 if not present
        **/

        public final цел индекс(T элемент)
        {
                цел i = 0;
                for (ЯчейкаСС p = this; p !is пусто; p = p.следщ_)
                    {
                    if (p.элемент() == элемент)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Счёт the число of occurrences of элемент in список
        **/

        public final цел счёт(T элемент)
        {
                цел c = 0;
                for (ЯчейкаСС p = this; p !is пусто; p = p.следщ_)
                     if (p.элемент() == элемент)
                         ++c;
                return c;
        }

        /**
         * Возвращает число ячеек в этом списке
        **/

        public final цел длина()
        {
                цел c = 0;
                for (ЯчейкаСС p = this; p !is пусто; p = p.следщ_)
                     ++c;
                return c;
        }

        /**
         * Возвращает ячейка representing the последний элемент этого списка
         * (i.e., the one whose следщ() is пусто
        **/

        public final ЯчейкаСС хвост()
        {
                ЯчейкаСС p = this;
                for ( ; p.следщ_ !is пусто; p = p.следщ_)
                    {}
                return p;
        }

        /**
         * Возвращает н_ый ячейка этого списка, либо пусто if no such
        **/

        public final ЯчейкаСС н_ый(цел n)
        {
                ЯчейкаСС p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.следщ_;
                return p;
        }


        /**
         * Создаёт копируй этого списка; i.e., a new список containing new cells
         * but включая the same элементы in the same order
        **/

        public final ЯчейкаСС копируйСписок()
        {
                ЯчейкаСС новый_список = пусто;
                новый_список = дубликат();
                ЯчейкаСС текущ = новый_список;

                for (ЯчейкаСС p = следщ_; p !is пусто; p = p.следщ_)
                    {
                    текущ.следщ_ = p.дубликат();
                    текущ = текущ.следщ_;
                    }
                текущ.следщ_ = пусто;
                return новый_список;
        }

        /**
         * Clone is SHALLOW; i.e., just makes a копируй of the текущ ячейка
        **/

        private final ЯчейкаСС дубликат()
        {
                return new ЯчейкаСС(элемент(), следщ_);
        }

        /**
         * Basic linkedlist совмести algorithm.
         * Merges the списки голова by перв и втор with respect в_ cmp
         * @param перв голова of the первый список
         * @param втор голова of the секунда список
         * @param cmp a Сравнитель использован в_ сравни элементы
         * Возвращает: the merged ordered список
        **/

        public final static ЯчейкаСС совмести(ЯчейкаСС перв, ЯчейкаСС втор, КомпараторТ cmp)
        {
                ЯчейкаСС a = перв;
                ЯчейкаСС b = втор;
                ЯчейкаСС hd = пусто;
                ЯчейкаСС текущ = пусто;
                for (;;)
                    {
                    if (a is пусто)
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          текущ.следщ(b);
                       return hd;
                       }
                    else
                       if (b is пусто)
                          {
                          if (hd is пусто)
                              hd = a;
                          else
                             текущ.следщ(a);
                          return hd;
                          }

                    цел рознь = cmp (a.элемент(), b.элемент());
                    if (рознь <= 0)
                       {
                       if (hd is пусто)
                           hd = a;
                       else
                          текущ.следщ(a);
                       текущ = a;
                       a = a.следщ();
                       }
                    else
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          текущ.следщ(b);
                       текущ = b;
                       b = b.следщ();
                       }
                    }
                return пусто;
        }

        /**
         * Standard список splitter, использован by сортируй.
         * Splits the список in half. Возвращает the голова of the секунда half
         * @param s the голова этого списка
         * Возвращает: the голова of the секунда half
        **/

        public final static ЯчейкаСС разбей(ЯчейкаСС s)
        {
                ЯчейкаСС быстро = s;
                ЯчейкаСС медленно = s;

                if (быстро is пусто || быстро.следщ() is пусто)
                    return пусто;

                while (быстро !is пусто)
                      {
                      быстро = быстро.следщ();
                      if (быстро !is пусто && быстро.следщ() !is пусто)
                         {
                         быстро = быстро.следщ();
                         медленно = медленно.следщ();
                         }
                      }

                ЯчейкаСС r = медленно.следщ();
                медленно.следщ(пусто);
                return r;

        }

        /**
         * Standard совмести сортируй algorithm
         * @param s the список в_ сортируй
         * @param cmp, the сравнитель в_ use for ordering
         * Возвращает: the голова of the sorted список
        **/

        public final static ЯчейкаСС mergeSort(ЯчейкаСС s, КомпараторТ cmp)
        {
                if (s is пусто || s.следщ() is пусто)
                    return s;
                else
                   {
                   ЯчейкаСС право = разбей(s);
                   ЯчейкаСС лево = s;
                   лево = mergeSort(лево, cmp);
                   право = mergeSort(право, cmp);
                   return совмести(лево, право, cmp);
                   }
        }

}

