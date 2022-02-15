﻿module text.convert.Sprint;

private import text.convert.Layout;

/******************************************************************************

        Конструирует вывод в стиле sprintf. Является заменой 
        семейству функций vsprintf(),вывод записывается в отдельный буфер:
        ---
        // создать экземпляр Тпечать 
        auto sprint = new Тпечать!(сим);

        // записать форматированный вывод в логгер
        лог.инфо (sprint ("{} green bottles, sitting on a wall\n", 10));
        ---

        Тпечать удобен, когда требуется форматировать вывод для Логгера
        или в подобной ситуации, т.к. при преобразовании используется
		не куча, а буфер преобразования фиксированного размера.
		Это важно при отладке, так как из-за использования кучи могут
		изменяться поведенческие моменты. Экземпляр Тпечать можно создать
		заблаговременно, и использовать его в связке с пакетом логгинга.
               
        Заметьте, что сам класс статичен, и, следовательно, 
        единичный экземпляр не делим между несколькими потоками-нитями.
        Возвращаемый контент также не .dup'лируется, поэтому это выполняется вручную,
        когда требуется постоянная копия.
        
        Заметьте также, что Тпечать шаблонен, и можно создать экземпляр для
        широких симвлолв с помощью Тпечать!(дим) или Тпечать!(шим). Широкие
        версии отличаются тем, что весь вывод и формат-ткст представлены в
        целевом типе. Вариадические текстовые аргументы транскодируются 
        соответствующим образом.

        Смотрите также: text.convert.Layout

******************************************************************************/

class Тпечать(T)
{
        protected T[]           буфер;
        Выкладка!(T)              выкладка;

        alias форматируй            opCall;
       
        /**********************************************************************

                Создаёт новые экземпляры Тпечать с буфером указанного
                размера.
                
                Deprecated - используйте вместо него Стдвыв.выкладка.sprint().

        **********************************************************************/

        deprecated this (цел размер = 256)
        {
                this (размер, Выкладка!(T).экземпляр);
        }
        
        /**********************************************************************

                Создаёт новые экземпляры Тпечать с буфером указанного
                размера и предоставленным форматёром. Второй аргумент можно
                использовать для применения к печати культурных специфик (I18N).
                
        **********************************************************************/

        this (цел размер, Выкладка!(T) форматёр)
        {
                буфер = new T[размер];
                this.выкладка = форматёр;
        }

        /**********************************************************************

                Выкладка набор of аргументы
                
        **********************************************************************/

        T[] форматируй (T[] фмт, ...)
        {
                return выкладка.vprint (буфер, фмт, _arguments, _argptr);
        }

        /**********************************************************************

                Выкладка набор of аргументы
                
        **********************************************************************/

        T[] форматируй (T[] фмт, ИнфОТипе[] аргументы, АргСписок argptr)
        {
                return выкладка.vprint (буфер, фмт, аргументы, argptr);
        }
}

