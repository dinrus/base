﻿
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

        Поддерживает основные нужды клиента, делающего запрос к HTTP
        серверу. Пример использования:

        ---
        // обрвызов для читателя клиента
        проц сток (проц[] контент)
        {
                Стдвыв (cast(ткст) контент);
        }

        // создать клиент для запроса GET
        auto клиент = new КлиентППГТ (КлиентППГТ.Get, "http://www.yahoo.com");

        // сделать запрос
        клиент.открой;

        // проверка статуса возврата на пригодность
        if (клиент.ответОК_ли)
           {
           // отнять длину контента
           auto length = клиент.дайЗаголовкиОтвета.получиЦел (ЗаголовокППГТ.ДлинаКонтента);

           // показать все возвращённые заголовки
           Стдвыв (клиент.дайЗаголовкиОтвета);

           // показать остальной контент
           клиент.читай (&сток, length);
           }
        else
           Стдош (клиент.дайОтвет);

        клиент.закрой;
        ---

        См. модули HttpGet и HttpPost, где находятся простые "обмотки".

*******************************************************************************/

class КлиентППГТ
{
        /// обрвызов для отправки PUT контента
        alias проц delegate (БуфВывод) Помпа;

        // это структура, а не typedef , чтобы не было ошибок компилятора
	struct МетодЗапроса
        {
                final ткст            имя;
        }

        // члены класса; их количество удивляет!
        private Уир                     уир;
        private Бввод           ввод;
        private Бвыв          вывод;
        private io.device.Array.Массив                   токены;
        private Строки!(сим)            строка;
        private Сокет                  сокет;
        private МетодЗапроса           метод;
        private АдресИнтернета         адрес;
        private ПараметрыППГТ              парамыВых;
        private ОбзорЗаголовковППГТ         загиНаВхо;
        private ЗаголовкиППГТ             загиНаВых;
        private КукикиППГТ             кукикиВых;
        private СтрокаОтвета            строкаОтвета;

        // по умолчанию 3-секундный таймаут на операции чтения ...
        private плав                   таймаут = 3.0;

        // активировать кодирование уир?
        private бул                    кодируй = да;

        // следует ли выполнять внутреннее перенаправление?
        private бул                    перенаправь = да;

        // пытаться бытьНаСвязи?
        private бул                    бытьНаСвязи = нет;

        // ограничить число перенаправлений, либо захват циркулярных перенаправлений
        private бцел                    перенаправления,
                                        лимитПеренаправлений = 5;

        // версия http отправляется с запросами
        private ткст                  версияППГТ;

        // идентификатор версии http
        public enum Версия {ОдинТчкНоль, ОдинТчкОдин};

        // стандартный набор методов запроса ...
        static const МетодЗапроса      Взять = {"GET"},
                                        Поместить = {"PUT"},
                                        Заг = {"HEAD"},
                                        Пост = {"POST"},
                                        След = {"TRACE"},
                                        Удалить = {"DELETE"},
                                        Опции = {"OPTIONS"},
                                        Соединить = {"CONNECT"};

        /***********************************************************************

                Создает клиент для указанного URL. Этот аргумент должен быть
                полностью задан по схеме "http:" или "https:", либо же
                явно указывается порт.

        ***********************************************************************/

        this (МетодЗапроса метод, ткст url)
        {
                this (метод, new Уир(url));
        }

        /***********************************************************************

                Создает клиент с указанным экземпляром Уир.
                Уир должен быть полностью задан по схеме
                "http:" или "https:", либо же явно указывается порт.

        ***********************************************************************/

        this (МетодЗапроса метод, Уир уир)
        {
                this.уир = уир;
                this.метод = метод;

                строкаОтвета = new СтрокаОтвета;
                загиНаВхо    = new ОбзорЗаголовковППГТ;
                токены       = new io.device.Array.Массив (1024 * 4);

                ввод        = new Бввод  (пусто, 1024 * 16);
                вывод       = new Бвыв (пусто, 1024 * 16);

                парамыВых    = new ПараметрыППГТ;
                загиНаВых   = new ЗаголовкиППГТ;
                кукикиВых   = new КукикиППГТ (загиНаВых, ЗаголовокППГТ.Куки);

                // раскодируй the хост имя (may возьми a секунда or two)
                auto хост = уир.дайХост;
                if (хост)
                    адрес = new АдресИнтернета (хост, уир.дайВалидныйПорт);
                else
                   ошибка ("УЛР, предоставленный конструктору КлиентППГТ, непригоден");

                // default the http version в_ 1.0
                установиВерсию (Версия.ОдинТчкНоль);
        }

        /***********************************************************************

                Get the текущ ввод заголовки, as returned by the хост request.

        ***********************************************************************/

        ОбзорЗаголовковППГТ дайЗаголовкиОтвета()
        {
                return загиНаВхо;
        }

        /***********************************************************************

                Gain доступ в_ the request заголовки. Use this в_ добавь whatever
                заголовки are требуется for a request.

        ***********************************************************************/

        ЗаголовкиППГТ дайЗаголовкиЗапроса()
        {
                return загиНаВых;
        }

        /***********************************************************************

                Gain доступ в_ the request параметры. Use this в_ добавь x=y
                стиль параметры в_ the request. These will be appended в_
                the request assuming the original Уир does not contain any
                of its own.

        ***********************************************************************/

        ПараметрыППГТ дайПараметрыЗапроса()
        {
                return парамыВых;
        }

        /***********************************************************************

                Return the Уир associated with this клиент

        ***********************************************************************/

        ОбзорУИР дайУир()
        {
                return уир;
        }

        /***********************************************************************

                Return the ответ-строка for the latest request. This takes
                the form of "version статус резон" as defined in the HTTP
                RFC.

        ***********************************************************************/

        СтрокаОтвета дайОтвет()
        {
                return строкаОтвета;
        }

        /***********************************************************************

                Return the HTTP статус код установи by the remote сервер

        ***********************************************************************/

        цел дайСтатус()
        {
                return строкаОтвета.дайСтатус;
        }

        /***********************************************************************

                Return whether the ответ was ОК or not

        ***********************************************************************/

        бул ответОК_ли()
        {
                return дайСтатус is КодОтветаППГТ.ОК;
        }

        /***********************************************************************

                Добавь a куки в_ the outgoing заголовки

        ***********************************************************************/

        КлиентППГТ добавьКуки (Куки куки)
        {
                кукикиВых.добавь (куки);
                return this;
        }

        /***********************************************************************

                Close все resources использован by a request. You must invoke this
                between successive открой() calls.

        ***********************************************************************/

        проц закрой ()
        {
                if (сокет)
                   {
                   сокет.глуши;
                   сокет.открепи;
                   сокет = пусто;
                   }
        }

        /***********************************************************************

                Reset the клиент such that it is ready for a new request.

        ***********************************************************************/

        КлиентППГТ сбрось ()
        {
                загиНаВхо.сбрось;
                загиНаВых.сбрось;
                парамыВых.сбрось;
                перенаправления = 0;
                return this;
        }

        /***********************************************************************

                Набор the request метод

        ***********************************************************************/

        КлиентППГТ установиЗапрос (МетодЗапроса метод)
        {
                this.метод = метод;
                return this;
        }

        /***********************************************************************

                Набор the request version

        ***********************************************************************/

        КлиентППГТ установиВерсию (Версия знач)
        {
                static const ткст[] versions = ["HTTP/1.0", "HTTP/1.1"];

                версияППГТ = versions[знач];
                return this;
        }

        /***********************************************************************

                активируй/disable the internal redirection suppport

        ***********************************************************************/

        КлиентППГТ активируйПеренаправление (бул данет = да)
        {
                перенаправь = данет;
                return this;
        }

        /***********************************************************************

                установи таймаут период for читай operation

        ***********************************************************************/

        КлиентППГТ установиТаймаут (плав интервал)
        {
                таймаут = интервал;
                return this;
        }

        /***********************************************************************

                Control бытьНаСвязи опция

        ***********************************************************************/

        КлиентППГТ будьНаСвязи (бул данет = да)
        {
                бытьНаСвязи = данет;
                return this;
        }

        /***********************************************************************

                Control Уир вывод кодировка

        ***********************************************************************/

        КлиентППГТ кодируйУри (бул данет = да)
        {
                кодируй = данет;
                return this;
        }

        /***********************************************************************

                Make a request for the resource specified via the constructor,
                using the specified таймаут период (in milli-сек).The
                return значение represents the ввод буфер, из_ which все
                returned заголовки и контент may be использовался.

        ***********************************************************************/

        БуфВывод открой ()
        {
                return открой (метод, пусто);
        }

        /***********************************************************************

                Make a request for the resource specified via the constructor,
                using a обрвызов for pumping добавьitional данные в_ the хост. This
                дефолты в_ a three-секунда таймаут период. The return значение
                represents the ввод буфер, из_ which все returned заголовки
                и контент may be использовался.

        ***********************************************************************/

        БуфВывод открой (Помпа помпа)
        {
                return открой (метод, помпа);
        }

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

        БуфВывод открой (МетодЗапроса метод, Помпа помпа)
        {
            try {
                this.метод = метод;
                if (++перенаправления > лимитПеренаправлений)
                    ошибка ("слишком много перенаправлений или зацикленное перенаправление");

                // new сокет for each request?
                if (бытьНаСвязи is нет)
                    закрой;

                // создай сокет и подключись it. Retain приор сокет if
                // not закрыт between calls
                if (сокет is пусто)
                   {
                   сокет = создайСокет;
                   сокет.таймаут = cast(цел)(таймаут * 1000);
                   сокет.подключись (адрес);
                   }

                // установи buffers for ввод и вывод
                вывод.вывод (сокет);
                ввод.ввод (сокет);
                ввод.очисть;

                // установи a Хост заголовок
                if (загиНаВых.получи (ЗаголовокППГТ.Хост, пусто) is пусто)
                    загиНаВых.добавь (ЗаголовокППГТ.Хост, уир.дайХост);

                // http/1.0 needs connection:закрой
                if (бытьНаСвязи is нет)
                    загиНаВых.добавь (ЗаголовокППГТ.Подключение, "close");

                // форматируй кодирован request
                вывод.добавь (метод.имя)
                      .добавь (" ");

                // патч request путь?
                auto путь = уир.дайПуть;
                if (путь.length is 0)
                    путь = "/";

                // излей путь
                if (кодируй)
                    уир.кодируй (&вывод.пиши, путь, уир.IncPath);
                else
                   вывод.добавь (путь);

                // прикрепи/расширь запрос параметры if пользователь имеется добавьed some
                токены.очисть;
                парамыВых.произведи(cast(т_мера delegate(проц[]))(проц[] p){if (токены.читаемый) токены.пиши("&");
                                    return cast(т_мера) уир.кодируй(&токены.пиши, cast(ткст) p, уир.IncQuery);});
                auto запрос = cast(ткст) токены.срез;

                // излей запрос?
                if (запрос.length)
                   {
                   вывод.добавь ("?").добавь(запрос);

                   if (метод is Пост && помпа.funcptr is пусто)
                      {
                      // we're POSTing запрос текст - добавь default инфо
                      if (загиНаВых.получи (ЗаголовокППГТ.ТипКонтента, пусто) is пусто)
                          загиНаВых.добавь (ЗаголовокППГТ.ТипКонтента, "application/x-www-form-urlencoded");

                      if (загиНаВых.получи (ЗаголовокППГТ.ДлинаКонтента, пусто) is пусто)
                         {
                         загиНаВых.добавьЦел (ЗаголовокППГТ.ДлинаКонтента, запрос.length);
                         помпа = cast(проц delegate(БуфВывод)) (БуфВывод o){o.добавь(запрос);};
                         }
                      }
                   }

                // complete the request строка, и излей заголовки too
                вывод.добавь (" ")
                      .добавь (версияППГТ)
                      .добавь (КонстППГТ.Кс);

                загиНаВых.произведи (&вывод.пиши, КонстППГТ.Кс);
                вывод.добавь (КонстППГТ.Кс);

                if (помпа.funcptr)
                    помпа (вывод);

                // шли entire request
                вывод.слей;

                // Токен for начальное parsing of ввод заголовок строки
                if (строка is пусто)
                    строка = new Строки!(сим) (ввод);
                else
                   строка.установи(ввод);

                // пропусти any blank строки
                while (строка.следщ && строка.получи.length is 0)
                      {}

                // is this a bogus request?
                if (строка.получи.length is 0)
                    ошибка ("truncated ответ");

                // читай ответ строка
                if (! строкаОтвета.разбор (строка.получи))
                      ошибка (строкаОтвета.ошибка);

                // разбор incoming заголовки
                загиНаВхо.сбрось.разбор (this.ввод);

                // проверь for redirection
                if (перенаправь)
                    switch (строкаОтвета.дайСтатус)
                           {
                           case КодОтветаППГТ.Найдено:
                           case КодОтветаППГТ.СмотриИное:
                           case КодОтветаППГТ.УдаленоНавсегда:
                           case КодОтветаППГТ.ВременноеПеренаправление:
                                // drop this connection
                                закрой;

                                // удали any existing Хост заголовок
                                загиНаВых.удали (ЗаголовокППГТ.Хост);

                                // разбор перенаправленый уир
                                auto перенаправ = загиНаВхо.получи (ЗаголовокППГТ.Местоположение, "[missing Location header]");
                                уир.отнРазбор (перенаправ.dup);

                                // раскодируй the хост имя (may возьми a секунда or two)
                                auto хост = уир.дайХост;
                                if (хост)
                                    адрес = new АдресИнтернета (уир.дайХост, уир.дайВалидныйПорт);
                                else
                                    ошибка ("перенаправление по непригодному url: "~перенаправ);

                                // figure out что в_ do
                                if (метод is Взять || метод is Заг)
                                    return открой (метод, помпа);
                                else
                                   if (метод is Пост)
                                       return перенаправьПост (помпа, строкаОтвета.дайСтатус);
                                   else
                                      ошибка ("неожиданное перенаправление для метода "~метод.имя);
                           default:
                                break;
                           }

                // return the ввод буфер
                return cast(БуфВывод) ввод;
                } finally {перенаправления = 0;}
        }

        /***********************************************************************

                Чит the контент из_ the returning ввод поток, up в_ a
                maximum length, и пароль контент в_ the given сток delegate
                as it arrives.

                Exits when length байты have been processed, or an Кф is
                seen on the поток.

        ***********************************************************************/

        проц читай (проц delegate(проц[]) сток, т_мера длин = т_мера.max)
        {
                while (да)
                      {
                      auto контент = ввод.срез;
                      if (контент.length > длин)
                         {
                         сток (контент [0 .. длин]);
                         ввод.пропусти (длин);
                         break;
                         }
                      else
                         {
                         длин -= контент.length;
                         сток (контент);
                         ввод.очисть;
                         if (ввод.наполни is ввод.Кф)
                             break;
                         }
                      }
        }

        /***********************************************************************

                Дескр redirection of Post

                Guопрance for the default behaviour came из_ this страница:
                http://ppewww.ph.gla.ac.uk/~flavell/www/post-перенаправ.html

        ***********************************************************************/

        БуфВывод перенаправьПост (Помпа помпа, цел статус)
        {
                switch (статус)
                       {
                            // use Get метод в_ complete the Post
                       case КодОтветаППГТ.Найдено:
                       case КодОтветаППГТ.СмотриИное:

                            // удали POST заголовки первый!
                            загиНаВых.удали (ЗаголовокППГТ.ДлинаКонтента);
                            загиНаВых.удали (ЗаголовокППГТ.ТипКонтента);
                            парамыВых.сбрось;
                            return открой (Взять, пусто);

                            // try entire Post again, if пользователь say ОК
                       case КодОтветаППГТ.УдаленоНавсегда:
                       case КодОтветаППГТ.ВременноеПеренаправление:
                            if (можноРепостировать (статус))
                                return открой (this.метод, помпа);
                            // fall through!

                       default:
                            ошибка ("Нелегальное перенаправление Пост");
                       }
                return пусто;
        }

        /***********************************************************************

                Дескр пользователь-notification of Post redirection. This should
                be overrопрden appropriately.

                Guопрance for the default behaviour came из_ this страница:
                http://ppewww.ph.gla.ac.uk/~flavell/www/post-перенаправ.html

        ***********************************************************************/

        бул можноРепостировать (бцел статус)
        {
                return нет;
        }

        /***********************************************************************

                Overrопрable сокет factory, for use with HTTPS и so on

        ***********************************************************************/

        protected Сокет создайСокет ()
        {
                return new Сокет;
        }

        /**********************************************************************

                throw an исключение, после closing the сокет

        **********************************************************************/

        private проц ошибка (ткст сооб)
        {
                закрой;
                throw new ВВИскл (сооб);
        }
}


/******************************************************************************

        Класс в_ represent an HTTP ответ-строка

******************************************************************************/

private class СтрокаОтвета : ТриплетППГТ
{
        private ткст          vers,
                                резон;
        private цел             статус;

        /**********************************************************************

                тест the validity of these токены

        **********************************************************************/

        override бул тест ()
        {
                vers = токены[0];
                резон = токены[2];
                статус = cast(цел) Целое.преобразуй (токены[1]);
                if (статус is 0)
                   {
                   статус = cast(цел) Целое.преобразуй (токены[2]);
                   if (статус is 0)
                      {
                      неудачно = "Неверный HTTP ответ: '"~токены[0]~"' '"~токены[1]~"' '" ~токены[2] ~"'";
                      return нет;
                      }
                   }
                return да;
        }

        /**********************************************************************

                Return HTTP version

        **********************************************************************/

        ткст дайВерсию ()
        {
                return vers;
        }

        /**********************************************************************

                Return резон текст

        **********************************************************************/

        ткст дайРезон ()
        {
                return резон;
        }

        /**********************************************************************

                Return статус целое

        **********************************************************************/

        цел дайСтатус ()
        {
                return статус;
        }
}


/******************************************************************************

******************************************************************************/

debug (HttpClient)
{
        import io.Stdout;
        import net.http.HttpClient;

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
