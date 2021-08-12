﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: April 2004      
                        Outback release: December 2006
        
        author:         Kris    - original module
        author:         h3r3tic - fixed a число of Post issues и
                                  bugs in the 'парамы' construction

        Redirection handling guопрed via 
                    http://ppewww.ph.gla.ac.uk/~flavell/www/post-перенаправ.html

*******************************************************************************/

module net.http.HttpClient;

private import  time.Time;
                
private import  net.Uri,
                net.device.Socket,
                net.InternetAddress;

private import  io.device.Array;

private import  io.stream.Lines;
private import  io.stream.Buffered;

private import  net.http.HttpConst,
                net.http.HttpParams,  
                net.http.HttpHeaders,
                net.http.HttpTriplet,
                net.http.HttpCookies;

private import  exception : ВВИскл;

private import  Целое = text.convert.Integer;

/*******************************************************************************

        Supports the basic needs of a клиент making requests of an HTTP
        сервер. The following is an example of как this might be использован:

        ---
        // обрвызов for клиент читатель
        проц сток (проц[] контент)
        {
                Стдвыв (cast(ткст) контент);
        }

        // создай клиент for a GET request
        auto клиент = new КлиентППГТ (КлиентППГТ.Get, "http://www.yahoo.com");

        // сделай request
        клиент.открой;

        // проверь return статус for validity
        if (клиент.ответОК_ли)
           {
           // выкинь контент length
           auto length = клиент.дайЗаголовкиОтвета.получиЦел (ЗаголовокППГТ.ДлинаКонтента);
        
           // display все returned заголовки
           Стдвыв (клиент.дайЗаголовкиОтвета);
        
           // display остаток контент
           клиент.читай (&сток, length);
           }
        else
           Стдош (клиент.дайОтвет);

        клиент.закрой;
        ---

        See modules ГетППГТ и ПостППГТ for simple wrappers instead.

*******************************************************************************/

class КлиентППГТ
{       
        /// обрвызов for Отправкаing PUT контент
        alias проц delegate (БуфВывод) Помпа;
        
        // this is struct rather than typedef в_ avoопр compiler bugs
        struct МетодЗапроса
        {
                final ткст            имя;
        }    
                        
        // http version опр
        public enum Версия {ОдинТчкНоль, ОдинТчкОдин};

        // стандарт установи of request methods ...
        static const МетодЗапроса      Взять = {"GET"},
                                        Поместить = {"PUT"},
                                        Заг = {"HEAD"},
                                        Пост = {"POST"},
                                        След = {"TRACE"},
                                        Удалить = {"DELETE"},
                                        Опции = {"OPTIONS"},
                                        Соединить = {"CONNECT"};

        /***********************************************************************
        
                Созд a клиент for the given URL. The аргумент should be
                fully qualified with an "http:" or "https:" scheme, or an
                явный порт should be provопрed.

        ***********************************************************************/

        this (МетодЗапроса метод, ткст url);

        /***********************************************************************
        
                Созд a клиент with the provопрed Уир экземпляр. The Уир should 
                be fully qualified with an "http:" or "https:" scheme, or an
                явный порт should be provопрed. 

        ***********************************************************************/

        this (МетодЗапроса метод, Уир уир);

        /***********************************************************************
        
                Get the текущ ввод заголовки, as returned by the хост request.

        ***********************************************************************/

        ОбзорЗаголовковППГТ дайЗаголовкиОтвета();

        /***********************************************************************
        
                Gain доступ в_ the request заголовки. Use this в_ добавь whatever
                заголовки are требуется for a request. 

        ***********************************************************************/

        ЗаголовкиППГТ дайЗаголовкиЗапроса();

        /***********************************************************************
        
                Gain доступ в_ the request параметры. Use this в_ добавь x=y
                стиль параметры в_ the request. These will be appended в_
                the request assuming the original Уир does not contain any
                of its own.

        ***********************************************************************/

        ПараметрыППГТ дайПараметрыЗапроса();

        /***********************************************************************
        
                Return the Уир associated with this клиент

        ***********************************************************************/

        ОбзорУИР дайУир();

        /***********************************************************************
        
                Return the ответ-строка for the latest request. This takes 
                the form of "version статус резон" as defined in the HTTP
                RFC.

        ***********************************************************************/

        СтрокаОтвета дайОтвет();

        /***********************************************************************
        
                Return the HTTP статус код установи by the remote сервер

        ***********************************************************************/

        цел дайСтатус();

        /***********************************************************************
        
                Return whether the ответ was ОК or not

        ***********************************************************************/

        бул ответОК_ли();

        /***********************************************************************
        
                Добавь a куки в_ the outgoing заголовки

        ***********************************************************************/

        КлиентППГТ добавьКуки (Куки куки);

        /***********************************************************************
        
                Close все resources использован by a request. You must invoke this 
                between successive открой() calls.

        ***********************************************************************/

        проц закрой ();

        /***********************************************************************

                Reset the клиент such that it is ready for a new request.
        
        ***********************************************************************/

        КлиентППГТ сбрось ();

        /***********************************************************************
        
                Набор the request метод

        ***********************************************************************/

        КлиентППГТ установиЗапрос (МетодЗапроса метод);

        /***********************************************************************
        
                Набор the request version

        ***********************************************************************/

        КлиентППГТ установиВерсию (Версия v);

        /***********************************************************************

                активируй/disable the internal redirection suppport
        
        ***********************************************************************/

        КлиентППГТ активируйПеренаправление (бул да = да);

        /***********************************************************************

                установи таймаут период for читай operation
        
        ***********************************************************************/

        КлиентППГТ установиТаймаут (плав интервал);

        /***********************************************************************

                Control бытьНаСвязи опция 

        ***********************************************************************/

        КлиентППГТ будьНаСвязи (бул да = да);

        /***********************************************************************

                Control Уир вывод кодировка 

        ***********************************************************************/

        КлиентППГТ кодируйУри (бул да = да);

        /***********************************************************************
        
                Make a request for the resource specified via the constructor,
                using the specified таймаут период (in milli-сек).The 
                return значение represents the ввод буфер, из_ which все
                returned заголовки и контент may be использовался.
                
        ***********************************************************************/

        БуфВвод открой ();

        /***********************************************************************
        
                Make a request for the resource specified via the constructor,
                using a обрвызов for pumping добавьitional данные в_ the хост. This 
                дефолты в_ a three-секунда таймаут период. The return значение 
                represents the ввод буфер, из_ which все returned заголовки 
                и контент may be использовался.
                
        ***********************************************************************/

        БуфВвод открой (Помпа помпа);
        /***********************************************************************
        
                Make a request for the resource specified via the constructor
                using the specified таймаут период (in micro-сек), и a
                пользователь-defined обрвызов for pumping добавьitional данные в_ the хост.
                The обрвызов would be использован when uploading данные during a 'помести'
                operation (or equivalent). The return значение represents the 
                ввод буфер, из_ which все returned заголовки и контент may 
                be использовался.

                Note that certain request-заголовки may generated automatically
                if they are not present. These include a Хост заголовок и, in
                the case of Post, Всё ТипКонтента & ДлинаКонтента for a запрос
                тип of request. The latter two are *not* produced for Post
                requests with 'помпа' specified ~ when using 'помпа' в_ вывод
                добавьitional контент, you must explicitly установи your own заголовки.

                Note also that ВВИскл экземпляры may be thrown. These 
                should be caught by the клиент в_ ensure a закрой() operation
                is always performed
                
        ***********************************************************************/

        БуфВвод открой (МетодЗапроса метод, Помпа помпа);

        /***********************************************************************
        
                Чит the контент из_ the returning ввод поток, up в_ a
                maximum length, и пароль контент в_ the given сток delegate
                as it arrives. 

                Exits when length байты have been processed, or an Кф is
                seen on the поток.

        ***********************************************************************/

        проц читай (проц delegate(проц[]) сток, т_мера длин = т_мера.max);

        /***********************************************************************
        
                Дескр redirection of Post
                
                Guопрance for the default behaviour came из_ this страница: 
                http://ppewww.ph.gla.ac.uk/~flavell/www/post-перенаправ.html

        ***********************************************************************/

        БуфВвод перенаправьПост (Помпа помпа, цел статус);

        /***********************************************************************
        
                Дескр пользователь-notification of Post redirection. This should
                be overrопрden appropriately.

                Guопрance for the default behaviour came из_ this страница: 
                http://ppewww.ph.gla.ac.uk/~flavell/www/post-перенаправ.html

        ***********************************************************************/

        бул можноРепостировать (бцел статус);

        /***********************************************************************
        
                Overrопрable сокет factory, for use with HTTPS и so on

        ***********************************************************************/

        protected Сокет создайСокет ();

        /**********************************************************************

                throw an исключение, after closing the сокет

        **********************************************************************/

        private проц ошибка (ткст сооб);
}


/******************************************************************************

        Class в_ represent an HTTP ответ-строка

******************************************************************************/

private class СтрокаОтвета : ТриплетППГТ
{
        private ткст          vers,
                                резон;
        private цел             статус;

        /**********************************************************************

                тест the validity of these токены

        **********************************************************************/

        override бул тест ();

        /**********************************************************************

                Return HTTP version

        **********************************************************************/

        ткст дайВерсию ();

        /**********************************************************************

                Return резон текст

        **********************************************************************/

        ткст дайРезон ();

        /**********************************************************************

                Return статус целое

        **********************************************************************/

        цел дайСтатус ();
}


/******************************************************************************

******************************************************************************/

debug (КлиентППГТ)
{
        import io.Stdout;

        проц main()
        {
        // обрвызов for клиент читатель
        проц сток (проц[] контент)
        {
                Стдвыв (cast(ткст) контент);
        }

        // создай клиент for a GET request
        auto клиент = new КлиентППГТ (КлиентППГТ.Get, "http://www.microsoft.com");

        // сделай request
        клиент.открой;

        // проверь return статус for validity
        if (клиент.ответОК_ли)
           {
           // display все returned заголовки
           foreach (заголовок; клиент.дайЗаголовкиОтвета)
                    Стдвыв.форматнс ("{} {}", заголовок.имя.значение, заголовок.значение);
        
           // выкинь контент length
           auto length = клиент.дайЗаголовкиОтвета.получиЦел (ЗаголовокППГТ.ДлинаКонтента);
        
           // display остаток контент
           клиент.читай (&сток, length);
           }
        else
           Стдош (клиент.дайОтвет);

        клиент.закрой;
        }
}
