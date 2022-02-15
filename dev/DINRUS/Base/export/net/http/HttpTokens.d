﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

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

        Структура использован в_ expose freachable ТокенППГТ экземпляры.

******************************************************************************/

struct ТокенППГТ
{
        ткст  имя,
                значение;
}

/******************************************************************************

        Maintains набор of HTTP токены. These токены include заголовки, запрос-
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

                Construct набор of токены based upon the given delimiter,
                и an indication of whether saопр delimiter should be
                consопрered часть of the left sопрe (effectively the имя).

                The latter is useful with заголовки, since the seperating
                ':' character should really be consопрered часть of the
                имя for purposes of subsequent токен совпадают.

        **********************************************************************/

        this (сим разделитель, бул включительно = нет);

        /**********************************************************************

                Clone a источник установи of ТокеныППГТ

        **********************************************************************/

        this (ТокеныППГТ источник);

        /**********************************************************************

                Чит все токены. Everything is mapped rather than being
                allocated & copied

        **********************************************************************/

        abstract проц разбор (БуфВвод ввод);

        /**********************************************************************

                Parse an ввод ткст.

        **********************************************************************/

        проц разбор (ткст контент);

        /**********************************************************************

                Reset this установи of токены.

        **********************************************************************/

        ТокеныППГТ сбрось ();

        /**********************************************************************

                Have токены been разобрано yet?

        **********************************************************************/

        бул разобран_ли ();

        /**********************************************************************

                Indicate whether токены have been разобрано or not.

        **********************************************************************/

        проц установиРазобран (бул разобрано);

        /**********************************************************************

                Возвращает значение of the provопрed заголовок, либо пусто if the
                заголовок does not есть_ли

        **********************************************************************/

        ткст получи (ткст имя, ткст возвр = пусто);

        /**********************************************************************

                Возвращает целое значение of the provопрed заголовок, либо the
                provопрed default-vaule if the заголовок does not есть_ли

        **********************************************************************/

        цел получиЦел (ткст имя, цел возвр = -1);

        /**********************************************************************

                Возвращает дата значение of the provопрed заголовок, либо the
                provопрed default-значение if the заголовок does not есть_ли

        **********************************************************************/

        Время дайДату (ткст имя, Время дата = Время.эпоха);

        /**********************************************************************

                Iterate over the установи of токены

        **********************************************************************/

        цел opApply (цел delegate(ref ТокенППГТ) дг);

        /**********************************************************************

                Вывод the токен список в_ the provопрed consumer

        **********************************************************************/

        проц произведи (т_мера delegate(проц[]) используй, ткст кс = пусто);

        /**********************************************************************

                overrопрable метод в_ укз the case where a токен does
                not have a разделитель. Apparently, this can happen in HTTP
                usage

        **********************************************************************/

        protected бул обработайНедостающийРазделитель (ткст s, ref ТокенППГТ элемент);

        /**********************************************************************

                разбей basic токен преобр_в an ТокенППГТ

        **********************************************************************/

        final private бул разбей (Токен t, ref ТокенППГТ элемент);

        /**********************************************************************

                Создаёт фильтр for iterating over the токены совпадают
                a particular имя.

        **********************************************************************/

        ФильтрованныеТокены создайФильтр (ткст сверь);

        /**********************************************************************

                Реализует a фильтр for iterating over токены совпадают
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
                        Устанавливает образец в_ сверь against.

                **************************************************************/

                this (ТокеныППГТ токены, ткст сверь);

                /**************************************************************

                        Iterate over все токены совпадают the given имя

                **************************************************************/

                цел opApply (цел delegate(ref ТокенППГТ) дг);

        }

        /**********************************************************************

                Is the аргумент a пробел character?

        **********************************************************************/

        private бул пбел_ли (сим c);

        /**********************************************************************

                Trim the provопрed ткст by strИПping пробел из_
                Всё заканчивается. Returns a срез of the original контент.

        **********************************************************************/

        private ткст убери (ткст источник);


        /**********************************************************************
        ****************** these should be exposed carefully ******************
        **********************************************************************/


        /**********************************************************************

                Возвращает ткст representing the вывод. An пустой Массив
                is returned if вывод was not configured. This perhaps
                could just return our 'вывод' буфер контент, but that
                would not reflect deletes, либо seperators. Better в_ do
                it like this instead, for a small cost.

        **********************************************************************/

        ткст форматируйТокены (БуфВывод приёмн, ткст разделитель);

        /**********************************************************************

                Добавь a токен with the given имя. The контент is provопрed
                via the specified delegate. We stuff this имя & контент
                преобр_в the буфер вывода, и карта a new Токен onto the
                appropriate буфер срез.

        **********************************************************************/

        protected проц добавь (ткст имя, проц delegate(БуфВывод) значение);

        /**********************************************************************

                Добавь a simple имя/значение пара в_ the вывод

        **********************************************************************/

        protected проц добавь (ткст имя, ткст значение);

        /**********************************************************************

                Добавь a имя/целое пара в_ the вывод

        **********************************************************************/

        protected проц добавьЦел (ткст имя, цел значение);

        /**********************************************************************

               Добавь a имя/дата(дол) пара в_ the вывод

        **********************************************************************/

        protected проц добавьДату (ткст имя, Время значение);

        /**********************************************************************

               удали a токен из_ our список. Returns нет if the named
               токен is не найден.

        **********************************************************************/

        protected бул удали (ткст имя);
}
