﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: April 2004

        author:         Kris

*******************************************************************************/

module net.http.HttpCookies;

private import  cidrus;

private import  io.device.Array;

private import  io.stream.Buffered, io.model;

private import  io.stream.Iterator;

private import  net.http.HttpHeaders;

private import  Целое = text.convert.Integer;

/*******************************************************************************

        Defines the Куки class, и the means for reading & writing them.
        Куки implementation conforms with RFC 2109, but supports parsing
        of сервер-sопрe кукики only. Client-sопрe кукики are supported in
        terms of вывод, but ответ parsing is not yet implemented ...

        See over <A HREF="http://www.faqs.org/rfcs/rfc2109.html">here</A>
        for the RFC document.

*******************************************************************************/

class Куки //: ИЗаписываемое
{
        ткст          имя,
                        путь,
                        значение,
                        домен,
                        коммент;
        бцел            vrsn=1;              // 'version' is a reserved word
        бул            безопасно=нет;
        дол            максВозраст=дол.min;

        /***********************************************************************

                Конструирует пустой клиент-sопрe куки. You добавь these
                в_ an вывод request using КлиентППГТ.добавьКуки(), or
                the equivalent.

        ***********************************************************************/

        this () {}

        /***********************************************************************

                Construct a куки with the предоставленный атрибуты. You добавь
                these в_ an вывод request using КлиентППГТ.добавьКуки(),
                or the equivalent.

        ***********************************************************************/

        this (ткст имя, ткст значение)
        {
                установиИмя (имя);
                установиЗначение (значение);
        }

        /***********************************************************************

                Набор the имя of this куки

        ***********************************************************************/

        Куки установиИмя (ткст имя)
        {
                this.имя = имя;
                return this;
        }

        /***********************************************************************

                Набор the значение of this куки

        ***********************************************************************/

        Куки установиЗначение (ткст значение)
        {
                this.значение = значение;
                return this;
        }

        /***********************************************************************

                Набор the version of this куки

        ***********************************************************************/

        Куки установиВерсию (бцел vrsn)
        {
                this.vrsn = vrsn;
                return this;
        }

        /***********************************************************************

                Набор the путь of this куки

        ***********************************************************************/

        Куки установиПуть (ткст путь)
        {
                this.путь = путь;
                return this;
        }

        /***********************************************************************

                Набор the домен of this куки

        ***********************************************************************/

        Куки установиДомен (ткст домен)
        {
                this.домен = домен;
                return this;
        }

        /***********************************************************************

                Набор the коммент associated with this куки

        ***********************************************************************/

        Куки установиКоммент (ткст коммент)
        {
                this.коммент = коммент;
                return this;
        }

        /***********************************************************************

                Набор the maximum duration of this куки

        ***********************************************************************/

        Куки установиМаксВозраст (дол максВозраст)
        {
                this.максВозраст = максВозраст;
                return this;
        }

        /***********************************************************************

                Indicate whether this куки should be consопрered безопасно or not

        ***********************************************************************/

        Куки установиБезоп (бул безопасно)
        {
                this.безопасно = безопасно;
                return this;
        }
/+
        /***********************************************************************

                Вывод the куки as a текст поток, via the предоставленный ИПисатель

        ***********************************************************************/

        проц пиши (ИПисатель писатель)
        {
                произведи (&писатель.буфер.используй);
        }
+/
        /***********************************************************************

                Вывод the куки as a текст поток, via the предоставленный consumer

        ***********************************************************************/

        проц произведи (т_мера delegate(проц[]) используй)
        {
                используй (имя);

                if (значение.length)
                    используй ("="), используй (значение);

                if (путь.length)
                    используй (";Путь="), используй (путь);

                if (домен.length)
                    используй (";Domain="), используй (домен);

                if (vrsn)
                   {
                   сим[16] врем =void;

                   используй (";Версия=");
                   используй (Целое.форматируй (врем, vrsn));

                   if (коммент.length)
                       используй (";Комментарий=\""), используй(коммент), используй("\"");

                   if (безопасно)
                       используй (";Secure");

                   if (максВозраст != максВозраст.min)
                       используй (";Max-Возраст="c), используй (Целое.форматируй (врем, максВозраст));
                   }
        }

        /***********************************************************************

                Reset this куки

        ***********************************************************************/

        Куки очисть ()
        {
                vrsn = 1;
                безопасно = нет;
                максВозраст = максВозраст.min;
                имя = путь = домен = коммент = пусто;
                return this;
        }
}



/*******************************************************************************

        Implements a стэк of кукики. Each куки is pushed onto the
        стэк by a парсер, which takes its ввод из_ ЗаголовкиППГТ. The
        стэк can be populated for Всё клиент и сервер sопрe кукики.

*******************************************************************************/

class СтэкКуки
{
        private цел             глубина;
        private Куки[]        кукики;

        /**********************************************************************

                Construct a куки стэк with the specified начальное протяженность.
                The стэк will grow as necessary over время.

        **********************************************************************/

        this (цел размер)
        {
                кукики = new Куки[0];
                перемерь (кукики, размер);
        }

        /**********************************************************************

                Pop the стэк все the way в_ zero

        **********************************************************************/

        final проц сбрось ()
        {
                глубина = 0;
        }

        /**********************************************************************

                Return a свежий куки из_ the стэк

        **********************************************************************/

        final Куки сунь ()
        {
                if (глубина == кукики.length)
                    перемерь (кукики, глубина * 2);
                return кукики [глубина++];
        }

        /**********************************************************************

                Resize the стэк such that it имеется ещё room.

        **********************************************************************/

        private final static проц перемерь (ref Куки[] кукики, цел размер)
        {
                цел i = кукики.length;

                for (кукики.length=размер; i < кукики.length; ++i)
                     кукики[i] = new Куки();
        }

        /**********************************************************************

                Iterate over все кукики in стэк

        **********************************************************************/

        цел opApply (цел delegate(ref Куки) дг)
        {
                цел результат = 0;

                for (цел i=0; i < глубина; ++i)
                     if ((результат = дг (кукики[i])) != 0)
                          break;
                return результат;
        }
}



/*******************************************************************************

        This is the support точка for сервер-sопрe кукики. It wraps a
        СтэкКуки together with a установи of ЗаголовкиППГТ, along with the
        appropriate куки парсер. One would do something very similar
        for клиент sопрe куки parsing also.

*******************************************************************************/

class ОбзорКуковППГТ //: ИЗаписываемое
{
        private бул                    разобрано;
        private СтэкКуки             стэк;
        private РазборщикКуков            парсер;
        private ОбзорЗаголовковППГТ         заголовки;

        /**********************************************************************

                Construct куки wrapper with the предоставленный заголовки.

        **********************************************************************/

        this (ОбзорЗаголовковППГТ заголовки)
        {
                this.заголовки = заголовки;

                // создай a стэк for разобрано кукики
                стэк = new СтэкКуки (10);

                // создай a парсер
                парсер = new РазборщикКуков (стэк);
        }
/+
        /**********************************************************************

                Вывод each of the кукики разобрано в_ the предоставленный ИПисатель.

        **********************************************************************/

        проц пиши (ИПисатель писатель)
        {
                произведи (&писатель.буфер.используй, КонстППГТ.Кс);
        }
+/
        /**********************************************************************

                Вывод the токен список в_ the предоставленный consumer

        **********************************************************************/

        проц произведи (т_мера delegate(проц[]) используй, ткст кс = КонстППГТ.Кс)
        {
                foreach (куки; разбор)
                         куки.произведи (используй), используй (кс);
        }

        /**********************************************************************

                Reset these кукики for другой разбор

        **********************************************************************/

        проц сбрось ()
        {
                стэк.сбрось;
                разобрано = нет;
        }

        /**********************************************************************

                Parse все кукики из_ our ЗаголовкиППГТ, pushing each onto
                the СтэкКуки as we go.

        **********************************************************************/

        СтэкКуки разбор ()
        {
                if (! разобрано)
                   {
                   разобрано = да;

                   foreach (ЭлементЗаголовка заголовок; заголовки)
                            if (заголовок.имя.значение == ЗаголовокППГТ.Куки.значение)
                                парсер.разбор (заголовок.значение);
                   }
                return стэк;
        }
}



/*******************************************************************************

        Handles a установи of вывод кукики by writing them преобр_в the список of
        вывод заголовки.

*******************************************************************************/

class КукикиППГТ
{
        private ИмяЗаголовкаППГТ  имя;
        private ЗаголовкиППГТ     заголовки;

        /**********************************************************************

                Конструирует вывод куки wrapper upon the предоставленный
                вывод заголовки. Each куки добавьed is преобразованый в_ an
                добавьition в_ those заголовки.

        **********************************************************************/

        this (ЗаголовкиППГТ заголовки, ИмяЗаголовкаППГТ имя = ЗаголовокППГТ.УстановитьКуки)
        {
                this.заголовки = заголовки;
                this.имя = имя;
        }

        /**********************************************************************

                Добавить куки в выводимые нами заголовки.

        **********************************************************************/

        проц добавь (Куки куки)
        {
                // добавь the куки заголовок via our обрвызов
                заголовки.добавь (имя, cast(проц delegate(БуфВывод)) (БуфВывод буф){куки.произведи (&буф.пиши);});
        }
}



/*******************************************************************************

        Разборщик куков на стороне сервера. See RFC 2109 for details.

*******************************************************************************/

class РазборщикКуков : Обходчик!(сим)
{
        private enum Состояние {Начало, ЛЗначение, Равно, ПЗначение, Токен, ВКавычка, НКавычка};

        private СтэкКуки       стэк;
        private io.device.Array.Массив             массив;
        private static бул[128]  симКарта;

        /***********************************************************************

                наполним карту токенов разделителями

        ***********************************************************************/

        static this ()
        {
                симКарта['('] = да;
                симКарта[')'] = да;
                симКарта['<'] = да;
                симКарта['>'] = да;
                симКарта['@'] = да;
                симКарта[','] = да;
                симКарта[';'] = да;
                симКарта[':'] = да;
                симКарта['\\'] = да;
                симКарта['"'] = да;
                симКарта['/'] = да;
                симКарта['['] = да;
                симКарта[']'] = да;
                симКарта['?'] = да;
                симКарта['='] = да;
                симКарта['{'] = да;
                симКарта['}'] = да;
        }

        /***********************************************************************

        ***********************************************************************/

        this (СтэкКуки стэк)
        {
                super();
                this.стэк = стэк;
                массив = new io.device.Array.Массив(0);
        }

        /***********************************************************************

                Callback for обходчик.следщ(). We скан for имя-значение
                pairs, populating Куки экземпляры along the way.

        ***********************************************************************/

        protected т_мера скан (проц[] данные)
        {
                сим    c;
                цел     метка,
                        vrsn;
                ткст  имя,
                        токен;
                Куки  куки;

                Состояние   состояние = Состояние.Начало;
                ткст  контент = cast(ткст) данные;

                /***************************************************************

                        Найдено a значение; установи that also

                ***************************************************************/

                проц установиЗначение (цел i)
                {
                        токен = контент [метка..i];
                        //Print ("::имя '%.*s'\n", имя);
                        //Print ("::значение '%.*s'\n", токен);

                        if (имя[0] != '$')
                           {
                           куки = стэк.сунь;
                           куки.установиИмя (имя);
                           куки.установиЗначение (токен);
                           куки.установиВерсию (vrsn);
                           }
                        else
                           switch (вПроп (имя))
                                  {
                                  case "$путь":
                                        if (куки)
                                            куки.установиПуть (токен);
                                        break;

                                  case "$домен":
                                        if (куки)
                                            куки.установиДомен (токен);
                                        break;

                                  case "$version":
                                        vrsn = cast(цел) Целое.разбор (токен);
                                        break;

                                  default:
                                       break;
                                  }
                        состояние = Состояние.Начало;
                }

                /***************************************************************

                        Scan контент looking for куки fields

                ***************************************************************/

                for (цел i; i < контент.length; ++i)
                    {
                    c = контент [i];
                    switch (состояние)
                           {
                           // look for an lValue
                           case Состояние.Начало:
                                метка = i;
                                if (токен_ли(c))
                                    состояние = Состояние.ЛЗначение;
                                continue;

                           // скан until we have все lValue симвы
                           case Состояние.ЛЗначение:
                                if (! токен_ли(c))
                                   {
                                   состояние = Состояние.Равно;
                                   имя = контент [метка..i];
                                   --i;
                                   }
                                continue;

                           // should сейчас have either a '=', ';', or ','
                           case Состояние.Равно:
                                if (c is '=')
                                    состояние = Состояние.ПЗначение;
                                else
                                   if (c is ',' || c is ';')
                                       // получи следщ NVPair
                                       состояние = Состояние.Начало;
                                continue;

                           // look for a quoted токен, or a plain one
                           case Состояние.ПЗначение:
                                метка = i;
                                if (c is '\'')
                                    состояние = Состояние.ВКавычка;
                                else
                                   if (c is '"')
                                       состояние = Состояние.НКавычка;
                                   else
                                      if (токен_ли(c))
                                          состояние = Состояние.Токен;
                                continue;

                           // скан for все plain токен симвы
                           case Состояние.Токен:
                                if (! токен_ли(c))
                                   {
                                   установиЗначение (i);
                                   --i;
                                   }
                                continue;

                           // скан until the следщ '
                           case Состояние.ВКавычка:
                                if (c is '\'')
                                    ++метка, установиЗначение (i);
                                continue;

                           // скан until the следщ "
                           case Состояние.НКавычка:
                                if (c is '"')
                                    ++метка, установиЗначение (i);
                                continue;

                           default:
                                continue;
                           }
                    }

                // we ran out of контент; патч partial куки значения
                if (состояние is Состояние.Токен)
                    установиЗначение (контент.length);

                // go home
                return ИПровод.Кф;
        }

        /***********************************************************************

                Locate the следщ токен из_ the предоставленный буфер, и карта a
                буфер reference преобр_в токен. Возвращает да if a токен was
                located, нет иначе.

                Note that the буфер контент is not duplicated. Instead, a
                срез of the буфер is referenced by the токен. You can use
                Токен.клонируй() or Токен.вТкст().dup() в_ копируй контент per
                your application needs.

                Note also that there may still be one токен лево in a буфер
                that was not terminated correctly (as in eof conditions). In
                such cases, токены are mapped onto остаток контент и the
                буфер will have no ещё читаемый контент.

        ***********************************************************************/

        бул разбор (ткст заголовок)
        {
                super.установи (массив.присвой (заголовок));
                return следщ.ptr > пусто;
        }

        /**********************************************************************

                in-place conversion в_ lowercase

        **********************************************************************/

        final static ткст вПроп (ref ткст ист)
        {
                foreach (цел i, сим c; ист)
                         if (c >= 'A' && c <= 'Z')
                             ист[i] = cast(сим)(c + ('a' - 'A'));
                return ист;
        }

        /***********************************************************************

                Is 'c' a действителен токен character?

        ***********************************************************************/

        private static бул токен_ли (сим c)
        {
                return (c > 32 && c < 127 && !симКарта[c]);
        }
}


