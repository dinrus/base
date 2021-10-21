module col.impl.RBPair;

private import col.impl.RBCell;
private import col.model.Comparator;

/**
 *
 * RBPairs are RBCells with ключи.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class КЧПара(К, T) : КЧЯчейка!(T) 
{
        alias КЧЯчейка!(T).элемент элемент;

        // экземпляр переменная

        private К ключ_;

        /**
         * Make a ячейка with given ключ и элемент значения, и пусто линки
        **/

        public this (К ключ, T знач)
        {
                super(знач);
                ключ_ = ключ;
        }

        /**
         * Make a new узел with same ключ и элемент значения, but пусто линки
        **/

        protected final КЧПара дубликат()
        {
                auto t = new КЧПара(ключ_, элемент());
                t.цвет_ = цвет_;
                return t;
        }

        /**
         * return the ключ
        **/

        public final К ключ()
        {
                return ключ_;
        }


        /**
         * установи the ключ
        **/

        public final проц ключ(К ключ)
        {
                ключ_ = ключ;
        }

        /**
         * Implements КЧЯчейка.найди.
         * Overrопрe КЧЯчейка version since we are ordered on ключи, not элементы, so
         * элемент найди имеется в_ ищи whole дерево.
         * сравнитель аргумент not actually использован.
         * See_Also: КЧЯчейка.найди
        **/

        public final override КЧЯчейка!(T) найди(T элемент, Сравнитель!(T) cmp)
        {
                КЧЯчейка!(T) t = this;

                while (t !is пусто)
                      {
                      if (t.элемент() == (элемент))
                          return t;
                      else
                        if (t.право_ is пусто)
                            t = t.лево_;
                        else
                           if (t.лево_ is пусто)
                               t = t.право_;
                           else
                              {
                              auto p = t.лево_.найди(элемент, cmp);

                              if (p !is пусто)
                                  return p;
                              else
                                 t = t.право_;
                              }
                      }
                return пусто; // not reached
        }

        /**
         * Implements КЧЯчейка.счёт.
         * See_Also: КЧЯчейка.счёт
        **/
        public final override цел счёт(T элемент, Сравнитель!(T) cmp)
        {
                цел c = 0;
                КЧЯчейка!(T) t = this;

                while (t !is пусто)
                      {
                      if (t.элемент() == (элемент))
                          ++c;

                      if (t.право_ is пусто)
                          t = t.лево_;
                      else
                         if (t.лево_ is пусто)
                             t = t.право_;
                         else
                            {
                            c += t.лево_.счёт(элемент, cmp);
                            t = t.право_;
                            }
                      }
                return c;
        }

        /**
         * найди и return a ячейка holding ключ, or пусто if no such
        **/

        public final КЧПара найдиКлюч(К ключ, Сравнитель!(К) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел рознь = cmp(ключ, t.ключ_);
                    if (рознь is 0)
                        return t;
                    else
                       if (рознь < 0)
                           t = cast(КЧПара)(t.лево_);
                       else
                          t = cast(КЧПара)(t.право_);

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        /**
         * найди и return a ячейка holding (ключ, элемент), or пусто if no such
        **/
        public final КЧПара найди(К ключ, T элемент, Сравнитель!(К) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел рознь = cmp(ключ, t.ключ_);
                    if (рознь is 0 && t.элемент() == (элемент))
                        return t;
                    else
                       if (рознь <= 0)
                           t = cast(КЧПара)(t.лево_);
                       else
                          t = cast(КЧПара)(t.право_);

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        /**
         * return число of узелs of subtree holding ключ
        **/
        public final цел учтиКлюч(К ключ, Сравнитель!(К) cmp)
        {
                цел c = 0;
                auto t = this;

                while (t !is пусто)
                      {
                      цел рознь = cmp(ключ, t.ключ_);
                      // rely on вставь в_ always go лево on <=
                      if (рознь is 0)
                          ++c;

                      if (рознь <= 0)
                          t = cast(КЧПара)(t.лево_);
                      else
                         t = cast(КЧПара)(t.право_);
                      }
                return c;
        }

        /**
         * return число of узелs of subtree holding (ключ, элемент)
        **/
        public final цел счёт(К ключ, T элемент, Сравнитель!(К) cmp)
        {
                цел c = 0;
                auto t = this;
                
                while (t !is пусто)
                      {
                      цел рознь = cmp(ключ, t.ключ_);
                      if (рознь is 0)
                         {
                         if (t.элемент() == (элемент))
                             ++c;

                         if (t.лево_ is пусто)
                             t = cast(КЧПара)(t.право_);
                         else
                            if (t.право_ is пусто)
                                t = cast(КЧПара)(t.лево_);
                            else
                               {
                               c += (cast(КЧПара)(t.право_)).счёт(ключ, элемент, cmp);
                               t = cast(КЧПара)(t.лево_);
                               }
                         }
                      else
                         if (рознь < 0)
                             t = cast(КЧПара)(t.лево());
                         else
                            t = cast(КЧПара)(t.право());
                      }
                return c;
        }
}

