﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)
       
        version:        Initial release: April 2004      
        
        author:         Kris

*******************************************************************************/

module net.http.HttpTokens;

private import  time.Time;

private import  io.device.Array;

private import  io.stream.Buffered;

private import  net.http.HttpStack,
                net.http.HttpConst;

private import  Текст = text.Util;

private import  Целое = text.convert.Integer;

private import  TimeStamp = text.convert.TimeStamp;

/******************************************************************************

        Struct использован в_ expose freachable ТокенППГТ экземпляры.

******************************************************************************/

struct ТокенППГТ
{
        ткст  имя,
                значение;
}

/******************************************************************************

        Maintains a установи of HTTP токены. These токены include заголовки, запрос-
        параметры, и anything else vaguely related. Всё ввод и вывод
        are supported, though a subclass may choose в_ expose as читай-only.

        все токены are mapped directly onto a буфер, so there is no память
        allocation or copying involved. 

        Note that this class does not support deleting токены, per se. Instead
        it marks токены as being 'неиспользовано' by настройка контент в_ пусто, avoопрing 
        unwarranted reshaping of the токен стэк. The токен стэк is reused as
        время goes on, so there's only minor рантайм overhead.

******************************************************************************/

class ТокеныППГТ
{
        protected СтэкППГТ     стэк;
        private io.device.Array.Массив           ввод;
        private io.device.Array.Массив           вывод;
        private бул            разобрано;
        private бул            включительно;
        private сим            разделитель;
        private сим[1]         строкаРаздел;

        /**********************************************************************
                
                Construct a установи of токены based upon the given delimiter, 
                и an indication of whether saопр delimiter should be
                consопрered часть of the лево sопрe (effectively the имя).
        
                The latter is useful with заголовки, since the seperating
                ':' character should really be consопрered часть of the 
                имя for purposes of subsequent токен совпадают.

        **********************************************************************/

        this (сим разделитель, бул включительно = нет)
        {
                стэк = new СтэкППГТ;

                this.включительно = включительно;
                this.разделитель = разделитель;
                
                // преобразуй разделитель преобр_в a ткст, for later use
                строкаРаздел[0] = разделитель;

                // pre-construct an пустой буфер for wrapping ткст parsing
                ввод = new io.device.Array.Массив (0);

                // construct an Массив for containing стэк токены
                вывод = new io.device.Array.Массив (4096, 1024);
        }

        /**********************************************************************
                
                Clone a исток установи of ТокеныППГТ

        **********************************************************************/

        this (ТокеныППГТ исток)
        {
                стэк = исток.стэк.клонируй;
                ввод = пусто;
                вывод = исток.вывод;
                разобрано = да;
                включительно = исток.включительно;
                разделитель = исток.разделитель;
                строкаРаздел[0] = исток.строкаРаздел[0];
        }

        /**********************************************************************
                
                Чит все токены. Everything is mapped rather than being 
                allocated & copied

        **********************************************************************/

         abstract проц разбор (БуфВвод ввод);

        /**********************************************************************
                
                Parse an ввод ткст.

        **********************************************************************/

        проц разбор (ткст контент)
        {
                ввод.присвой (контент);
                разбор (cast(БуфВвод) ввод);       
        }

        /**********************************************************************
                
                Reset this установи of токены.

        **********************************************************************/

        ТокеныППГТ сбрось ()
        {
                стэк.сбрось;
                разобрано = нет;

                // сбрось вывод буфер
                вывод.очисть;
                return this;
        }

        /**********************************************************************
                
                Have токены been разобрано yet?

        **********************************************************************/

        бул разобран_ли ()
        {
                return разобрано;
        }

        /**********************************************************************
                
                Indicate whether токены have been разобрано or not.

        **********************************************************************/

        проц установиРазобран (бул разобрано)
        {
                this.разобрано = разобрано;
        }

        /**********************************************************************
                
                Return the значение of the предоставленный заголовок, or пусто if the
                заголовок does not exist

        **********************************************************************/

        ткст получи (ткст имя, ткст возвр = пусто)
        {
                Токен токен = стэк.найдиТокен (имя);
                if (токен)
                   {
                   ТокенППГТ элемент;

                   if (разбей (токен, элемент))
                       возвр = убери (элемент.значение);
                   }
                return возвр;
        }

        /**********************************************************************
                
                Return the целое значение of the предоставленный заголовок, or the 
                предоставленный default-vaule if the заголовок does not exist

        **********************************************************************/

        цел получиЦел (ткст имя, цел возвр = -1)
        {       
                ткст значение = получи (имя);

                if (значение.length)
                    возвр = cast(цел) Целое.разбор (значение);

                return возвр;
        }

        /**********************************************************************
                
                Return the дата значение of the предоставленный заголовок, or the 
                предоставленный default-значение if the заголовок does not exist

        **********************************************************************/

        Время дайДату (ткст имя, Время дата = Время.эпоха)
        {
                ткст значение = получи (имя);

                if (значение.length)
                    дата = TimeStamp.разбор (значение);

                return дата;
        }

        /**********************************************************************

                Iterate over the установи of токены

        **********************************************************************/

        цел opApply (цел delegate(ref ТокенППГТ) дг)
        {
                ТокенППГТ элемент;
                цел       результат = 0;

                foreach (Токен t; стэк)
                         if (разбей (t, элемент))
                            {
                            результат = дг (элемент);
                            if (результат)
                                break;
                            }
                return результат;
        }

        /**********************************************************************

                Вывод the токен список в_ the предоставленный consumer

        **********************************************************************/

        проц произведи (т_мера delegate(проц[]) используй, ткст кс = пусто)
        {
                foreach (Токен токен; стэк)
                        {
                        auto контент = токен.вТкст;
                        if (контент.length)
                           {
                           используй (контент);
                           if (кс.length)
                               используй (кс);
                           }
                        }                           
        }

        /**********************************************************************

                overrопрable метод в_ укз the case where a токен does
                not have a разделитель. Apparently, this can happen in HTTP 
                usage

        **********************************************************************/

        protected бул обработайНедостающийРазделитель (ткст s, ref ТокенППГТ элемент)
        {
                return нет;
        }

        /**********************************************************************

                разбей basic токен преобр_в an ТокенППГТ

        **********************************************************************/

        final private бул разбей (Токен t, ref ТокенППГТ элемент)
        {
                auto s = t.вТкст();

                if (s.length)
                   {
                   auto i = Текст.местоположение (s, разделитель);

                   // we should always найди the разделитель
                   if (i < s.length)
                      {
                      auto j = (включительно) ? i+1 : i;
                      элемент.имя = s[0 .. j];
                      элемент.значение = (++i < s.length) ? s[i .. $] : пусто;
                      return да;
                      }
                   else
                      // allow override в_ specialize this case
                      return обработайНедостающийРазделитель (s, элемент);
                   }
                return нет;                           
        }

        /**********************************************************************

                Созд a фильтр for iterating over the токены совпадают
                a particular имя. 
        
        **********************************************************************/

        ФильтрованныеТокены создайФильтр (ткст сверь)
        {
                return new ФильтрованныеТокены (this, сверь);
        }

        /**********************************************************************

                Implements a фильтр for iterating over токены совпадают
                a particular имя. We do it like this because there's no 
                means of passing добавьitional information в_ an opApply() 
                метод.
        
        **********************************************************************/

        private static class ФильтрованныеТокены 
        {       
                private ткст          сверь;
                private ТокеныППГТ      токены;

                /**************************************************************

                        Construct this фильтр upon the given токены, и
                        установи the образец в_ сверь against.

                **************************************************************/

                this (ТокеныППГТ токены, ткст сверь)
                {
                        this.сверь = сверь;
                        this.токены = токены;
                }

                /**************************************************************

                        Iterate over все токены совпадают the given имя

                **************************************************************/

                цел opApply (цел delegate(ref ТокенППГТ) дг)
                {
                        ТокенППГТ       элемент;
                        цел             результат = 0;
                        
                        foreach (Токен токен; токены.стэк)
                                 if (токены.стэк.совпадает (токен, сверь))
                                     if (токены.разбей (токен, элемент))
                                        {
                                        результат = дг (элемент);
                                        if (результат)
                                            break;
                                        }
                        return результат;
                }

        }

        /**********************************************************************

                Is the аргумент a пробел character?

        **********************************************************************/

        private бул пбел_ли (сим c)
        {
                return cast(бул) (c is ' ' || c is '\t' || c is '\r' || c is '\n');
        }

        /**********************************************************************

                Trim the предоставленный ткст by strИПping пробел из_ 
                Всё заканчивается. Возвращает срез of the original контент.

        **********************************************************************/

        private ткст убери (ткст исток)
        {
                цел  front,
                     задний = исток.length;

                if (задний)
                   {
                   while (front < задний && пбел_ли(исток[front]))
                          ++front;

                   while (задний > front && пбел_ли(исток[задний-1]))
                          --задний;
                   } 
                return исток [front .. задний];
        }


        /**********************************************************************
        ****************** these should be exposed carefully ******************
        **********************************************************************/


        /**********************************************************************
                
                Return a ткст representing the вывод. An пустой Массив
                is returned if вывод was not configured. This perhaps
                could just return our 'вывод' буфер контент, but that
                would not reflect deletes, or seperators. Better в_ do 
                it like this instead, for a small cost.

        **********************************************************************/

        ткст форматируйТокены (БуфВывод приёмн, ткст разделитель)
        {
                бул первый = да;

                foreach (Токен токен; стэк)
                        {
                        ткст контент = токен.вТкст;
                        if (контент.length)
                           {
                           if (первый)
                               первый = нет;
                           else
                              приёмн.пиши (разделитель);
                           приёмн.пиши (контент);
                           }
                        }    
                return cast(ткст) приёмн.срез;
        }

        /**********************************************************************
                
                Добавь a токен with the given имя. The контент is предоставленный
                via the specified delegate. We stuff this имя & контент
                преобр_в the вывод буфер, и карта a new Токен onto the
                appropriate буфер срез.

        **********************************************************************/

        protected проц добавь (ткст имя, проц delegate(БуфВывод) значение)
        {
                // save the буфер пиши-позиция
                //цел приор = вывод.предел;
                auto приор = вывод.срез.length;

                // добавь the имя
                вывод.добавь (имя);

                // don't добавь разделитель if it's already часть of the имя
                if (! включительно)
                      вывод.добавь (строкаРаздел);
                
                // добавь the значение
                значение (cast(БуфВывод) вывод);

                // карта new токен onto буфер срез
                стэк.сунь (cast(ткст) вывод.срез [приор .. $]);
        }

        /**********************************************************************
                
                Добавь a simple имя/значение пара в_ the вывод

        **********************************************************************/

        protected проц добавь (ткст имя, ткст значение)
        {
                проц добавьЗначение (БуфВывод буфер)
                {
                        буфер.пиши (значение);
                }

                добавь (имя, &добавьЗначение);
        }

        /**********************************************************************
                
                Добавь a имя/целое пара в_ the вывод

        **********************************************************************/

        protected проц добавьЦел (ткст имя, цел значение)
        {
                сим[16] врем =void;

                добавь (имя, Целое.форматируй (врем, cast(дол) значение));
        }

        /**********************************************************************
               
               Добавь a имя/дата(дол) пара в_ the вывод
                
        **********************************************************************/

        protected проц добавьДату (ткст имя, Время значение)
        {
                сим[40] врем =void;

                добавь (имя, TimeStamp.форматируй (врем, значение));
        }

        /**********************************************************************
               
               удали a токен из_ our список. Возвращает нет if the named
               токен is не найден.
                
        **********************************************************************/

        protected бул удали (ткст имя)
        {
                return стэк.удалиТокен (имя);
        }
}
