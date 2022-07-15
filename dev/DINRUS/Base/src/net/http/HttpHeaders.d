﻿module net.http.HttpHeaders;

private import  time.Time;

private import  io.stream.Lines;

private import  io.stream.Buffered;

public  import  net.http.HttpConst;

private import  net.http.HttpTokens;

/******************************************************************************

        Exposes freachable ЗаголовокППГТ экземпляры 

******************************************************************************/

struct ЭлементЗаголовка
{
        ИмяЗаголовкаППГТ  имя;
        ткст          значение;
}

/******************************************************************************

        Maintains набор of ввод заголовки. These are placed преобр_в an ввод
        буфер и indexed via a СтэкППГТ. 

******************************************************************************/

export class ОбзорЗаголовковППГТ : ТокеныППГТ
{

        private Строки!(сим) строка;
        private бул         preserve;

        /**********************************************************************
                
                Construct this установи of заголовки, using a СтэкППГТ based
                upon a ':' delimiter   
              
        **********************************************************************/

        export this ()
        {
                // разделитель is a ':', и specify we want it included as
                // часть of the имя whilst iterating
                super (':', да);
        
                // construct a строка tokenizer for later usage
                строка = new Строки!(сим);
        }

        /**********************************************************************
                
                Clone a исток установи of ЗаголовкиППГТ

        **********************************************************************/

        export this (ОбзорЗаголовковППГТ исток)
        {
                super (исток);
                this.preserve = исток.preserve;
        }

        /**********************************************************************
                
                Clone this установи of ОбзорЗаголовковППГТ

        **********************************************************************/

        export ОбзорЗаголовковППГТ клонируй ()
        {
                return new ОбзорЗаголовковППГТ (this);
        }

        /***********************************************************************

                Control whether заголовки are duplicated or not. Default 
                behaviour is aliasing instead of copying, avoопрing any
                allocatation overhead. However, the default won't preserve
                those заголовки once добавьitional контент имеется been читай.

                To retain заголовки across arbitrary buffering, you should 
                установи this опция да

        ***********************************************************************/

        export ОбзорЗаголовковППГТ retain (бул да = да)
        {
                preserve = да;
                return this;
        }

        /**********************************************************************
                
                Чит все заголовок строки. Everything is mapped rather 
                than being allocated & copied

        **********************************************************************/

        export override проц разбор (БуфВвод ввод)
        {
                установиРазобран (да);
                строка.установи (ввод);

                while (строка.следщ && строка.получи.length)
                       стэк.сунь (preserve ? строка.получи.dup : строка.получи);
        }

        /**********************************************************************
                
                Возвращает значение of the предоставленный заголовок, либо пусто if the
                заголовок does not есть_ли

        **********************************************************************/

        export ткст получи (ИмяЗаголовкаППГТ имя, ткст def = пусто)
        {
                return super.получи (имя.значение, def);
        }

        /**********************************************************************
                
                Возвращает целое значение of the предоставленный заголовок, либо -1 
                if the заголовок does not есть_ли

        **********************************************************************/

        export цел получиЦел (ИмяЗаголовкаППГТ имя, цел def = -1)
        {
                return super.получиЦел (имя.значение, def);
        }

        /**********************************************************************
                
                Возвращает дата значение of the предоставленный заголовок, либо Время.эпоха 
                if the заголовок does not есть_ли

        **********************************************************************/

        export Время дайДату (ИмяЗаголовкаППГТ имя, Время def = Время.эпоха)
        {
                return super.дайДату (имя.значение, def);
        }

        /**********************************************************************

                Iterate over the установи of заголовки. This is a shell around
                the superclass, where we can преобразуй the ТокенППГТ преобр_в 
                a ЭлементЗаголовка instead.

        **********************************************************************/

        export цел opApply (цел delegate(ref ЭлементЗаголовка) дг)
        {
                ЭлементЗаголовка   элемент;
                цел             результат = 0;

                foreach (ТокенППГТ токен; super)
                        {
                        элемент.имя.значение = токен.имя;
                        элемент.значение = токен.значение;
                        результат = дг (элемент);
                        if (результат)
                            break;
                        }
                return результат;
        }

        /**********************************************************************

                Создаёт фильтр for iterating of набор of named заголовки.
                We have в_ создай a фильтр since we can't пароль добавьitional
                аргументы directly в_ an opApply() метод.

        **********************************************************************/

        export ФильтрованныеЗаголовки создайФильтр (ИмяЗаголовкаППГТ заголовок)
        {
                return new ФильтрованныеЗаголовки (this, заголовок);
        }

        /**********************************************************************

                Фильтр class for isolating набор of named заголовки.

        **********************************************************************/

        private static class ФильтрованныеЗаголовки : ФильтрованныеТокены
        {       
                /**************************************************************

                        Construct a фильтр upon the specified заголовки, for
                        the given заголовок имя.

                **************************************************************/

                this (ОбзорЗаголовковППГТ заголовки, ИмяЗаголовкаППГТ заголовок)
                {
                        super (заголовки, заголовок.значение);
                }

                /**************************************************************

                        Iterate over все заголовки совпадают the given имя. 
                        This wraps the ТокенППГТ обходчик в_ преобразуй the 
                        вывод преобр_в a ЭлементЗаголовка instead.

                **************************************************************/

                цел opApply (цел delegate(ref ЭлементЗаголовка) дг)
                {
                        ЭлементЗаголовка   элемент;
                        цел             результат = 0;
                        
                        foreach (ТокенППГТ токен; super)
                                {
                                элемент.имя.значение = токен.имя;
                                элемент.значение = токен.значение;
                                результат = дг (элемент);
                                if (результат)
                                    break;
                                }
                        return результат;
                }

        }
}


/******************************************************************************

        Maintains набор of вывод заголовки. These are held in an вывод
        буфер, и indexed via a СтэкППГТ. Deleting a заголовок could be 
        supported by настройка the СтэкППГТ Запись в_ пусто, и ignoring
        such значения when it's время в_ пиши the заголовки.

******************************************************************************/

export class ЗаголовкиППГТ : ОбзорЗаголовковППГТ
{
        /**********************************************************************
                
                Construct вывод заголовки

        **********************************************************************/

        export this ()
        {
        }

        /**********************************************************************
                
                Clone a исток установи of ЗаголовкиППГТ

        **********************************************************************/

        export this (ЗаголовкиППГТ исток)
        {
                super (исток);
        }

        /**********************************************************************
                
                Clone this установи of ЗаголовкиППГТ

        **********************************************************************/

        export ЗаголовкиППГТ клонируй ()
        {
                return new ЗаголовкиППГТ (this);
        }

        /**********************************************************************
                
                Добавь the specified заголовок, и use a обрвызов в_ предоставляет
                the контент.

        **********************************************************************/

        export проц добавь (ИмяЗаголовкаППГТ имя, проц delegate(БуфВывод) дг)
        {
                super.добавь (имя.значение, дг);
        }

        /**********************************************************************
                
                Добавь the specified заголовок и текст 

        **********************************************************************/

        export проц добавь (ИмяЗаголовкаППГТ имя, ткст значение)
        {
                super.добавь (имя.значение, значение);
        }

        /**********************************************************************
                
                Добавь the specified заголовок и целое значение

        **********************************************************************/

        export проц добавьЦел (ИмяЗаголовкаППГТ имя, цел значение)
        {
                super.добавьЦел (имя.значение, значение);
        }

        /**********************************************************************
                
                Добавь the specified заголовок и дол/дата значение

        **********************************************************************/

        export проц добавьДату (ИмяЗаголовкаППГТ имя, Время значение)
        {
                super.добавьДату (имя.значение, значение);
        }

        /**********************************************************************
                
                Удали the specified заголовок заголовок. Возвращает нет if not 
                найдено.

        **********************************************************************/

        export бул удали (ИмяЗаголовкаППГТ имя)
        {
                return super.удали (имя.значение);
        }
}