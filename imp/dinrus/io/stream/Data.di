﻿/*******************************************************************************

        Эти классы представляют простые средства чтения и записи
        дискретных типов данных как двоичных значений, с опцией инвертировать
        эндианный порядок у числовых значений.

        Масссивы рассматриваются как как нетипированные байтовые потоки, с
        дополнительным префиксом длины, и в ином случае должны обрабатываться
        явно на уровне приложения.

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
        auto s = cast(ткст) ввод.массив;      // читать длину, разместить пространство
        ввод.закрой;
        ---

*******************************************************************************/
extern(D):

class ВводДанных : ФильтрВвода
{
        public alias массив     получи;             /// псевдоним строго имени
        public alias булево   получиБул;         /// описано ранее
        public alias цел8      получиБайт;         /// описано ранее
        public alias цел16     получиКрат;        /// описано ранее
        public alias цел32     получиЦел;          /// описано ранее
        public alias цел64     получиДол;         /// описано ранее
        public alias плав32   получиПлав;        /// описано ранее
        public alias плав64   получиДво;       /// описано ранее

        public enum                             /// эндианные вариации
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

        this (ИПотокВвода поток);

        /***********************************************************************

                Установка разместителя массива

        ***********************************************************************/

        final ВводДанных размести (Размести размести);

        /***********************************************************************

                Установка трансляции текущей эндианности

        ***********************************************************************/

        final ВводДанных эндиан (цел e);

        /***********************************************************************

                Читает массив в предоставленное пользователем пространство. Этого
                рабочего пространства должно хватать для вмещения всего
                массива; возвращает действительное число байтов.

                Размер массива записывается как целое, префиксируя
                само содержимое массива.  Для удаления этого префикса
				используется читай(проц[]).

        ***********************************************************************/
        
        final бцел массив (проц[] приёмн);

        /***********************************************************************

                Читает массив из истока, принимая как факт, что он записан
                функцией ВыводДанных.помести() или иначе
                в начале помещается целое, представляющее общее число
                байтов в контенте массива. Это *байты*, а не элементы.

                Массив соответствующего размера размещается либо посредством
                предоставленного делегата, либо из кучи, заполняется и
                возвращается вызывающей функции. Преобразование (переброс)
				возвращаемого значения в соответствующий тип, при необходимости
				исправляет число элементов:
                ---
                auto текст = cast(ткст) ввод.получи;
                ---
                
        ***********************************************************************/

        final проц[] массив();

        /***********************************************************************

        ***********************************************************************/

        final бул булево ();

        /***********************************************************************

        ***********************************************************************/

        final байт цел8 ();

        /***********************************************************************

        ***********************************************************************/

        final крат цел16 ();

        /***********************************************************************

        ***********************************************************************/

        final цел цел32 ();

        /***********************************************************************

        ***********************************************************************/

        final дол цел64 ();

        /***********************************************************************

        ***********************************************************************/

        final плав плав32 ();

        /***********************************************************************

        ***********************************************************************/

        final дво плав64 ();

        /***********************************************************************

        ***********************************************************************/

        final override т_мера читай (проц[] данные);

        /***********************************************************************

        ***********************************************************************/

        private final проц съешь (ук  приёмн, т_мера байты);
}


/*******************************************************************************

        Простое средство записи двоичных данных в произвольный ИПотокВывода,
        такой как файл:
        ---
        auto вывод = new ВыводДанных (new Файл ("путь", Файл.ЗапСозд));
        вывод.цел32   (1024);
        вывод.плав64 (3.14159);
        вывод.массив   ("ткст с префиксом длины");
        вывод.пиши   ("необработанный массив, без префикса");
        вывод.закрой;
        ---

*******************************************************************************/

class ВыводДанных : ФильтрВывода
{       
        public alias массив      помести;            /// старый алиас
		public alias булево    поместиБул;        /// описано ранее
        public alias цел8       поместиБайт;        /// описано ранее
        public alias цел16      поместиКрат;       /// описано ранее
        public alias цел32      поместиЦел;         /// описано ранее
        public alias цел64      поместиДол;        /// описано ранее
        public alias плав32    поместиПлав;       /// описано ранее
        public alias плав64    поместиПлав;       /// описано ранее

        public enum                             /// эндианные вариации
        {
                Натив  = 0,
                Сеть = 1,
                Биг     = 1,
                Литл  = 2
        }

       // private бул            флип;
       // private ИПотокВывода    вывод;

        /***********************************************************************

                Распространить конструктор на суперкласс.

        ***********************************************************************/

        this (ИПотокВывода поток);

        /***********************************************************************

                Установить текущую эндианную трансдляцию.

        ***********************************************************************/

        final ВыводДанных эндиан (цел e);

        /***********************************************************************

                Записать массив в целевой поток. Размер массива записывается 
                как целое, префиксируемое к содержимому самого массива.
				Чтобы убрать этот префикс, используется пиши(проц[]).

        ***********************************************************************/

        final бцел массив (проц[] ист);

        /***********************************************************************

        ***********************************************************************/

        final проц булево (бул x);

        /***********************************************************************

        ***********************************************************************/

        final проц цел8 (байт x);

        /***********************************************************************

        ***********************************************************************/

        final проц цел16 (крат x);

        /***********************************************************************

        ***********************************************************************/

        final проц цел32 (цел x);

        /***********************************************************************

        ***********************************************************************/

        final проц цел64 (дол x);

        /***********************************************************************

        ***********************************************************************/

        final проц плав32 (плав x);

        /***********************************************************************

        ***********************************************************************/

        final проц плав64 (дво x);

        /***********************************************************************

        ***********************************************************************/

        final override т_мера пиши (проц[] данные);

        /***********************************************************************

        ***********************************************************************/

       // private final проц съешь (ук  ист, т_мера байты);
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
