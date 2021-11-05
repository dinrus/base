﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2007

        author:         Kris

        These classes represent a simple means of reading and writing
        discrete данные типы as binary values, with an опция в_ invert
        the эндиан order of numeric values.

        Arrays are treated as untyped байт Потокs, with an optional
        length-префикс, and should иначе be explicitly managed at
        the application уровень. We'll добавь добавьitional support for массивы
        and aggregates in future.

*******************************************************************************/

module io.stream.Data;

private import stdrus :ПерестановкаБайт;

private import io.device.Conduit;

private import io.stream.Buffered;

/*******************************************************************************

        Простой способ чтения бинарных данных из произвольного ИПотокВвода,
        такого как файл:
        ---
        auto ввод = new ВводДанных (new Файл ("путь"));
        auto x = ввод.цел32;
        auto y = ввод.плав64;
        auto l = ввод.читай (буфер);           // прямое чтение необр данных
        auto s = cast(ткст) ввод.массив;      // читай length, размести пространство
        ввод.закрой;
        ---

*******************************************************************************/

class ВводДанных : ФильтрВвода
{
        public alias массив     получи;             /// old имя alias
        public alias булево   получиБул;         /// описано ранее
        public alias цел8      получиБайт;         /// описано ранее
        public alias цел16     получиКрат;        /// описано ранее
        public alias цел32     получиЦел;          /// описано ранее
        public alias цел64     получиДол;         /// описано ранее
        public alias плав32   получиПлав;        /// описано ранее
        public alias плав64   получиДво;       /// описано ранее

        public enum                             /// эндиан variations
        {
                Натив  = 0,
                Сеть = 1,
                Биг     = 1,
                Литл  = 2
        }

        private бул            флип;
        protected ИПотокВвода   ввод;
        private Размести        разместитель;

        private alias проц[] delegate (бцел) Размести;

        /***********************************************************************

                Продвижение конструктора в суперкласс

        ***********************************************************************/

        this (ИПотокВвода поток)
        {
                super (ввод = Бввод.создай (поток));

                разместитель = (бцел байты){return new void[байты];};
        }

        /***********************************************************************

                Установка разместителя массива

        ***********************************************************************/

        final ВводДанных размести (Размести размести)
        {
                разместитель = размести;
                return this;
        }

        /***********************************************************************

                Установка трансляции текущей эндианности

        ***********************************************************************/

        final ВводДанных эндиан (цел e)
        {
                version (БигЭндиан)
                         флип = e is Литл;
                   else
                      флип = e is Сеть;
                return this;
        }

        /***********************************************************************

                Чтен an массив задний преобр_в a пользователь-предоставленный workspace. The
                пространство must be sufficiently large enough в_ house все of
                the массив, and the actual число of байты is returned.

                Note that the размер of the массив is записано as an целое
                prefixing the массив контент itself.  Use читай(проц[]) в_ 
                eschew this префикс.

        ***********************************************************************/
        
        final бцел массив (проц[] приёмн)
        {
                auto длин = цел32;
                if (длин > приёмн.length)
                    провод.ошибка ("ВводДанных.читайМассив :: приёмный массив слишком мал");
                съешь (приёмн.ptr, длин);
                return длин;
        }

        /***********************************************************************

                Чтен an массив задний из_ the исток, with the assumption
                it есть been записано using ВыводДанных.помести() or иначе
                псеп_в_начале with an целое representing the total число
                of байты within the массив контент. That's *байты*, not
                elements.

                An массив of the appropriate размер is allocated either via
                the предоставленный delegate, or из_ the куча, populated and
                returned в_ the caller. Casting the return значение в_ an
                appropriate тип will исправь the число of elements as
                required:
                ---
                auto текст = cast(ткст) ввод.получи;
                ---
                
        ***********************************************************************/

        final проц[] массив ()
        {
                auto длин = цел32;
                auto приёмн = разместитель (длин);
                съешь (приёмн.ptr, длин);
                return приёмн;
        }

        /***********************************************************************

        ***********************************************************************/

        final бул булево ()
        {
                бул x;
                съешь (&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final байт цел8 ()
        {
                байт x;
                съешь (&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final крат цел16 ()
        {
                крат x;
                съешь (&x, x.sizeof);
                if (флип)
                    ПерестановкаБайт.своп16(&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final цел цел32 ()
        {
                цел x;
                съешь (&x, x.sizeof);
                if (флип)
                    ПерестановкаБайт.своп32(&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final дол цел64 ()
        {
                дол x;
                съешь (&x, x.sizeof);
                if (флип)
                    ПерестановкаБайт.своп64(&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final плав плав32 ()
        {
                плав x;
                съешь (&x, x.sizeof);
                if (флип)
                    ПерестановкаБайт.своп32(&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final дво плав64 ()
        {
                дво x;
                съешь (&x, x.sizeof);
                if (флип)
                    ПерестановкаБайт.своп64(&x, x.sizeof);
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final override т_мера читай (проц[] данные)
        {
                съешь (данные.ptr, данные.length);
                return данные.length;
        }

        /***********************************************************************

        ***********************************************************************/

        private final проц съешь (ук  приёмн, т_мера байты)
        {
                while (байты)
                      {
                      auto i = ввод.читай (приёмн [0 .. байты]);
                      if (i is Кф)
                          ввод.провод.ошибка ("ВводДанных :: неожиданный кф при чтении");
                      байты -= i;
                      приёмн += i;
                      } 
         }
}


/*******************************************************************************

        A simple way в_ пиши binary данные в_ an arbitrary ИПотокВывода,
        such as a файл:
        ---
        auto вывод = new ВыводДанных (new Файл ("путь", Файл.ЗапСозд));
        вывод.цел32   (1024);
        вывод.плав64 (3.14159);
        вывод.массив   ("ткст with length префикс");
        вывод.пиши   ("необр массив, no префикс");
        вывод.закрой;
        ---

*******************************************************************************/

class ВыводДанных : ФильтрВывода
{       
        public alias массив      помести;            /// old имя alias
        public alias булево    поместиБул;        /// описано ранее
        public alias цел8       поместиБайт;        /// описано ранее
        public alias цел16      поместиКрат;       /// описано ранее
        public alias цел32      поместиЦел;         /// описано ранее
        public alias цел64      поместиДол;        /// описано ранее
        public alias плав32    поместиПлав;       /// описано ранее
        public alias плав64    поместиПлав;       /// описано ранее

        public enum                             /// эндиан variations
        {
                Натив  = 0,
                Сеть = 1,
                Биг     = 1,
                Литл  = 2
        }

        private бул            флип;
        private ИПотокВывода    вывод;

        /***********************************************************************

                Propagate ctor в_ superclass

        ***********************************************************************/

        this (ИПотокВывода поток)
        {
                super (вывод = Бвыв.создай (поток));
        }

        /***********************************************************************

                Набор current эндиан translation

        ***********************************************************************/

        final ВыводДанных эндиан (цел e)
        {
                version (БигЭндиан)
                         флип = e is Литл;
                   else
                      флип = e is Сеть;
                return this;
        }

        /***********************************************************************

                Write an массив в_ the мишень поток. Note that the размер 
                of the массив is записано as an целое prefixing the массив 
                контент itself. Use пиши(проц[]) в_ eschew this префикс.

        ***********************************************************************/

        final бцел массив (проц[] ист)
        {
                auto длин = ист.length;
                цел32 (длин);
                вывод.пиши (ист);
                return длин;
        }

        /***********************************************************************

        ***********************************************************************/

        final проц булево (бул x)
        {
                съешь (&x, x.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final проц цел8 (байт x)
        {
                съешь (&x, x.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final проц цел16 (крат x)
        {
                if (флип)
                    ПерестановкаБайт.своп16 (&x, x.sizeof);
                съешь (&x, x.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final проц цел32 (цел x)
        {
                if (флип)
                    ПерестановкаБайт.своп32 (&x, x.sizeof);
                съешь (&x, бцел.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final проц цел64 (дол x)
        {
                if (флип)
                    ПерестановкаБайт.своп64 (&x, x.sizeof);
                съешь (&x, x.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final проц плав32 (плав x)
        {
                if (флип)
                    ПерестановкаБайт.своп32 (&x, x.sizeof);
                съешь (&x, x.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final проц плав64 (дво x)
        {
                if (флип)
                    ПерестановкаБайт.своп64 (&x, x.sizeof);
                съешь (&x, x.sizeof);
        }

        /***********************************************************************

        ***********************************************************************/

        final override т_мера пиши (проц[] данные)
        {
                съешь (данные.ptr, данные.length);
                return данные.length;
        }

        /***********************************************************************

        ***********************************************************************/

        private final проц съешь (ук  ист, т_мера байты)
        {
                auto счёт = вывод.пиши (ист[0..байты]);
                assert (счёт is байты);
        }
}


/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        import io.device.Array;

        unittest
        {
                auto буф = new массив(32);

                auto вывод = new ВыводДанных (буф);
                вывод.массив ("blah blah");
                вывод.цел32 (1024);

                auto ввод = new ВводДанных (буф);
                assert (ввод.массив(new сим[9]) is 9);
                assert (ввод.цел32 is 1024);
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Данные)
{
        import io.device.Array;

        проц main()
        {
                auto буф = new массив(64);

                auto вывод = new ВыводДанных (буф);
                вывод.массив ("blah blah");
                вывод.цел32 (1024);

                auto ввод = new ВводДанных (буф);
                assert (ввод.массив.length is 9);
                assert (ввод.цел32 is 1024);
        }
}
