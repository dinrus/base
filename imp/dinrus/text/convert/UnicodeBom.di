﻿module text.convert.UnicodeBom;

private import  stdrus;

private import  Utf = text.convert.Utf;


private extern (C) проц onUnicodeError (ткст сооб, т_мера индкс = 0);

/*******************************************************************************

        Смотрите http://icu.sourceforge.net/docs/papers/forms_of_unicode/#t2

*******************************************************************************/

enum Кодировка {
              Неизвестно,
              UTF_8N,
              UTF_8,
              UTF_16,
              UTF_16BE,
              UTF_16LE,
              UTF_32,
              UTF_32BE,
              UTF_32LE,
              };

/*******************************************************************************

        Преобразует контент в формате Юникод.

        Юникод - это кодировка текстового материала. Задача этого модуля 
        создать интерфейс между внешней кодировкой и внутренней кодировкой
 		программирования. Эта внутренняя кодировка декларируется через
		шаблонный аргумент T, в то время как внешняя кодировка либо задаётся,
		либо является производной.

        Поддерживается три внутренних кодировки: сим, шим и дим. Методы
		отсюда оперируют над массивами такого типа. То есть раскодируй()
        возвращает массив такого типа, в то время как кодируй() ожидает
		сопутствующего типа.

        Поддерживаются следующие внешние кодировки:

                Кодировка.Неизвестно 
                Кодировка.UTF_8N
                Кодировка.UTF_8
                Кодировка.UTF_16
                Кодировка.UTF_16BE
                Кодировка.UTF_16LE 
                Кодировка.UTF_32 
                Кодировка.UTF_32BE
                Кодировка.UTF_32LE 

        Их можно разбить на неявные и явные кодировки:

                Кодировка.Неизвестно 
                Кодировка.UTF_8
                Кодировка.UTF_16
                Кодировка.UTF_32 


                Кодировка.UTF_8N
                Кодировка.UTF_16BE
                Кодировка.UTF_16LE 
                Кодировка.UTF_32BE
                Кодировка.UTF_32LE 
        
        Первая группа неявных кодировок может быть использована для 'открытия'
        неизвестной кодировки, путём исследованияe первых нескольких байтов контента
        на наличие сигнатуры. Эта сигнатура необязательна, но часто записывается так, 
        что контент становится самоописательным.Когда кодировка неизвестна, используя 
        одну из неявных кодировок можно заставить метод раскодируй() найти 
        сигнатуру и соответственно исправиться. Есть возможность перепутать 
        символ ZWNBSP с сигнатурой; современный контент Юникода 
        должен использовать вмето этого символ WORD-JOINER.
       
        Группа явных кодировок используется, когда кодировка контента известна.
        Она *должна* использоваться при конвертировании вр внешнюю кодировку, 
        поскольку записываемый контент уже в известном формате. Отметим, что 
        при операции раскодируй() присутствие сигнатуры конфликтует с 
        явными вариациями.


        Смотрите 
        $(LINK http://www.utf-8.com/)
        $(LINK http://www.hackcraft.net/xmlUnicode/)
        $(LINK http://www.unicode.org/faq/utf_bom.html/)
        $(LINK http://www.azillionmonkeys.com/qed/unicode.html/)
        $(LINK http://icu.sourceforge.net/docs/papers/forms_of_unicode/)

*******************************************************************************/

class ЮникодМПБ(T) : ТестерМПБ
{
        static if (!is (T == сим) && !is (T == шим) && !is (T == дим)) 
                    pragma (msg, "Типом шаблона должен быть сим, шим или дим");

        /***********************************************************************
        
                Конструирует экземпляр, применяя указанную внешнюю кодировку -
				один из типов Кодировка.xx. 

        ***********************************************************************/
                                  
        this (Кодировка кодировка)
        {
                установи (кодировка);
        }
        
        /***********************************************************************

                Преобразует предоставленный контент. Этот контент исследуется
				на наличие сигнатуры МПБ, которая очищается. Когда, согласно
				типу кодировки, сигнатура отсутствует, а она есть - 
				выводится исключение. Точно также исключение выводится,
				когда известной сигнатуры нет, а в текущей кодировке она
				должна быть.

                Если 'взято' предоставлено, оно устанавливается в число 
                элементов, потреблённое из ввода, и декодер оперирует 
                в поточном режиме. То есть: 'приёмн' должен предотставляться,
				так как его размер не меняется и  он не размещается явно.

        ***********************************************************************/

        final T[] раскодируй (проц[] контент, T[] приёмн=пусто, бцел* взято=пусто)
        {
                // поиск мпб
                auto инфо = тест (контент);

                // Ожидаем мпб?
                if (отыщи[кодировка].тест)
                    if (инфо)
                       {
                       // да, есть
                       установи (инфо.кодировка, да);

                       // откинем мпб из контента
                       контент = контент [инфо.мпб.length .. length];
                       }
                    else
                       // может ли это кодировка быть по умолчанию?
                       if (настройки.откат)
                           установи (настройки.откат, нет);
                       else
                          onUnicodeError ("ЮникодМПБ.раскодируй :: неизвестно или отсутствует мпб");
                else
                   if (инфо)
                       // найдена мпб при использовании явной кодировки
                       onUnicodeError ("ЮникодМПБ.раскодируй :: явно кодировка не допускает мпб");   
                
                // преобразуем её во внутреннее представление
                auto возвр = преобр_в (обменяйБайты(контент), настройки.тип, приёмн, взято);
                if (взято && инфо)
                    *взято += инфо.мпб.length;
                return возвр;
        }

        /***********************************************************************

            Выполняет кодирование контента. Заметьте, что кодировка должна быть 
            на время её получения здесь нами в явной разновидности.

        ***********************************************************************/

        final проц[] кодируй (T[] контент, проц[] приёмн=пусто)
        {
                if (настройки.тест)
                    onUnicodeError ("ЮникодМПБ.кодируй :: не удаётся запись в неспецифичной кодировке");

                // преобразуем её во внешнее представление, и запишим
		return обменяйБайты (из_ (контент, настройки.тип, приёмн));
        }

        /***********************************************************************

            Меняем местами байты (переворачивает их), как требуется кодировкой.

        ***********************************************************************/

        private final проц[] обменяйБайты (проц[] контент)
        {
                бул эндиан = настройки.эндиан;
                бул обменяй   = настройки.бигЭндиан;

                version (БигЭндиан)
                         обменяй = !обменяй;

                if (эндиан && обменяй)
                   {
                   if (настройки.тип == Утф16)
                       ПерестановкаБайт.своп16 (контент.ptr, контент.length);
                   else
                       ПерестановкаБайт.своп32 (контент.ptr, контент.length);
                   }
                return контент;
        }
        
        /***********************************************************************
      
                Преобразует из 'тип' в указанный T.

                Когда 'взято' предоставлен, оно устанавливается в число 
                элементов, потреблённых из ввода и декодер оперирует 
                в поточном режиме.  То есть: 'приёмн' должен предотставляться,
				так как его размер не меняется и  он не размещается явно.

        ***********************************************************************/

        static T[] преобр_в (проц[] x, бцел тип, T[] приёмн=пусто, бцел* взято = пусто)
        {
                T[] возвр;
                
                static if (is (T == сим))
                          {
                          if (тип == Утф8)
                             {
                             if (взято)
                                 *взято = x.length;
                             возвр = cast(ткст) x;
                             }
                          else
                          if (тип == Утф16)
                              возвр = Utf.вТкст (cast(шим[]) x, приёмн, взято);
                          else
                          if (тип == Утф32)
                              возвр = Utf.вТкст (cast(дим[]) x, приёмн, взято);
                          }

                static if (is (T == шим))
                          {
                          if (тип == Утф16)
                             {
                             if (взято)
                                 *взято = x.length;
                             возвр = cast(шим[]) x;
                             }
                          else
                          if (тип == Утф8)
                              возвр = Utf.вТкст16 (cast(ткст) x, приёмн, взято);
                          else
                          if (тип == Утф32)
                              возвр = Utf.вТкст16 (cast(дим[]) x, приёмн, взято);
                          }

                static if (is (T == дим))
                          {
                          if (тип == Утф32)
                             {
                             if (взято)
                                 *взято = x.length;
                             возвр = cast(дим[]) x;
                             }
                          else
                          if (тип == Утф8)
                              возвр = Utf.вТкст32 (cast(ткст) x, приёмн, взято);
                          else
                          if (тип == Утф16)
                              возвр = Utf.вТкст32 (cast(шим[]) x, приёмн, взято);
                          }
                return возвр;
        }


        /***********************************************************************
      
                Преобразует из T в указанный 'тип'.

                Когда 'взято' предоставлен, оно устанавливается в число 
                элементов, потреблённых из ввода и декодер оперирует 
                в поточном режиме.  То есть: 'приёмн' должен предотставляться,
				так как его размер не меняется и  он не размещается явно.

        ***********************************************************************/

        static проц[] из_ (T[] x, бцел тип, проц[] приёмн=пусто, бцел* взято=пусто)
        {
                проц[] возвр;

                static if (is (T == сим))
                          {
                          if (тип == Утф8)
                             {
                             if (взято)
                                 *взято = x.length;
                             возвр = x;
                             }
                          else
                          if (тип == Утф16)
                              возвр = Utf.вТкст16 (x, cast(шим[]) приёмн, взято);
                          else
                          if (тип == Утф32)
                              возвр = Utf.вТкст32 (x, cast(дим[]) приёмн, взято);
                          }

                static if (is (T == шим))
                          {
                          if (тип == Утф16)
                             {
                             if (взято)
                                 *взято = x.length;
                             возвр = x;
                             }
                          else
                          if (тип == Утф8)
                              возвр = Utf.вТкст (x, cast(ткст) приёмн, взято);
                          else
                          if (тип == Утф32)
                              возвр = Utf.вТкст32 (x, cast(дим[]) приёмн, взято);
                          }

                static if (is (T == дим))
                          {
                          if (тип == Утф32)
                             {
                             if (взято)
                                 *взято = x.length;
                             возвр = x;
                             }
                          else
                          if (тип == Утф8)
                              возвр = Utf.вТкст (x, cast(ткст) приёмн, взято);
                          else
                          if (тип == Утф16)
                              возвр = Utf.вТкст16 (x, cast(шим[]) приёмн, взято);
                          }

                return возвр;
        }
}



/*******************************************************************************

        Обработка префиксов меток порядка байтов (МПБ).  

*******************************************************************************/

class ТестерМПБ 
{
        private бул     найдено;        // обнаружена ли кодировка?
        private Кодировка кодер;      // текущая кодировка 
        private Инфо*    настройки;     // указатель на конфигурацию кодировки

        private struct  Инфо
                {
                цел      тип;          // тип элемента (сим/шим/дим)
                Кодировка кодировка;      // кодировка Кодировка.xx
                ткст   мпб;           // образец, сравниваемый на сигнатуру
                бул     тест,          // нужно ли тестировать эту кодировку?
                         эндиан,        // у этой кодировки есть эндиан?
                         бигЭндиан;     // это кодировка биг-эндиан?
                Кодировка откат;      // может быть эта кодировка по умолчанию?
                };

        private enum {Утф8, Утф16, Утф32};
        
        private const Инфо[] отыщи =
        [
        {Утф8,  Кодировка.Неизвестно,  пусто,        да,  нет, нет, Кодировка.UTF_8},
        {Утф8,  Кодировка.UTF_8N,   пусто,        да,  нет, нет, Кодировка.UTF_8},
        {Утф8,  Кодировка.UTF_8,    x"efbbbf",   нет},
        {Утф16, Кодировка.UTF_16,   пусто,        да,  нет, нет, Кодировка.UTF_16BE},
        {Утф16, Кодировка.UTF_16BE, x"feff",     нет, да, да},
        {Утф16, Кодировка.UTF_16LE, x"fffe",     нет, да},
        {Утф32, Кодировка.UTF_32,   пусто,        да,  нет, нет, Кодировка.UTF_32BE},
        {Утф32, Кодировка.UTF_32BE, x"0000feff", нет, да, да},
        {Утф32, Кодировка.UTF_32LE, x"fffe0000", нет, да},
        ];

        /***********************************************************************
		
                Возвращает текущую кодировку. Это либо изначально заданная
                кодировка, либо производная, полученная при исследовании
                контента на мпб. Последнее выполняется как часть метода 
                раскодируй().
				
        ***********************************************************************/

        final Кодировка кодировка ()
        {
                return кодер;
        }
        
        /***********************************************************************

                Найдена ли в тексте кодировка (конфигурируется через установи).

        ***********************************************************************/

        final бул кодирован ()
        {
                return найдено;
        }

        /***********************************************************************

                Возвращает сигнатуру (мпб) текущей кодировки.

        ***********************************************************************/

        final проц[] сигнатура ()
        {
                return настройки.мпб;
        }

        /***********************************************************************

                Конфигурирует данный экземпляр с помощью конвертеров юникод.

        ***********************************************************************/

        final проц установи (Кодировка кодировка, бул найдено = нет)
        {
                this.настройки = &отыщи[кодировка];
                this.кодер = кодировка;
                this.найдено = найдено;
        }
        
        /***********************************************************************

                Сканирует сигнатуры мпб, в поисках сверяемого. Сканируется в 
                обратном порядке, чтобы самый длинный свер был получен первым.

        ***********************************************************************/

        static final Инфо* тест (проц[] контент)
        {
                for (Инфо* инфо=отыщи.ptr+отыщи.length; --инфо >= отыщи.ptr;)
                     if (инфо.мпб)
                        {
                        цел длин = инфо.мпб.length;
                        if (длин <= контент.length)
                            if (контент[0..длин] == инфо.мпб[0..длин])
                                return инфо;
                        }
                return пусто;
        }
}

/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        unittest
        {
                проц[] INPUT2 = "abc\xE3\x81\x82\xE3\x81\x84\xE3\x81\x86";
                проц[] INPUT = x"efbbbf" ~ INPUT2;
                auto мпб = new ЮникодМПБ!(сим)(Кодировка.Неизвестно);
                бцел взято;
                сим[256] буф;
                
                auto temp = мпб.раскодируй (INPUT, буф, &взято);
                assert (взято == INPUT.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
                
                temp = мпб.раскодируй (INPUT2, буф, &взято);
                assert (взято == INPUT2.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
        }
}

debug (ЮникодМПБ)
{
        import io.Stdout;

        проц main()
        {
                проц[] INPUT2 = "abc\xE3\x81\x82\xE3\x81\x84\xE3\x81\x86";
                проц[] INPUT = x"efbbbf" ~ INPUT2;
                auto мпб = new ЮникодМПБ!(сим)(Кодировка.Неизвестно);
                бцел взято;
                сим[256] буф;
                
                auto temp = мпб.раскодируй (INPUT, буф, &взято);
                assert (temp == INPUT2);
                assert (взято == INPUT.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
                
                temp = мпб.раскодируй (INPUT2, буф, &взято);
                assert (temp == INPUT2);
                assert (взято == INPUT2.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
        }
}