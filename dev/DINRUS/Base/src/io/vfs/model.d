﻿
module io.vfs.model;

private import time.Time: Время;
private import io.model;


/*******************************************************************************

        alias ИнфОФайле for filtering

*******************************************************************************/

alias ИнфОФайле ИнфОФильтреВфс;
alias ИнфОФильтреВфс* ИнфОВфс;

// return нет в_ exclude something
alias бул delegate(ИнфОВфс) ФильтрВфс;


/*******************************************************************************

*******************************************************************************/

struct СтатсВфс
{
    бдол   байты;                  // байтовый счёт файлов
    бцел    файлы,                  // число файлов
    папки;                // число папок
}

/*******************************************************************************

******************************************************************************/

interface ХостВфс : ПапкаВфс
{
    /**********************************************************************

            Добавь a ветвь папка. The ветвь cannot 'overlap' with другие
            in the дерево of the same тип. Circular references across a
            дерево of virtual папки are detected и trapped.

            The секунда аргумент represents an optional имя that the
            прикрепи should be known as, instead of the имя exposed by
            the предоставленный папка (it is not an alias).

    **********************************************************************/

    ХостВфс прикрепи (ПапкаВфс папка, ткст имя=пусто);

    /***********************************************************************

            Добавь набор of ветвь папки. The ветви cannot 'overlap'
            with другие in the дерево of the same тип. Circular references
            are detected и trapped.

    ***********************************************************************/

    ХостВфс прикрепи (ПапкиВфс группа);

    /**********************************************************************

            Unhook a ветвь папка

    **********************************************************************/

    ХостВфс открепи (ПапкаВфс папка);

    /**********************************************************************

            Добавь a symbolic link в_ другой файл. These are referenced
            by файл() alone, и do not show up in дерево traversals

    **********************************************************************/

    ХостВфс карта (ФайлВфс мишень, ткст имя);

    /***********************************************************************

            Добавь a symbolic link в_ другой папка. These are referenced
            by папка() alone, и do not show up in дерево traversals

    ***********************************************************************/

    ХостВфс карта (ЗаписьПапкиВфс мишень, ткст имя);
}


/*******************************************************************************

        Supports a model a bit like CSS selectors, where a выделение
        of operands is made перед applying some operation. For example:
        ---
        // счёт of файлы in this папка
        auto счёт = папка.сам.файлы;

        // accumulated файл байт-счёт
        auto байты = папка.сам.байты;

        // a группа of one папка (itself)
        auto папки = папка.сам;
        ---

        The same approach is использован в_ выбери the subtree descending из_
        a папка:
        ---
        // счёт of файлы in this дерево
        auto счёт = папка.дерево.файлы;

        // accumulated файл байт-счёт
        auto байты = папка.дерево.байты;

        // the группа of ветвь папки
        auto папки = папка.дерево;
        ---

        Filtering can be applied в_ the дерево результатing in a подст-группа.
        Group operations remain applicable. Note that various wildcard
        characters may be использован in the filtering:
        ---
        // выбери a поднабор of the результатant дерево
        auto папки = папка.дерево.поднабор("install");

        // получи total файл байты for a дерево поднабор, using wildcards
        auto байты = папка.дерево.поднабор("foo*").байты;
        ---

        Files are selected из_ набор of папки in a similar manner:
        ---
        // файлы called "readme.txt" in this папка
        auto счёт = папка.сам.каталог("readme.txt").файлы;

        // файлы called "читай*.*" in this дерево
        auto счёт = папка.дерево.каталог("читай*.*").файлы;

        // все txt файлы belonging в_ папки starting with "ins"
        auto счёт = папка.дерево.поднабор("ins*").каталог("*.txt").файлы;

        // custom-filtered файлы внутри a subtree
        auto счёт = папка.дерево.каталог(&фильтр).файлы;
        ---

        Sets of папки и файлы support iteration via foreach:
        ---
        foreach (папка; корень.дерево)
                 Стдвыв.форматнс ("папка имя:{}", папка.имя);

        foreach (папка; корень.дерево.поднабор("ins*"))
                 Стдвыв.форматнс ("папка имя:{}", папка.имя);

        foreach (файл; корень.дерево.каталог("*.d"))
                 Стдвыв.форматнс ("файл имя:{}", файл.имя);
        ---

        Creating и opening a подст-папка is supported in a similar
        manner, where the single экземпляр is 'selected' перед the
        operation is applied. Открыть differs из_ создай in that the
        папка must есть_ли for the former:
        ---
        корень.папка("myNewFolder").создай;

        корень.папка("myExistingFolder").открой;
        ---

        Файл manИПulation is handled in much the same way:
        ---
        корень.файл("myNewFile").создай;

        auto исток = корень.файл("myExistingFile");
        корень.файл("myCopiedFile").копируй(исток);
        ---

        The princИПal benefits of these approaches are twofold: 1) it
        turns out в_ be notably ещё efficient in terms of traversal, и
        2) there's no casting требуется, since there is a clean separation
        between файлы и папки.

        See ФайлВфс for ещё information on файл handling

*******************************************************************************/

interface ПапкаВфс
{
    /***********************************************************************

            Возвращает крат имя

    ***********************************************************************/

    ткст имя ();

    /***********************************************************************

            Возвращает дол имя

    ***********************************************************************/

    ткст вТкст ();

    /***********************************************************************

            Возвращает contained файл представление

    ***********************************************************************/

    ФайлВфс файл (ткст путь);

    /***********************************************************************

            Возвращает contained папка представление

    ***********************************************************************/

    ЗаписьПапкиВфс папка (ткст путь);

    /***********************************************************************

            Возвращает папка установи containing only this one. Statistics
            are включительно of записи внутри this папка only

    ***********************************************************************/

    ПапкиВфс сам ();

    /***********************************************************************

            Возвращает subtree of папки. Statistics are включительно of
            файлы внутри this папка и все другие внутри the дерево

    ***********************************************************************/

    ПапкиВфс дерево ();

    /***********************************************************************

            Iterate over the установи of immediate ветвь папки. This is
            useful for reflecting the иерархия

    ***********************************************************************/

    цел opApply (цел delegate(ref ПапкаВфс) дг);

    /***********************************************************************

            Clear все контент из_ this папка и subordinates

    ***********************************************************************/

    ПапкаВфс очисть ();

    /***********************************************************************

            Is папка записываемый?

    ***********************************************************************/

    бул записываемый ();

    /***********************************************************************

            Close и/or synchronize changes made в_ this папка. Each
            driver should возьми advantage of this as appropriate, perhaps
            combining Несколько файлы together, либо possibly copying в_ a
            remote location

    ***********************************************************************/

    ПапкаВфс закрой (бул подай = да);

    /***********************************************************************

            A папка is being добавьed or removed из_ the иерархия. Use
            this в_ тест for validity (or whatever) и throw exceptions
            as necessary

    ***********************************************************************/

    проц проверь (ПапкаВфс папка, бул mounting);

    //ПапкаВфс копируй(ПапкаВфс из_, ткст в_);
    //ПапкаВфс перемести(Запись из_, ПапкаВфс toFolder, ткст toName);
    //ткст absolutePath(ткст путь);
}


/*******************************************************************************

        Operations upon набор of папки

*******************************************************************************/

interface ПапкиВфс
{
    /***********************************************************************

            Iterate over the установи of contained ПапкаВфс экземпляры

    ***********************************************************************/

    цел opApply (цел delegate(ref ПапкаВфс) дг);

    /***********************************************************************

            Возвращает число of файлы

    ***********************************************************************/

    бцел файлы ();

    /***********************************************************************

            Возвращает число of папки

    ***********************************************************************/

    бцел папки ();

    /***********************************************************************

            Возвращает total число of записи (файлы + папки)

    ***********************************************************************/

    бцел записи ();

    /***********************************************************************

            Возвращает total размер of contained файлы

    ***********************************************************************/

    бдол байты ();

    /***********************************************************************

            Возвращает поднабор of папки совпадают the given образец

    ***********************************************************************/

    ПапкиВфс поднабор (ткст образец);

    /***********************************************************************

             Возвращает установи of файлы совпадают the given образец

     ***********************************************************************/

    ФайлыВфс каталог (ткст образец);

    /***********************************************************************

            Возвращает установи of файлы совпадают the given фильтр

    ***********************************************************************/

    ФайлыВфс каталог (ФильтрВфс фильтр = пусто);
}


/*******************************************************************************

        Operations upon набор of файлы

*******************************************************************************/

interface ФайлыВфс
{
    /***********************************************************************

            Iterate over the установи of contained ФайлВфс экземпляры

    ***********************************************************************/

    цел opApply (цел delegate(ref ФайлВфс) дг);

    /***********************************************************************

            Возвращает total число of записи

    ***********************************************************************/

    бцел файлы ();

    /***********************************************************************

            Возвращает total размер of все файлы

    ***********************************************************************/

    бдол байты ();
}


/*******************************************************************************

        A specific файл представление

*******************************************************************************/

interface ФайлВфс
{
    /***********************************************************************

            Возвращает крат имя

    ***********************************************************************/

    ткст имя ();

    /***********************************************************************

            Возвращает дол имя

    ***********************************************************************/

    ткст вТкст ();

    /***********************************************************************

            Does this файл есть_ли?

    ***********************************************************************/

    бул есть_ли ();

    /***********************************************************************

            Возвращает файл размер

    ***********************************************************************/

    бдол размер ();

    /***********************************************************************

            Созд и копируй the given исток

    ***********************************************************************/

    ФайлВфс копируй (ФайлВфс исток);

    /***********************************************************************

            Созд и копируй the given исток, и удали the исток

    ***********************************************************************/

    ФайлВфс перемести (ФайлВфс исток);

    /***********************************************************************

            Создаёт new файл экземпляр

    ***********************************************************************/

    ФайлВфс создай ();

    /***********************************************************************

            Создаёт new файл экземпляр и наполни with поток

    ***********************************************************************/

    ФайлВфс создай (ИПотокВвода поток);

    /***********************************************************************

            Удали this файл

    ***********************************************************************/

    ФайлВфс удали ();

    /***********************************************************************

            Возвращает ввод поток. Don't forget в_ закрой it

    ***********************************************************************/

    ИПотокВвода ввод ();

    /***********************************************************************

            Возвращает вывод поток. Don't forget в_ закрой it

    ***********************************************************************/

    ИПотокВывода вывод ();

    /***********************************************************************

            Duplicate this Запись

    ***********************************************************************/

    ФайлВфс dup ();

    /***********************************************************************

            The изменён время of the папка

    ***********************************************************************/

    Время изменён ();
}


/*******************************************************************************

        Handler for папка operations. Needs some work ...

*******************************************************************************/

interface ЗаписьПапкиВфс
{
    /***********************************************************************

            Открыть a папка

    ***********************************************************************/

    ПапкаВфс открой ();

    /***********************************************************************

            Создаёт new папка

    ***********************************************************************/

    ПапкаВфс создай ();

    /***********************************************************************

            Test в_ see if a папка есть_ли

    ***********************************************************************/

    бул есть_ли ();
}


/*******************************************************************************

    Would be использован for things like zИП файлы, where the
    implementation mantains the contents in память or on disk, и where
    the actual zИП файл isn't/shouldn't be записано until one is завершено
    filling it up (for zИП due в_ inefficient файл форматируй).

*******************************************************************************/

interface СинхВфс
{
    /***********************************************************************

    ***********************************************************************/

    ПапкаВфс синх ();
}

