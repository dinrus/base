module col.ArraySeq;

private import  col.model.IteratorX,
                col.model.Sortable,
                col.model.Comparator,
                col.model.GuardIterator;
				
private import  col.impl.SeqCollection,
                col.impl.AbstractIterator;


/**
 *
 * Dynamically allocated и resized Arrays.
 * 
 * Beyond implementing its interfaces, добавьs methods
 * в_ исправь capacities. The default heuristics for resizing
 * usually work fine, but you can исправь them manually when
 * you need в_.
 *
 * ArraySeqs are generally like java.util.Vectors. But unlike them,
 * ArraySeqs do not actually размести массивы when they are constructed.
 * Among другой consequences, you can исправь the ёмкость `for free'
 * после construction but before добавим элементы. You can исправь
 * it at другой times as well, but this may lead в_ ещё expensive
 * resizing. Also, unlike Vectors, they release their internal массивы
 * whenever they are пустой.
 *
**/

deprecated public class СекМассив(T) : КоллекцияСек!(T), Сортируемый!(T)
{
        alias КоллекцияСек!(T).удали     удали;
        alias КоллекцияСек!(T).удалиВсе  удалиВсе;

        /**
         * The minimum ёмкость of any non-пустой буфер
        **/

        public static цел минЁмкость = 16;


        // экземпляр variables

        /**
         * The элементы, or пусто if no буфер yet allocated.
        **/

        package T Массив[];


        // constructors

        /**
         * Make a new пустой СекМассив. 
        **/

        public this ()
        {
                this (пусто, пусто, 0);
        }

        /**
         * Make an пустой СекМассив with given элемент скринер
        **/

        public this (Предикат скринер)
        {
                this (скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        package this (Предикат s, T[] b, цел c)
        {
                super(s);
                Массив = b;
                счёт = c;
        }

        /**
         * Make an independent копируй. The элементы themselves are not cloned
        **/

        public final СекМассив!(T) дубликат()
        {
                цел cap = счёт;
                if (cap is 0)
                    return new СекМассив!(T) (скринер, пусто, 0);
                else
                   {
                   if (cap < минЁмкость)
                       cap = минЁмкость;

                   T newArray[] = new T[cap];
                   //System.копируй (Массив[0].sizeof, Массив, 0, newArray, 0, счёт);

                   newArray[0..счёт] = Массив[0..счёт];
                   return new СекМассив!(T)(скринер, newArray, счёт);
                   }
        }

        // methods introduced _in СекМассив

        /**
         * return the текущ internal буфер ёмкость (zero if no буфер allocated).
         * Возвращает: ёмкость (always greater than or equal в_ размер())
        **/

        public final цел ёмкость()
        {
                return (Массив is пусто) ? 0 : Массив.length;
        }

        /**
         * Набор the internal буфер ёмкость в_ max(размер(), newCap).
         * That is, if given an аргумент less than the текущ
         * число of элементы, the ёмкость is just установи в_ the
         * текущ число of элементы. Thus, элементы are never lost
         * by настройка the ёмкость. 
         * 
         * @param newCap the desired ёмкость.
         * Возвращает: condition: 
         * <PRE>
         * ёмкость() >= размер() &&
         * version() != PREV(this).version() == (ёмкость() != PREV(this).ёмкость())
         * </PRE>
        **/

        public final проц ёмкость(цел newCap)
        {
                if (newCap < счёт)
                    newCap = счёт;

                if (newCap is 0)
                   {
                   очисть();
                   }
                else
                   if (Массив is пусто)
                      {
                      Массив = new T[newCap];
                      инкрВерсию();
                      }
                   else
                      if (newCap !is Массив.length)
                         {
                         //T newArray[] = new T[newCap];
                         //newArray[0..счёт] = Массив[0..счёт];
                         //Массив = newArray;
                         Массив ~= new T[newCap - Массив.length];
                         инкрВерсию();
                         }
        }


        // Коллекция methods

        /**
         * Implements col.impl.Collection.Коллекция.содержит
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (! действительныйАргумент (элемент))
                      return нет;

                for (цел i = 0; i < счёт; ++i)
                     if (Массив[i] == (элемент))
                         return да;
                return нет;
        }

        /**
         * Implements col.impl.Collection.Коллекция.экземпляры
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (! действительныйАргумент(элемент))
                      return 0;

                бцел c = 0;
                for (бцел i = 0; i < счёт; ++i)
                     if (Массив[i] == (элемент))
                         ++c;
                return c;
        }

        /**
         * Implements col.impl.Collection.Коллекция.элементы
         * Временная ёмкость: O(1).
         * See_Also: col.impl.Collection.Коллекция.элементы
        **/
        public final СтражОбходчик!(T) элементы()
        {
                return new ОбходчикМассива!(T)(this);
        }

        /**
         * Implements col.model.View.Обзор.opApply
         * Временная ёмкость: O(n).
         * See_Also: col.model.View.Обзор.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикМассива!(T)(this);
                return обходчик.opApply (дг);
        }


        // Сек methods:

        /**
         * Implements col.model.Seq.Сек.голова.
         * Временная ёмкость: O(1).
         * See_Also: col.model.Seq.Сек.голова
        **/
        public final T голова()
        {
                проверьИндекс(0);
                return Массив[0];
        }

        /**
         * Implements col.model.Seq.Сек.хвост.
         * Временная ёмкость: O(1).
         * See_Also: col.model.Seq.Сек.хвост
        **/
        public final T хвост()
        {
                проверьИндекс(счёт -1);
                return Массив[счёт -1];
        }

        /**
         * Implements col.model.Seq.Сек.получи.
         * Временная ёмкость: O(1).
         * See_Also: col.model.Seq.Сек.получи
        **/
        public final T получи(цел индекс)
        in {
           проверьИндекс(индекс);
           }
        body
        {
                return Массив[индекс];
        }

        /**
         * Implements col.model.Seq.Сек.первый.
         * Временная ёмкость: O(n).
         * See_Also: col.model.Seq.Сек.первый
        **/
        public final цел первый(T элемент, цел стартовыйИндекс = 0)
        {
                if (стартовыйИндекс < 0)
                    стартовыйИндекс = 0;

                for (цел i = стартовыйИндекс; i < счёт; ++i)
                     if (Массив[i] == (элемент))
                         return i;
                return -1;
        }

        /**
         * Implements col.model.Seq.Сек.последний.
         * Временная ёмкость: O(n).
         * See_Also: col.model.Seq.Сек.последний
        **/
        public final цел последний(T элемент, цел стартовыйИндекс = 0)
        {
                if (стартовыйИндекс >= счёт)
                    стартовыйИндекс = счёт -1;
 
                for (цел i = стартовыйИндекс; i >= 0; --i)
                     if (Массив[i] == (элемент))
                         return i;
                return -1;
        }


        /**
         * Implements col.model.Seq.Сек.subseq.
         * Временная ёмкость: O(length).
         * See_Also: col.model.Seq.Сек.subseq
        **/
        public final СекМассив поднабор (цел из_, цел длина)
        {
                if (длина > 0)
                   {
                   проверьИндекс(из_);
                   проверьИндекс(из_ + длина - 1);

                   T newArray[] = new T[длина];
                   //System.копируй (Массив[0].sizeof, Массив, из_, newArray, 0, длина);

                   newArray[0..длина] = Массив[из_..из_+длина];
                   return new СекМассив!(T)(скринер, newArray, длина);
                   }
                else
                   return new СекМассив!(T)(скринер);
        }


        // MutableCollection methods

        /**
         * Implements col.impl.Collection.Коллекция.очисть.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                Массив = пусто;
                устСчёт(0);
        }

        /**
         * Implements col.impl.Collection.Коллекция.removeOneOf.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали(T элемент)
        {
                удали_(элемент, нет);
        }


        /**
         * Implements col.impl.Collection.Коллекция.replaceOneOf
         * Временная ёмкость: O(n).
         * See_Also: col.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /**
         * Implements col.impl.Collection.Коллекция.replaceAllOf.
         * Временная ёмкость: O(n * число of replacements).
         * See_Also: col.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /**
         * Implements col.impl.Collection.Коллекция.exclude.
         * Временная ёмкость: O(n * экземпляры(элемент)).
         * See_Also: col.impl.Collection.Коллекция.exclude
        **/
        public final проц удалиВсе(T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements col.impl.Collection.Коллекция.возьми.
         * Временная ёмкость: O(1).
         * Takes the правейший элемент of the Массив.
         * See_Also: col.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                T знач = хвост();
                удалиХвост();
                return знач;
        }


        // SortableCollection methods:


        /**
         * Implements col.SortableCollection.сортируй.
         * Временная ёмкость: O(n лог n).
         * Uses a быстросорт-based algorithm.
         * See_Also: col.SortableCollection.сортируй
        **/
        public проц сортируй(Сравнитель!(T) cmp)
        {
                if (счёт > 0)
                   {
                   быстрСорт(Массив, 0, счёт - 1, cmp);
                   инкрВерсию();
                   }
        }


        // MutableSeq methods

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.приставь.
         * Временная ёмкость: O(n)
         * See_Also: col.impl.SeqCollection.КоллекцияСек.приставь
        **/
        public final проц приставь(T элемент)
        {
                проверьЭлемент(элемент);
                ростПо_(1);
                for (цел i = счёт -1; i > 0; --i)
                     Массив[i] = Массив[i - 1];
                Массив[0] = элемент;
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениГолову.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениГолову
        **/
        public final проц замениГолову(T элемент)
        {
                проверьЭлемент(элемент);
                Массив[0] = элемент;
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удалиГолову.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиГолову
        **/
        public final проц удалиГолову()
        {
                удалиПо(0);
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавь.
         * Временная ёмкость: normally O(1), but O(n) if размер() == ёмкость().
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавь
        **/
        public final проц добавь(T элемент)
        in {
           проверьЭлемент (элемент);
           }
        body
        {
                цел последний = счёт;
                ростПо_(1);
                Массив[последний] = элемент;
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениХвост.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениХвост
        **/
        public final проц замениХвост(T элемент)
        {
                проверьЭлемент(элемент);
                Массив[счёт -1] = элемент;
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удалиХвост.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиХвост
        **/
        public final проц удалиХвост()
        {
                проверьИндекс(0);
                Массив[счёт -1] = T.init;
                ростПо_( -1);
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавьПо.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавьПо
        **/
        public final проц добавьПо(цел индекс, T элемент)
        {
                if (индекс !is счёт)
                    проверьИндекс(индекс);

                проверьЭлемент(элемент);
                ростПо_(1);
                for (цел i = счёт -1; i > индекс; --i)
                     Массив[i] = Массив[i - 1];
                Массив[индекс] = элемент;
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.удали.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.удалиПо
        **/
        public final проц удалиПо(цел индекс)
        {
                проверьИндекс(индекс);
                for (цел i = индекс + 1; i < счёт; ++i)
                     Массив[i - 1] = Массив[i];
                Массив[счёт -1] = T.init;
                ростПо_( -1);
        }


        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.замениПо.
         * Временная ёмкость: O(1).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.замениПо
        **/
        public final проц замениПо(цел индекс, T элемент)
        {
                проверьИндекс(индекс);
                проверьЭлемент(элемент);
                Массив[индекс] = элемент;
                инкрВерсию();
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.приставь.
         * Временная ёмкость: O(n + число of элементы in e) if (e 
         * instanceof CollectionIterator) else O(n * число of элементы in e)
         * See_Also: col.impl.SeqCollection.КоллекцияСек.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                вставь_(0, e);
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавь.
         * Временная ёмкость: O(число of элементы in e) 
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                вставь_(счёт, e);
        }

        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.добавьПо.
         * Временная ёмкость: O(n + число of элементы in e) if (e 
         * instanceof CollectionIterator) else O(n * число of элементы in e)
         * See_Also: col.impl.SeqCollection.КоллекцияСек.добавьПо
        **/
        public final проц добавьПо(цел индекс, Обходчик!(T) e)
        {
                if (индекс !is счёт)
                    проверьИндекс(индекс);
                вставь_(индекс, e);
        }


        /**
         * Implements col.impl.SeqCollection.КоллекцияСек.removeFromTo.
         * Временная ёмкость: O(n).
         * See_Also: col.impl.SeqCollection.КоллекцияСек.removeFromTo
        **/
        public final проц удалиДиапазон (цел отИндекса, цел доИндекса)
        {
                проверьИндекс(отИндекса);
                проверьИндекс(доИндекса);
                if (отИндекса <= доИндекса)
                   {
                   цел gap = доИндекса - отИндекса + 1;
                   цел j = отИндекса;
                   for (цел i = доИндекса + 1; i < счёт; ++i)
                        Массив[j++] = Массив[i];
 
                   for (цел i = 1; i <= gap; ++i)
                        Массив[счёт -i] = T.init;
                   добавьВСчёт( -gap);
                   }
        }

        /**
         * An implementation of Quicksort using medians of 3 for partitions.
         * Used internally by сортируй.
         * It is public и static so it can be использован  в_ сортируй plain
         * массивы as well.
         * @param s, the Массив в_ сортируй
         * @param lo, the least индекс в_ сортируй из_
         * @param hi, the greatest индекс
         * @param cmp, the сравнитель в_ use for comparing элементы
        **/

        public final static проц быстрСорт(T s[], цел lo, цел hi, Сравнитель!(T) cmp)
        {
                if (lo >= hi)
                    return;

                /*
                   Use median-of-three(lo, mопр, hi) в_ pick a partition. 
                   Also обменяй them преобр_в relative order while we are at it.
                */

                цел mопр = (lo + hi) / 2;

                if (cmp(s[lo], s[mопр]) > 0)
                   {
                   T врем = s[lo];
                   s[lo] = s[mопр];
                   s[mопр] = врем; // обменяй
                   }

                if (cmp(s[mопр], s[hi]) > 0)
                   {
                   T врем = s[mопр];
                   s[mопр] = s[hi];
                   s[hi] = врем; // обменяй

                   if (cmp(s[lo], s[mопр]) > 0)
                      {
                      T tmp2 = s[lo];
                      s[lo] = s[mопр];
                      s[mопр] = tmp2; // обменяй
                      }
                   }

                цел лево = lo + 1;           // старт one past lo since already handled lo
                цел право = hi - 1;          // similarly
                if (лево >= право)
                    return;                  // if three or fewer we are готово

                T partition = s[mопр];

                for (;;)
                    {
                    while (cmp(s[право], partition) > 0)
                           --право;

                    while (лево < право && cmp(s[лево], partition) <= 0)
                           ++лево;

                    if (лево < право)
                       {
                       T врем = s[лево];
                       s[лево] = s[право];
                       s[право] = врем; // обменяй
                       --право;
                       }
                    else
                       break;
                    }

                быстрСорт(s, lo, лево, cmp);
                быстрСорт(s, лево + 1, hi, cmp);
        }

        /***********************************************************************

                expose collection контент as an Массив

        ************************************************************************/

        override public T[] вМассив ()
        {
                return Массив[0..счёт].dup;
        }
        
        // helper methods

        /**
         * Main метод в_ control буфер sizing.
         * The heuristic использован for growth is:
         * <PRE>
         * if out of пространство:
         *   if need less than минЁмкость, grow в_ минЁмкость
         *   else grow by average of requested размер и минЁмкость.
         * </PRE>
         * <P>
         * For small buffers, this causes them в_ be about 1/2 full.
         * while for large buffers, it causes them в_ be about 2/3 full.
         * <P>
         * For shrinkage, the only thing we do is отвяжи the буфер if it is пустой.
         * @param inc, the amount of пространство в_ grow by. Negative значения mean shrink.
         * Возвращает: condition: исправь record of счёт, и if any of
         * the above conditions apply, размести и копируй преобр_в a new
         * буфер of the appropriate размер.
        **/

        private final проц ростПо_(цел inc)
        {
                цел needed = счёт + inc;
                if (inc > 0)
                   {
                   /* heuristic: */
                   цел текущ = ёмкость();
                   if (needed > текущ)
                      {
                      инкрВерсию();
                      цел newCap = needed + (needed + минЁмкость) / 2;

                      if (newCap < минЁмкость)
                          newCap = минЁмкость;

                      if (Массив is пусто)
                         {
                         Массив = new T[newCap];
                         }
                      else
                         {
                         //T newArray[] = new T[newCap];
                         //newArray[0..счёт] = Массив[0..счёт];
                         //Массив = newArray;
                         Массив ~= new T[newCap - Массив.length];
                         }
                      }
                   }
                else
                   if (needed is 0)
                       Массив = пусто;

                устСчёт(needed);
        }


        /**
         * Utility в_ splice in enumerations
        **/

        private final проц вставь_(цел индекс, Обходчик!(T) e)
        {
                if (cast(СтражОбходчик!(T)) e)
                   { 
                   // we know размер!
                   цел inc = (cast(СтражОбходчик!(T)) (e)).остаток();
                   цел oldcount = счёт;
                   цел oldversion = vershion;
                   ростПо_(inc);

                   for (цел i = oldcount - 1; i >= индекс; --i)
                        Массив[i + inc] = Массив[i];

                   цел j = индекс;
                   while (e.ещё())
                         {
                         T элемент = e.получи();
                         if (!допускается (элемент))
                            { // Ugh. Can only do full rollback
                            for (цел i = индекс; i < oldcount; ++i)
                                 Массив[i] = Массив[i + inc];

                            vershion = oldversion;
                            счёт = oldcount;
                            проверьЭлемент(элемент); // force throw
                            }
                         Массив[j++] = элемент;
                         }
                   }
                else
                   if (индекс is счёт)
                      { // следщ best; we can добавь
                      while (e.ещё())
                            {
                            T элемент = e.получи();
                            проверьЭлемент(элемент);
                            ростПо_(1);
                            Массив[счёт -1] = элемент;
                            }
                      }
                   else
                      { // do it the медленно way
                      цел j = индекс;
                      while (e.ещё())
                            {
                            T элемент = e.получи();
                            проверьЭлемент(элемент);
                            ростПо_(1);

                            for (цел i = счёт -1; i > j; --i)
                                 Массив[i] = Массив[i - 1];
                            Массив[j++] = элемент;
                            }
                      }
        }

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (! действительныйАргумент(элемент))
                      return;

                for (цел i = 0; i < счёт; ++i)
                    {
                    while (i < счёт && Массив[i] == (элемент))
                          {
                          for (цел j = i + 1; j < счёт; ++j)
                               Массив[j - 1] = Массив[j];

                          Массив[счёт -1] = T.init;
                          ростПо_( -1);

                          if (!всеСлучаи || счёт is 0)
                               return ;
                          }
                    }
        }

        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (действительныйАргумент(старЭлемент) is нет || счёт is 0)
                    return;

                for (цел i = 0; i < счёт; ++i)
                    {
                    if (Массив[i] == (старЭлемент))
                       {
                       проверьЭлемент(новЭлемент);
                       Массив[i] = новЭлемент;
                       инкрВерсию();

                       if (! всеСлучаи)
                             return;
                       }
                    }
        }

        /**
         * Implements col.model.View.Обзор.проверьРеализацию.
         * See_Also: col.model.View.Обзор.проверьРеализацию
        **/
        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();
                assert(!(Массив is пусто && счёт !is 0));
                assert((Массив is пусто || счёт <= Массив.length));

                for (цел i = 0; i < счёт; ++i)
                    {
                    assert(допускается(Массив[i]));
                    assert(экземпляры(Массив[i]) > 0);
                    assert(содержит(Массив[i]));
                    }
        }

        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class ОбходчикМассива(T) : АбстрактныйОбходчик!(T)
        {
                private цел ряд;
                private T[] Массив;

                public this (СекМассив пследвтн)
                {
                        super (пследвтн);
                        Массив = пследвтн.Массив;
                }

                public final T получи()
                {
                        декрементируйОстаток();
                        return Массив[ряд++];
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
                auto Массив = new СекМассив!(ткст);
                Массив.добавь ("foo");
                Массив.добавь ("bar");
                Массив.добавь ("wumpus");

                foreach (значение; Массив.элементы) {}

                auto элементы = Массив.элементы();
                while (элементы.ещё)
                       auto знач = элементы.получи();

                foreach (значение; Массив)
                         Квывод (значение).нс;

                auto a = Массив.вМассив;
                a.сортируй;
                foreach (значение; a)
                         Квывод (значение).нс;

                 Массив.проверьРеализацию();
        }
}
